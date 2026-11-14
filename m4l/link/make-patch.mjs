// Generates the SY.CORE Link device patches — run: node make-patch.mjs
// The devices play only SY.CORE's MIDI: the track's own input is not passed through (with MIDI From =
// All Ins, a controller's notes and CCs would reach the instruments of the tracks recording from it).
//   sycore-link.maxpat          the bridge (one per Live set): WebSocket server, Live's transport, timed MIDI
//   sycore-link-receive.maxpat  a receiver for other tracks: the bridge's MIDI on one channel (or all)
//   sycore-rig.maxpat           SY.CORE's Rig Controller slot grid in Live (in the device, and a floating window)
//   sycore-map.maxpat           SY.CORE Map (P12): the instrument of a track driven by table (one per set)
// Every MIDI message the bridge plays is also sent to [s sycore_link_midi] (global across the
// Live set's devices), so each receiver on its own track picks its channel: Drum ch 10 → Drum Rack, etc.
import { writeFileSync } from 'node:fs';

const SEND_NAME = 'sycore_link_midi';
// Rig devices ↔ the bridge, inside Max: the Rig state out ([s RIG_STATE]), the clicks in ([s RIG_PRESS]).
const RIG_STATE = 'sycore_rig';
const RIG_PRESS = 'sycore_rig_in';
// The SY.CORE Map device (P12) ↔ the bridge: the tables / slot values out, its info and values in.
const MAP_OUT = 'sycore_map';
const MAP_IN = 'sycore_map_in';
// Scripts by file name only: Max finds them next to the .amxd (the distributed folder). SYCORE_LINK_DIR
// pins a folder instead (a full path, as before), for a dev setup that keeps the scripts elsewhere.
const LINK_DIR = process.env.SYCORE_LINK_DIR || '';
const at = f => (LINK_DIR ? `${LINK_DIR}/${f}` : f);

// SY.CORE's look (src/assets/main.css in sycore-refactor): dark panels, brand green, cyan accent,
// bold uppercase titles, small muted uppercase labels. Max colors: [r, g, b, a] in 0–1.
const hex = (h, a = 1) => [0, 2, 4].map(i => +(parseInt(h.slice(1 + i, 3 + i), 16) / 255).toFixed(3)).concat(a);
const C = {
  canvas: hex('#0a0a0a'), panel: hex('#131313'), border: hex('#ffffff', 0.1), line: hex('#ffffff', 0.06),
  ink: hex('#f5f5f5'), muted: hex('#8a8f92'), dim: hex('#5b6265'),
  brand: hex('#00A370'), brandSoft: hex('#33D6A8'), accent: hex('#00C2FF'), amber: hex('#F59E0B'), red: hex('#EF4444'),
};
const H = 169; // a Live device is 169 px tall
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
    if (!['live.menu', 'live.numbox', 'led', 'panel', 'jsui', 'inlet'].includes(kind)) box.text = text;
    if (p) { box.presentation = 1; box.presentation_rect = p; }
    // Keys in alphabetical order, as Max saves them (a live.tab ignored its rows otherwise).
    return { box: Object.fromEntries(Object.entries(box).sort(([a], [b]) => a.localeCompare(b))) };
  });
  // Max draws its box list back to front (first box on top): panels go last, the background panel last of all.
  const depth = b => (b.box.id === id('bg') ? 2 : b.box.maxclass === 'panel' ? 1 : 0);
  boxes.sort((a, b) => depth(a) - depth(b));
  const lines = L.map(([s, so, d, di]) => ({ patchline: { source: [id(s), so], destination: [id(d), di] } }));
  return { patcher: {
    fileversion: 1, appversion: { major: 8, minor: 6, revision: 0, architecture: 'x64', modernui: 1 },
    classnamespace: 'box', rect: [100, 100, 1100, 640], openinpresentation: 1, devicewidth: width,
    boxes, lines,
  } };
}

