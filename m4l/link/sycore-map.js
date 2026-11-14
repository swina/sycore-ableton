// sycore-map.js — the SY.CORE Map device's logic ([js], Max JS / ES5; P12; drawn by sycore-map-view.js): one device in the set drives
// the instrument of a track by table — slot n (an encoder in SY.CORE) → a parameter, by original_name.
//   Target: the track selected in Live (Follow) or the one SY.CORE picks; a track without an instrument
//   (e.g. this device's own) keeps the last one. On the track, the first instrument by its table; a Rack
//   with mapped Macros → its configured Macros first, then the first instrument's table (parameters a
//   Macro holds left out) up to 16; a Rack without → the first instrument in its chains.
//   in : bang (live.thisdevice: the Live API is ready), "follow <0|1>" (the device's toggle),
//        from the view: "drag <slot> <0–1>" (a slot dragged), "viewready" (the view (re)loaded: the state again),
//        from the bridge ([r sycore_map]): "tables <json>", "value <slot> <0–1>", "target <follow|track>", "params",
//        "variation <index | next | prev | store | delete>" (a Rack's Macro Variations), "randomize" (its Macros),
//        "sync" (the bridge restarted: everything again)
//   A slot moves its parameter through the Live API (like the mouse: no lock, the knob in Live follows;
//   no live.remote~ — it greyed the parameter out and Live kept playing the old value while it held it).
//   out 0: to the bridge ([s sycore_map_in]): "mapready", "mapinfo <json>", "mapvalue <slot> <0–1>",
//          "maptracks <json>", "mapparams <json>"; "followtoggle <0|1>" (SY.CORE changed the target: the toggle follows)
//   out 1: to the view: "state <json>" (header, tag, slots), "val <slot> <0–1>"
// No autowatch: a reloaded script would get no live.thisdevice bang (its only one, at load) — reload the device.
// Parameters are read once per device (ids cached by device id): only the table's 16 on a track change.
autowatch = 0;
inlets = 1;
outlets = 2;

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
function toBridge() { var a = arrayfromargs(arguments); outlet.apply(this, [0].concat(a)); }

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
  pollTask.repeat();
  readTracks();
  var sel = ids(view.get('selected_track'))[0];
  if (sel) safeTarget(sel);
}

// Notifications can't change the set: the work is deferred out of the callbacks.
var pendingTrack = 0;
var deferred = new Task(function () { if (pendingTrack) { var t = pendingTrack; pendingTrack = 0; safeTarget(t); } }, this);
function safeTarget(id) { try { goTarget(id); } catch (e) { post('sycore-map: target failed: ' + e + '\n'); } }
var DEBUG = 0;   // 1: selections, targets and left-out parameters in the Max console
var DEBUG_VAL = 0;   // 1: every slot value sent, the parameter's value after it, the observer's reports
function onSelected(args) {
  if (DEBUG) post('sycore-map: selected ' + (args ? args.join(' ') : '?') + (following ? '' : ' (lock)') + '\n');
  if (!following || !args || args[0] !== 'selected_track') return;
  var id = +args[2];
  if (!id || id === T.trackId) return;
  pendingTrack = id;
  deferred.schedule(0);
}
var tracksTask = new Task(readTracks, this);
function onTracks(args) { if (args && args[0] === 'tracks') tracksTask.schedule(0); }
/** The set's tracks, each with its first instrument's name ('' = none: SY.CORE's DECK lists only the
 *  tracks with one). Read at start and when the tracks change; a track's entry is refreshed on a target. */
function readTracks() {
  var list = ids(new LiveAPI(null, 'live_set').get('tracks'));
  tracks = [];
  for (var i = 0; i < list.length; i++) tracks.push({ id: list[i], index: i, name: clean(get(list[i], 'name')), instrument: trackInstrument(list[i]) });
  sendTracks();
}
function trackInstrument(trackId) {
  var devs = ids(get(trackId, 'devices'));
  for (var i = 0; i < devs.length; i++) if (num(devs[i], 'type') === 1) return clean(get(devs[i], 'name'));
  return '';
}
function sendTracks() {
  toBridge('maptracks', JSON.stringify(tracks.map(function (t) { return { index: t.index, name: t.name, instrument: t.instrument }; })));
}

