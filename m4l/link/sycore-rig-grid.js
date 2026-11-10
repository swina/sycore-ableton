// sycore-rig-grid.js — the SY.CORE Rig Controller's slot grid in Live ([jsui], Max JS / ES5).
// Used by the SY.CORE Rig device (in the device and in its floating window): it draws to its box's
// size, so the same script serves both.
//
//   in : "row <i> <filled mask> <playing> <queued> <muted> <solo> <gen>"  (rows 0–4: Chord Drum Seq Bass
//        Arp; gen = Generates done on the row: a change flashes its GEN)
//        "sec <section> <queued section>"                            (-1 = none)
//        "active <0|1>"                                              (a Rig Controller open in SY.CORE)
//        "fill <0|1>"                                                (the Drum Machine's Fill is on)
//        "chord <now> <dur> <next> <dur> <ms> <bars> <seq> <elapsed>"  ('-' = none; ms = the chord's
//                                                                      length, seq = one per step)
//   out: "rigpress <rig action>"  — rig_slot_<app>_<a–h>, rig_mute_<app>, rig_solo_<app>, rig_gen_<app>,
//        rig_section_<1–8>, rig_fill
//
// A box less than 40 px tall shows the chord line only (the device's header); a box taller than
// 200 px (the floating window) shows the SY.CORE RIG title, the chord line and its progress bar
// above the grid (labels left, pads A–H, M / S / GEN apart, FILL under them); the device's grid box
// shows the grid only (G for GEN).
// Colours as the Rig Controller: filled amber (dark, amber letters), playing green, queued / armed blinking, muted red.
autowatch = 1;
inlets = 1;
outlets = 1;
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;

var APPS = ['chord', 'drum', 'seq', 'bass', 'arp'];
var LABELS = ['CHORD', 'DRUM', 'SEQ', 'BASS', 'ARP'];
var SLOTS = 'abcdefgh';
var rows = [];
for (var i = 0; i < 5; i++) rows.push({ filled: 0, playing: -1, queued: -1, muted: 0, solo: 0, gen: -1 });
var section = -1, queuedSection = -1, isActive = 0, blink = 0, fillOn = 0;
// A GEN press flashes its button (GEN has no state to show): row, until when (ms).
var genFlash = -1;
var flashOff = new Task(function () { genFlash = -1; mgraphics.redraw(); }, this);
function flashGen(r) { genFlash = r; flashOff.cancel(); flashOff.schedule(300); mgraphics.redraw(); }
flashGen.local = 1;
var chordNow = '-', chordDur = '-', chordNext = '-', chordNextDur = '-';
// The chord's progress bar: green, orange from 80 % (the change is near); a tick per bar.
var chordMs = 0, chordBars = 0, chordSeq = -1, chordStart = 0;
var WARN = 0.8;
var ticker = new Task(function () { if (chordMs > 0) mgraphics.redraw(); }, this);
ticker.interval = 40;
ticker.repeat();

var C = {
  bg: [0.075, 0.075, 0.075, 1], cell: [0.12, 0.12, 0.12, 1], border: [1, 1, 1, 0.1],
  ink: [0.96, 0.96, 0.96, 1], muted: [0.54, 0.56, 0.57, 1], dim: [0.36, 0.38, 0.4, 1],
  amber: [0.37, 0.26, 0.07, 1], amberInk: [0.96, 0.78, 0.42, 1], amberHot: [0.62, 0.43, 0.08, 1],
  pad: [0.125, 0.125, 0.125, 1], label: [0.6, 0.62, 0.63, 1],
  title: [0.92, 0.92, 0.92, 1], titleCore: [0.42, 0.66, 0.2, 1], titleRig: [0.93, 0.13, 0.55, 1],
  green: [0.13, 0.77, 0.37, 1], orange: [0.98, 0.45, 0.09, 1], brandSoft: [0.2, 0.84, 0.66, 1], red: [0.94, 0.27, 0.27, 1], brand: [0, 0.64, 0.44, 1], cyan: [0, 0.76, 1, 1],
};

var blinker = new Task(function () { blink = 1 - blink; mgraphics.redraw(); }, this);
blinker.interval = 300;
blinker.repeat();

