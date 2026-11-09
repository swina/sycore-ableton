// sycore-rig-grid.js — the SY.CORE Rig Controller's slot grid in Live ([jsui], Max JS / ES5).
// Used by the SY.CORE Rig device (in the device and in its floating window): it draws to its box's
// size, so the same script serves both.
//
//   in : "row <i> <filled mask> <playing> <queued> <muted> <solo>"   (rows 0–4: Chord Drum Seq Bass Arp)
//        "sec <section> <queued section>"                            (-1 = none)
//        "active <0|1>"                                              (a Rig Controller open in SY.CORE)
//        "chord <now> <duration> <next> <duration>"                  ('-' = none)
//   out: "rigpress <rig action>"  — rig_slot_<app>_<a–h>, rig_mute_<app>, rig_solo_<app>, rig_section_<1–8>
//
// A box less than 40 px tall shows the chord line only (the device's header); a box taller than
// 200 px (the floating window) shows it above the grid; the device's grid box shows the grid only.
// Colours as the Rig Controller: filled amber, playing green, queued / armed blinking, muted red.
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
for (var i = 0; i < 5; i++) rows.push({ filled: 0, playing: -1, queued: -1, muted: 0, solo: 0 });
var section = -1, queuedSection = -1, isActive = 0, blink = 0;
var chordNow = '-', chordDur = '-', chordNext = '-', chordNextDur = '-';

var C = {
  bg: [0.075, 0.075, 0.075, 1], cell: [0.12, 0.12, 0.12, 1], border: [1, 1, 1, 0.1],
  ink: [0.96, 0.96, 0.96, 1], muted: [0.54, 0.56, 0.57, 1], dim: [0.36, 0.38, 0.4, 1],
  amber: [0.96, 0.62, 0.04, 0.35], amberInk: [0.99, 0.83, 0.5, 1], amberHot: [0.96, 0.62, 0.04, 0.85],
  green: [0.13, 0.77, 0.37, 1], red: [0.94, 0.27, 0.27, 1], brand: [0, 0.64, 0.44, 1], cyan: [0, 0.76, 1, 1],
};

var blinker = new Task(function () { blink = 1 - blink; mgraphics.redraw(); }, this);
blinker.interval = 300;
blinker.repeat();

function row(i, filled, playing, queued, muted, solo) {
  if (i < 0 || i > 4) return;
  rows[i] = { filled: filled | 0, playing: playing | 0, queued: queued | 0, muted: muted | 0, solo: solo | 0 };
  mgraphics.redraw();
}
function sec(s, q) { section = s | 0; queuedSection = q | 0; mgraphics.redraw(); }
function active(v) { isActive = v | 0; mgraphics.redraw(); }
function chord(now, dur, next, nextDur) {
  chordNow = String(now); chordDur = String(dur); chordNext = String(next); chordNextDur = String(nextDur);
  mgraphics.redraw();
}
var none = function (v) { return !v || v === '-'; };

/** The cells of the grid for a box of w × h: 5 app rows + the sections row. */
function layout() {
  var w = box.rect[2] - box.rect[0], h = box.rect[3] - box.rect[1];
  var band = h > 200 ? Math.round(h * 0.16) : 0;
  var pad = Math.max(2, Math.round(h / 80));
  var labelW = Math.round(w * 0.13), sideW = Math.round(w * 0.075);
  var rowH = (h - band - pad * 7) / 6;
  var padsW = w - labelW - sideW * 2 - pad * 12;
  var cellW = padsW / 8;
  return { w: w, h: h, band: band, pad: pad, labelW: labelW, sideW: sideW, rowH: rowH, cellW: cellW };
}
function rowY(L, r) { return L.band + L.pad + r * (L.rowH + L.pad); }
function slotX(L, c) { return L.labelW + L.pad * 2 + c * (L.cellW + L.pad); }
function muteX(L) { return slotX(L, 8) + L.pad; }
function soloX(L) { return muteX(L) + L.sideW + L.pad; }

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
function text(t, x, y, w, h, col, size) {
  mgraphics.select_font_face('Arial Bold');
  mgraphics.set_font_size(size);
  var m = mgraphics.text_measure(t);
  mgraphics.set_source_rgba(col);
  mgraphics.move_to(x + (w - m[0]) / 2, y + (h + size * 0.72) / 2);
  mgraphics.show_text(t);
}

function textAt(t, x, y, h, col, size) {
  mgraphics.select_font_face('Arial Bold');
  mgraphics.set_font_size(size);
  var m = mgraphics.text_measure(t);
  mgraphics.set_source_rgba(col);
  mgraphics.move_to(x, y + (h + size * 0.72) / 2);
  mgraphics.show_text(t);
  return m[0];
}
/** The chord line: NOW <chord> <duration>  NEXT <chord> <duration>, from x, in a band of height h. */
function chordLine(x, y, h, size) {
  var gap = size * 0.6;
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
    chordLine(6, 0, h0, Math.max(9, Math.min(13, h0 * 0.6)));
    return;
  }
  var L = layout();
  var fs = Math.max(8, Math.min(14, L.rowH * 0.42));
  fillRect(0, 0, L.w, L.h, C.bg);
  if (L.band) chordLine(L.pad * 3, 0, L.band, Math.min(28, L.band * 0.5));
  for (var r = 0; r < 5; r++) {
    var R = rows[r], y = rowY(L, r);
    text(LABELS[r], 0, y, L.labelW + L.pad, L.rowH, R.muted ? C.red : C.muted, fs * 0.85);
    for (var c = 0; c < 8; c++) {
      var x = slotX(L, c), filled = (R.filled >> c) & 1;
      var col = C.cell, ink = C.dim;
      if (R.playing === c) { col = R.muted ? C.red : C.green; ink = [0, 0, 0, 1]; }
      else if (R.queued === c) { col = blink ? C.amberHot : C.amber; ink = C.ink; }
      else if (filled) { col = C.amber; ink = C.amberInk; }
      fillRect(x, y, L.cellW, L.rowH, col);
      strokeRect(x, y, L.cellW, L.rowH, C.border);
      text(SLOTS.charAt(c).toUpperCase(), x, y, L.cellW, L.rowH, ink, fs);
    }
    fillRect(muteX(L), y, L.sideW, L.rowH, R.muted ? C.red : C.cell);
    strokeRect(muteX(L), y, L.sideW, L.rowH, C.border);
    text('M', muteX(L), y, L.sideW, L.rowH, R.muted ? [1, 1, 1, 1] : C.muted, fs * 0.85);
    fillRect(soloX(L), y, L.sideW, L.rowH, R.solo ? C.cyan : C.cell);
    strokeRect(soloX(L), y, L.sideW, L.rowH, C.border);
    text('S', soloX(L), y, L.sideW, L.rowH, R.solo ? [0, 0, 0, 1] : C.muted, fs * 0.85);
  }
  var ys = rowY(L, 5);
  text('SECT', 0, ys, L.labelW + L.pad, L.rowH, C.muted, fs * 0.85);
  for (var k = 0; k < 8; k++) {
    var xs = slotX(L, k), cs = C.cell, is = C.muted;
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
  var r = Math.floor((y - L.band - L.pad / 2) / (L.rowH + L.pad));
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
  if (r === 5) return;
  if (x >= muteX(L) && x <= muteX(L) + L.sideW) outlet(0, 'rigpress', 'rig_mute_' + APPS[r]);
  else if (x >= soloX(L) && x <= soloX(L) + L.sideW) outlet(0, 'rigpress', 'rig_solo_' + APPS[r]);
}
onclick.local = 1;

function onresize() { mgraphics.redraw(); }
onresize.local = 1;
