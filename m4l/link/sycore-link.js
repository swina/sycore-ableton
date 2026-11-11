/**
 * sycore-link.js — SY.CORE Link bridge, protocol v1 (docs/link-protocol-v1.md).
 * Runs in Node for Max ([node.script sycore-link.js @autostart 1]) or, with --sim,
 * in plain Node with a simulated Live (tests, development).
 *
 *   Max → node : "transport <playing> <beat> <tempo> <num> <den>"  (live.observer)
 *                "track <name…>"                                    (this device's track name)
 *                "rigpress <rig action>"                            (a click on a SY.CORE Rig device)
 *                "mapready" / "mapinfo <json>" / "mapvalue <slot> <0–1>" / "maptracks <json>" / "mapparams <json>"
 *                                                                   (the SY.CORE Map device, P12)
 *   node → Max : "midi3 <b1> <b2> <b3> <beat>"  (beat -1 = now) → delay from [transport] → [pipe] → [midiout]
 *                "midi2 <b1> <b2> <beat>"
 *                "clear"                            → both pipes (drop pending messages)
 *                "info <text…>" / "stats <text…>"  → the device's status lines
 *                "state <0|1|2>"                    → status LED: waiting, connected, error
 *                "rig row <i> <filled mask> <playing> <queued> <muted> <solo> <gen>" → [s sycore_rig]
 *                "rig sec <section> <queued section>" / "rig active <0|1>"      (SY.CORE Rig devices)
 *                "rig fill <0|1>"                                                (the Drum Machine's Fill on)
 *                "rig chord <now> <duration> <next> <duration> <ms> <bars> <seq> <elapsed ms>"  ('-' = none)
 *                "map tables <json>" / "map value <slot> <0–1>" / "map target <follow|track>" / "map params"
 *                "map variation <index|next|prev|store|delete>" / "map randomize"
 *                                                                   → [s sycore_map] (the SY.CORE Map device)
 */
const http = require('http');
const { WebSocketServer } = require('ws');
const { TimedQueue, PROTOCOL_VERSION, Transport, MidiScheduler, parseMessage, infoText, infoState, statsText, parseRig, rigName,
  parseMapTables, parseMap, parseMapTarget, parseMapVariation, mapInfoFromDevice, mapValueFromDevice, mapTracksFromDevice, mapParamsFromDevice } = require('./link-core');

const VERSION = '1.4.0'; // 1.4.0: MIDI ports played on Live's beat (midi.port, ports) · 1.3.5: map sync on start · 1.3.4: transport `at`, pong `nt` (the client corrects late reads) · 1.1: Rig GEN / FILL · 1.2: SY.CORE Map (P12) · 1.2.1: map mode 'mixed' · 1.3: Macro Variations · 1.3.1: tracks' instruments · 1.3.2: auto mode, tables by device name · 1.3.3: store / delete variations
const SIM = process.argv.includes('--sim');
const PORT = Number(process.env.SYCORE_LINK_PORT || 9400);

let max = null;
if (!SIM) { try { max = require('max-api'); } catch { /* plain node: simulated Live */ } }
const log = (...a) => (max ? max.post(a.join(' ')) : console.log('[link]', ...a));
const toMax = (...a) => { if (max) Promise.resolve(max.outlet(...a)).catch(e => log('outlet failed:', e)); };
const now = () => performance.now();

const tr = new Transport();
const sched = new MidiScheduler(tr);
let trackName = '';
let rejectLogs = 0;
let serverError = null;
let lastStats = '';
/** The Rig Controller's state as SY.CORE last sent it (re-sent to the Rig devices every second,
 *  so one added later shows it); null = no Rig Controller open in SY.CORE. */
let rigState = null;
let chordAt = 0; // when the chord sounding started (its seq first seen)
/** SY.CORE Map (P12): the tables and the target as SY.CORE last sent them (to a Map device loaded
 *  later), and the device's last info / track list (to a SY.CORE connecting later). */
let mapTables = null, mapTarget = 'follow', mapInfo = null, mapTracks = null;
function sendMapSetup() {
  if (mapTables) toMax('map', 'tables', JSON.stringify(mapTables));
  toMax('map', 'target', mapTarget);
}