function row(i, filled, playing, queued, muted, solo, gen) {
  if (i < 0 || i > 4) return;
  gen = gen | 0;
  // a new Generate in SY.CORE (from anywhere): flash GEN — not on the first state received
  if (rows[i].gen >= 0 && gen !== rows[i].gen) flashGen(i);
  rows[i] = { filled: filled | 0, playing: playing | 0, queued: queued | 0, muted: muted | 0, solo: solo | 0, gen: gen };
  mgraphics.redraw();
}
function sec(s, q) { section = s | 0; queuedSection = q | 0; mgraphics.redraw(); }
function active(v) { isActive = v | 0; mgraphics.redraw(); }
function fill(v) { fillOn = v | 0; mgraphics.redraw(); }
function chord(now, dur, next, nextDur, ms, bars, seq, elapsed) {
  chordNow = String(now); chordDur = String(dur); chordNext = String(next); chordNextDur = String(nextDur);
  chordMs = ms | 0; chordBars = +bars || 0;
  // a new step: the bar restarts (the bridge's repeats every second keep the same seq)
  if ((seq | 0) !== chordSeq) { chordSeq = seq | 0; chordStart = new Date().getTime() - (elapsed | 0); }
  mgraphics.redraw();
}
function chordProgress() {
  if (chordMs <= 0 || none(chordNow)) return -1;
  return Math.max(0, Math.min(1, (new Date().getTime() - chordStart) / chordMs));
}
var C_ORANGE = [0.98, 0.45, 0.09, 1];
/** The progress bar at x, y, w × h: the elapsed part green (orange from 80 %), a tick per bar. */
function progressBar(x, y, w, h) {
  var p = chordProgress();
  if (p < 0) return;
  fillRect(x, y, w, h, [1, 1, 1, 0.08]);
  if (p > 0) {
    mgraphics.set_source_rgba(p >= WARN ? C_ORANGE : C.green);
    mgraphics.rectangle_rounded(x, y, Math.max(h, w * p), h, h / 2, h / 2);
    mgraphics.fill();
  }
  var n = Math.round(chordBars);
  if (n > 1 && n <= 16) for (var i = 1; i < n; i++) {
    mgraphics.set_source_rgba([0, 0, 0, 0.6]);
    mgraphics.rectangle(x + (w * i) / n - 0.5, y, 1, h);
    mgraphics.fill();
  }
}
var none = function (v) { return !v || v === '-'; };

/** The cells of the grid for the box: 5 app rows + the sections row. A box taller than 200 px is
 *  the floating window: title, chord line and progress bar above the grid, in the proportions of
 *  the reference layout (REF, 1351 × 693); otherwise the device's compact grid. */
var REF = { w: 1451, h: 693, x0: 165, cellW: 102, stepX: 108.5, y0: 169, rowH: 67, stepY: 74.5,
  muteX: 1041, soloX: 1141, genX: 1241, sideW: 92, labelX: 73 };
function layout() {
  var w = box.rect[2] - box.rect[0], h = box.rect[3] - box.rect[1];
  if (h > 200) {
    var sx = w / REF.w, sy = h / REF.h;
    return { win: 1, w: w, h: h, sx: sx, sy: sy, s: Math.min(sx, sy),
      x0: REF.x0 * sx, cellW: REF.cellW * sx, stepX: REF.stepX * sx,
      y0: REF.y0 * sy, rowH: REF.rowH * sy, stepY: REF.stepY * sy,
      muteX: REF.muteX * sx, soloX: REF.soloX * sx, genX: REF.genX * sx, sideW: REF.sideW * sx,
      labelX: 0, labelW: REF.labelX * 2 * sx };
  }
  var pad = Math.max(2, Math.round(h / 80));
  var labelW = Math.round(w * 0.13), sideW = Math.round(w * 0.075);
  var rowH = (h - pad * 7) / 6;
  var cellW = (w - labelW - sideW * 3 - pad * 14) / 8;
  var L = { win: 0, w: w, h: h, x0: labelW + pad * 2, cellW: cellW, stepX: cellW + pad,
    y0: pad, rowH: rowH, stepY: rowH + pad, sideW: sideW, labelX: 0, labelW: labelW + pad };
  L.muteX = slotX(L, 8) + pad; L.soloX = L.muteX + sideW + pad; L.genX = L.soloX + sideW + pad;
  return L;
}
function rowY(L, r) { return L.y0 + r * L.stepY; }
function slotX(L, c) { return L.x0 + c * L.stepX; }