// ── the target ──
/**
 * The instrument of a list of device ids: { id (the instrument, or the Rack), rackId?, rack (name), macros }.
 * A Rack with mapped Macros (the user's rule, 2026-11-10): its configured Macros first, then the table of
 * the first instrument in its chains for the slots left (macros: 1). A Rack without: the instrument
 * inside, by its table. An outer Rack's Macros win over an inner one's.
 */
function findInstrument(devIds, depth) {
  for (var i = 0; i < devIds.length; i++) {
    var d = devIds[i];
    if (num(d, 'type') !== 1) continue;                       // 1 = instrument
    if (num(d, 'can_have_chains') && depth < 4) {
      var rackName = clean(get(d, 'name')), inner = null;
      var chains = ids(get(d, 'chains'));
      for (var c = 0; c < chains.length && !inner; c++) inner = findInstrument(ids(get(chains[c], 'devices')), depth + 1);
      if (num(d, 'has_macro_mappings')) return { id: inner ? inner.id : d, rackId: d, rack: rackName, macros: 1 };
      if (inner) { if (!inner.rack) inner.rack = rackName; return inner; }
      return { id: d, rackId: d, rack: rackName, macros: 1 };   // an empty Rack: its Macros
    }
    return { id: d, rackId: 0, rack: null, macros: 0 };
  }
  return null;
}
/** The device's class, name and parameter ids — read once, then cached. */
// Reading every parameter's name is the slow part (~3 ms each: Analog's 172 ≈ 500 ms). A class's
// parameters are always in the same order, so their positions are learnt once per class (classIndex)
// and another device of that class only checks the names of the parameters it uses.
var classIndex = {};   // class_name → { original_name: position }
function deviceInfo(devId) {
  if (cache[devId]) return cache[devId];
  var c = { cls: clean(get(devId, 'class_name')), name: clean(get(devId, 'name')), pids: ids(get(devId, 'parameters')), byName: null, names: null };
  cache[devId] = c;
  return c;
}
/** Every parameter's name (once per device; teaches the class its positions). */
function readAll(c) {
  if (c.names) return;
  var idx = {};
  c.names = []; c.byName = {};
  for (var i = 0; i < c.pids.length; i++) {
    var n = clean(get(c.pids[i], 'original_name'));
    c.names.push(n);
    if (!(n in c.byName)) { c.byName[n] = c.pids[i]; idx[n] = i; }
  }
  classIndex[c.cls] = idx;
}
/** The id of a device's parameter by original_name: by its class's position (checked), else read all. */
function paramId(c, name) {
  if (c.byName) return c.byName[name];
  var idx = classIndex[c.cls];
  if (idx) {
    if (!(name in idx)) return undefined;
    var pid = c.pids[idx[name]];
    if (pid && clean(get(pid, 'original_name')) === name) return pid;
  }
  readAll(c);
  return c.byName[name];
}
function slotFor(pid, def) {
  var min = num(pid, 'min'), max = num(pid, 'max');
  var s = { id: pid, param: def.param, name: def.label || clean(get(pid, 'name')), min: min, max: max, int: def.int || num(pid, 'is_quantized') ? 1 : 0 };
  if (def.min !== undefined && def.min !== null) s.min = Math.max(min, def.min);
  if (def.max !== undefined && def.max !== null) s.max = Math.min(max, def.max);
  if (s.max <= s.min) { s.min = min; s.max = max; }
  s.value = 0;          // the value comes from the slot's observer (it reports it when set up)
  return s;
}
function copy(o) { var r = {}; for (var k in o) r[k] = o[k]; return r; }
function norm(s, x) { return s.max > s.min ? Math.max(0, Math.min(1, (x - s.min) / (s.max - s.min))) : 0; }

