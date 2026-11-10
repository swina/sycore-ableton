// node --test — unit tests of the bridge's pure part (protocol v1).
const test = require('node:test');
const assert = require('node:assert/strict');
const { Transport, MidiScheduler, NoteTracker, validMidi, parseMessage } = require('./link-core');

const playingAt120 = () => { const tr = new Transport(); tr.set({ playing: 1, beat: 0, tempo: 120, num: 4, den: 4 }, 0); return tr; };

test('transport interpolates the beat while playing, holds it when stopped', () => {
  const tr = playingAt120();
  assert.equal(tr.beatAt(500), 1); // 120 BPM: 500 ms = 1 beat
  tr.set({ playing: 0, beat: 2 }, 1000);
  assert.equal(tr.beatAt(5000), 2);
});

test('transport reports a change only for playing / tempo / signature', () => {
  const tr = playingAt120();
  assert.equal(tr.set({ playing: 1, beat: 1, tempo: 120 }, 500), false);
  assert.equal(tr.set({ playing: 1, beat: 2, tempo: 90 }, 1000), true);
  assert.equal(tr.set({ playing: 1, tempo: 90, num: 3, den: 4 }, 1100), true);
});

test('a note ahead of its beat is delayed by the lead', () => {
  const s = new MidiScheduler(playingAt120());
  const r = s.schedule({ data: [0x90, 60, 100], beat: 1 }, 400); // beat 1 = 500 ms
  assert.deepEqual(r.data, [0x90, 60, 100]);
  assert.ok(Math.abs(r.delayMs - 100) < 1e-6);
  assert.equal(r.beat, 1); // Max places it on beat 1
  const st = s.takeStats();
  assert.equal(st.msgs, 1); assert.equal(st.leadMinMs, 100);
});

test('a late note-on is dropped, a late note-off goes out at once', () => {
  const s = new MidiScheduler(playingAt120());
  assert.equal(s.schedule({ data: [0x90, 60, 100], beat: 1 }, 600), null);
  assert.deepEqual(s.schedule({ data: [0x80, 60, 0], beat: 1 }, 600), { data: [0x80, 60, 0], delayMs: 0, beat: null });
  const st = s.takeStats();
  assert.equal(st.late, 2); assert.equal(st.dropped, 1);
});

test('within 5 ms late still plays (no drop)', () => {
  const s = new MidiScheduler(playingAt120());
  assert.ok(s.schedule({ data: [0x90, 60, 100], beat: 1 }, 504));
});

test('no beat = now; stopped transport drops note-ons, passes note-offs and CCs', () => {
  const tr = new Transport();
  const s = new MidiScheduler(tr);
  assert.deepEqual(s.schedule({ data: [0xb0, 7, 100] }, 0), { data: [0xb0, 7, 100], delayMs: 0, beat: null });
  assert.equal(s.schedule({ data: [0x90, 60, 100], beat: 4 }, 0), null);
  assert.ok(s.schedule({ data: [0x80, 60, 0], beat: 4 }, 0));
});

test('clear ends the notes sounding now, not the ones still to come or already over', () => {
  const s = new MidiScheduler(playingAt120());
  s.schedule({ data: [0x90, 60, 100], beat: 0.2 }, 0);  // on at 100 ms
  s.schedule({ data: [0x80, 60, 0], beat: 0.4 }, 0);    // off at 200
  s.schedule({ data: [0x91, 64, 100], beat: 0.5 }, 0);  // ch 2, on at 250, no off yet
  s.schedule({ data: [0x90, 67, 100], beat: 2 }, 0);    // on at 1000 (future)
  assert.deepEqual(s.clear(300), [[0x81, 64, 0]]);
  assert.deepEqual(s.clear(2000), []); // tracker emptied
});

test('note-on with velocity 0 counts as a note-off', () => {
  const n = new NoteTracker();
  n.record([0x90, 60, 100], 0); n.record([0x90, 60, 0], 10);
  assert.equal(n.soundingAt(20).length, 0);
});

test('validMidi: channel messages only, right length', () => {
  assert.ok(validMidi([0x90, 60, 100]));
  assert.ok(validMidi([0xc0, 5]));
  assert.ok(!validMidi([0xc0, 5, 0]));
  assert.ok(!validMidi([0xf8]));
  assert.ok(!validMidi([0xf0, 1, 2]));
  assert.ok(!validMidi([0x90, 200, 1]));
  assert.ok(!validMidi('x'));
});

