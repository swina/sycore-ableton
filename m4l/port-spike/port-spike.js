/**
 * port-spike.js — SY.CORE Link, spike "MIDI ports on Live's beat".
 *
 * Question: can the bridge (Node for Max, a process apart from Chrome) send MIDI to a port
 * (Emulator X3, SYC OUT A…) on Live's beat with little jitter? If yes, a MIDI Flow cable to a
 * port can go "via SY.CORE Link": SY.CORE sends ahead with the beat and the port, the bridge
 * plays it on time — no browser main thread in the way (see sycore-refactor CHANGES 2026-11-11).
 *
 * In Max ([node.script port-spike.js]): follows Live's transport (live.observer → "transport
 * <playing> <beat> <tempo>"), and while Live plays sends 1/4-note chords (C E G, gate 90 %) on
 * every beat to the chosen port and channel. Messages from Max: "ports", "port <name…>",
 * "channel <1–16>", "pattern <on|off>".
 *
 * Standalone (plain Node on Windows, no Live): `node port-spike.js --standalone [--port <name>]
 * [--bpm 120]` — its own clock at that tempo, to measure the timer alone.
 *
 * Every second it reports how late the sends left against their time (avg / p95 / max, ms):
 * the timer's quality. A system timer wakes ~WAKE_EARLY_MS before, then a short spin.
 */
const { performance } = require('node:perf_hooks');
const STANDALONE = process.argv.includes('--standalone');
let max = null;
if (!STANDALONE) { try { max = require('max-api'); } catch { /* plain node */ } }
const log = (...a) => { const s = a.join(' '); if (max) max.post(s); else console.log(s); };
const out2max = (...a) => { if (max) max.outlet(...a); };
const arg = (name, dflt) => { const i = process.argv.indexOf(name); return i > 0 && process.argv[i + 1] ? process.argv[i + 1] : dflt; };

let midi = null;
try { midi = require('@julusian/midi'); } catch (e) { log('port-spike: @julusian/midi not installed (click "script npm install"):', e.message); }

// ── Port ──────────────────────────────────────────────────────────────────────
let output = null, portName = null, channel = 1;
function listPorts() {
  if (!midi) return [];
  const o = new midi.Output();
  const names = [];
  for (let i = 0; i < o.getPortCount(); i++) names.push(o.getPortName(i));
  try { o.closePort(); } catch {}
  return names;
}
function openPort(want) {
  if (!midi) return false;
  try { output?.closePort(); } catch {}
  output = null; portName = null;
  const names = listPorts();
  const w = String(want || '').toLowerCase().trim();
  let i = names.findIndex(n => n.toLowerCase().trim() === w);
  if (i < 0 && w) i = names.findIndex(n => n.toLowerCase().includes(w));
  if (i < 0) { log('port-spike: no port matching', JSON.stringify(want), '· ports:', names.join(' | ')); return false; }
  output = new midi.Output();
  output.openPort(i);
  portName = names[i];
  log('port-spike: port open:', portName, '· channel', channel);
  out2max('port', portName);
  return true;
}

// ── Timer: a sorted queue, a system timer ~WAKE_EARLY_MS early, then a spin ──
const WAKE_EARLY_MS = 2;
const SPIN_MAX_MS = 4;
const queue = []; // { at, fn }
let timer = null;
const lateness = [];
function at(t, fn) {
  let i = queue.length;
  while (i > 0 && queue[i - 1].at > t) i--;
  queue.splice(i, 0, { at: t, fn });
  arm();
}
function arm() {
  if (timer) { clearTimeout(timer); timer = null; }
  if (!queue.length) return;
  const wait = queue[0].at - performance.now() - WAKE_EARLY_MS;
  timer = setTimeout(run, Math.max(0, wait));
}
function run() {
  timer = null;
  let now = performance.now();
  // spin up to the first due time (bounded: a timer woken far too early just re-arms)
  if (queue.length && queue[0].at - now <= SPIN_MAX_MS) while ((now = performance.now()) < queue[0].at) { /* spin */ }
  while (queue.length && queue[0].at <= now + 0.05) {
    const e = queue.shift();
    lateness.push(performance.now() - e.at);
    try { e.fn(); } catch (err) { log('port-spike: send failed', err.message); }
    now = performance.now();
  }
  arm();
}
function send(bytes) { if (output) output.sendMessage(bytes); }