const comment = (p, extra = {}) => ({ kind: 'comment', p, textcolor: C.ink, fontsize: 10, ...extra });
const title = p => comment(p, { fontsize: 12, fontface: 1, textcolor: C.ink });
const label = (p, extra = {}) => comment(p, { fontsize: 9, fontface: 1, textcolor: C.muted, ...extra });
const hint = p => comment(p, { fontsize: 9, textcolor: C.dim });
// Panels as Ableton's own devices have them: not on the background layer (it did not show in
// Live), but at the end of the box list (build() moves them there), so they are drawn under the rest.
const panel = (p, { bgcolor, ...extra } = {}) => ({
  kind: 'panel', p, ignoreclick: 1, mode: 0, angle: 270, proportion: 0.39, style: '',
  bgcolor, bgfillcolor_type: 'color', bgfillcolor_color: bgcolor, ...extra,
});
const led = (p, oncolor) => ({ kind: 'led', p, oncolor, offcolor: C.line, blinkcolor: oncolor, blinktime: 60, ignoreclick: 1 });

/** Background boxes: the dark panel, a thin brand line on top, a divider under the status lines. */
const chrome = (width, dividerY) => [
  ['bg', '', 1, 0, 900, 20, panel([0, 0, width, H], { bgcolor: C.panel, bordercolor: C.border, border: 1, rounded: 6 })],
  ['bar', '', 1, 0, 900, 50, panel([0, 0, width, 2], { bgcolor: C.brand, border: 0, rounded: 0 })],
  ['div', '', 1, 0, 900, 80, panel([8, dividerY, width - 16, 1], { bgcolor: C.border, border: 0, rounded: 0 })],
];

/** Channel menu (a Live parameter: saved with the set) + filter: a message passes when the menu is All or its channel. */
const filterBoxes = (x, y, menuP) => [
  ['ft', 't l l', 1, 2, x, y],
  ['fn', 'zl nth 1', 2, 2, x + 90, y + 30],
  ['fx', 'expr $i2 == 0 || (($i1 & 15) + 1) == $i2', 2, 1, x + 90, y + 60],
  ['fg', 'gate 1 1', 2, 1, x, y + 90],
  ['menu', '', 1, 3, x + 330, y + 30, {
    kind: 'live.menu', p: menuP, parameter_enable: 1, varname: 'Channel',
    bgcolor: C.canvas, textcolor: C.ink, tricolor: C.accent, bgfillcolor_color: C.canvas,
    activebgcolor: C.canvas, activetextcolor: C.ink, fontsize: 10,
    saved_attribute_attributes: { valueof: {
      parameter_enum: CHANNELS, parameter_initial: [0], parameter_initial_enable: 1,
      parameter_longname: 'Channel', parameter_shortname: 'Channel', parameter_type: 2, parameter_mmax: 16,
    } },
  }],
];
/** Receiver: the channel as a 2×8 grid of buttons 1–16 (no All; a live.tab will not wrap onto two
 *  rows). The channel itself is a hidden int parameter 'MIDI Channel' (saved with the set; its own
 *  name, so a set saved with the old menu, index 0 = All, does not restore a shifted channel).
 *  Button k on → channel k; the channel → every button's state (set, no output): one lit at a time,
 *  and clicking the lit one leaves it lit. */