/** A Rack's configured Macros: those Live has named after a mapping (a free one is "Macro n"). */
function rackMacros(rackId) {
  var ri = deviceInfo(rackId), out = [];
  for (var m = 1; m <= 16; m++) {
    var mid = paramId(ri, 'Macro ' + m);
    if (!mid) continue;
    var label = clean(get(mid, 'name'));
    if (label !== 'Macro ' + m) out.push(slotFor(mid, { param: 'Macro ' + m, label: label }));
  }
  return out;
}
// Max for Live instruments and plugins all share one class (MxDeviceInstrument, PluginDevice,
// AuPluginDevice): their tables are kept by class and device name ("MxDeviceInstrument:Cheese Grater").
var NAMED_CLASSES = { MxDeviceInstrument: 1, PluginDevice: 1, AuPluginDevice: 1 };
function tableKey(info) { return NAMED_CLASSES[info.cls] ? info.cls + ':' + info.name : info.cls; }
/** No table (a Max for Live device, a plugin, an instrument not in the tables): its first 16 parameters,
 *  "Device On" and the ones a Macro holds left out — usually the device's main controls, in its order. */
function autoSlots(info) {
  var out = [];
  for (var i = 0; i < info.pids.length && out.length < SLOTS; i++) {
    var pid = info.pids[i];
    if (num(pid, 'state') === 2) continue;
    var on = clean(get(pid, 'original_name'));
    if (on === 'Device On') continue;
    out.push(slotFor(pid, { param: on }));
  }
  return out;
}
/** The table's slots of an instrument, skipping the parameters a Macro holds (state 2: disabled) and
 *  those in `skip`, at most `room`. */
function tableSlots(info, table, room) {
  var out = [];
  for (var s = 0; s < table.length && out.length < room; s++) {
    var def = table[s], pid = def && paramId(info, def.param);
    if (!pid) continue;
    if (num(pid, 'state') === 2) { if (DEBUG) post('sycore-map: "' + def.param + '" is held by a Macro: left out\n'); continue; }
    out.push(slotFor(pid, def));
  }
  return out;
}

// (not named after a message: Max JS calls a function named like the message — "target follow" → target('follow'))
var foundCache = {};   // track id → { key: its device ids, found }: the instrument search skipped while the devices stay
var slotCache = {};    // instrument / Rack → its 16 slots (name, range…), values apart
function goTarget(trackId) {
  if (DEBUG) post('sycore-map: target ' + trackId + '\n');
  var t0 = Date.now();
  var devs = ids(get(trackId, 'devices')), key = devs.join(','), fc = foundCache[trackId];
  var found = fc && fc.key === key ? fc.found : findInstrument(devs, 0);
  foundCache[trackId] = { key: key, found: found };
  var tname = clean(get(trackId, 'name'));
  if (!found) {                                   // keep the last instrument (this device's own track…)
    watchDevices(trackId);                        // an instrument added on it later: taken then
    T.note = tname + ': no instrument';
    post('sycore-map: ' + tname + ': no instrument' + (T.devId ? ' — still on ' + T.track + ' > ' + T.device : '') + '\n');
    sendView();
    return;
  }
  var inst = found.id !== found.rackId ? found.id : 0;          // the instrument (0: an empty Rack)
  var info = deviceInfo(found.id), table = inst ? tableSet[tableKey(info)] : null;
  var ck = (found.macros ? 'r' + found.rackId + ':' : '') + found.id, sc = slotCache[ck];
  var slots, mode, nMacros = 0;
  if (sc) { mode = sc.mode; nMacros = sc.nMacros; slots = sc.slots.map(function (x) { return x ? copy(x) : null; }); }
  else {
    slots = found.macros ? rackMacros(found.rackId) : [];
    nMacros = slots.length;
    if (table) slots = slots.concat(tableSlots(info, table, SLOTS - slots.length));
    var auto = 0;
    if (!table && inst && !nMacros) { slots = autoSlots(info); auto = 1; }     // no table: its first 16 parameters
    mode = !slots.length ? 'none' : auto ? 'auto' : nMacros === slots.length ? 'macros' : nMacros ? 'mixed' : 'table';
    while (slots.length < SLOTS) slots.push(null);
    slotCache[ck] = { mode: mode, nMacros: nMacros, slots: slots.map(function (x) { return x ? copy(x) : null; }) };
  }
  var ti = trackIndex(trackId), shown = found.rack || (inst ? info.name : '');
  if (ti >= 0 && (tracks[ti].instrument !== shown || tracks[ti].name !== tname)) { tracks[ti].instrument = shown; tracks[ti].name = tname; sendTracks(); }
  T = { trackId: trackId, track: tname, index: trackIndex(trackId), devId: found.id, device: inst ? info.name : '', cls: inst ? info.cls : '',
    rack: found.rack, rackId: found.macros ? found.rackId : 0, mode: mode, nMacros: nMacros, slots: slots, ms: 0, note: '' };
  watchVariations(T.rackId);
  watchDevices(trackId);
  for (var k = 0; k < SLOTS; k++) watch(k, slots[k]);
  T.ms = Date.now() - t0;
  var n = 0; for (var q = 0; q < SLOTS; q++) if (slots[q]) n++;
  post('sycore-map: ' + tname + ' > ' + (found.rack ? found.rack + ' > ' : '') + (inst ? info.name + ' (' + info.cls + ')' : '(Rack)') +
    ' · ' + (mode === 'auto' ? n + ' first parameters (no table: ' + tableKey(info) + ')' : (nMacros ? nMacros + ' Macros + ' : '') + (n - nMacros) + ' from the table') + ' · ' + T.ms + ' ms\n');
  sendInfo();
  sendView();
}
function trackIndex(id) { for (var i = 0; i < tracks.length; i++) if (tracks[i].id === id) return i; return -1; }

