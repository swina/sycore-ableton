// Generates sycore-link-spike.maxpat (the spike device patch) — run: node make-patch.mjs
import { writeFileSync } from 'node:fs';
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
  ['start', 'script start', 2, 1, 200, 230, 'message'],
  ['inst', 'script npm install', 2, 1, 300, 230, 'message'],
  ['node', 'node.script sycore-link-spike.js @autostart 1', 1, 2, 30, 270],
  ['route', 'route note status', 1, 3, 30, 310],
  ['pipe', 'pipe 0 0 0 0', 4, 3, 30, 350],
  ['mk', 'makenote 100 125', 3, 2, 30, 390],
  ['pk', 'pack 0 0', 2, 1, 30, 420],
  ['mf', 'midiformat', 7, 2, 30, 450],
  ['in', 'midiin', 1, 1, 300, 420],
  ['out', 'midiout', 1, 0, 30, 490],
  ['set', 'prepend set', 1, 1, 260, 350],
  ['stat', '0', 2, 1, 260, 380, 'message'],
  ['c1', 'SY.CORE Link spike · clients:', 1, 0, 360, 380, 'comment'],
];
const L = [
  ['dev', 0, 'tb', 0], ['tb', 0, 'path', 0], ['path', 0, 'lp', 0],
  ['lp', 0, 'obP', 1], ['lp', 0, 'obB', 1], ['lp', 0, 'obT', 1],
  ['obP', 0, 'pak', 0], ['obB', 0, 'pak', 1], ['obT', 0, 'pak', 2],
  ['pak', 0, 'pre', 0], ['pre', 0, 'node', 0], ['start', 0, 'node', 0], ['inst', 0, 'node', 0],
  ['node', 0, 'route', 0], ['route', 0, 'pipe', 0], ['route', 1, 'set', 0], ['set', 0, 'stat', 0],
  ['pipe', 0, 'mk', 0], ['pipe', 1, 'mk', 1], ['pipe', 2, 'mk', 2],
  ['mk', 0, 'pk', 0], ['mk', 1, 'pk', 1], ['pk', 0, 'mf', 0],
  ['mf', 0, 'out', 0], ['in', 0, 'out', 0],
];
const id = k => 'obj-' + k;
const boxes = B.map(([k, text, ni, no, x, y, kind = 'newobj']) => ({ box: {
  id: id(k), maxclass: kind, text, numinlets: ni, numoutlets: no,
  outlettype: Array(no).fill(''), patching_rect: [x, y, Math.max(60, text.length * 7 + 16), 22],
}}));
const lines = L.map(([s, so, d, di]) => ({ patchline: { source: [id(s), so], destination: [id(d), di] } }));
const patcher = { patcher: { fileversion: 1, appversion: { major: 8, minor: 6, revision: 0, architecture: 'x64', modernui: 1 },
  classnamespace: 'box', rect: [100, 100, 760, 560], openinpresentation: 0, boxes, lines } };
writeFileSync(new URL('./sycore-link-spike.maxpat', import.meta.url), JSON.stringify(patcher, null, 2));
console.log('wrote sycore-link-spike.maxpat:', boxes.length, 'boxes,', lines.length, 'lines');