function fillRect(x, y, w, h, col) {
  mgraphics.set_source_rgba(col);
  mgraphics.rectangle_rounded(x, y, w, h, 4, 4);
  mgraphics.fill();
}
function strokeRect(x, y, w, h, col) {
  mgraphics.set_source_rgba(col);
  mgraphics.set_line_width(1);
  mgraphics.rectangle_rounded(x + 0.5, y + 0.5, w - 1, h - 1, 4, 4);
  mgraphics.stroke();
}
function text(t, x, y, w, h, col, size, face) {
  mgraphics.select_font_face(face || 'Arial Bold');
  mgraphics.set_font_size(size);
  var m = mgraphics.text_measure(t);
  mgraphics.set_source_rgba(col);
  mgraphics.move_to(x + (w - m[0]) / 2, y + (h + size * 0.72) / 2);
  mgraphics.show_text(t);
}

function textAt(t, x, y, h, col, size, face) {
  mgraphics.select_font_face(face || 'Arial Bold');
  mgraphics.set_font_size(size);
  var m = mgraphics.text_measure(t);
  mgraphics.set_source_rgba(col);
  mgraphics.move_to(x, y + (h + size * 0.72) / 2);
  mgraphics.show_text(t);
  return m[0];
}
/** The chord line: NOW <chord> <duration>  NEXT <chord> <duration>, from x, in a band of height h. */
function chordLine(x, y, h, size) {
  var gap = size * 0.45;
  if (!isActive || none(chordNow) && none(chordNext)) { textAt('CHORD  —', x, y, h, C.dim, size * 0.8); return; }
  x += textAt('NOW', x, y, h, C.muted, size * 0.7) + gap;
  x += textAt(none(chordNow) ? '—' : chordNow, x, y, h, none(chordNow) ? C.dim : C.green, size) + gap * 0.7;
  if (!none(chordDur)) x += textAt(chordDur, x, y, h, C.muted, size * 0.75);
  x += gap * 2.2;
  x += textAt('NEXT', x, y, h, C.muted, size * 0.7) + gap;
  x += textAt(none(chordNext) ? '—' : chordNext, x, y, h, none(chordNext) ? C.dim : C.amberInk, size) + gap * 0.7;
  if (!none(chordNextDur)) textAt(chordNextDur, x, y, h, C.muted, size * 0.75);
}