// The target track's devices: its instrument replaced, added or removed (same track, no new selection)
// → the target read again. Only the instrument counts: MIDI effects before it (an Arpeggiator…) and
// audio effects after it are skipped, as in findInstrument; a change of those alone does nothing.
// Read out of the notification (it can't touch the set), after the change settles.
var devObs = null, devObsTrack = 0;
function instrumentKey(trackId) {
  var f = findInstrument(ids(get(trackId, 'devices')), 0);
  return f ? f.rackId + ':' + f.id : '';
}
/** The instrument on the watched track changed (not its MIDI / audio effects): the target read again. */
function checkInstrument(why) {
  if (!devObsTrack) return;
  var o = new LiveAPI(null, 'id ' + devObsTrack);
  if (!(+o.id > 0)) { devObsTrack = 0; return; }          // the track was deleted
  var key = instrumentKey(devObsTrack);
  var now = T.trackId === devObsTrack ? T.rackId + ':' + T.devId : '';
  if (key === now) return;
  post('sycore-map: track ' + clean(get(devObsTrack, 'name')) + ': instrument changed (' + why + ')\n');
  delete foundCache[devObsTrack];
  T.trackId = 0;
  safeTarget(devObsTrack);
}
var devTask = new Task(function () { try { checkInstrument('devices'); } catch (e) { post('sycore-map: devices check failed: ' + e + '\n'); } }, this);
// Every 500 ms, as a backstop: Live's notification of the track's devices didn't come in every case
// (an Instrument Rack replaced on the track went unseen). The poll creates NO LiveAPI object: it reads
// the track's device list through the observer already on it (devObs) and runs the full check only when
// that list changed. (It used to run checkInstrument each time — a new LiveAPI per property read, a
// dozen per poll with a Rack: tens of thousands an hour, and Live hung after an hour or two idle.)
var lastDevList = null;
var pollTask = new Task(function () {
  try {
    if (!devObs || !devObsTrack) return;
    if (!(+devObs.id > 0)) { checkInstrument('check'); return; }   // the track was deleted
    var list = String(devObs.get('devices'));
    if (list === lastDevList) return;
    var first = lastDevList === null;
    lastDevList = list;
    if (!first) checkInstrument('check');
  } catch (e) {}
}, this);
pollTask.interval = 500;
function onDevices(args) {
  if (!args || args[0] !== 'devices') return;
  devTask.cancel();
  devTask.schedule(100);
}
function watchDevices(trackId) {
  if (devObsTrack === trackId) return;
  if (devObs) { try { devObs.property = ''; } catch (e) {} devObs = null; }
  devObsTrack = trackId;
  devObs = new LiveAPI(onDevices, 'id ' + trackId);
  devObs.property = 'devices';
  lastDevList = null;   // the poll takes this track's list as it is now
}
/** The target again (new tables, or SY.CORE picked a track). */
function retarget() { if (T.trackId) { var id = T.trackId; T.trackId = 0; safeTarget(id); } }