const channelGrid = (x, y, [gx, gy, gw, gh]) => {
  const gap = 2, cw = (gw - 7 * gap) / 8, ch = (gh - gap) / 2;
  const boxes = [
    ['ft', 't l l', 1, 2, x, y],
    ['fn', 'zl nth 1', 2, 2, x + 90, y + 30],
    ['fx', 'expr $i2 == 0 || (($i1 & 15) + 1) == $i2', 2, 1, x + 90, y + 60],
    ['fg', 'gate 1 1', 2, 1, x, y + 90],
    ['chan', '', 1, 2, x + 330, y + 300, {
      kind: 'live.numbox', parameter_enable: 1, varname: 'MIDI Channel',
      saved_attribute_attributes: { valueof: {
        parameter_initial: [1], parameter_initial_enable: 1, parameter_mmin: 1, parameter_mmax: 16,
        parameter_longname: 'MIDI Channel', parameter_shortname: 'Channel', parameter_type: 1,
      } },
    }],
    ['cdev', 'live.thisdevice', 1, 3, x + 330, y + 260],
  ];
  for (let k = 1; k <= 16; k++) {
    const r = k > 8 ? 1 : 0, c = (k - 1) % 8;
    const bx = x + 330 + (k - 1) * 40;
    boxes.push(
      ['b' + k, String(k), 1, 2, bx, y + 120, {
        kind: 'live.text', p: [gx + c * (cw + gap), gy + r * (ch + gap), cw, ch], mode: 1, texton: String(k),
        // A Live parameter as in Ableton's own devices (with parameter_enable 0 it did not react in
        // Live), hidden: not automatable, not saved — the channel is saved by 'MIDI Channel'.
        parameter_enable: 1, varname: 'Ch ' + k, fontsize: 9, rounded: 2,
        saved_attribute_attributes: { valueof: {
          parameter_enum: ['off', 'on'], parameter_mmax: 1, parameter_type: 2, parameter_invisible: 2,
          parameter_longname: 'Ch ' + k, parameter_shortname: String(k),
        } },
        bgcolor: C.canvas, bgoncolor: C.brand, activebgcolor: C.canvas, activebgoncolor: C.brand,
        textcolor: C.muted, textoncolor: hex('#000000'), activetextcolor: C.muted, activetextoncolor: hex('#000000'),
        bordercolor: C.border, focusbordercolor: C.border,
      }],
      ['s' + k, 'sel 1', 2, 2, bx, y + 150],
      ['m' + k, String(k), 2, 1, bx, y + 180, { kind: 'message' }],
      ['e' + k, '== ' + k, 2, 1, bx, y + 360],
      ['p' + k, 'prepend set', 1, 1, bx, y + 390],
    );
  }
  return boxes;
};
const channelGridLines = [
  ['ft', 1, 'fn', 0], ['fn', 0, 'fx', 0], ['chan', 0, 'fx', 1], ['fx', 0, 'fg', 0], ['ft', 0, 'fg', 1],
  ['cdev', 0, 'chan', 0],
  ...Array.from({ length: 16 }, (_, i) => i + 1).flatMap(k => [
    ['b' + k, 0, 's' + k, 0], ['s' + k, 0, 'm' + k, 0], ['m' + k, 0, 'chan', 0],
    ['chan', 0, 'e' + k, 0], ['e' + k, 0, 'p' + k, 0], ['p' + k, 0, 'b' + k, 0],
  ]),
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
  // The track name again once the script is up: the first one, at load, can arrive before it.
  ['tdel', 'del 1500', 2, 1, 760, 20],
  ['tpath', 'path this_device canonical_parent', 2, 1, 600, 50, { kind: 'message' }],
  ['tlp', 'live.path', 1, 3, 600, 80],
  ['obName', 'live.observer name', 2, 2, 600, 110],
  ['tpre', 'prepend track', 1, 1, 600, 220],
  ['start', 'script start', 2, 1, 250, 220, { kind: 'message' }],
  ['inst', 'script npm install', 2, 1, 350, 220, { kind: 'message' }],
  ['node', `node.script ${at('sycore-link.js')} @autostart 1`, 1, 2, 30, 260],
  ['route', 'route midi3 midi2 clear info stats state rig map play tempo', 1, 11, 30, 300],
  // Play / Stop from SY.CORE (bridge 1.5: 'transport'): Live's is_playing set on live_set
  ['pset', 'prepend set is_playing', 1, 1, 1280, 300],
  ['lobj', 'live.object', 2, 1, 1280, 330],
  // Tempo from SY.CORE (bridge 1.6: 'tempo'): live_set tempo
  ['tset', 'prepend set tempo', 1, 1, 1440, 300],
  // SY.CORE Rig devices: the Rig state to them, their clicks to SY.CORE
  ['rigs', `s ${RIG_STATE}`, 1, 0, 1000, 300],
  ['rigr', `r ${RIG_PRESS}`, 1, 1, 1000, 220],
  // the SY.CORE Map device (P12)
  ['maps', `s ${MAP_OUT}`, 1, 0, 1140, 300],
  ['mapr', `r ${MAP_IN}`, 1, 1, 1140, 220],
  // midi3 b1 b2 b3 beat → delay = (beat × resolution − ticks now) in ms, from Live's transport in Max.
  // Due now (≤ 0.5 ms: late, or beat -1): straight out through [gate], not through [pipe] — a click
  // on a slot sends a burst of these (note-offs, All Notes Off, the first note-ons), and Live crashed
  // inside [pipe] on one (2026-11-11, MaxPlug.dll access violation with pipe.mxe64 on the stack).
  ['t3', 't l b', 1, 2, 30, 330],
  ['tr3', 'transport', 2, 9, 120, 360],
  ['sl3', 'zl.slice 3', 2, 2, 30, 360],
  ['ex3', 'expr max(0.\\, ($f1*$f4 - $f2)*60000./($f3*$f4))', 4, 1, 120, 390],
  ['td3', 't f f', 1, 2, 120, 410],
  ['gt3', '> 0.5', 2, 1, 200, 430],
  ['gp3', '+ 1', 2, 1, 200, 450],
  ['g3', 'gate 2', 2, 2, 30, 430],
  ['up3', 'unpack 0 0 0', 1, 3, 90, 450],
  ['pipe3', 'pipe 0 0 0 0', 4, 3, 90, 470],
  ['pk3', 'pack 0 0 0', 3, 1, 90, 490],
  ['t2', 't l b', 1, 2, 380, 330],
  ['tr2', 'transport', 2, 9, 470, 360],
  ['sl2', 'zl.slice 2', 2, 2, 380, 360],
  ['ex2', 'expr max(0.\\, ($f1*$f4 - $f2)*60000./($f3*$f4))', 4, 1, 470, 390],
  ['td2', 't f f', 1, 2, 470, 410],
  ['gt2', '> 0.5', 2, 1, 550, 430],
  ['gp2', '+ 1', 2, 1, 550, 450],
  ['g2', 'gate 2', 2, 2, 380, 430],
  ['up2', 'unpack 0 0', 1, 2, 440, 450],
  ['pipe2', 'pipe 0 0 0', 3, 2, 440, 470],
  ['pk2', 'pack 0 0', 2, 1, 440, 490],
  ['tclr', 't clear clear', 1, 2, 330, 340],
  ['snd', `s ${SEND_NAME}`, 1, 0, 250, 520],
  ...filterBoxes(30, 520, [66, 90, 62, 18]),
  // [iter]: raw bytes one at a time — the safe way into [midiout]
  ['iter', 'iter', 1, 1, 30, 650],
  ['out', 'midiout', 1, 0, 30, 680],
  ['pinfo', 'prepend set', 1, 1, 700, 300],
  ['pstats', 'prepend set', 1, 1, 850, 300],
  // UI (presentation)
  ...chrome(270, 76),
  ['sled', '', 1, 1, 700, 360, led([10, 12, 12, 12], C.amber)],
  ['ssel', 'sel 0 1 2', 1, 4, 850, 330],
  ['s0', 'oncolor 0.961 0.62 0.043 1, 1', 2, 1, 850, 360, { kind: 'message' }],
  ['s1', 'oncolor 0. 0.639 0.439 1, 1', 2, 1, 1050, 360, { kind: 'message' }],
  ['s2', 'oncolor 0.937 0.267 0.267 1, 1', 2, 1, 1250, 360, { kind: 'message' }],
  ['ttl', 'SY.CORE LINK', 1, 0, 700, 400, title([28, 7, 150, 20])],
  ['actl', 'MIDI', 1, 0, 700, 430, label([214, 9, 34, 18])],
  ['ab', 't b', 1, 1, 600, 460],
  ['aled', '', 1, 1, 700, 460, led([248, 12, 12, 12], C.accent)],
  ['info', 'starting…', 1, 0, 700, 490, comment([8, 32, 254, 18])],
  ['stats', '–', 1, 0, 700, 520, comment([8, 52, 254, 18], { textcolor: C.muted, fontsize: 9 })],
  ['chl', 'CHANNEL', 1, 0, 700, 550, label([8, 90, 60, 18])],
  ['chd', 'played on this track', 1, 0, 700, 580, hint([134, 90, 130, 18])],
  ['hint', 'Other tracks: SY.CORE Link Receive', 1, 0, 700, 610, hint([8, 146, 254, 18])],
], [
  ['dev', 0, 'tb', 0], ['tb', 1, 'path', 0], ['tb', 0, 'tpath', 0], ['tb', 0, 'tdel', 0], ['tdel', 0, 'tpath', 0], ['path', 0, 'lp', 0],
  ['lp', 0, 'obP', 1], ['lp', 0, 'obB', 1], ['lp', 0, 'obT', 1], ['lp', 0, 'obN', 1], ['lp', 0, 'obD', 1],
  ['obP', 0, 'pak', 0], ['obB', 0, 'pak', 1], ['obT', 0, 'pak', 2], ['obN', 0, 'pak', 3], ['obD', 0, 'pak', 4],
  ['pak', 0, 'pre', 0], ['pre', 0, 'node', 0],
  ['tpath', 0, 'tlp', 0], ['tlp', 0, 'obName', 1], ['obName', 0, 'tpre', 0], ['tpre', 0, 'node', 0],
  ['start', 0, 'node', 0], ['inst', 0, 'node', 0],
  ['route', 6, 'rigs', 0], ['rigr', 0, 'node', 0],
  ['route', 7, 'maps', 0], ['mapr', 0, 'node', 0],
  ['route', 8, 'pset', 0], ['pset', 0, 'lobj', 0], ['lp', 0, 'lobj', 1],
  ['route', 9, 'tset', 0], ['tset', 0, 'lobj', 0],
  ['node', 0, 'route', 0],
  // [zl.slice] sends the beat (right) before the bytes (left): the delay and the gate's way are set first.
  ['route', 0, 't3', 0], ['t3', 1, 'tr3', 0], ['t3', 0, 'sl3', 0],
  ['tr3', 7, 'ex3', 1], ['tr3', 4, 'ex3', 2], ['tr3', 3, 'ex3', 3],
  ['sl3', 1, 'ex3', 0], ['ex3', 0, 'td3', 0], ['td3', 1, 'pipe3', 3], ['td3', 0, 'gt3', 0], ['gt3', 0, 'gp3', 0], ['gp3', 0, 'g3', 0],
  ['sl3', 0, 'g3', 1], ['g3', 1, 'up3', 0],
  ['up3', 2, 'pipe3', 2], ['up3', 1, 'pipe3', 1], ['up3', 0, 'pipe3', 0],
  ['pipe3', 0, 'pk3', 0], ['pipe3', 1, 'pk3', 1], ['pipe3', 2, 'pk3', 2],
  ['route', 1, 't2', 0], ['t2', 1, 'tr2', 0], ['t2', 0, 'sl2', 0],
  ['tr2', 7, 'ex2', 1], ['tr2', 4, 'ex2', 2], ['tr2', 3, 'ex2', 3],
  ['sl2', 1, 'ex2', 0], ['ex2', 0, 'td2', 0], ['td2', 1, 'pipe2', 2], ['td2', 0, 'gt2', 0], ['gt2', 0, 'gp2', 0], ['gp2', 0, 'g2', 0],
  ['sl2', 0, 'g2', 1], ['g2', 1, 'up2', 0],
  ['up2', 1, 'pipe2', 1], ['up2', 0, 'pipe2', 0],
  ['pipe2', 0, 'pk2', 0], ['pipe2', 1, 'pk2', 1],
  // Each message: to the receivers, and through this track's channel filter to its own output —
  // from [pipe] (later) or straight from [gate] (now).
  ['pk3', 0, 'snd', 0], ['pk2', 0, 'snd', 0], ['pk3', 0, 'ft', 0], ['pk2', 0, 'ft', 0],
  ['g3', 0, 'snd', 0], ['g2', 0, 'snd', 0], ['g3', 0, 'ft', 0], ['g2', 0, 'ft', 0],
  ...filterLines, ['fg', 0, 'iter', 0], ['iter', 0, 'out', 0],
  ['route', 2, 'tclr', 0], ['tclr', 0, 'pipe3', 0], ['tclr', 1, 'pipe2', 0],
  ['route', 3, 'pinfo', 0], ['pinfo', 0, 'info', 0],
  ['route', 4, 'pstats', 0], ['pstats', 0, 'stats', 0],
  ['route', 5, 'ssel', 0], ['ssel', 0, 's0', 0], ['ssel', 1, 's1', 0], ['ssel', 2, 's2', 0],
  ['s0', 0, 'sled', 0], ['s1', 0, 'sled', 0], ['s2', 0, 'sled', 0],
  ['fg', 0, 'ab', 0], ['ab', 0, 'aled', 0],
], { width: 270 });

