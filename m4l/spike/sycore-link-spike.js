/**
 * sycore-link-spike.js — P11 spike: a WebSocket server on localhost between SY.CORE (browser)
 * and a Max for Live device. Runs in Node for Max ([node.script sycore-link-spike.js]) or,
 * with --sim, in plain Node with a simulated Live transport (for tests without Live).
 *
 *   Max → node : "transport <playing 0/1> <beat> <tempo>"  (live.observer: is_playing,
 *                 current_song_time, tempo) — the script interpolates the beat between reports.
 *   node → Max : "note <pitch> <vel> <durMs> <delayMs>"   → [pipe 0 0 0 0] → [makenote] → midiout
 *                "status <clients>"                       → UI
 *   browser ↔ node (JSON, "v": 1):
 *     → {type:'ping', t}                 ← {type:'pong', t, beat}
 *     → {type:'note', id, note, vel, beat, durBeats}   (beat = Live song time, in quarter notes)
 *     ← {type:'transport', playing, beat, tempo} every 50 ms and on change
 *     ← {type:'stats', notes, late, leadMinMs, leadAvgMs} every second while notes arrive
 *
 * Also serves test.html at http://127.0.0.1:<port>/ (same port).
 */
const http = require('http');
const fs = require('fs');
const path = require('path');
const { WebSocketServer } = require('ws');

const SIM = process.argv.includes('--sim');
const PORT = Number(process.env.SYCORE_LINK_PORT || 9400);
const LATE_TOLERANCE_MS = 5;

let max = null;
if (!SIM) {
  try { max = require('max-api'); } catch { /* plain node without --sim: behave as sim */ }
}
const log = (...a) => (max ? max.post(a.join(' ')) : console.log('[link]', ...a));
const toMax = (...a) => { if (max) max.outlet(...a); };

// ── Live transport (reported by Max, or simulated) ──────────────────────────
const tr = { playing: false, beat: 0, tempo: 120, at: performance.now() };
function beatNow() {
  if (!tr.playing) return tr.beat;
  return tr.beat + ((performance.now() - tr.at) * tr.tempo) / 60000;
}
function setTransport(playing, beat, tempo) {
  const changed = !!playing !== tr.playing || (tempo > 0 && tempo !== tr.tempo);
  tr.playing = !!playing;
  tr.beat = Number(beat) || 0;
  if (tempo > 0) tr.tempo = Number(tempo);
  tr.at = performance.now();
  if (changed) broadcastTransport();
}
if (max) {
  max.addHandler('transport', (playing, beat, tempo) => setTransport(playing, beat, tempo));
  max.addHandler('tempo', t => setTransport(tr.playing, beatNow(), t));
}
if (SIM || !max) {
  // Simulated Live: playing at 120 BPM from beat 0; the report jitters like Live's UI rate.
  setTransport(1, 0, 120);
  setInterval(() => setTransport(1, beatNow(), tr.tempo), 60);
}

// ── HTTP (test page) + WebSocket ───────────────────────────────────────────
const server = http.createServer((req, res) => {
  if (req.url === '/' || req.url.startsWith('/test.html')) {
    res.writeHead(200, { 'content-type': 'text/html; charset=utf-8' });
    fs.createReadStream(path.join(__dirname, 'test.html')).pipe(res);
    return;
  }
  res.writeHead(404); res.end();
});
var wss = new WebSocketServer({ server }); // var: hoisted, transport reports may come first

function send(ws, obj) { try { ws.send(JSON.stringify({ v: 1, ...obj })); } catch {} }
function broadcastTransport() {
  if (!wss) return; // a transport report before the server is up
  const msg = { type: 'transport', playing: tr.playing, beat: beatNow(), tempo: tr.tempo };
  wss.clients.forEach(ws => send(ws, msg));
}
setInterval(broadcastTransport, 50);

// Note arrival stats: how early each note came before its beat (lead), late ones dropped.
let st = { notes: 0, late: 0, leadMin: Infinity, leadSum: 0 };
setInterval(() => {
  if (!st.notes && !st.late) return;
  const msg = {
    type: 'stats', notes: st.notes, late: st.late,
    leadMinMs: st.notes ? Math.round(st.leadMin * 10) / 10 : null,
    leadAvgMs: st.notes ? Math.round((st.leadSum / st.notes) * 10) / 10 : null,
  };
  wss.clients.forEach(ws => send(ws, msg));
  st = { notes: 0, late: 0, leadMin: Infinity, leadSum: 0 };
}, 1000);

function onNote(m) {
  const msPerBeat = 60000 / tr.tempo;
  const leadMs = (Number(m.beat) - beatNow()) * msPerBeat;
  if (!tr.playing || leadMs < -LATE_TOLERANCE_MS) { st.late++; return; }
  st.notes++; st.leadSum += leadMs; if (leadMs < st.leadMin) st.leadMin = leadMs;
  const durMs = Math.max(1, (Number(m.durBeats) || 0.25) * msPerBeat);
  toMax('note', m.note | 0, m.vel | 0, durMs, Math.max(0, leadMs));
}

wss.on('connection', (ws, req) => {
  log('client connected from', req.headers.origin || '?');
  toMax('status', wss.clients.size);
  send(ws, { type: 'hello', device: 'sycore-link-spike', sim: !max });
  send(ws, { type: 'transport', playing: tr.playing, beat: beatNow(), tempo: tr.tempo });
  ws.on('message', data => {
    let m; try { m = JSON.parse(String(data)); } catch { return; }
    if (m.type === 'ping') send(ws, { type: 'pong', t: m.t, beat: beatNow() });
    else if (m.type === 'note') onNote(m);
  });
  ws.on('close', () => { toMax('status', wss.clients.size); log('client gone'); });
});

server.listen(PORT, '127.0.0.1', () => log(`SY.CORE Link spike on ws://127.0.0.1:${PORT} (${max ? 'Max' : 'simulated Live'})`));
