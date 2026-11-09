// Generates the SY.CORE Link device patches — run: node make-patch.mjs
// The devices play only SY.CORE's MIDI: the track's own input is not passed through (with MIDI From =
// All Ins, a controller's notes and CCs would reach the instruments of the tracks recording from it).
//   sycore-link.maxpat          the bridge (one per Live set): WebSocket server, Live's transport, timed MIDI
//   sycore-link-receive.maxpat  a receiver for other tracks: the bridge's MIDI on one channel (or all)
// Every MIDI message the bridge plays is also sent to [s sycore_link_midi] (global across the
// Live set's devices), so each receiver on its own track picks its channel: Drum ch 10 → Drum Rack, etc.
import { writeFileSync } from 'node:fs';

const SEND_NAME = 'sycore_link_midi';
const CHANNELS = ['All', ...Array.from({ length: 16 }, (_, i) => String(i + 1))];

/** Box: [id, text, inlets, outlets, x, y, opts] — opts: kind (maxclass), p (presentation rect), extra box props. */
function build(B, L, { width }) {
  const id = k => 'obj-' + k;
  const boxes = B.map(([k, text, ni, no, x, y, o = {}]) => {
    const { kind = 'newobj', p, ...extra } = o;
    const box = {
      id: id(k), maxclass: kind, numinlets: ni, numoutlets: no, outlettype: Array(no).fill(''),
      patching_rect: [x, y, Math.max(60, String(text).length * 7 + 16), 22], ...extra,
    };
    if (kind !== 'live.menu') box.text = text;
    if (p) { box.presentation = 1; box.presentation_rect = p; }
    return { box };
  });
  const lines = L.map(([s, so, d, di]) => ({ patchline: { source: [id(s), so], destination: [id(d), di] } }));
  return { patcher: {
    fileversion: 1, appversion: { major: 8, minor: 6, revision: 0, architecture: 'x64', modernui: 1 },
    classnamespace: 'box', rect: [100, 100, 1100, 640], openinpresentation: 1, devicewidth: width,
    boxes, lines,
  } };
}

const comment = (p, extra = {}) => ({ kind: 'comment', p, ...extra });
const title = p => comment(p, { fontsize: 12, fontface: 1 });

/** Channel menu (a Live parameter: saved with the set) + filter: a message passes when the menu is All or its channel. */
const filterBoxes = (x, y, menuP) => [
  ['ft', 't l l', 1, 2, x, y],
  ['fn', 'zl nth 1', 2, 2, x + 90, y + 30],
  ['fx', 'expr $i2 == 0 || (($i1 & 15) + 1) == $i2', 2, 1, x + 90, y + 60],
  ['fg', 'gate 1 1', 2, 1, x, y + 90],
  ['menu', '', 1, 3, x + 330, y + 30, {
    kind: 'live.menu', p: menuP, parameter_enable: 1, varname: 'Channel',
    saved_attribute_attributes: { valueof: {
      parameter_enum: CHANNELS, parameter_initial: [0], parameter_initial_enable: 1,
      parameter_longname: 'Channel', parameter_shortname: 'Channel', parameter_type: 2, parameter_mmax: 16,
    } },
  }],
];
// t l l: right outlet first (channel → gate open/closed), then the message into the gate.
const filterLines = [
  ['ft', 1, 'fn', 0], ['fn', 0, 'fx', 0], ['menu', 0, 'fx', 1], ['fx', 0, 'fg', 0], ['ft', 0, 'fg', 1],
];

