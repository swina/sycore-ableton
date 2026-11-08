/**
 * sycore-link.js — SY.CORE Link bridge, protocol v1 (docs/link-protocol-v1.md).
 * Runs in Node for Max ([node.script sycore-link.js @autostart 1]) or, with --sim,
 * in plain Node with a simulated Live (tests, development).
 *
 *   Max → node : "transport <playing> <beat> <tempo> <num> <den>"  (live.observer)
 *                "track <name…>"                                    (this device's track name)
 *   node → Max : "midi3 <b1> <b2> <b3> <delayMs>"   → [pipe 0 0 0 0] → [pack 0 0 0] → [midiout]
 *                "midi2 <b1> <b2> <delayMs>"        → [pipe 0 0 0]   → [pack 0 0]   → [midiout]
 *                "clear"                            → both pipes (drop pending messages)
 *                "status <clients>"                 → UI
 */
const http = require('http');
const { WebSocketServer } = require('ws');
const { PROTOCOL_VERSION, Transport, MidiScheduler, parseMessage } = require('./link-core');

const VERSION = '1.0.0';
const SIM = process.argv.includes('--sim');
const PORT = Number(process.env.SYCORE_LINK_PORT || 9400);

let max = null;
if (!SIM) { try { max = require('max-api'); } catch { /* plain node: simulated Live */ } }
const log = (...a) => (max ? max.post(a.join(' ')) : console.log('[link]', ...a));
const toMax = (...a) => { if (max) max.outlet(...a); };
const now = () => performance.now();

const tr = new Transport();
const sched = new MidiScheduler(tr);
let trackName = '';

function sendMidi(data, delayMs) {
  const d = Math.round(delayMs * 100) / 100;
  if (data.length === 3) toMax('midi3', data[0], data[1], data[2], d);
  else toMax('midi2', data[0], data[1], d);
}

function clearAll() {
  toMax('clear');
  for (const off of sched.clear(now())) sendMidi(off, 0);
}

// ── Live transport ───────────────────────────────────────────────────────────
function onTransport(playing, beat, tempo, num, den) {
  const wasPlaying = tr.playing;
  const changed = tr.set({ playing, beat, tempo, num, den }, now());
  // Live stopped: drop what is queued and end what sounds (as a DAW does on stop).
  if (wasPlaying && !tr.playing) clearAll();
  if (changed) broadcast(tr.snapshot(now()));
}
if (max) {
  max.addHandler('transport', onTransport);
  max.addHandler('track', (...name) => { trackName = name.join(' '); });
} else {
  // Simulated Live: 120 BPM from beat 0, reports at Live's UI rate.
  tr.set({ playing: 1, beat: 0, tempo: 120, num: 4, den: 4 }, now());
  setInterval(() => tr.set({ playing: 1, tempo: tr.tempo }, now()), 60);
}

// ── WebSocket ───────────────────────────────────────────────────────────────
const server = http.createServer((req, res) => { res.writeHead(404); res.end(); });
const wss = new WebSocketServer({ server });

function send(ws, obj) { try { ws.send(JSON.stringify({ v: PROTOCOL_VERSION, ...obj })); } catch {} }
function broadcast(obj) { wss.clients.forEach(ws => send(ws, obj)); }

setInterval(() => broadcast(tr.snapshot(now())), 50);
setInterval(() => { const s = sched.takeStats(); if (s) broadcast(s); }, 1000);

wss.on('connection', (ws, req) => {
  log('client connected from', req.headers.origin || '?');
  toMax('status', wss.clients.size);
  send(ws, { type: 'hello', device: 'sycore-link', version: VERSION, track: trackName, sim: !max });
  send(ws, tr.snapshot(now()));
  ws.on('message', text => {
    const { msg, error } = parseMessage(text);
    if (error) { send(ws, { type: 'error', ...error }); return; }
    if (!msg) return;
    switch (msg.type) {
      case 'midi': {
        const r = sched.schedule(msg, now());
        if (r) sendMidi(r.data, r.delayMs);
        break;
      }
      case 'clear': clearAll(); break;
      case 'ping': send(ws, { type: 'pong', t: msg.t, beat: tr.beatAt(now()) }); break;
      case 'hello': log('client hello', msg.client || '?', msg.app || ''); break;
      default: break; // unknown types are ignored (forward compatibility)
    }
  });
  ws.on('close', () => {
    toMax('status', wss.clients.size);
    log('client gone');
    // No client left to send note-offs: end what sounds.
    if (wss.clients.size === 0) clearAll();
  });
});

server.listen(PORT, '127.0.0.1', () => log(`SY.CORE Link ${VERSION} on ws://127.0.0.1:${PORT} (${max ? 'Max' : 'simulated Live'})`));
server.on('error', e => log('server error:', e.code === 'EADDRINUSE' ? `port ${PORT} in use (another SY.CORE Link device?)` : e.message));
