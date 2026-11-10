// sycore-map.js — the SY.CORE Map device's logic ([js], Max JS / ES5; P12; drawn by sycore-map-view.js): one device in the set drives
// the instrument of a track by table — slot n (an encoder in SY.CORE) → a parameter, by original_name.
//   Target: the track selected in Live (Follow) or the one SY.CORE picks; a track without an instrument
//   (e.g. this device's own) keeps the last one. On the track, the first instrument; a Rack with mapped
//   Macros → its 16 Macros; a Rack without → the first instrument in its chains.
//   in : bang (live.thisdevice: the Live API is ready), "follow <0|1>" (the device's toggle),
//        from the view: "drag <slot> <0–1>" (a slot dragged), "viewready" (the view (re)loaded: the state again),
//        from the bridge ([r sycore_map]): "tables <json>", "value <slot> <0–1>", "target <follow|track>", "params"
//   out 0: "<slot> id <param id>" (re-point a live.remote~, id 0 = released) / "<slot> <value>" (parameter units)
//   out 1: to the bridge ([s sycore_map_in]): "mapready", "mapinfo <json>", "mapvalue <slot> <0–1>",
//          "maptracks <json>", "mapparams <json>"; "followtoggle <0|1>" (SY.CORE changed the target: the toggle follows)
//   out 2: to the view: "state <json>" (header, tag, slots), "val <slot> <0–1>"
// No autowatch: a reloaded script would get no live.thisdevice bang (its only one, at load) — reload the device.
// Parameters are read once per device (ids cached by device id): only the table's 16 on a track change.
autowatch = 0;
inlets = 1;
outlets = 3;

var SLOTS = 16;
// Factory tables (SY.CORE's tables replace them; variables are not named like the messages "tables", "follow"): slot = { param: original_name, min?, max?, int? }.
var FACTORY = {
  Drift: ['LP Freq', 'LP Res', 'HP Freq', 'LP Mod Amt 1', 'Env 1 Attack', 'Env 1 Decay', 'Env 1 Sustain', 'Env 1 Release',
    'Osc 1 Shape', 'Osc 2 Detune', 'Osc 2 Gain', 'Noise Gain', 'LFO Rate', 'LFO Amt', 'Drift', 'Volume'],
  UltraAnalog: ['F1 Freq', 'F1 Resonance', 'F1 Freq < Env', 'F1 Freq < LFO', 'AEG1 Attack', 'AEG1 Decay', 'AEG1 Sustain', 'AEG1 Rel',
    'OSC1 PW', 'OSC2 Detune', 'OSC1 Level', 'OSC2 Level', 'Noise Level', 'LFO1 Speed', 'Glide Time', 'Volume'],
  OriginalSimpler: ['Filter Freq', 'Filter Res', 'Fe < Env', 'Filter Drive', 'Ve Attack', 'Ve Decay', 'Ve Sustain', 'Ve Release',
    'S Start', 'S Length', { param: 'Transpose', min: -24, max: 24, int: 1 }, 'Detune', 'Glide Time', 'Shaper Amt', 'Pan',
    { param: 'Volume', min: -36, max: 6 }],
};
var tableSet = {};
function setTables(t) {
  tableSet = {};
  var k, i;
  for (k in FACTORY) tableSet[k] = FACTORY[k].map(function (x) { return typeof x === 'string' ? { param: x } : x; });
  for (k in t) if (t[k] instanceof Array) { tableSet[k] = []; for (i = 0; i < SLOTS; i++) tableSet[k].push(t[k][i] || null); }
}
setTables({});

var ready = 0, following = 1;
var view = null, setObs = null;
var cache = {};          // device id → { cls, name, byName: { original_name: param id } }
var tracks = [];         // [{ id, index, name }]
// The target: track, device, mode, and the 16 slots { id, param, name, min, max, int, value (0–1) } or null
var T = { trackId: 0, track: '', index: -1, devId: 0, device: '', cls: '', rack: null, mode: 'none', slots: [], ms: 0 };
var obs = [];            // 16 value observers
var dirty = {};          // slots whose value changed in Live (sent at most every 30 ms)

// ── Live API helpers ──
function clean(v) { return String(v instanceof Array ? v.join(' ') : v).replace(/^"(.*)"$/, '$1'); }
function ids(list) { var r = []; for (var i = 0; i + 1 < list.length; i += 2) if (list[i] === 'id' && +list[i + 1]) r.push(+list[i + 1]); return r; }
/** A LiveAPI object on an id (a new one each time, as in the spike: goto('id N') leaves it invalid). */
function at(id) { return new LiveAPI(null, 'id ' + id); }
/** A property of the object with that id; an invalid id is reported (with what was read) and gives []. */
function get(id, prop) {
  if (!(+id > 0)) { post('sycore-map: no object for "' + prop + '" (id ' + id + ')\n'); return []; }
  return at(id).get(prop);
}
function num(id, prop) { return +get(id, prop)[0]; }
function toBridge() { var a = arrayfromargs(arguments); outlet.apply(this, [1].concat(a)); }

