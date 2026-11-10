// P12 spike — generates sycore-map-spike.maxpat and .amxd (a Max MIDI Effect): node make-patch.mjs
// [live.thisdevice] → [js sycore-map-spike.js] (Live API) → 16 [live.remote~], one per slot.
// The track's MIDI passes through ([midiin] → [midiout]): the device can sit on an instrument track.
import { writeFileSync } from 'node:fs';

const DIR = process.env.SYCORE_MAP_DIR || 'C:/Users/swina/Documents/sycore-map-spike';
const W = 460, H = 169, SLOTS = 16;
const hex = (h, a = 1) => [0, 2, 4].map(i => +(parseInt(h.slice(1 + i, 3 + i), 16) / 255).toFixed(3)).concat(a);
const C = { panel: hex('#131313'), ink: hex('#f5f5f5'), muted: hex('#8a8f92'), brand: hex('#00A370'), canvas: hex('#0a0a0a'), border: hex('#ffffff', 0.1) };

const boxes = [], lines = [];
function box(k, text, ni, no, x, y, o = {}) {
  const { kind = 'newobj', p, ...extra } = o;
  const b = { id: 'obj-' + k, maxclass: kind, numinlets: ni, numoutlets: no, outlettype: Array(no).fill(''),
    patching_rect: [x, y, Math.max(50, String(text).length * 7 + 16), 22], ...extra };
  if (!['live.toggle', 'live.dial', 'panel'].includes(kind)) b.text = text;
  if (p) { b.presentation = 1; b.presentation_rect = p; }
  boxes.push({ box: Object.fromEntries(Object.entries(b).sort(([a], [c]) => a.localeCompare(c))) });
}
const line = (s, so, d, di) => lines.push({ patchline: { source: ['obj-' + s, so], destination: ['obj-' + d, di] } });
const param = (long, short, extra) => ({ parameter_enable: 1, saved_attribute_attributes: { valueof: { parameter_longname: long, parameter_shortname: short, ...extra } } });

box('bg', '', 1, 0, 900, 20, { kind: 'panel', p: [0, 0, W, H], bgcolor: C.panel, bgfillcolor_type: 'color', bgfillcolor_color: C.panel, ignoreclick: 1, mode: 0, rounded: 6, border: 1, bordercolor: C.border });
box('ttl', 'SY.CORE MAP · spike', 1, 0, 600, 20, { kind: 'comment', p: [10, 6, 200, 20], fontsize: 12, fontface: 1, textcolor: C.ink });
box('mi', 'midiin', 1, 1, 900, 100); box('mo', 'midiout', 1, 0, 900, 140); line('mi', 0, 'mo', 0);

box('dev', 'live.thisdevice', 1, 3, 30, 20);
box('js', `js ${DIR}/sycore-map-spike.js`, 1, 2, 30, 120);
line('dev', 0, 'js', 0);

// UI: Follow, Slot 1 dial, Sweep 16, Dump
box('fol', 'Follow', 1, 1, 300, 20, { kind: 'live.toggle', p: [10, 34, 16, 16], ...param('Follow', 'Follow', { parameter_type: 2, parameter_mmax: 1, parameter_enum: ['off', 'on'], parameter_initial_enable: 1, parameter_initial: [1] }) });
box('folc', 'Follow selected track', 1, 0, 300, 50, { kind: 'comment', p: [30, 33, 140, 18], fontsize: 10, textcolor: C.muted });
box('folp', 'prepend follow', 1, 1, 300, 80); line('fol', 0, 'folp', 0); line('folp', 0, 'js', 0);
box('dial', 'Slot1', 1, 2, 420, 20, { kind: 'live.dial', p: [10, 100, 44, 48], ...param('Slot 1', 'Slot 1', { parameter_type: 0, parameter_mmin: 0, parameter_mmax: 1 }) });
box('dialp', 'prepend dial', 1, 1, 420, 80); line('dial', 0, 'dialp', 0); line('dialp', 0, 'js', 0);
box('sw', 'Sweep', 1, 1, 520, 20, { kind: 'live.toggle', p: [70, 108, 16, 16], ...param('Sweep 16', 'Sweep', { parameter_type: 2, parameter_mmax: 1, parameter_enum: ['off', 'on'] }) });
box('swc', 'Sweep all 16 (CPU)', 1, 0, 520, 50, { kind: 'comment', p: [90, 107, 130, 18], fontsize: 10, textcolor: C.muted });
box('swp', 'prepend sweep', 1, 1, 520, 80); line('sw', 0, 'swp', 0); line('swp', 0, 'js', 0);
box('dump', 'dump', 2, 1, 640, 80, { kind: 'message', p: [240, 106, 50, 20] });
box('dumpc', '→ Max console', 1, 0, 700, 80, { kind: 'comment', p: [296, 107, 100, 18], fontsize: 10, textcolor: C.muted });
line('dump', 0, 'js', 0);

// status lines: "info …" and "time …"
box('rt', 'route info time', 1, 3, 30, 400);
box('ps1', 'prepend set', 1, 1, 30, 430); box('ps2', 'prepend set', 1, 1, 160, 430);
box('inf', '—', 1, 0, 30, 460, { kind: 'comment', p: [10, 56, W - 20, 18], fontsize: 10, textcolor: C.ink });
box('tim', '—', 1, 0, 160, 490, { kind: 'comment', p: [10, 76, W - 20, 18], fontsize: 10, textcolor: C.muted });
line('js', 1, 'rt', 0); line('rt', 0, 'ps1', 0); line('rt', 1, 'ps2', 0); line('ps1', 0, 'inf', 0); line('ps2', 0, 'tim', 0);

// 16 slots: "<s> id <n>" → live.remote~ right inlet; "<s> <value>" → left inlet
box('rs', 'route ' + Array.from({ length: SLOTS }, (_, i) => i).join(' '), 1, SLOTS + 1, 30, 180);
line('js', 0, 'rs', 0);
for (let s = 0; s < SLOTS; s++) {
  const x = 30 + s * 110;
  box('ri' + s, 'route id', 1, 2, x, 220);
  box('pi' + s, 'prepend id', 1, 1, x, 250);
  box('lr' + s, 'live.remote~', 2, 0, x, 290);
  line('rs', s, 'ri' + s, 0); line('ri' + s, 0, 'pi' + s, 0); line('pi' + s, 0, 'lr' + s, 1); line('ri' + s, 1, 'lr' + s, 0);
}

// panels last (drawn under the rest)
boxes.sort((a, b) => (a.box.id === 'obj-bg') - (b.box.id === 'obj-bg'));
const patch = { patcher: {
  fileversion: 1, appversion: { major: 8, minor: 6, revision: 0, architecture: 'x64', modernui: 1 },
  classnamespace: 'box', rect: [100, 100, 1900, 640], openinpresentation: 1, devicewidth: W, boxes, lines,
} };
writeFileSync(new URL('./sycore-map-spike.maxpat', import.meta.url), JSON.stringify(patch, null, 2));
const u32 = n => { const b = Buffer.alloc(4); b.writeUInt32LE(n); return b; };
const json = Buffer.from(JSON.stringify(patch, null, 2) + '\n\0', 'utf8');
writeFileSync(new URL('./sycore-map-spike.amxd', import.meta.url), Buffer.concat([
  Buffer.from('ampf'), u32(4), Buffer.from('mmmm'), Buffer.from('meta'), u32(4), Buffer.alloc(4), Buffer.from('ptch'), u32(json.length), json,
]));
console.log('wrote sycore-map-spike.maxpat / .amxd', boxes.length, 'boxes,', lines.length, 'lines');