// ── Receiver ────────────────────────────────────────────────────────────────
const receiver = build([
  ['rcv', `r ${SEND_NAME}`, 1, 1, 30, 20],
  ...channelGrid(30, 60, [8, 78, 194, 42]),
  ['iter', 'iter', 1, 1, 30, 190],
  ['out', 'midiout', 1, 0, 30, 220],
  ...chrome(210, 52),
  ['ttl', 'SY.CORE LINK', 1, 0, 400, 20, title([8, 7, 150, 20])],
  ['sub', 'RECEIVE', 1, 0, 400, 50, label([8, 27, 80, 18], { textcolor: C.accent })],
  ['actl', 'MIDI', 1, 0, 400, 80, label([154, 9, 34, 18])],
  ['ab', 't b', 1, 1, 300, 110],
  ['aled', '', 1, 1, 400, 110, led([188, 12, 12, 12], C.accent)],
  ['chl', 'CHANNEL', 1, 0, 400, 140, label([8, 58, 60, 18])],
  ['hint', 'Needs SY.CORE Link in this set', 1, 0, 400, 170, hint([8, 146, 194, 18])],
], [
  ['rcv', 0, 'ft', 0], ...channelGridLines, ['fg', 0, 'iter', 0], ['iter', 0, 'out', 0], ['fg', 0, 'ab', 0], ['ab', 0, 'aled', 0],
], { width: 210 });