// ── Bridge ──────────────────────────────────────────────────────────────────
const bridge = build([
  ['dev', 'live.thisdevice', 1, 3, 30, 20],
  ['tb', 't b b', 1, 2, 30, 50],
  ['path', 'path live_set', 2, 1, 30, 80, { kind: 'message' }],
  ['lp', 'live.path', 1, 3, 30, 110],
  ['obP', 'live.observer is_playing', 2, 2, 30, 150],
  ['obB', 'live.observer current_song_time', 2, 2, 190, 150],
  ['obT', 'live.observer tempo', 2, 2, 400, 150],
  ['obN', 'live.observer signature_numerator', 2, 2, 540, 150],
  ['obD', 'live.observer signature_denominator', 2, 2, 770, 150],
  ['pak', 'pak 0 0. 0. 4 4', 5, 1, 30, 190],
  ['pre', 'prepend transport', 1, 1, 30, 220],
  ['tpath', 'path this_device canonical_parent', 2, 1, 600, 50, { kind: 'message' }],
  ['tlp', 'live.path', 1, 3, 600, 80],
  ['obName', 'live.observer name', 2, 2, 600, 110],
  ['tpre', 'prepend track', 1, 1, 600, 220],
  ['start', 'script start', 2, 1, 250, 220, { kind: 'message' }],
  ['inst', 'script npm install', 2, 1, 350, 220, { kind: 'message' }],
  // Full path: the device works wherever Live saves the .amxd (SYCORE_LINK_DIR overrides it).
  ['node', `node.script ${(process.env.SYCORE_LINK_DIR || 'C:/Users/swina/Documents/sycore-link')}/sycore-link.js @autostart 1`, 1, 2, 30, 260],
  ['route', 'route midi3 midi2 clear info stats', 1, 6, 30, 300],
  // midi3 b1 b2 b3 beat → delay = (beat × resolution − ticks now) in ms, from Live's transport in Max
  ['t3', 't l b', 1, 2, 30, 330],
  ['tr3', 'transport', 2, 9, 120, 360],
  ['ex3', 'expr max(0.\\, ($f1*$f4 - $f2)*60000./($f3*$f4))', 4, 1, 30, 420],
  ['up3', 'unpack 0 0 0 0.', 1, 4, 30, 390],
  ['pipe3', 'pipe 0 0 0 0', 4, 3, 30, 450],
  ['pk3', 'pack 0 0 0', 3, 1, 30, 480],
  ['t2', 't l b', 1, 2, 380, 330],
  ['tr2', 'transport', 2, 9, 470, 360],
  ['ex2', 'expr max(0.\\, ($f1*$f4 - $f2)*60000./($f3*$f4))', 4, 1, 380, 420],
  ['up2', 'unpack 0 0 0.', 1, 3, 380, 390],
  ['pipe2', 'pipe 0 0 0', 3, 2, 380, 450],
  ['pk2', 'pack 0 0', 2, 1, 380, 480],
  ['tclr', 't clear clear', 1, 2, 330, 340],
  ['snd', `s ${SEND_NAME}`, 1, 0, 250, 520],
  ...filterBoxes(30, 520, [10, 92, 60, 18]),
  // [iter]: raw bytes one at a time — the safe way into [midiout]
  ['iter', 'iter', 1, 1, 30, 650],
  ['out', 'midiout', 1, 0, 30, 680],
  ['pinfo', 'prepend set', 1, 1, 700, 300],
  ['pstats', 'prepend set', 1, 1, 850, 300],
  // UI (presentation)
  ['ttl', 'SY.CORE Link', 1, 0, 700, 400, title([8, 6, 200, 20])],
  ['info', 'starting…', 1, 0, 700, 430, comment([8, 30, 250, 18])],
  ['stats', '–', 1, 0, 700, 460, comment([8, 50, 250, 18])],
  ['chl', 'Channel played on this track', 1, 0, 700, 490, comment([76, 92, 190, 18])],
  ['hint', 'Other tracks: SY.CORE Link Receive', 1, 0, 700, 520, comment([8, 120, 250, 18], { textcolor: [0.6, 0.6, 0.6, 1] })],
], [
  ['dev', 0, 'tb', 0], ['tb', 1, 'path', 0], ['tb', 0, 'tpath', 0], ['path', 0, 'lp', 0],
  ['lp', 0, 'obP', 1], ['lp', 0, 'obB', 1], ['lp', 0, 'obT', 1], ['lp', 0, 'obN', 1], ['lp', 0, 'obD', 1],
  ['obP', 0, 'pak', 0], ['obB', 0, 'pak', 1], ['obT', 0, 'pak', 2], ['obN', 0, 'pak', 3], ['obD', 0, 'pak', 4],
  ['pak', 0, 'pre', 0], ['pre', 0, 'node', 0],
  ['tpath', 0, 'tlp', 0], ['tlp', 0, 'obName', 1], ['obName', 0, 'tpre', 0], ['tpre', 0, 'node', 0],
  ['start', 0, 'node', 0], ['inst', 0, 'node', 0],
  ['node', 0, 'route', 0],
  ['route', 0, 't3', 0], ['t3', 1, 'tr3', 0], ['t3', 0, 'up3', 0],
  ['tr3', 7, 'ex3', 1], ['tr3', 4, 'ex3', 2], ['tr3', 3, 'ex3', 3],
  ['up3', 3, 'ex3', 0], ['ex3', 0, 'pipe3', 3], ['up3', 2, 'pipe3', 2], ['up3', 1, 'pipe3', 1], ['up3', 0, 'pipe3', 0],
  ['pipe3', 0, 'pk3', 0], ['pipe3', 1, 'pk3', 1], ['pipe3', 2, 'pk3', 2],
  ['route', 1, 't2', 0], ['t2', 1, 'tr2', 0], ['t2', 0, 'up2', 0],
  ['tr2', 7, 'ex2', 1], ['tr2', 4, 'ex2', 2], ['tr2', 3, 'ex2', 3],
  ['up2', 2, 'ex2', 0], ['ex2', 0, 'pipe2', 2], ['up2', 1, 'pipe2', 1], ['up2', 0, 'pipe2', 0],
  ['pipe2', 0, 'pk2', 0], ['pipe2', 1, 'pk2', 1],
  // Each timed message: to the receivers, and through this track's channel filter to its own output.
  ['pk3', 0, 'snd', 0], ['pk2', 0, 'snd', 0], ['pk3', 0, 'ft', 0], ['pk2', 0, 'ft', 0],
  ...filterLines, ['fg', 0, 'iter', 0], ['iter', 0, 'out', 0],
  ['route', 2, 'tclr', 0], ['tclr', 0, 'pipe3', 0], ['tclr', 1, 'pipe2', 0],
  ['route', 3, 'pinfo', 0], ['pinfo', 0, 'info', 0],
  ['route', 4, 'pstats', 0], ['pstats', 0, 'stats', 0],
], { width: 270 });