test('parseMessage: JSON, type, version', () => {
  assert.equal(parseMessage('{"v":1,"type":"ping","t":1}').msg.type, 'ping');
  assert.equal(parseMessage('nope').error.code, 'bad-message');
  assert.equal(parseMessage('{"v":2,"type":"ping"}').error.code, 'version');
  assert.equal(parseMessage('{"v":1}').error.code, 'bad-message');
});

test('position reports are smoothed: one read 20 ms late barely moves the estimate, one ahead counts more', () => {
  const tr = playingAt120();
  tr.set({ playing: 1, beat: 1 - 0.04, tempo: 120 }, 500);
  assert.ok(Math.abs(tr.beatAt(500) - (1 - 0.04 * 0.02)) < 1e-9);
  const tr2 = playingAt120();
  tr2.set({ playing: 1, beat: 1 + 0.04, tempo: 120 }, 500);
  assert.ok(Math.abs(tr2.beatAt(500) - (1 + 0.04 * 0.3)) < 1e-9);
});

test('a jump in position is taken at once', () => {
  const tr = playingAt120();
  tr.set({ playing: 1, beat: 0, tempo: 120 }, 2000); // loop back from beat 4
  assert.equal(tr.beatAt(2000), 0);
});

test('stats report the transport jitter', () => {
  const tr = playingAt120();
  const s = new MidiScheduler(tr);
  tr.set({ playing: 1, beat: 1 - 0.06, tempo: 120 }, 500); // 30 ms late
  s.schedule({ data: [0xb0, 7, 1] }, 500);
  assert.equal(s.takeStats().reportJitterMs, 30);
});

test('device status lines', () => {
  const { infoText, statsText } = require('./link-core');
  assert.equal(infoText({ clients: 0, port: 9400 }), 'waiting for SY.CORE · port 9400');
  assert.equal(infoText({ clients: 1, port: 9400, track: 'Drums' }), 'SY.CORE connected · track Drums');
  assert.equal(infoText({ clients: 2, port: 9400, error: 'port 9400 in use' }), 'port 9400 in use');
  const { infoState } = require('./link-core');
  assert.equal(infoState({ clients: 0 }), 0);
  assert.equal(infoState({ clients: 1 }), 1);
  assert.equal(infoState({ clients: 1, error: 'port 9400 in use' }), 2);
  assert.equal(statsText(null), 'idle');
  assert.equal(statsText({ msgs: 16, late: 0, dropped: 1, leadMinMs: 73.4 }), '16 msgs/s · 0 late · 1 dropped · lead 73 ms');
  assert.equal(statsText({ msgs: 2, late: 0, dropped: 0, leadMinMs: null }), '2 msgs/s · 0 late · 0 dropped');
});

test('rig: SY.CORE\'s Rig state for the Rig devices, clamped; active false = none', () => {
  const { parseRig, rigName } = require('./link-core');
  assert.equal(parseRig({ type: 'midi' }), undefined);
  assert.equal(parseRig({ type: 'rig', active: false }), null);
  const r = parseRig({ type: 'rig', rows: [{ filled: 5, playing: 2, queued: 9, muted: true }], section: 3 });
  assert.deepEqual(r.rows[0], { filled: 5, playing: 2, queued: -1, muted: 1, solo: 0, gen: 0 });
  assert.equal(r.rows.length, 5);
  assert.deepEqual(r.rows[4], { filled: 0, playing: -1, queued: -1, muted: 0, solo: 0, gen: 0 });
  assert.equal(r.section, 3);
  assert.equal(r.queuedSection, -1);
  assert.equal(r.chord, null);
  const c = parseRig({ type: 'rig', rows: [], chord: { now: 'C maj7', dur: '1/1', next: '', nextDur: '' } }).chord;
  assert.deepEqual(c, { now: 'Cmaj7', dur: '1/1', next: '-', nextDur: '-', ms: 0, bars: 0, seq: 0 });
  assert.deepEqual(parseRig({ type: 'rig', rows: [], chord: { now: 'C', ms: 2000, bars: 1, seq: 4 } }).chord.ms, 2000);
  assert.ok(rigName('rig_slot_bass_h') && rigName('rig_mute_arp') && rigName('rig_section_8'));
  assert.ok(rigName('rig_gen_seq') && rigName('rig_fill'));
  assert.ok(!rigName('rig_global') && !rigName('dm_fill') && !rigName('rig_slot_drum_i') && !rigName('rig_gen_x'));
  assert.equal(parseRig({ type: 'rig', rows: [], fill: true }).fill, 1);
  assert.equal(parseRig({ type: 'rig', rows: [] }).fill, 0);
  assert.equal(parseRig({ type: 'rig', rows: [{ gen: 3 }] }).rows[0].gen, 3);
  assert.equal(parseRig({ type: 'rig', rows: [{}] }).rows[0].gen, 0);
});

