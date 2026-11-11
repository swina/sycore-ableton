// Generates port-spike.maxpat and port-spike.amxd (a ready Max MIDI Effect) — run: node make-device.mjs
// Also copies ../link/link-core.js here (the spike smooths Live's transport as the bridge does).
import { writeFileSync, readFileSync, copyFileSync } from 'node:fs';
const DIR = 'C:/Users/swina/Documents/sycore-port-spike';
copyFileSync(new URL('../link/link-core.js', import.meta.url), new URL('./link-core.js', import.meta.url));
const B = [
  // id, text, inlets, outlets, x, y, kind
  ['dev', 'live.thisdevice', 1, 3, 30, 30],
  ['tb', 't b', 1, 1, 30, 60],
  ['path', 'path live_set', 2, 1, 30, 90, 'message'],
  ['lp', 'live.path', 1, 3, 30, 120],
  ['obP', 'live.observer is_playing', 2, 2, 30, 160],
  ['obB', 'live.observer current_song_time', 2, 2, 200, 160],
  ['obT', 'live.observer tempo', 2, 2, 420, 160],
  ['pak', 'pak 0 0. 0.', 3, 1, 30, 200],
  ['pre', 'prepend transport', 1, 1, 30, 230],
  ['inst', 'script npm install', 2, 1, 30, 270, 'message'],
  ['start', 'script start', 2, 1, 160, 270, 'message'],
  ['ports', 'ports', 2, 1, 260, 270, 'message'],
  ['pW1', 'port MIDIWIN (B)', 2, 1, 320, 240, 'message'],
  ['pW2', 'port MIDI WIN 2 (B)', 2, 1, 450, 240, 'message'],
  ['pW3', 'port MIDI WIN 3 (B)', 2, 1, 600, 240, 'message'],
  ['pSyc', 'port SYC OUT A', 2, 1, 750, 240, 'message'],
  ['chN', 'number', 1, 2, 510, 270, 'number'],
  ['chP', 'prepend channel', 1, 1, 510, 295],
  ['chL', 'channel:', 1, 0, 450, 270, 'comment'],
  ['pOn', 'pattern on', 2, 1, 590, 270, 'message'],
  ['pOff', 'pattern off', 2, 1, 670, 270, 'message'],
  ['node', `node.script ${DIR}/port-spike.js @autostart 1`, 1, 2, 30, 310],
  ['route', 'route stats port', 1, 3, 30, 350],
  ['setS', 'prepend set', 1, 1, 30, 380],
  ['stat', '-', 2, 1, 30, 410, 'message'],
  ['setP', 'prepend set', 1, 1, 330, 380],
  ['portM', '-', 2, 1, 330, 410, 'message'],
  ['in', 'midiin', 1, 1, 560, 380],
  ['out', 'midiout', 1, 0, 560, 410],
  ['c1', 'Pick a port (ports: list in the Max console) and a channel, Live in Play: a C chord on every beat. Stats: lateness of the sends (timer quality).', 1, 0, 30, 440, 'comment'],
];
const L = [
  ['dev', 0, 'tb', 0], ['tb', 0, 'path', 0], ['path', 0, 'lp', 0],
  ['lp', 0, 'obP', 1], ['lp', 0, 'obB', 1], ['lp', 0, 'obT', 1],
  ['obP', 0, 'pak', 0], ['obB', 0, 'pak', 1], ['obT', 0, 'pak', 2],
  ['pak', 0, 'pre', 0], ['pre', 0, 'node', 0],
  ...['inst', 'start', 'ports', 'pW1', 'pW2', 'pW3', 'pSyc', 'pOn', 'pOff'].map(k => [k, 0, 'node', 0]),
  ['chN', 0, 'chP', 0], ['chP', 0, 'node', 0],
  ['node', 0, 'route', 0], ['route', 0, 'setS', 0], ['setS', 0, 'stat', 0], ['route', 1, 'setP', 0], ['setP', 0, 'portM', 0],
  ['in', 0, 'out', 0],
];
const id = k => 'obj-' + k;
// Live shows the device in presentation: the controls and the stats, in a 570 × 150 strip.
const PRES = {
  inst: [4, 4, 110, 20], start: [118, 4, 70, 20], ports: [192, 4, 44, 20], pOn: [250, 4, 70, 20], pOff: [324, 4, 74, 20],
  pW1: [4, 28, 110, 20], pW2: [118, 28, 124, 20], pW3: [246, 28, 124, 20], pSyc: [374, 28, 104, 20],
  chL: [484, 30, 50, 18], chN: [532, 28, 34, 20],
  portM: [4, 54, 562, 20], stat: [4, 78, 562, 20], c1: [4, 104, 562, 36],
};
const boxes = B.map(([k, text, ni, no, x, y, kind = 'newobj']) => ({ box: {
  id: id(k), maxclass: kind, text, numinlets: ni, numoutlets: no,
  outlettype: Array(no).fill(''), patching_rect: [x, y, Math.max(60, text.length * 7 + 16), 22],
  ...(PRES[k] ? { presentation: 1, presentation_rect: PRES[k] } : {}),
  ...(kind === 'number' ? { minimum: 1, maximum: 16, text: undefined } : {}),
}}));
const lines = L.map(([s, so, d, di]) => ({ patchline: { source: [id(s), so], destination: [id(d), di] } }));
const patcher = { patcher: { fileversion: 1, appversion: { major: 8, minor: 6, revision: 0, architecture: 'x64', modernui: 1 },
  classnamespace: 'box', rect: [100, 100, 900, 520], openinpresentation: 1, devicewidth: 570, boxes, lines } };
const json = JSON.stringify(patcher, null, 2);
writeFileSync(new URL('./port-spike.maxpat', import.meta.url), json);
const u32 = n => { const b = Buffer.alloc(4); b.writeUInt32LE(n); return b; };
const body = Buffer.from(json + '\n\0', 'utf8');
writeFileSync(new URL('./port-spike.amxd', import.meta.url), Buffer.concat([
  Buffer.from('ampf'), u32(4), Buffer.from('mmmm'), Buffer.from('meta'), u32(4), Buffer.alloc(4),
  Buffer.from('ptch'), u32(body.length), body,
]));
console.log('wrote port-spike.maxpat and port-spike.amxd:', boxes.length, 'boxes,', lines.length, 'lines');