/** Status lines on the device (words as separate atoms: Max shows them without quotes). */
const words = t => String(t).split(' ');
function showInfo() {
  const st = { clients: wss.clients.size, port: PORT, error: serverError, track: trackName };
  toMax('info', ...words(infoText(st)));
  toMax('state', infoState(st));
}
function showStats(s) { const t = statsText(s); if (t !== lastStats) { lastStats = t; toMax('stats', ...words(t)); } }

/** To Max with the Live beat to play it on (-1 = now): Max reads its own [transport] when
 *  the message arrives and waits the rest — the note lands on Live's beat whatever the
 *  delays between Live, this script and Max. */
function sendMidi(data, beat) {
  const b = beat === undefined || beat === null ? -1 : Math.round(beat * 1e6) / 1e6;
  if (data.length === 3) toMax('midi3', data[0], data[1], data[2], b);
  else toMax('midi2', data[0], data[1], b);
}

/** The Rig state to the SY.CORE Rig devices (compact: ints, no JSON through Max). */
function sendRig() {
  if (!rigState) { toMax('rig', 'active', 0); return; }
  toMax('rig', 'active', 1);
  rigState.rows.forEach((r, i) => toMax('rig', 'row', i, r.filled, r.playing, r.queued, r.muted, r.solo, r.gen));
  toMax('rig', 'sec', rigState.section, rigState.queuedSection);
  toMax('rig', 'fill', rigState.fill);
  const c = rigState.chord;
  // + its length (ms), bars, the step counter and the ms already gone (a device added mid-chord)
  toMax('rig', 'chord', c ? c.now : '-', c ? c.dur : '-', c ? c.next : '-', c ? c.nextDur : '-',
    c ? c.ms : 0, c ? c.bars : 0, c ? c.seq : 0, c ? Date.now() - chordAt : 0);
}

function clearAll() {
  toMax('clear');
  for (const off of sched.clear(now())) sendMidi(off, -1);
  clearPorts();
}

// ── MIDI ports played by the bridge (1.4) ─────────────────────────────────────────
// SY.CORE's MIDI Flow cables "via SY.CORE Link": a message with `port` goes to that MIDI port
// (Emulator X3 on a Windows MIDI Services loopback…) at its Live beat, from this process — not
// from the browser's main thread, which delayed it by 5–240 ms. Node's MIDI: @julusian/midi
// (RtMidi, N-API, Windows binaries included).
let midiLib = null;
try { midiLib = require('@julusian/midi'); } catch (e) { log('MIDI ports off (@julusian/midi not found: script npm install):', e.message); }
const ports = new Map(); // lower-case name → { name, out, sched } | { name, missing: true }
const portQueue = new TimedQueue({ now });
let portMissing = 0;
let midiFailLogged = false;
function listPorts() {
  if (!midiLib) return [];
  try {
    const o = new midiLib.Output();
    const names = [];
    for (let i = 0; i < o.getPortCount(); i++) names.push(o.getPortName(i));
    try { o.closePort(); } catch {}
    return names;
  } catch (e) {
    if (!midiFailLogged) { midiFailLogged = true; log('MIDI ports unavailable:', e.message); }
    return [];
  }
}
/** The open port named `name` (exact, case-insensitive; else the first containing it), or null. */
function portFor(name) {
  const key = String(name).toLowerCase().trim();
  const had = ports.get(key);
  if (had) return had.missing ? null : had;
  if (!midiLib) return null;
  const names = listPorts();
  let i = names.findIndex(n => n.toLowerCase().trim() === key);
  if (i < 0) i = names.findIndex(n => n.toLowerCase().includes(key));
  if (i < 0) {
    log('MIDI port not found:', JSON.stringify(name), '· ports:', names.join(' | '));
    ports.set(key, { name, missing: true });
    return null;
  }
  let out;
  try { out = new midiLib.Output(); out.openPort(i); } catch (e) { log('MIDI port', names[i], 'failed to open:', e.message); ports.set(key, { name, missing: true }); return null; }
  const p = { name: names[i], out, sched: new MidiScheduler(tr) };
  ports.set(key, p);
  log('MIDI port open:', p.name);
  return p;
}
function portSend(p, data) { try { p.out.sendMessage(data); } catch (e) { log('MIDI port', p.name, 'send failed:', e.message); } }
/** A `midi` message with `port`: on its Live beat (or now), from the timed queue. */
function routePort(msg) {
  const p = portFor(msg.port);
  if (!p) { portMissing++; return; }
  const r = p.sched.schedule(msg, now());
  if (!r) return;
  if (r.delayMs <= 0.5) portSend(p, r.data);
  else portQueue.at(now() + r.delayMs, () => portSend(p, r.data));
}
/** Drop what is pending on the ports and end the notes sounding there. */
function clearPorts() {
  portQueue.clear();
  for (const p of ports.values()) if (!p.missing) for (const off of p.sched.clear(now())) portSend(p, off);
}
/** Ports part of the stats (null when no port traffic). */
function takePortStats() {
  let msgs = 0, late = 0, dropped = 0;
  for (const p of ports.values()) {
    if (p.missing) continue;
    const st = p.sched.takeStats();
    if (st) { msgs += st.msgs; late += st.late; dropped += st.dropped; }
  }
  const t = portQueue.st; portQueue.resetStats();
  const missing = portMissing; portMissing = 0;
  if (!msgs && !late && !dropped && !missing) return null;
  return { portMsgs: msgs, portLate: late, portDropped: dropped, portMissing: missing, portTimerMaxMs: Math.round(t.lateMax * 100) / 100 };
}
// A port can come back (plugged in, loopback created): forget the missing ones now and then.
setInterval(() => { for (const [k, p] of ports) if (p.missing) ports.delete(k); }, 5000);