test('map: tables by class_name, slots clamped to 16, bad classes and slots dropped', () => {
  const { parseMapTables } = require('./link-core');
  assert.equal(parseMapTables({ type: 'map' }), undefined);
  const t = parseMapTables({ type: 'map-tables', tables: {
    Drift: [{ param: 'LP Freq' }, { param: 'Volume', min: 0, max: '0.8' }, null, { param: 'Osc 1 Oct', int: true }, {}],
    'bad name!': [{ param: 'x' }],
    Simpler: 'nope',
  } });
  assert.deepEqual(Object.keys(t), ['Drift']);
  assert.equal(t.Drift.length, 16);
  assert.deepEqual(t.Drift.slice(0, 5), [{ param: 'LP Freq' }, { param: 'Volume', min: 0, max: 0.8 }, null, { param: 'Osc 1 Oct', int: 1 }, null]);
});

test('map: slot value 0–1 and the target', () => {
  const { parseMap, parseMapTarget } = require('./link-core');
  assert.deepEqual(parseMap({ type: 'map', slot: 3, value: 0.25 }), { slot: 3, value: 0.25 });
  assert.deepEqual(parseMap({ type: 'map', slot: 0, value: 7 }), { slot: 0, value: 1 });
  assert.equal(parseMap({ type: 'map', slot: 16, value: 0.5 }), undefined);
  assert.equal(parseMap({ type: 'map', slot: 1 }), undefined);
  assert.equal(parseMapTarget({ type: 'map-target', follow: true }), 'follow');
  assert.equal(parseMapTarget({ type: 'map-target', track: 4 }), 4);
  assert.equal(parseMapTarget({ type: 'map-target', track: -1 }), undefined);
});

test('map: the device\'s info, values, tracks and parameters for SY.CORE', () => {
  const { mapInfoFromDevice, mapValueFromDevice, mapTracksFromDevice, mapParamsFromDevice } = require('./link-core');
  const info = mapInfoFromDevice(JSON.stringify({
    track: { index: 3, name: '4-Hera Pad' }, device: { name: 'Drift', cls: 'Drift', rack: 'Hera Pad' }, mode: 'table',
    slots: [{ param: 'LP Freq', value: 0.4 }, null, { param: 'Macro 1', name: 'Filter Cutoff', value: 2 }],
  }));
  assert.equal(info.type, 'map-info');
  assert.deepEqual(info.track, { index: 3, name: '4-Hera Pad' });
  assert.deepEqual(info.device, { name: 'Drift', cls: 'Drift', rack: 'Hera Pad' });
  assert.equal(info.slots.length, 16);
  assert.deepEqual(info.slots[0], { param: 'LP Freq', name: 'LP Freq', value: 0.4 });
  assert.equal(info.slots[1], null);
  assert.deepEqual(info.slots[2], { param: 'Macro 1', name: 'Filter Cutoff', value: 1 });
  assert.equal(mapInfoFromDevice('{"mode":"mixed"}').mode, 'mixed');
  assert.equal(mapInfoFromDevice('not json'), null);
  // a JSON symbol split in words by Max: joined again
  assert.equal(mapInfoFromDevice(['{"mode":"none",', '"track":null}']).mode, 'none');
  assert.deepEqual(mapValueFromDevice(2, 0.5), { type: 'map-value', slot: 2, value: 0.5 });
  assert.equal(mapValueFromDevice(20, 0.5), null);
  assert.deepEqual(mapTracksFromDevice('[{"index":0,"name":"1-Drums"}]'), { type: 'map-tracks', tracks: [{ index: 0, name: '1-Drums' }] });
  const p = mapParamsFromDevice(JSON.stringify({ cls: 'OriginalSimpler', name: 'Bass', params: [{ name: 'Volume', min: -36, max: 36 }, { name: 'F On', q: 1 }] }));
  assert.deepEqual(p.params, [{ name: 'Volume', shown: 'Volume', min: -36, max: 36, quantized: 0 }, { name: 'F On', shown: 'F On', min: 0, max: 1, quantized: 1 }]);
});
