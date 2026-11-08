// Generates sycore-link.maxpat (the SY.CORE Link device patch) — run: node make-patch.mjs
import { writeFileSync } from 'node:fs';
const B = [
  // id, text, inlets, outlets, x, y, kind
  ['dev', 'live.thisdevice', 1, 3, 30, 20],
  ['tb', 't b b', 1, 2, 30, 50],
  ['path', 'path live_set', 2, 1, 30, 80, 'message'],
  ['lp', 'live.path', 1, 3, 30, 110],
  ['obP', 'live.observer is_playing', 2, 2, 30, 150],
  ['obB', 'live.observer current_song_time', 2, 2, 190, 150],
  ['obT', 'live.observer tempo', 2, 2, 400, 150],
  ['obN', 'live.observer signature_numerator', 2, 2, 540, 150],
  ['obD', 'live.observer signature_denominator', 2, 2, 770, 150],
  ['pak', 'pak 0 0. 0. 4 4', 5, 1, 30, 190],
  ['pre', 'prepend transport', 1, 1, 30, 220],
  ['tpath', 'path this_device canonical_parent', 2, 1, 600, 50, 'message'],
  ['tlp', 'live.path', 1, 3, 600, 80],
  ['obName', 'live.observer name', 2, 2, 600, 110],
  ['tpre', 'prepend track', 1, 1, 600, 220],
  ['start', 'script start', 2, 1, 250, 220, 'message'],
  ['inst', 'script npm install', 2, 1, 350, 220, 'message'],
  // Full path: the device works wherever Live saves the .amxd (SYCORE_LINK_DIR overrides it).
  ['node', `node.script ${(process.env.SYCORE_LINK_DIR || 'C:/Users/swina/Documents/sycore-link')}/sycore-link.js @autostart 1`, 1, 2, 30, 260],
  ['route', 'route midi3 midi2 clear status', 1, 5, 30, 300],
  ['pipe3', 'pipe 0 0 0 0', 4, 3, 30, 340],
  ['pk3', 'pack 0 0 0', 3, 1, 30, 370],
  ['pipe2', 'pipe 0 0 0', 3, 2, 200, 340],
  ['pk2', 'pack 0 0', 2, 1, 200, 370],
  ['tclr', 't clear clear', 1, 2, 330, 340],
  ['in', 'midiin', 1, 1, 470, 370],
  ['out', 'midiout', 1, 0, 30, 420],
  ['set', 'prepend set', 1, 1, 470, 300],
  ['stat', '0', 2, 1, 470, 330, 'message'],
  ['c1', 'SY.CORE Link · clients connected', 1, 0, 520, 330, 'comment'],
];
const L = [
  ['dev', 0, 'tb', 0], ['tb', 1, 'path', 0], ['tb', 0, 'tpath', 0], ['path', 0, 'lp', 0],
  ['lp', 0, 'obP', 1], ['lp', 0, 'obB', 1], ['lp', 0, 'obT', 1], ['lp', 0, 'obN', 1], ['lp', 0, 'obD', 1],
  ['obP', 0, 'pak', 0], ['obB', 0, 'pak', 1], ['obT', 0, 'pak', 2], ['obN', 0, 'pak', 3], ['obD', 0, 'pak', 4],
  ['pak', 0, 'pre', 0], ['pre', 0, 'node', 0],
  ['tpath', 0, 'tlp', 0], ['tlp', 0, 'obName', 1], ['obName', 0, 'tpre', 0], ['tpre', 0, 'node', 0],
  ['start', 0, 'node', 0], ['inst', 0, 'node', 0],
  ['node', 0, 'route', 0],
  ['route', 0, 'pipe3', 0], ['pipe3', 0, 'pk3', 0], ['pipe3', 1, 'pk3', 1], ['pipe3', 2, 'pk3', 2], ['pk3', 0, 'out', 0],
  ['route', 1, 'pipe2', 0], ['pipe2', 0, 'pk2', 0], ['pipe2', 1, 'pk2', 1], ['pk2', 0, 'out', 0],
  ['route', 2, 'tclr', 0], ['tclr', 0, 'pipe3', 0], ['tclr', 1, 'pipe2', 0],
  ['route', 3, 'set', 0], ['set', 0, 'stat', 0],
  ['in', 0, 'out', 0],
];
const id = k => 'obj-' + k;
const boxes = B.map(([k, text, ni, no, x, y, kind = 'newobj']) => ({ box: {
  id: id(k), maxclass: kind, text, numinlets: ni, numoutlets: no,
  outlettype: Array(no).fill(''), patching_rect: [x, y, Math.max(60, text.length * 7 + 16), 22],
}}));
const lines = L.map(([s, so, d, di]) => ({ patchline: { source: [id(s), so], destination: [id(d), di] } }));
const patcher = { patcher: { fileversion: 1, appversion: { major: 8, minor: 6, revision: 0, architecture: 'x64', modernui: 1 },
  classnamespace: 'box', rect: [100, 100, 1000, 520], openinpresentation: 0, boxes, lines } };
writeFileSync(new URL('./sycore-link.maxpat', import.meta.url), JSON.stringify(patcher, null, 2));
console.log('wrote sycore-link.maxpat:', boxes.length, 'boxes,', lines.length, 'lines');