// ── WebSocket server ────────────────────────────────────────────────────────
// Created before the Max handlers: Max delivers Live's transport reports as soon as
// they are registered, and a report reaching broadcast() before `wss` existed crashed
// the script (Max restarted it in a loop).
const server = http.createServer((req, res) => { res.writeHead(404); res.end(); });
const wss = new WebSocketServer({ server });

function send(ws, obj) { try { ws.send(JSON.stringify({ v: PROTOCOL_VERSION, ...obj })); } catch {} }
function broadcast(obj) { wss.clients.forEach(ws => send(ws, obj)); }

/** A handler error is logged to the Max console instead of ending the script. */
const safe = (name, fn) => (...args) => { try { return fn(...args); } catch (e) { log(`${name} failed:`, e && e.stack || e); } };
process.on('uncaughtException', e => log('uncaught:', e && e.stack || e));
process.on('unhandledRejection', e => log('unhandled rejection:', e && e.stack || e));

// ── Live transport ───────────────────────────────────────────────────────────
function onTransport(playing, beat, tempo, num, den) {
  const wasPlaying = tr.playing;
  const changed = tr.set({ playing, beat, tempo, num, den }, now());
  // Live stopped: drop what is queued and end what sounds (as a DAW does on stop).
  if (wasPlaying && !tr.playing) clearAll();
  if (changed) broadcast(tr.snapshot(now()));
}
if (max) {
  max.addHandler('transport', safe('transport', onTransport));
  max.addHandler('track', safe('track', (...name) => { trackName = name.join(' ').replace(/^"(.*)"$/, '$1'); showInfo(); }));
  // A click on a SY.CORE Rig device: to SY.CORE as the rig action it is (rig_slot_drum_a, rig_mute_bass…).
  // Each click is logged in the Max console (an unknown one too): the way to see where a click stops.
  // The SY.CORE Map device: loaded (tables and target to it), its instrument, values, tracks, parameters.
  max.addHandler('mapready', safe('mapready', () => { log('map: device ready'); sendMapSetup(); }));
  // A Map device already in the set when this script (re)starts (the SY.CORE Link device reloaded) sent
  // its tracks and instrument to the old script: ask again (and once more if nothing came).
  setTimeout(() => toMax('map', 'sync'), 500);
  setTimeout(() => { if (!mapTracks) toMax('map', 'sync'); }, 3000);
  max.addHandler('mapinfo', safe('mapinfo', (...t) => { const m = mapInfoFromDevice(t); if (m) { mapInfo = m; broadcast(m); } }));
  max.addHandler('mapvalue', safe('mapvalue', (slot, v) => { const m = mapValueFromDevice(slot, v); if (m) broadcast(m); }));
  max.addHandler('maptracks', safe('maptracks', (...t) => { const m = mapTracksFromDevice(t); if (m) { mapTracks = m; broadcast(m); } }));
  max.addHandler('mapparams', safe('mapparams', (...t) => { const m = mapParamsFromDevice(t); if (m) broadcast(m); }));
  max.addHandler('rigpress', safe('rigpress', name => {
    if (!rigName(name)) { log(`rig: ignored ${name}`); return; }
    log(`rig: ${name} → SY.CORE (${wss.clients.size} connected)`);
    broadcast({ type: 'rig-press', name: String(name) });
  }));
} else {
  // Simulated Live: 120 BPM from beat 0, reports at Live's UI rate.
  tr.set({ playing: 1, beat: 0, tempo: 120, num: 4, den: 4 }, now());
  setInterval(() => tr.set({ playing: 1, tempo: tr.tempo }, now()), 60);
}