// ── Rig ─────────────────────────────────────────────────────────────────────
// The Rig Controller's slot grid ([jsui] sycore-rig-grid.js, drawn to its box): the Rig state from
// the bridge, each click back to SY.CORE as a rig action. OPEN shows the same grid larger, in a
// floating window (a subpatcher opened with [pcontrol]).
const RIG_W = 380;
const jsui = (p, extra = {}) => ({ kind: 'jsui', p, filename: at('sycore-rig-grid.js'), border: 0, ...extra });
const WIN = [820, 390]; // the reference layout's proportions (1451 × 693: with the GEN column)
// OPEN reaches the window twice: [pcontrol] open on its box, and "front" to its own [thispatcher]
// through a device-local send (---: this device only) — either one opens it and brings it forward.
const rigWindow = build([
  ['in', '', 0, 1, 20, 20, { kind: 'inlet', index: 1, comment: '' }],
  ['wr', `r ${RIG_STATE}`, 1, 1, 20, 400],
  ['grid', '', 1, 1, 0, 0, jsui([0, 0, ...WIN], { patching_rect: [0, 0, ...WIN] })],
  ['ws', `s ${RIG_PRESS}`, 1, 0, 20, 440],
  ['wf', 'r ---rig_front', 1, 1, 200, 400],
  ['wb', 't b', 1, 1, 260, 400],
  ['wd', 'delay 30', 2, 1, 200, 430],
  ['wm', 'front', 2, 1, 200, 460, { kind: 'message' }],
  ['wt', 'thispatcher', 1, 2, 200, 490],
], [['wr', 0, 'grid', 0], ['grid', 0, 'ws', 0], ['wf', 0, 'wb', 0], ['wb', 0, 'wd', 0], ['wd', 0, 'wm', 0], ['wm', 0, 'wt', 0]], { width: WIN[0] }).patcher;
Object.assign(rigWindow, { rect: [120, 120, 120 + WIN[0], 120 + WIN[1]], toolbarvisible: 0, statusbarvisible: 0, enablehscroll: 0, enablevscroll: 0, bgcolor: C.panel });
const rig = build([
  ['rr', `r ${RIG_STATE}`, 1, 1, 30, 20],
  ['grid', '', 1, 1, 30, 60, jsui([8, 28, RIG_W - 16, 134], { patching_rect: [30, 60, 360, 134] })],
  ['rs', `s ${RIG_PRESS}`, 1, 0, 30, 220],
  ['open', 'OPEN', 1, 2, 420, 20, {
    kind: 'live.text', p: [RIG_W - 64, 6, 56, 17], mode: 0, texton: 'OPEN',
    parameter_enable: 1, varname: 'Open', fontsize: 9, rounded: 2,
    saved_attribute_attributes: { valueof: {
      parameter_enum: ['off', 'on'], parameter_mmax: 1, parameter_type: 2, parameter_invisible: 2,
      parameter_longname: 'Open window', parameter_shortname: 'Open',
    } },
    bgcolor: C.canvas, bgoncolor: C.brand, activebgcolor: C.canvas, activebgoncolor: C.brand,
    textcolor: C.ink, textoncolor: hex('#000000'), activetextcolor: C.ink, activetextoncolor: hex('#000000'),
    bordercolor: C.border, focusbordercolor: C.border,
  }],
  // live.text's click: 1 (or a bang) opens; its 0 does not
  ['orb', 'route bang', 1, 2, 520, 40],
  ['osel', 'sel 1', 2, 2, 420, 60],
  ['ofs', 's ---rig_front', 1, 0, 560, 120],
  ['omsg', 'open', 2, 1, 420, 90, { kind: 'message' }],
  ['pc', 'pcontrol', 1, 1, 420, 120],
  ['win', 'p SY.CORE Rig', 1, 0, 420, 160, { patcher: rigWindow }],
  ...chrome(RIG_W, 25).filter(b => b[0] !== 'div'),
  ['ttl', 'SY.CORE RIG', 1, 0, 600, 20, title([10, 5, 90, 20])],
  // the chord sounding and the next one (the same script, in a box less than 40 px tall)
  ['chd', '', 1, 1, 30, 260, jsui([100, 3, RIG_W - 64 - 108, 22], { patching_rect: [30, 260, 208, 22] })],
], [
  ['rr', 0, 'grid', 0], ['grid', 0, 'rs', 0], ['rr', 0, 'chd', 0],
  ['open', 0, 'orb', 0], ['orb', 0, 'omsg', 0], ['orb', 1, 'osel', 0], ['osel', 0, 'omsg', 0],
  ['omsg', 0, 'pc', 0], ['pc', 0, 'win', 0], ['omsg', 0, 'ofs', 0],
], { width: RIG_W });

