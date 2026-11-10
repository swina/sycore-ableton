// sycore-map.js — the SY.CORE Map device ([jsui], Max JS / ES5; P12): one device in the set drives
// the instrument of a track by table — slot n (an encoder in SY.CORE) → a parameter, by original_name.
//   Target: the track selected in Live (Follow) or the one SY.CORE picks; a track without an instrument
//   (e.g. this device's own) keeps the last one. On the track, the first instrument; a Rack with mapped
//   Macros → its 16 Macros; a Rack without → the first instrument in its chains.
//   in : bang (live.thisdevice: the Live API is ready), "follow <0|1>" (the device's toggle),
//        from the bridge ([r sycore_map]): "tables <json>", "value <slot> <0–1>", "target <follow|track>", "params"
//   out 0: "<slot> id <param id>" (re-point a live.remote~, id 0 = released) / "<slot> <value>" (parameter units)
//   out 1: to the bridge ([s sycore_map_in]): "mapready", "mapinfo <json>", "mapvalue <slot> <0–1>",
//          "maptracks <json>", "mapparams <json>"; "followtoggle <0|1>" (SY.CORE changed the target: the toggle follows)
// Parameters are read once per device (ids cached by device id): only the table's 16 on a track change.
autowatch = 1;
inlets = 1;
outlets = 2;
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;

var SLOTS = 16;
// Factory tables (SY.CORE's tables replace them): slot = { param: original_name, min?, max?, int? }.
var FACTORY = {
  Drift: ['LP Freq', 'LP Res', 'HP Freq', 'LP Mod Amt 1', 'Env 1 Attack', 'Env 1 Decay', 'Env 1 Sustain', 'Env 1 Release',
    'Osc 1 Shape', 'Osc 2 Detune', 'Osc 2 Gain', 'Noise Gain', 'LFO Rate', 'LFO Amt', 'Drift', 'Volume'],
  UltraAnalog: ['F1 Freq', 'F1 Resonance', 'F1 Freq < Env', 'F1 Freq < LFO', 'AEG1 Attack', 'AEG1 Decay', 'AEG1 Sustain', 'AEG1 Rel',
    'OSC1 PW', 'OSC2 Detune', 'OSC1 Level', 'OSC2 Level', 'Noise Level', 'LFO1 Speed', 'Glide Time', 'Volume'],
  OriginalSimpler: ['Filter Freq', 'Filter Res', 'Fe < Env', 'Filter Drive', 'Ve Attack', 'Ve Decay', 'Ve Sustain', 'Ve Release',
    'S Start', 'S Length', { param: 'Transpose', min: -24, max: 24, int: 1 }, 'Detune', 'Glide Time', 'Shaper Amt', 'Pan',
    { param: 'Volume', min: -36, max: 6 }],
};
var tables = {};
function setTables(t) {
  tables = {};
  var k, i;
  for (k in FACTORY) tables[k] = FACTORY[k].map(function (x) { return typeof x === 'string' ? { param: x } : x; });
  for (k in t) if (t[k] instanceof Array) { tables[k] = []; for (i = 0; i < SLOTS; i++) tables[k].push(t[k][i] || null); }
}
setTables({});

var ready = 0, follow = 1;
var view = null, setObs = null, P = null;
var cache = {};          // device id → { cls, name, byName: { original_name: param id } }
var tracks = [];         // [{ id, index, name }]
// The target: track, device, mode, and the 16 slots { id, param, name, min, max, int, value (0–1) } or null
var T = { trackId: 0, track: '', index: -1, devId: 0, device: '', cls: '', rack: null, mode: 'none', slots: [], ms: 0 };
var obs = [];            // 16 value observers
var dirty = {};          // slots whose value changed in Live (sent at most every 30 ms)