// ── Live's transport (smoothed as the bridge does) ──────────────────────────────
let Transport;
try { ({ Transport } = require('./link-core')); } catch { Transport = null; }
const tr = Transport ? new Transport() : { playing: false, beat: 0, tempo: 120, set(o) { Object.assign(this, o); this.at = performance.now(); }, beatAt(n) { return this.playing ? this.beat + (n - this.at) * this.tempo / 60000 : this.beat; }, msPerBeat() { return 60000 / this.tempo; } };

// ── The pattern: a chord on every beat, scheduled LOOKAHEAD_MS ahead ────────────
const LOOKAHEAD_MS = 150;
const CHORD = [60, 64, 67];
let patternOn = true;
let nextBeat = null; // next whole beat to schedule
function scheduleAhead() {
  const now = performance.now();
  if (!tr.playing || !patternOn || !output) { nextBeat = null; return; }
  const b = tr.beatAt(now);
  if (nextBeat === null) nextBeat = Math.ceil(b + 0.05);
  const msPerBeat = tr.msPerBeat();
  while (true) {
    const t = now + (nextBeat - b) * msPerBeat;
    if (t > now + LOOKAHEAD_MS) break;
    const ch = (channel - 1) & 15;
    const offT = t + msPerBeat * 0.9;
    at(t, () => { for (const n of CHORD) send([0x90 | ch, n, 100]); });
    at(offT, () => { for (const n of CHORD) send([0x80 | ch, n, 0]); });
    nextBeat++;
  }
}
setInterval(scheduleAhead, 10);

// ── Stats every second ──────────────────────────────────────────────────────────
setInterval(() => {
  if (!lateness.length) return;
  const a = lateness.splice(0).sort((x, y) => x - y);
  const avg = a.reduce((s, x) => s + x, 0) / a.length;
  const p95 = a[Math.min(a.length - 1, Math.floor(a.length * 0.95))];
  const line = `sends ${a.length} late avg ${avg.toFixed(2)} / p95 ${p95.toFixed(2)} / max ${a[a.length - 1].toFixed(2)} ms · ${portName || 'no port'} ch ${channel} · ${tr.playing ? 'playing' : 'stopped'} ${tr.tempo.toFixed(1)} BPM`;
  log('port-spike:', line);
  out2max('stats', line);
}, 1000);

// ── Max messages / standalone clock ───────────────────────────────────────────
if (max) {
  max.addHandler('transport', (playing, beat, tempo) => { tr.set({ playing: !!Number(playing), beat: Number(beat), tempo: Number(tempo) }, performance.now()); if (!tr.playing) nextBeat = null; });
  max.addHandler('ports', () => log('port-spike: ports:', listPorts().join(' | ')));
  max.addHandler('port', (...words) => openPort(words.join(' ')));
  max.addHandler('channel', c => { channel = Math.max(1, Math.min(16, Number(c) | 0)); log('port-spike: channel', channel); });
  max.addHandler('pattern', v => { patternOn = String(v) !== 'off' && String(v) !== '0'; log('port-spike: pattern', patternOn ? 'on' : 'off'); });
  log('port-spike 0.0.1 (Max) · node', process.version, '· ports:', listPorts().join(' | ') || '(none)');
} else {
  const bpm = Number(arg('--bpm', '120'));
  const want = arg('--port', null);
  channel = Number(arg('--channel', '1'));
  log('port-spike 0.0.1 standalone · node', process.version, '· ports:', listPorts().join(' | ') || '(none)');
  if (want) openPort(want);
  if (!output && midi) log('port-spike: no port open (--port <name>): measuring the timer only');
  // no port: still measure the timer (sends are no-ops)
  if (!output) output = { sendMessage() {} };
  const t0 = performance.now();
  tr.set({ playing: true, beat: 0, tempo: bpm }, t0);
  // a steady clock: re-report every 50 ms as Live does
  setInterval(() => { const n = performance.now(); tr.set({ playing: true, beat: (n - t0) * bpm / 60000, tempo: bpm }, n); }, 50);
  process.on('SIGINT', () => { try { output.closePort?.(); } catch {} process.exit(0); });
}