// ── Map (P12) ───────────────────────────────────────────────────────────────
// One device in the set drives the instrument of a track by table: [js sycore-map.js] the logic (Live API),
// [jsui sycore-map-view.js] the 16 slots drawn (a reload of the view loses nothing); the logic moves the
// parameters through the Live API (no live.remote~). Follow: the selected track.
// The track's MIDI passes through (the device can sit on an instrument track too).
const MAP_W = 470;
const map = build([
  ['dev', 'live.thisdevice', 1, 3, 30, 20],
  ['mr', `r ${MAP_OUT}`, 1, 1, 200, 20],
  ['logic', `js ${at('sycore-map.js')}`, 1, 2, 30, 90],
  ['view', '', 1, 1, 30, 120, { kind: 'jsui', p: [8, 28, MAP_W - 16, 134], filename: at('sycore-map-view.js'), border: 0, patching_rect: [500, 120, 440, 134] }],
  // to the bridge; "followtoggle" sets the Follow toggle (without sending it back)
  ['rf', 'route followtoggle', 1, 2, 500, 270],
  ['fset', 'prepend set', 1, 1, 500, 300],
  ['ms', `s ${MAP_IN}`, 1, 0, 620, 300],
  ['fol', 'LOCK', 1, 1, 500, 20, {
    kind: 'live.text', p: [MAP_W - 64, 6, 56, 17], mode: 1, text: 'LOCK', texton: 'FOLLOW',
    parameter_enable: 1, varname: 'Follow', fontsize: 9, rounded: 2,
    saved_attribute_attributes: { valueof: {
      parameter_enum: ['off', 'on'], parameter_mmax: 1, parameter_type: 2, parameter_initial_enable: 1, parameter_initial: [1],
      parameter_longname: 'Follow selected track', parameter_shortname: 'Follow',
    } },
    bgcolor: C.canvas, bgoncolor: C.brand, activebgcolor: C.canvas, activebgoncolor: C.brand,
    textcolor: C.ink, textoncolor: hex('#000000'), activetextcolor: C.ink, activetextoncolor: hex('#000000'),
    bordercolor: C.border, focusbordercolor: C.border,
  }],
  ['fp', 'prepend follow', 1, 1, 500, 60],
  ['mi', 'midiin', 1, 1, 800, 20], ['mo', 'midiout', 1, 0, 800, 60],
  ...chrome(MAP_W, 25).filter(b => b[0] !== 'div'),
  ['ttl', 'SY.CORE MAP', 1, 0, 600, 20, title([10, 5, 120, 20])],
], [
  ['dev', 0, 'logic', 0], ['mr', 0, 'logic', 0],
  ['logic', 0, 'rf', 0], ['rf', 0, 'fset', 0], ['fset', 0, 'fol', 0], ['rf', 1, 'ms', 0],
  ['logic', 1, 'view', 0], ['view', 0, 'logic', 0],
  ['fol', 0, 'fp', 0], ['fp', 0, 'logic', 0],
  ['mi', 0, 'mo', 0],
], { width: MAP_W });

for (const [file, p] of [['sycore-link.maxpat', bridge], ['sycore-link-receive.maxpat', receiver], ['sycore-rig.maxpat', rig], ['sycore-map.maxpat', map]]) {
  writeFileSync(new URL('./' + file, import.meta.url), JSON.stringify(p, null, 2));
  console.log('wrote', file, p.patcher.boxes.length, 'boxes,', p.patcher.lines.length, 'lines');
}