// ── Live API helpers ──
function clean(v) { return String(v instanceof Array ? v.join(' ') : v).replace(/^"(.*)"$/, '$1'); }
function ids(list) { var r = []; for (var i = 0; i + 1 < list.length; i += 2) if (list[i] === 'id' && +list[i + 1]) r.push(+list[i + 1]); return r; }
/** One reused LiveAPI object pointed at an id (goto), a new one where goto is missing. */
function at(id) {
  if (!P) P = new LiveAPI(null, 'id ' + id);
  else if (typeof P.goto === 'function') P.goto('id ' + id);
  else P = new LiveAPI(null, 'id ' + id);
  return P;
}
function get(id, prop) { return at(id).get(prop); }
function num(id, prop) { return +get(id, prop)[0]; }
function toBridge() { var a = arrayfromargs(arguments); outlet.apply(this, [1].concat(a)); }

// ── init ──
function bang() {
  if (ready) return;
  ready = 1;
  view = new LiveAPI(onSelected, 'live_set view');
  view.property = 'selected_track';
  setObs = new LiveAPI(onTracks, 'live_set');
  setObs.property = 'tracks';
  for (var s = 0; s < SLOTS; s++) obs.push(makeObserver(s));
  readTracks();
  toBridge('mapready');
  var sel = ids(view.get('selected_track'))[0];
  if (sel) target(sel);
}

// Notifications can't change the set: the work is deferred out of the callbacks.
var pendingTrack = 0;
var deferred = new Task(function () { if (pendingTrack) { var t = pendingTrack; pendingTrack = 0; target(t); } }, this);
function onSelected(args) {
  if (!follow || !args || args[0] !== 'selected_track') return;
  var id = +args[2];
  if (!id || id === T.trackId) return;
  pendingTrack = id;
  deferred.schedule(0);
}
var tracksTask = new Task(readTracks, this);
function onTracks(args) { if (args && args[0] === 'tracks') tracksTask.schedule(0); }
function readTracks() {
  var list = ids(new LiveAPI(null, 'live_set').get('tracks'));
  tracks = [];
  for (var i = 0; i < list.length; i++) tracks.push({ id: list[i], index: i, name: clean(get(list[i], 'name')) });
  toBridge('maptracks', JSON.stringify(tracks.map(function (t) { return { index: t.index, name: t.name }; })));
}

// ── the target ──
/** The first instrument in a list of device ids: { id, rack } — a Rack with mapped Macros is the target
 *  itself (macros); without, the first instrument in any of its chains, else its Macros. */
function findInstrument(devIds, depth) {
  for (var i = 0; i < devIds.length; i++) {
    var d = devIds[i];
    if (num(d, 'type') !== 1) continue;                       // 1 = instrument
    if (num(d, 'can_have_chains') && depth < 4) {
      var rackName = clean(get(d, 'name'));
      if (num(d, 'has_macro_mappings')) return { id: d, macros: 1, rack: null };
      var chains = ids(get(d, 'chains'));
      for (var c = 0; c < chains.length; c++) {
        var inner = findInstrument(ids(get(chains[c], 'devices')), depth + 1);
        if (inner) { if (!inner.rack) inner.rack = rackName; return inner; }
      }
      return { id: d, macros: 1, rack: null };
    }
    return { id: d, macros: 0, rack: null };
  }
  return null;
}
/** The device's class, name and parameter ids by original_name — read once, then cached. */
function deviceInfo(devId) {
  if (cache[devId]) return cache[devId];
  var pids = ids(get(devId, 'parameters')), byName = {}, list = [];
  for (var i = 0; i < pids.length; i++) { var n = clean(get(pids[i], 'original_name')); list.push(n); if (!(n in byName)) byName[n] = pids[i]; }
  var c = { cls: clean(get(devId, 'class_name')), name: clean(get(devId, 'name')), byName: byName, pids: pids, names: list };
  cache[devId] = c;
  return c;
}
function slotFor(pid, def) {
  var min = num(pid, 'min'), max = num(pid, 'max');
  var s = { id: pid, param: def.param, name: def.label || clean(get(pid, 'name')), min: min, max: max, int: def.int || num(pid, 'is_quantized') ? 1 : 0 };
  if (def.min !== undefined && def.min !== null) s.min = Math.max(min, def.min);
  if (def.max !== undefined && def.max !== null) s.max = Math.min(max, def.max);
  if (s.max <= s.min) { s.min = min; s.max = max; }
  s.value = norm(s, num(pid, 'value'));
  return s;
}
function norm(s, x) { return s.max > s.min ? Math.max(0, Math.min(1, (x - s.min) / (s.max - s.min))) : 0; }