// ── WebSocket (connection handling) ─────────────────────────────────────────

setInterval(() => broadcast(tr.snapshot(now())), 50);
setInterval(() => {
  const s = sched.takeStats();
  const ps = takePortStats();
  const all = s || ps ? { ...(s || { type: 'stats', msgs: 0, late: 0, dropped: 0, reportJitterMs: null, leadMinMs: null, leadAvgMs: null }), ...(ps || {}) } : null;
  if (all) broadcast(all);
  showStats(all);
}, 1000);
setInterval(safe('rig', sendRig), 1000);

wss.on('connection', (ws, req) => {
  log('client connected from', req.headers.origin || '?');
  showInfo();
  send(ws, { type: 'hello', device: 'sycore-link', version: VERSION, track: trackName, sim: !max, ports: !!midiLib });
  send(ws, tr.snapshot(now()));
  if (mapInfo) send(ws, mapInfo);
  if (mapTracks) send(ws, mapTracks);
  ws.on('message', safe('message', text => {
    const { msg, error } = parseMessage(text);
    if (error) { send(ws, { type: 'error', ...error }); return; }
    if (!msg) return;
    switch (msg.type) {
      case 'midi': {
        if (msg.port !== undefined && msg.port !== null && msg.port !== '') { routePort(msg); break; }
        const r = sched.schedule(msg, now());
        // Diagnostics: the first few refused messages, as received.
        if (!r && rejectLogs < 5) { rejectLogs++; log('refused midi:', JSON.stringify(msg).slice(0, 160), `playing=${tr.playing} beatNow=${tr.beatAt(now()).toFixed(3)}`); }
        if (r) sendMidi(r.data, r.beat);
        break;
      }
      case 'clear': clearAll(); break;
      case 'ports': send(ws, { type: 'ports', names: listPorts() }); break;
      case 'rig': {
        const r = parseRig(msg);
        if (r === undefined) break;
        if (r && r.chord && (!rigState || !rigState.chord || rigState.chord.seq !== r.chord.seq)) chordAt = Date.now();
        rigState = r; sendRig(); break;
      }
      case 'map-tables': { const t = parseMapTables(msg); if (t) { mapTables = t; toMax('map', 'tables', JSON.stringify(t)); } break; }
      case 'map': { const r = parseMap(msg); if (r) toMax('map', 'value', r.slot, r.value); break; }
      case 'map-target': { const t = parseMapTarget(msg); if (t !== undefined) { mapTarget = t; toMax('map', 'target', t); } break; }
      case 'map-params-request': toMax('map', 'params'); break;
      case 'map-variation': { const v = parseMapVariation(msg); if (v !== undefined) toMax('map', 'variation', v); break; }
      case 'map-randomize': toMax('map', 'randomize'); break;
      case 'ping': { const t = now(); send(ws, { type: 'pong', t: msg.t, beat: tr.beatAt(t), nt: Math.round(t * 1000) / 1000 }); break; }
      case 'hello': log('client hello', msg.client || '?', msg.app || ''); break;
      default: break; // unknown types are ignored (forward compatibility)
    }
  }));
  ws.on('close', () => {
    showInfo();
    log('client gone');
    // No client left to send note-offs: end what sounds.
    if (wss.clients.size === 0) { clearAll(); rigState = null; sendRig(); }
  });
});

server.listen(PORT, '127.0.0.1', () => { log(`SY.CORE Link ${VERSION} on ws://127.0.0.1:${PORT} (${max ? 'Max' : 'simulated Live'})`); showInfo(); });
server.on('error', e => {
  serverError = e.code === 'EADDRINUSE' ? `port ${PORT} in use: another SY.CORE Link device?` : `server error: ${e.message}`;
  log(serverError); showInfo();
});
