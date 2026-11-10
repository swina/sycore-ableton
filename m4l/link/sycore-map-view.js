// sycore-map-view.js — the SY.CORE Map device's 16 slots ([jsui], Max JS / ES5; P12). Only draws and
// handles dragging: the logic (Live API) is in sycore-map.js, so a reload of this script loses nothing.
//   in : "state <json>" ({ head, on, tag, warn, slots: 16 × { name, value 0–1 } | null }), "val <slot> <0–1>"
//   out: "drag <slot> <0–1>" (a slot dragged up / down), "viewready" (loaded: the logic sends the state)
autowatch = 1;
inlets = 1;
outlets = 1;
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;

var SLOTS = 16;
var S = { head: 'Starting…', on: 0, tag: '', warn: 0, slots: [] };
var hello = new Task(function () { outlet(0, 'viewready'); }, this);
hello.schedule(200);

function anything() {
  var a = arrayfromargs(arguments);
  if (messagename === 'state') {
    try { S = JSON.parse(a.join(' ')); } catch (e) { return; }
    mgraphics.redraw();
  } else if (messagename === 'val') {
    var p = S.slots && S.slots[a[0] | 0];
    if (p) { p.value = +a[1]; mgraphics.redraw(); }
  }
}

var C = {
  bg: [0.075, 0.075, 0.075, 1], cell: [0.12, 0.12, 0.12, 1], ink: [0.96, 0.96, 0.96, 1],
  muted: [0.54, 0.56, 0.57, 1], dim: [0.36, 0.38, 0.4, 1], brandSoft: [0.2, 0.84, 0.66, 1], amber: [0.96, 0.62, 0.04, 1],
};
function rect(x, y, w, h, col, r) { mgraphics.set_source_rgba(col); mgraphics.rectangle_rounded(x, y, w, h, r || 3, r || 3); mgraphics.fill(); }
function txt(t, x, y, col, size, bold, maxW) {
  mgraphics.select_font_face(bold ? 'Arial Bold' : 'Arial');
  mgraphics.set_font_size(size);
  t = String(t);
  if (maxW) while (t.length > 1 && mgraphics.text_measure(t)[0] > maxW) t = t.slice(0, -1);
  mgraphics.set_source_rgba(col);
  mgraphics.move_to(x, y);
  mgraphics.show_text(t);
}
/** A name on up to two lines (words; the second line cut to fit). */
function wrap2(t, x, y, col, size, maxW) {
  mgraphics.select_font_face('Arial'); mgraphics.set_font_size(size);
  var w = String(t).split(' '), a = '', i = 0;
  for (; i < w.length; i++) { var n = a ? a + ' ' + w[i] : w[i]; if (a && mgraphics.text_measure(n)[0] > maxW) break; a = n; }
  txt(a, x, y, col, size, 0, maxW);
  if (i < w.length) txt(w.slice(i).join(' '), x, y + size + 2, col, size, 0, maxW);
}
function grid() {
  var w = box.rect[2] - box.rect[0], h = box.rect[3] - box.rect[1];
  var top = 20, gap = 3, cw = (w - gap * 7) / 8, ch = (h - top - gap) / 2;
  return { w: w, h: h, top: top, gap: gap, cw: cw, ch: ch };
}
function cellAt(G, s) { return { x: (s % 8) * (G.cw + G.gap), y: G.top + Math.floor(s / 8) * (G.ch + G.gap) }; }
function paint() {
  var G = grid();
  rect(0, 0, G.w, G.h, C.bg, 4);
  txt(S.head, 2, 13, S.on ? C.ink : C.dim, 10, 1, G.w - 120);
  mgraphics.select_font_face('Arial'); mgraphics.set_font_size(9);
  var tw = mgraphics.text_measure(S.tag || '')[0];
  txt(S.tag || '', G.w - tw - 2, 13, S.warn ? C.amber : C.muted, 9, 0);
  for (var s = 0; s < SLOTS; s++) {
    var c = cellAt(G, s), p = S.slots && S.slots[s];
    rect(c.x, c.y, G.cw, G.ch, C.cell);
    txt(String(s + 1), c.x + 3, c.y + 10, C.dim, 8, 1);
    if (!p) continue;
    wrap2(p.name, c.x + 3, c.y + 21, C.ink, 9, G.cw - 5);
    var bh = 4, by = c.y + G.ch - bh - 3;
    rect(c.x + 3, by, G.cw - 6, bh, [1, 1, 1, 0.08], 2);
    rect(c.x + 3, by, Math.max(bh, (G.cw - 6) * p.value), bh, C.brandSoft, 2);
  }
}

// dragging a slot: up / down, 120 px = the full range
var drag = -1, dragY = 0, dragV = 0;
function onclick(x, y) {
  var G = grid();
  drag = -1;
  for (var s = 0; s < SLOTS; s++) {
    var c = cellAt(G, s), p = S.slots && S.slots[s];
    if (p && x >= c.x && x <= c.x + G.cw && y >= c.y && y <= c.y + G.ch) { drag = s; dragY = y; dragV = p.value; return; }
  }
}
onclick.local = 1;
function ondrag(x, y, but) {
  if (drag < 0) return;
  if (!but) { drag = -1; return; }
  var v = Math.max(0, Math.min(1, dragV + (dragY - y) / 120));
  S.slots[drag].value = v;
  mgraphics.redraw();
  outlet(0, 'drag', drag, v);
}
ondrag.local = 1;
function onresize() { mgraphics.redraw(); }
onresize.local = 1;