// ── init ──
function bang() {
  if (ready) return;
  try { start(); } catch (e) { post('sycore-map: start failed: ' + e + '\n'); }
}
function start() {
  ready = 1;
  post('sycore-map: started\n');
  view = new LiveAPI(onSelected, 'live_set view');
  view.property = 'selected_track';
  setObs = new LiveAPI(onTracks, 'live_set');
  setObs.property = 'tracks';
  for (var s = 0; s < SLOTS; s++) obs.push(null);
  toBridge('mapready');
  readTracks();
  var sel = ids(view.get('selected_track'))[0];
  if (sel) safeTarget(sel);
}

// Notifications can't change the set: the work is deferred out of the callbacks.
var pendingTrack = 0;
var deferred = new Task(function () { if (pendingTrack) { var t = pendingTrack; pendingTrack = 0; safeTarget(t); } }, this);
function safeTarget(id) { try { goTarget(id); } catch (e) { post('sycore-map: target failed: ' + e + '\n'); } }
function onSelected(args) {
  if (!following || !args || args[0] !== 'selected_track') return;
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

// (not named after a message: Max JS calls a function named like the message — "target follow" → target('follow'))
function goTarget(trackId) {
  var t0 = Date.now();
  var found = findInstrument(ids(get(trackId, 'devices')), 0);
  var tname = clean(get(trackId, 'name'));
  if (!found) {                                   // keep the last instrument (this device's own track…)
    T.note = tname + ': no instrument';
    sendView();
    return;
  }
  var info = deviceInfo(found.id), slots = [], mode;
  if (found.macros) {
    mode = 'macros';
    for (var m = 0; m < SLOTS; m++) { var mp = info.byName['Macro ' + (m + 1)]; slots.push(mp ? slotFor(mp, { param: 'Macro ' + (m + 1) }) : null); }
  } else {
    var table = tableSet[info.cls];
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
  var n = 0; for (var q = 0; q < SLOTS; q++) if (slots[q]) n++;
  post('sycore-map: ' + tname + ' > ' + (found.rack ? found.rack + ' > ' : '') + info.name + ' (' + info.cls + ') · ' + mode + ' ' + n + '/16 · ' + T.ms + ' ms\n');
  sendInfo();
  sendView();
}
function trackIndex(id) { for (var i = 0; i < tracks.length; i++) if (tracks[i].id === id) return i; return -1; }
/** The target again (new tables, or SY.CORE picked a track). */
function retarget() { if (T.trackId) { var id = T.trackId; T.trackId = 0; safeTarget(id); } }

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
  outlet(2, 'val', s, p.value);
}
/** A value observer on slot s's parameter (a new one per target: an observer on "id 0" is an invalid path). */
function makeObserver(s, pid) {
  var o = new LiveAPI(function (args) {
    if (!args || args[0] !== 'value') return;
    var p = T.slots[s];
    if (!p) return;
    var v = norm(p, +args[1]);
    if (Math.abs(v - p.value) < 1e-4) return;
    p.value = v; dirty[s] = 1;
  }, 'id ' + pid);
  o.property = 'value';
  return o;
}
function watch(s, slot) {
  if (obs[s]) { obs[s].property = ''; obs[s] = null; }
  if (slot) obs[s] = makeObserver(s, slot.id);
}
var flush = new Task(function () {
  var any = 0;
  for (var s in dirty) { var v = T.slots[s] ? T.slots[s].value : 0; toBridge('mapvalue', +s, v); outlet(2, 'val', +s, v); any = 1; }
  dirty = {};
}, this);
flush.interval = 30;
flush.repeat();

// ── the view (sycore-map-view.js) ──
// (sendView, not view: `view` is the selected-track observer)
function sendView() {
  var head = !T.devId ? (ready ? 'Select a track with an instrument' : 'Starting…')
    : T.track + ' > ' + (T.rack ? T.rack + ' > ' : '') + T.device;
  var tag = T.note || (T.mode === 'macros' ? 'MACROS' : T.mode === 'table' ? T.cls : T.devId ? 'NO TABLE · ' + T.cls : '');
  outlet(2, 'state', JSON.stringify({ head: head, on: T.devId ? 1 : 0, tag: tag, warn: T.mode === 'none' && T.devId ? 1 : 0,
    slots: T.slots.map(function (x) { return x ? { name: x.name, value: x.value } : null; }) }));
}

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
      else if (ready && tracks[a[0] | 0]) { setFollow(0); outlet(1, 'followtoggle', 0); safeTarget(tracks[a[0] | 0].id); }
      break;
    case 'params': sendParams(); break;
    case 'drag': setSlot(a[0] | 0, +a[1]); break;
    case 'viewready': sendView(); break;
  }
}
/** Follow the selected track (on: go to it now) or stay on the target (Lock). */
function setFollow(v) {
  following = v ? 1 : 0;
  if (following && ready) { var sel = ids(view.get('selected_track'))[0]; if (sel && sel !== T.trackId) safeTarget(sel); }
  sendView();
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