function target(trackId) {
  var t0 = Date.now();
  var found = findInstrument(ids(get(trackId, 'devices')), 0);
  var tname = clean(get(trackId, 'name'));
  if (!found) {                                   // keep the last instrument (this device's own track…)
    T.note = tname + ': no instrument';
    mgraphics.redraw();
    return;
  }
  var info = deviceInfo(found.id), slots = [], mode;
  if (found.macros) {
    mode = 'macros';
    for (var m = 0; m < SLOTS; m++) { var mp = info.byName['Macro ' + (m + 1)]; slots.push(mp ? slotFor(mp, { param: 'Macro ' + (m + 1) }) : null); }
  } else {
    var table = tables[info.cls];
    mode = table ? 'table' : 'none';
    for (var s = 0; s < SLOTS; s++) {
      var def = table && table[s], pid = def && info.byName[def.param];
      slots.push(pid ? slotFor(pid, def) : null);
    }
  }
  T = { trackId: trackId, track: tname, index: trackIndex(trackId), devId: found.id, device: info.name, cls: info.cls,
    rack: found.rack, mode: mode, slots: slots, ms: 0, note: '' };
  for (var k = 0; k < SLOTS; k++) { outlet(0, k, 'id', slots[k] ? slots[k].id : 0); watch(k, slots[k]); }
  T.ms = Date.now() - t0;
  sendInfo();
  mgraphics.redraw();
}
function trackIndex(id) { for (var i = 0; i < tracks.length; i++) if (tracks[i].id === id) return i; return -1; }
/** The target again (new tables, or SY.CORE picked a track). */
function retarget() { if (T.trackId) { var id = T.trackId; T.trackId = 0; target(id); } }

function sendInfo() {
  toBridge('mapinfo', JSON.stringify({
    track: { index: T.index, name: T.track },
    device: T.devId ? { name: T.device, cls: T.cls, rack: T.rack } : null,
    mode: T.mode,
    slots: T.slots.map(function (s) { return s ? { param: s.param, name: s.name, value: s.value } : null; }),
  }));
}

// ── values ──
/** Slot s to v (0–1): its range, whole numbers when int. */
function setSlot(s, v) {
  var p = T.slots[s];
  if (!p) return;
  p.value = Math.max(0, Math.min(1, v));
  var x = p.min + p.value * (p.max - p.min);
  outlet(0, s, p.int ? Math.round(x) : x);
  mgraphics.redraw();
}
function makeObserver(s) {
  var o = new LiveAPI(function (args) {
    if (!args || args[0] !== 'value') return;
    var p = T.slots[s];
    if (!p) return;
    var v = norm(p, +args[1]);
    if (Math.abs(v - p.value) < 1e-4) return;
    p.value = v; dirty[s] = 1;
  }, 'id 0');
  return o;
}
function watch(s, slot) {
  var o = obs[s];
  o.property = '';
  if (!slot) return;
  if (typeof o.goto === 'function') o.goto('id ' + slot.id);
  else { o = obs[s] = makeObserver(s); o.path = 'id ' + slot.id; }
  o.property = 'value';
}
var flush = new Task(function () {
  var any = 0;
  for (var s in dirty) { toBridge('mapvalue', +s, T.slots[s] ? T.slots[s].value : 0); any = 1; }
  dirty = {};
  if (any) mgraphics.redraw();
}, this);
flush.interval = 30;
flush.repeat();

