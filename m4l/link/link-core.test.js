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
  const st = s.takeStats();
  assert.equal(st.msgs, 1); assert.equal(st.leadMinMs, 100);
});

test('a late note-on is dropped, a late note-off goes out at once', () => {
  const s = new MidiScheduler(playingAt120());
  assert.equal(s.schedule({ data: [0x90, 60, 100], beat: 1 }, 600), null);
  assert.deepEqual(s.schedule({ data: [0x80, 60, 0], beat: 1 }, 600), { data: [0x80, 60, 0], delayMs: 0 });
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
  assert.deepEqual(s.schedule({ data: [0xb0, 7, 100] }, 0), { data: [0xb0, 7, 100], delayMs: 0 });
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

test('late position reports do not move the estimate back; an early one moves it forward', () => {
  const tr = playingAt120();
  tr.set({ playing: 1, beat: 1 - 0.04, tempo: 120 }, 500);   // 20 ms late
  assert.ok(Math.abs(tr.beatAt(500) - (1 - 0.04 * 0.05)) < 1e-9);
  tr.set({ playing: 1, beat: 2.02, tempo: 120 }, 1000);      // ahead: taken
  assert.equal(tr.beatAt(1000), 2.02);
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
