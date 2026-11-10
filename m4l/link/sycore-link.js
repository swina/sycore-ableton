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
 *                                                                   → [s sycore_map] (the SY.CORE Map device)
 */
const http = require('http');
const { WebSocketServer } = require('ws');
const { PROTOCOL_VERSION, Transport, MidiScheduler, parseMessage, infoText, infoState, statsText, parseRig, rigName,
  parseMapTables, parseMap, parseMapTarget, mapInfoFromDevice, mapValueFromDevice, mapTracksFromDevice, mapParamsFromDevice } = require('./link-core');

const VERSION = '1.2.1'; // 1.1: Rig GEN / FILL · 1.2: SY.CORE Map (P12) · 1.2.1: map mode 'mixed'
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
}

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
setInterval(() => { const s = sched.takeStats(); if (s) broadcast(s); showStats(s); }, 1000);
setInterval(safe('rig', sendRig), 1000);

wss.on('connection', (ws, req) => {
  log('client connected from', req.headers.origin || '?');
  showInfo();
  send(ws, { type: 'hello', device: 'sycore-link', version: VERSION, track: trackName, sim: !max });
  send(ws, tr.snapshot(now()));
  if (mapInfo) send(ws, mapInfo);
  if (mapTracks) send(ws, mapTracks);
  ws.on('message', safe('message', text => {
    const { msg, error } = parseMessage(text);
    if (error) { send(ws, { type: 'error', ...error }); return; }
    if (!msg) return;
    switch (msg.type) {
      case 'midi': {
        const r = sched.schedule(msg, now());
        // Diagnostics: the first few refused messages, as received.
        if (!r && rejectLogs < 5) { rejectLogs++; log('refused midi:', JSON.stringify(msg).slice(0, 160), `playing=${tr.playing} beatNow=${tr.beatAt(now()).toFixed(3)}`); }
        if (r) sendMidi(r.data, r.beat);
        break;
      }
      case 'clear': clearAll(); break;
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
      case 'ping': send(ws, { type: 'pong', t: msg.t, beat: tr.beatAt(now()) }); break;
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