// ── messages ──
function anything() {
  var a = arrayfromargs(arguments);
  switch (messagename) {
    case 'follow': setFollow(a[0]); break;
    case 'tables':
      try { setTables(JSON.parse(a.join(' '))); } catch (e) { post('sycore-map: bad tables\n'); break; }
      cache = {};
      if (ready) retarget();
      break;
    case 'value': setSlot(a[0] | 0, +a[1]); break;
    case 'target':
      if (a[0] === 'follow') { setFollow(1); outlet(1, 'followtoggle', 1); }
      else if (ready && tracks[a[0] | 0]) { setFollow(0); outlet(1, 'followtoggle', 0); target(tracks[a[0] | 0].id); }
      break;
    case 'params': sendParams(); break;
  }
}
/** Follow the selected track (on: go to it now) or stay on the target (Lock). */
function setFollow(v) {
  follow = v ? 1 : 0;
  if (follow && ready) { var sel = ids(view.get('selected_track'))[0]; if (sel && sel !== T.trackId) target(sel); }
  mgraphics.redraw();
}
/** Every parameter of the instrument driven now (for SY.CORE's table editor): slow, on request only. */
function sendParams() {
  if (!T.devId) return;
  var info = deviceInfo(T.devId), out = [];
  for (var i = 0; i < info.pids.length; i++) {
    var pid = info.pids[i];
    out.push({ name: info.names[i], shown: clean(get(pid, 'name')), min: num(pid, 'min'), max: num(pid, 'max'), q: num(pid, 'is_quantized') });
  }
  toBridge('mapparams', JSON.stringify({ cls: info.cls, name: info.name, params: out }));
}

// ── drawing ──
var C = {
  bg: [0.075, 0.075, 0.075, 1], cell: [0.12, 0.12, 0.12, 1], border: [1, 1, 1, 0.1], ink: [0.96, 0.96, 0.96, 1],
  muted: [0.54, 0.56, 0.57, 1], dim: [0.36, 0.38, 0.4, 1], brand: [0, 0.64, 0.44, 1], brandSoft: [0.2, 0.84, 0.66, 1],
  amber: [0.96, 0.62, 0.04, 1],
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
  // the target: track › (rack ›) instrument · mode
  var head = !T.devId ? (ready ? 'Select a track with an instrument' : 'Starting…')
    : T.track + ' > ' + (T.rack ? T.rack + ' > ' : '') + T.device;
  txt(head, 2, 13, T.devId ? C.ink : C.dim, 10, 1, G.w - 120);
  var tag = T.mode === 'macros' ? 'MACROS' : T.mode === 'table' ? T.cls : T.devId ? 'NO TABLE · ' + T.cls : '';
  if (T.note) tag = T.note;
  mgraphics.select_font_face('Arial'); mgraphics.set_font_size(9);
  var tw = mgraphics.text_measure(tag)[0];
  txt(tag, G.w - tw - 2, 13, T.mode === 'none' ? C.amber : C.muted, 9, 0);
  for (var s = 0; s < SLOTS; s++) {
    var c = cellAt(G, s), p = T.slots[s];
    rect(c.x, c.y, G.cw, G.ch, C.cell);
    txt(String(s + 1), c.x + 3, c.y + 10, C.dim, 8, 1);
    if (!p) continue;
    wrap2(p.name, c.x + 3, c.y + 21, C.ink, 9, G.cw - 5);
    // the value: a bar along the bottom
    var bh = 4, by = c.y + G.ch - bh - 3;
    rect(c.x + 3, by, G.cw - 6, bh, [1, 1, 1, 0.08], 2);
    rect(c.x + 3, by, Math.max(bh, (G.cw - 6) * p.value), bh, C.brandSoft, 2);
  }
}

// ── dragging a slot (also without SY.CORE) ──
var drag = -1, dragY = 0, dragV = 0;
function onclick(x, y) {
  var G = grid();
  drag = -1;
  for (var s = 0; s < SLOTS; s++) {
    var c = cellAt(G, s);
    if (x >= c.x && x <= c.x + G.cw && y >= c.y && y <= c.y + G.ch && T.slots[s]) { drag = s; dragY = y; dragV = T.slots[s].value; return; }
  }
}
onclick.local = 1;
function ondrag(x, y, but) {
  if (drag < 0) return;
  if (!but) { drag = -1; return; }
  setSlot(drag, dragV + (dragY - y) / 120);
}
ondrag.local = 1;
function onresize() { mgraphics.redraw(); }
onresize.local = 1;