function sendInfo() {
  toBridge('mapinfo', JSON.stringify({
    track: { index: T.index, name: T.track },
    device: T.devId ? { name: T.device || T.rack, cls: T.cls || 'Rack', rack: T.rack } : null,
    mode: T.mode,
    slots: T.slots.map(function (s) { return s ? { param: s.param, name: s.name, value: s.value } : null; }),
    variations: T.rackId ? { count: T.varCount | 0, selected: T.varSel === undefined ? -1 : T.varSel } : null,
  }));
}

// ── Macro Variations (a Rack's stored Macro settings) ──
// Observed on the Rack in focus: their count and the selected one (Live's own changes included); SY.CORE
// recalls one (index, next, prev) or randomizes the Macros. Changes to the set are made outside
// notifications (deferred).
var varObs = [];
var varTask = new Task(function () { sendInfo(); sendView(); }, this);
function watchVariations(rackId) {
  for (var i = 0; i < varObs.length; i++) varObs[i].property = '';
  varObs = [];
  T.varCount = 0; T.varSel = -1;
  if (!rackId) return;
  T.varCount = num(rackId, 'variation_count') | 0;
  T.varSel = num(rackId, 'selected_variation_index');
  ['variation_count', 'selected_variation_index'].forEach(function (prop) {
    var o = new LiveAPI(function (args) {
      if (!args || args[0] !== prop || T.rackId !== rackId) return;
      if (prop === 'variation_count') T.varCount = +args[1] | 0; else T.varSel = +args[1];
      varTask.schedule(0);
    }, 'id ' + rackId);
    o.property = prop;
    varObs.push(o);
  });
}
/** Recall a Macro Variation of the Rack in focus: an index, or 'next' / 'prev' (wrapping); 'store' (the
 *  Macros as they are now, a new variation) and 'delete' (the selected one). */
function recallVariation(arg) {
  if (arg === 'store') { storeVar(); return; }
  if (arg === 'delete') { deleteVar(); return; }
  if (!T.rackId || !T.varCount) return;
  var cur = T.varSel, n = T.varCount, i;
  if (arg === 'next') i = cur < 0 ? 0 : (cur + 1) % n;
  else if (arg === 'prev') i = cur < 0 ? n - 1 : (cur - 1 + n) % n;
  else i = arg | 0;
  if (i < 0 || i >= n) return;
  var r = at(T.rackId);
  r.set('selected_variation_index', i);
  r.call('recall_selected_variation');
  T.varSel = i;
  post('sycore-map: ' + T.rack + ' variation ' + (i + 1) + '/' + n + '\n');
  sendInfo(); sendView();
}
function storeVar() {
  if (!T.rackId) return;
  at(T.rackId).call('store_variation');
  T.varCount = num(T.rackId, 'variation_count') | 0;
  T.varSel = num(T.rackId, 'selected_variation_index');
  post('sycore-map: ' + T.rack + ' variation stored (' + T.varCount + ')\n');
  sendInfo(); sendView();
}
function deleteVar() {
  if (!T.rackId || !T.varCount || T.varSel < 0) return;
  var n = T.varSel + 1;
  at(T.rackId).call('delete_selected_variation');
  T.varCount = num(T.rackId, 'variation_count') | 0;
  T.varSel = num(T.rackId, 'selected_variation_index');
  post('sycore-map: ' + T.rack + ' variation ' + n + ' deleted (' + T.varCount + ' left)\n');
  sendInfo(); sendView();
}
function randomizeMacros() {
  if (!T.rackId) return;
  at(T.rackId).call('randomize_macros');
  post('sycore-map: ' + T.rack + ' Macros randomized\n');
}