// ── Receiver ────────────────────────────────────────────────────────────────
const receiver = build([
  ['rcv', `r ${SEND_NAME}`, 1, 1, 30, 20],
  ...filterBoxes(30, 60, [10, 34, 60, 18]),
  ['iter', 'iter', 1, 1, 30, 190],
  ['out', 'midiout', 1, 0, 30, 220],
  ['ttl', 'SY.CORE Link Receive', 1, 0, 400, 20, title([8, 6, 200, 20])],
  ['chl', 'Channel', 1, 0, 400, 50, comment([76, 34, 80, 18])],
  ['hint', 'Needs the SY.CORE Link device on a track of this set', 1, 0, 400, 80,
    comment([8, 60, 190, 32], { textcolor: [0.6, 0.6, 0.6, 1] })],
], [
  ['rcv', 0, 'ft', 0], ...filterLines, ['fg', 0, 'iter', 0], ['iter', 0, 'out', 0],
], { width: 210 });

for (const [file, p] of [['sycore-link.maxpat', bridge], ['sycore-link-receive.maxpat', receiver]]) {
  writeFileSync(new URL('./' + file, import.meta.url), JSON.stringify(p, null, 2));
  console.log('wrote', file, p.patcher.boxes.length, 'boxes,', p.patcher.lines.length, 'lines');
}
