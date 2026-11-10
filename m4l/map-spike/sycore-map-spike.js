// sycore-map-spike.js — P12 spike ([js], Max JS / ES5): one device drives the instrument of the
// selected track by table — slot n → a parameter by original_name, moved with live.remote~.
//   in : bang (from live.thisdevice: the Live API is ready), "follow <0|1>", "dial <0–1>" (slot 1),
//        "sweep <0|1>" (all 16 slots moving, for CPU), "dump" (the instrument's parameters → Max console)
//   out 0: "<slot> id <param id>" (re-point a live.remote~; id 0 = released) / "<slot> <value>"
//   out 1: "info <text>", "time <text>"  (the device's two status lines)
// To measure: how long a track change takes (the info is read, the 16 remotes re-pointed), CPU with
// 16 slots moving, an instrument inside a Rack.
autowatch = 1;
inlets = 1;
outlets = 2;

var SLOTS = 16;
// Guessed tables (the spike checks the real original_names: "dump" lists them). A class with no
// table: the first 16 parameters after "Device On".
var TABLES = {
  InstrumentVector: ['Filter 1 Freq', 'Filter 1 Res', 'Osc 1 Pos', 'Osc 2 Pos', 'Osc 1 Gain', 'Osc 2 Gain',
    'Amp Attack', 'Amp Decay', 'Amp Sustain', 'Amp Release', 'Mod Env Amount', 'LFO 1 Rate', 'LFO 1 Amount',
    'Sub Gain', 'Unison Amount', 'Volume'],
};

var follow = 1, ready = 0;
var viewObs = null;
var slots = [];             // { id, name, min, max, q } or null
var current = { track: '', device: '', cls: '', params: [] };

function clean(v) { return String(v instanceof Array ? v.join(' ') : v).replace(/^"(.*)"$/, '$1'); }
function ids(list) { var r = []; for (var i = 0; i + 1 < list.length; i += 2) if (list[i] === 'id' && +list[i + 1]) r.push(+list[i + 1]); return r; }
function api(id) { return new LiveAPI(null, 'id ' + id); }
function info(t) { outlet(1, 'info', t); }

function bang() {
  ready = 1;
  viewObs = new LiveAPI(onSelected, 'live_set view');
  viewObs.property = 'selected_track';
}

// Notifications can't change the set: the work is deferred out of the callback.
var pendingTrack = 0;
var deferred = new Task(function () { if (pendingTrack) target(pendingTrack); }, this);
function onSelected(args) {
  if (!follow || !args || args[0] !== 'selected_track') return;
  var id = +args[2];
  if (!id) return;
  pendingTrack = id;
  deferred.schedule(0);
}

/** The first instrument of a list of device ids; a Rack: the first instrument of its first chain. */
function findInstrument(devIds, depth) {
  for (var i = 0; i < devIds.length; i++) {
    var d = api(devIds[i]);
    if (+d.get('type')[0] !== 1) continue;            // 1 = instrument
    if (+d.get('can_have_chains')[0] && depth < 3) {
      var chains = ids(d.get('chains'));
      if (chains.length) {
        var inner = findInstrument(ids(api(chains[0]).get('devices')), depth + 1);
        if (inner) { inner.rack = clean(d.get('name')); return inner; }
      }
      return { dev: d, rack: null };                   // an empty rack: its macros
    }
    return { dev: d, rack: null };
  }
  return null;
}

function target(trackId) {
  var t0 = Date.now();
  var tr = api(trackId);
  var tname = clean(tr.get('name'));
  var found = findInstrument(ids(tr.get('devices')), 0);
  var t1 = Date.now();
  // A track without an instrument (e.g. this device's own, selected when clicking on it): the last
  // instrument stays the target, so the device can still be used.
  if (!found) {
    info(tname + ': no instrument' + (current.device ? ' — still on ' + current.track + ' › ' + current.device : ''));
    outlet(1, 'time', 'read ' + (t1 - t0) + ' ms');
    return;
  }
  current = { track: tname, device: '', cls: '', params: [] };
  var d = found.dev;
  current.device = clean(d.get('name'));
  current.cls = clean(d.get('class_name'));
  var pids = ids(d.get('parameters'));
  for (var i = 0; i < pids.length; i++) {
    var p = api(pids[i]);
    current.params.push({ id: pids[i], name: clean(p.get('original_name')), shown: clean(p.get('name')),
      min: +p.get('min')[0], max: +p.get('max')[0], q: +p.get('is_quantized')[0] });
  }
  var t2 = Date.now();
  // the table: by original_name; none: the first 16 after "Device On"
  var table = TABLES[current.cls], matched = 0;
  slots = [];
  for (var s = 0; s < SLOTS; s++) {
    var prm = null;
    if (table) { for (var k = 0; k < current.params.length; k++) if (current.params[k].name === table[s]) { prm = current.params[k]; break; } }
    else prm = current.params[s + 1] || null;
    slots.push(prm);
    if (prm) matched++;
    outlet(0, s, 'id', prm ? prm.id : 0);
  }
  var t3 = Date.now();
  info(tname + ' › ' + (found.rack ? found.rack + ' › ' : '') + current.device + ' (' + current.cls + ') · ' +
    matched + '/' + SLOTS + (table ? ' by table' : ' first params'));
  outlet(1, 'time', 'devices ' + (t1 - t0) + ' ms · ' + pids.length + ' params ' + (t2 - t1) + ' ms · remotes ' + (t3 - t2) + ' ms · total ' + (t3 - t0) + ' ms');
  if (table) for (var m = 0; m < SLOTS; m++) if (!slots[m]) post('map spike: no "' + table[m] + '" in ' + current.cls + '\n');
}

function release(from) { for (var s = from; s < SLOTS; s++) outlet(0, s, 'id', 0); slots = []; }

/** Slot s to v (0–1): the parameter's range; a quantized one by steps. */
function setSlot(s, v) {
  var p = slots[s];
  if (!p) return;
  var x = p.min + Math.max(0, Math.min(1, v)) * (p.max - p.min);
  outlet(0, s, p.q ? Math.round(x) : x);
}

function anything() {
  var a = arrayfromargs(arguments);
  if (messagename === 'follow') { follow = a[0] ? 1 : 0; if (follow && ready && viewObs) { var id = ids(viewObs.get('selected_track'))[0]; if (id) target(id); } }
  else if (messagename === 'dial') setSlot(0, +a[0]);
  else if (messagename === 'sweep') { if (a[0]) sweeper.repeat(); else sweeper.cancel(); }
  else if (messagename === 'dump') dump();
}

var phase = 0;
var sweeper = new Task(function () {
  phase += 0.04;
  for (var s = 0; s < SLOTS; s++) setSlot(s, 0.5 + 0.4 * Math.sin(phase + s * 0.4));
}, this);
sweeper.interval = 25;

function dump() {
  post('map spike: ' + current.track + ' › ' + current.device + ' (' + current.cls + '), ' + current.params.length + ' parameters\n');
  for (var i = 0; i < current.params.length; i++) {
    var p = current.params[i];
    post('  ' + i + '  ' + p.name + (p.shown !== p.name ? '  [' + p.shown + ']' : '') + '  ' + p.min + '…' + p.max + (p.q ? '  (steps)' : '') + '\n');
  }
}