// ── values ──
/** Slot s to v (0–1): its range, whole numbers when int; written through the Live API (like the mouse). */
function setSlot(s, v) {
  var p = T.slots[s];
  if (!p) return;
  p.value = Math.max(0, Math.min(1, v));
  var x = p.min + p.value * (p.max - p.min);
  if (p.int) x = Math.round(x);
  try { (obs[s] || at(p.id)).set('value', x); } catch (e) { post('sycore-map: set ' + p.name + ' failed: ' + e + '\n'); }
  if (DEBUG_VAL) post('sycore-map: set ' + s + ' ' + p.name + ' x=' + x + ' → live ' + num(p.id, 'value') + '\n');
  outlet(1, 'val', s, p.value);
}
/** A value observer on slot s's parameter (a new one per target: an observer on "id 0" is an invalid path). */
function makeObserver(s, pid) {
  var o = new LiveAPI(function (args) {
    if (!args || args[0] !== 'value') return;
    var p = T.slots[s];
    if (!p) return;
    var v = norm(p, +args[1]);
    if (DEBUG_VAL) post('sycore-map: obs ' + s + ' ' + p.name + ' raw=' + (+args[1]).toFixed(3) + ' v=' + v.toFixed(3) + ' (had ' + p.value.toFixed(3) + ')\n');
    if (p.seen && Math.abs(v - p.value) < 1e-4) return;
    p.seen = 1; p.value = v; dirty[s] = 1;
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
  for (var s in dirty) { var v = T.slots[s] ? T.slots[s].value : 0; toBridge('mapvalue', +s, v); outlet(1, 'val', +s, v); any = 1; }
  dirty = {};
}, this);
flush.interval = 30;
flush.repeat();

// ── the view (sycore-map-view.js) ──
// (sendView, not view: `view` is the selected-track observer)
function sendView() {
  var head = !T.devId ? (ready ? 'Select a track with an instrument' : 'Starting…')
    : T.track + ' > ' + (T.rack ? T.rack + ' > ' : '') + T.device;
  var tag = T.note || (T.mode === 'auto' ? 'AUTO · ' + T.cls : T.mode === 'macros' ? 'MACROS' : T.mode === 'mixed' ? T.nMacros + ' MACROS + ' + T.cls
    : T.mode === 'table' ? T.cls : T.devId ? 'NO TABLE · ' + (T.cls || 'Rack') : '');
  if (!T.note && T.rackId && T.varCount) tag = 'VAR ' + (T.varSel >= 0 ? T.varSel + 1 : '–') + '/' + T.varCount + ' · ' + tag;
  outlet(1, 'state', JSON.stringify({ head: head, on: T.devId ? 1 : 0, tag: tag, warn: T.mode === 'none' && T.devId ? 1 : 0,
    slots: T.slots.map(function (x) { return x ? { name: x.name, value: x.value } : null; }) }));
}

// ── messages ──
function anything() {
  var a = arrayfromargs(arguments);
  switch (messagename) {
    case 'follow': setFollow(a[0]); break;
    case 'tables':
      try { setTables(JSON.parse(a.join(' '))); } catch (e) { post('sycore-map: bad tables\n'); break; }
      cache = {}; slotCache = {}; foundCache = {};
      if (ready) retarget();
      break;
    case 'value': setSlot(a[0] | 0, +a[1]); break;
    case 'target':
      if (a[0] === 'follow') { setFollow(1); outlet(0, 'followtoggle', 1); }
      else if (ready && tracks[a[0] | 0]) { setFollow(0); outlet(0, 'followtoggle', 0); safeTarget(tracks[a[0] | 0].id); }
      break;
    case 'params': sendParams(); break;
    case 'variation': recallVariation(a[0]); break;
    case 'randomize': randomizeMacros(); break;
    case 'drag': setSlot(a[0] | 0, +a[1]); break;
    case 'viewready': sendView(); break;
    // The bridge (re)started (the SY.CORE Link device reloaded): it knows nothing of this device — the
    // tables and target again (mapready), the tracks and the instrument in focus.
    case 'sync': if (ready) { toBridge('mapready'); readTracks(); sendInfo(); } break;
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
  if (!T.devId || !T.cls) return;
  var info = deviceInfo(T.devId), out = [];
  readAll(info);
  for (var i = 0; i < info.pids.length; i++) {
    var pid = info.pids[i];
    out.push({ name: info.names[i], shown: clean(get(pid, 'name')), min: num(pid, 'min'), max: num(pid, 'max'), q: num(pid, 'is_quantized') });
  }
  toBridge('mapparams', JSON.stringify({ cls: tableKey(info), name: info.name, params: out }));
}


// The device removed / the script freed: no more checks.
function notifydeleted() { try { pollTask.cancel(); devTask.cancel(); } catch (e) {} }