function paint() {
  var w0 = box.rect[2] - box.rect[0], h0 = box.rect[3] - box.rect[1];
  if (h0 < 40) {                    // the chord line only (the device's header)
    fillRect(0, 0, w0, h0, C.bg);
    var bh = Math.max(2, Math.round(h0 * 0.14));
    chordLine(6, 0, h0 - bh - 1, Math.max(9, Math.min(12, h0 * 0.55)));
    progressBar(4, h0 - bh - 1, w0 - 8, bh);
    return;
  }
  var L = layout();
  var fs = L.win ? 24 * L.s : Math.max(8, Math.min(14, L.rowH * 0.42));
  var fl = L.win ? 20 * L.s : fs * 0.85;    // row labels, M / S
  mgraphics.set_source_rgba(C.bg);
  mgraphics.rectangle(0, 0, L.w, L.h);
  mgraphics.fill();
  if (L.win) {
    // SY.CORE RIG — the title; then NOW / NEXT over the pads and the chord's progress bar
    var tx = 8 * L.sx, th = 40 * L.sy, ts = 32 * L.s;
    tx += textAt('SY.', tx, 0, th, C.title, ts, 'Consolas');
    tx += textAt('CORE', tx, 0, th, C.titleCore, ts, 'Consolas') + ts * 0.3;
    textAt('RIG', tx, 0, th, C.titleRig, ts, 'Consolas');
    chordLine(L.x0, 70 * L.sy, 50 * L.sy, 36 * L.s);
    progressBar(L.x0, 133 * L.sy, L.genX + L.sideW - L.x0, Math.max(3, 8 * L.sy));
  }
  var anySolo = 0;
  for (var q = 0; q < 5; q++) if (rows[q].solo) anySolo = 1;
  for (var r = 0; r < 5; r++) {
    var R = rows[r], y = rowY(L, r);
    // the label: red when muted, dim when another row's Solo silences it
    text(LABELS[r], L.labelX, y, L.labelW, L.rowH, R.muted ? C.red : anySolo && !R.solo ? C.dim : C.label, fl);
    for (var c = 0; c < 8; c++) {
      var x = slotX(L, c), filled = (R.filled >> c) & 1;
      var col = C.pad, ink = C.dim;
      if (R.playing === c) { col = R.muted ? C.red : C.green; ink = [0, 0, 0, 1]; }
      else if (R.queued === c) { col = blink ? C.amberHot : C.amber; ink = C.ink; }
      else if (filled) { col = C.amber; ink = C.amberInk; }
      fillRect(x, y, L.cellW, L.rowH, col);
      strokeRect(x, y, L.cellW, L.rowH, C.border);
      text(SLOTS.charAt(c).toUpperCase(), x, y, L.cellW, L.rowH, ink, fs);
    }
    fillRect(L.muteX, y, L.sideW, L.rowH, R.muted ? C.red : C.pad);
    strokeRect(L.muteX, y, L.sideW, L.rowH, C.border);
    text('M', L.muteX, y, L.sideW, L.rowH, R.muted ? [1, 1, 1, 1] : C.muted, fl);
    fillRect(L.soloX, y, L.sideW, L.rowH, R.solo ? C.cyan : C.pad);
    strokeRect(L.soloX, y, L.sideW, L.rowH, C.border);
    text('S', L.soloX, y, L.sideW, L.rowH, R.solo ? [0, 0, 0, 1] : C.muted, fl);
    fillRect(L.genX, y, L.sideW, L.rowH, genFlash === r ? C.brandSoft : C.pad);
    strokeRect(L.genX, y, L.sideW, L.rowH, C.border);
    text(L.win ? 'GEN' : 'G', L.genX, y, L.sideW, L.rowH, genFlash === r ? [0, 0, 0, 1] : C.brandSoft, fl);
  }
  // FILL (the Drum Machine's): under M / S / GEN, blinking amber while the fill plays
  var fx = L.muteX, fw = L.genX + L.sideW - L.muteX, ysf = rowY(L, 5);
  fillRect(fx, ysf, fw, L.rowH, fillOn ? (blink ? C.amberHot : C.orange) : C.pad);
  strokeRect(fx, ysf, fw, L.rowH, C.border);
  text('FILL', fx, ysf, fw, L.rowH, fillOn ? [0, 0, 0, 1] : C.amberInk, fl);
  var ys = rowY(L, 5);
  text('SECT', L.labelX, ys, L.labelW, L.rowH, C.label, fl);
  for (var k = 0; k < 8; k++) {
    var xs = slotX(L, k), cs = C.pad, is = C.muted;
    if (section === k) { cs = C.green; is = [0, 0, 0, 1]; }
    else if (queuedSection === k) { cs = blink ? C.amberHot : C.amber; is = C.ink; }
    fillRect(xs, ys, L.cellW, L.rowH, cs);
    strokeRect(xs, ys, L.cellW, L.rowH, C.border);
    text(String(k + 1), xs, ys, L.cellW, L.rowH, is, fs);
  }
  if (!isActive) {
    fillRect(0, 0, L.w, L.h, [0.04, 0.04, 0.04, 0.82]);
    text('Open the Rig Controller in SY.CORE', 0, 0, L.w, L.h, C.muted, Math.max(9, fs * 0.9));
  }
}

/** A click: the rig action under it, to SY.CORE (through the bridge). */
function onclick(x, y) {
  if (!isActive || box.rect[3] - box.rect[1] < 40) return;
  var L = layout();
  var r = Math.floor((y - L.y0) / L.stepY);
  if (r < 0 || r > 5) return;
  var y0 = rowY(L, r);
  if (y < y0 || y > y0 + L.rowH) return;
  for (var c = 0; c < 8; c++) {
    var x0 = slotX(L, c);
    if (x >= x0 && x <= x0 + L.cellW) {
      outlet(0, 'rigpress', r === 5 ? 'rig_section_' + (c + 1) : 'rig_slot_' + APPS[r] + '_' + SLOTS.charAt(c));
      return;
    }
  }
  if (r === 5) { if (x >= L.muteX && x <= L.genX + L.sideW) outlet(0, 'rigpress', 'rig_fill'); return; }
  if (x >= L.muteX && x <= L.muteX + L.sideW) outlet(0, 'rigpress', 'rig_mute_' + APPS[r]);
  else if (x >= L.soloX && x <= L.soloX + L.sideW) outlet(0, 'rigpress', 'rig_solo_' + APPS[r]);
  else if (x >= L.genX && x <= L.genX + L.sideW) {
    outlet(0, 'rigpress', 'rig_gen_' + APPS[r]);
    flashGen(r);
  }
}
onclick.local = 1;

function onresize() { mgraphics.redraw(); }
onresize.local = 1;
