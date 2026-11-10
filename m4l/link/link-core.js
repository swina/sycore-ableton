/**
 * link-core.js — the pure part of the SY.CORE Link bridge (protocol v1, docs/link-protocol-v1.md):
 * Live's transport as last reported, the timing of incoming MIDI against it, and the notes
 * sounding (so `clear` can end them). No I/O: times are passed in (performance.now() ms).
 */
const PROTOCOL_VERSION = 1;
const LATE_TOLERANCE_MS = 5;

/** A position this far off the estimate is a jump (loop, relocation), not delivery jitter (beats). */
const JUMP_BEATS = 0.25;
/** Share of a report's error taken into the estimate: a report is never early (true when Live
 *  sent it, read later), so one ahead of the estimate counts a good part, one behind it barely. */
const GAIN_AHEAD = 0.3;
const GAIN_BEHIND = 0.02;

class Transport {
  constructor() { this.playing = false; this.beat = 0; this.tempo = 120; this.num = 4; this.den = 4; this.at = 0; this.resetJitter(); }

  resetJitter() { this.jitter = { maxLateMs: 0, n: 0 }; }

  /**
   * A report from Live. Returns true when playing, tempo or signature changed.
   * Live reports the position from its UI thread, each report some ms late by a varying
   * amount: while playing at a steady tempo the estimate follows the reports smoothed
   * (part of each error), a big difference is a jump and is taken at once. The note times
   * don't depend on it: Max places each note from its own [transport] (see sycore-link.js);
   * this estimate decides lateness and feeds the client's mirror.
   */
  set({ playing, beat, tempo, num, den }, now) {
    const p = !!playing;
    const t = Number(tempo) > 0 ? Number(tempo) : this.tempo;
    const n = Number(num) > 0 ? Number(num) | 0 : this.num;
    const d = Number(den) > 0 ? Number(den) | 0 : this.den;
    const changed = p !== this.playing || t !== this.tempo || n !== this.num || d !== this.den;
    const steady = p && this.playing && t === this.tempo;
    const hasBeat = beat !== undefined && Number.isFinite(Number(beat));
    const predicted = this.beatAt(now);
    this.playing = p; this.tempo = t; this.num = n; this.den = d;
    if (!hasBeat) {
      this.beat = predicted;
    } else if (!steady) {
      this.beat = Number(beat);
    } else {
      const err = Number(beat) - predicted;
      if (Math.abs(err) > JUMP_BEATS) this.beat = Number(beat);
      else {
        this.beat = predicted + err * (err > 0 ? GAIN_AHEAD : GAIN_BEHIND);
        this.jitter.n++;
        const offMs = (Math.abs(err) * 60000) / t;
        if (offMs > this.jitter.maxLateMs) this.jitter.maxLateMs = offMs;
      }
    }
    this.at = now;
    return changed;
  }

  beatAt(now) {
    return this.playing ? this.beat + ((now - this.at) * this.tempo) / 60000 : this.beat;
  }

  msPerBeat() { return 60000 / this.tempo; }

  snapshot(now) {
    return { type: 'transport', playing: this.playing, beat: this.beatAt(now), tempo: this.tempo, num: this.num, den: this.den };
  }
}

const isNoteOn = d => (d[0] & 0xf0) === 0x90 && (d[2] | 0) > 0;
const isNoteOff = d => (d[0] & 0xf0) === 0x80 || ((d[0] & 0xf0) === 0x90 && (d[2] | 0) === 0);

/** Valid channel message of 2–3 bytes (no SysEx, no real-time). */
function validMidi(data) {
  if (!Array.isArray(data) || data.length < 2 || data.length > 3) return false;
  if (!data.every(b => Number.isInteger(b) && b >= 0 && b <= 255)) return false;
  const status = data[0];
  if (status < 0x80 || status >= 0xf0) return false;
  for (let i = 1; i < data.length; i++) if (data[i] > 127) return false;
  const kind = status & 0xf0;
  const len = kind === 0xc0 || kind === 0xd0 ? 2 : 3;
  return data.length === len;
}

/**
 * Notes sounding, from the note-ons and note-offs handed to the scheduler with their
 * play time. `soundingAt(now)` = notes started and not yet ended at `now`.
 */
class NoteTracker {
  constructor() { this.notes = []; }
  key(d) { return ((d[0] & 0x0f) << 7) | d[1]; }

  record(data, at) {
    if (isNoteOn(data)) {
      this.notes.push({ key: this.key(data), ch: data[0] & 0x0f, pitch: data[1], on: at, off: Infinity });
    } else if (isNoteOff(data)) {
      const k = this.key(data);
      // The oldest open note of that key, started before this note-off.
      const n = this.notes.find(x => x.key === k && x.off === Infinity && x.on <= at);
      if (n) n.off = at;
    }
  }

  /** Notes sounding at `now` (started, not ended); forgets the ones already over. */
  soundingAt(now) {
    this.notes = this.notes.filter(n => n.off > now);
    return this.notes.filter(n => n.on <= now);
  }

  clear() { this.notes = []; }
}

/**
 * Timing of incoming MIDI against Live's transport, and the stats sent back every second.
 * `schedule(msg, now)` → { data, delayMs } to play, or null (dropped).
 */
class MidiScheduler {
  constructor(transport) {
    this.tr = transport;
    this.notes = new NoteTracker();
    this.resetStats();
  }

  resetStats() { this.st = { msgs: 0, late: 0, dropped: 0, leadMin: Infinity, leadSum: 0, leadN: 0 }; }

  schedule(msg, now) {
    const data = msg && msg.data;
    if (!validMidi(data)) { this.st.dropped++; return null; }
    let delayMs = 0;
    if (msg.beat !== undefined && msg.beat !== null) {
      const beat = Number(msg.beat);
      if (!Number.isFinite(beat)) { this.st.dropped++; return null; }
      if (!this.tr.playing) {
        // Stopped: nothing to place it on. Note-offs and CCs still go out (no hanging notes).
        if (isNoteOn(data)) { this.st.dropped++; return null; }
      } else {
        const lead = (beat - this.tr.beatAt(now)) * this.tr.msPerBeat();
        if (lead < -LATE_TOLERANCE_MS) {
          this.st.late++;
          if (isNoteOn(data)) { this.st.dropped++; return null; }
        } else {
          this.st.leadN++; this.st.leadSum += lead;
          if (lead < this.st.leadMin) this.st.leadMin = lead;
        }
        delayMs = Math.max(0, lead);
      }
    }
    this.st.msgs++;
    this.notes.record(data, now + delayMs);
    // Max places it on its beat; a late or beat-less message goes out now.
    const playBeat = delayMs > 0 ? Number(msg.beat) : null;
    return { data: data.slice(), delayMs, beat: playBeat };
  }

  /** Note-offs for the notes sounding now (pending messages are dropped by the caller). */
  clear(now) {
    const offs = this.notes.soundingAt(now).map(n => [0x80 | n.ch, n.pitch, 0]);
    this.notes.clear();
    return offs;
  }

  /** Stats message for the last period, or null if nothing arrived. Resets the counters. */
  takeStats() {
    const s = this.st;
    if (!s.msgs && !s.late && !s.dropped) return null;
    this.resetStats();
    const j = this.tr.jitter; this.tr.resetJitter();
    return {
      type: 'stats', msgs: s.msgs, late: s.late, dropped: s.dropped,
      // How far Live's position reports were from the estimate (ms, max over the period): their delivery jitter.
      reportJitterMs: j.n ? Math.round(j.maxLateMs * 10) / 10 : null,
      leadMinMs: s.leadN ? Math.round(s.leadMin * 10) / 10 : null,
      leadAvgMs: s.leadN ? Math.round((s.leadSum / s.leadN) * 10) / 10 : null,
    };
  }
}

/** Device status line: clients connected, or what it waits for. */
function infoText({ clients = 0, port, error = null, track = '' }) {
  if (error) return error;
  const where = track ? ` · track ${track}` : '';
  if (!clients) return `waiting for SY.CORE · port ${port}`;
  return `${clients === 1 ? 'SY.CORE connected' : `${clients} SY.CORE clients`}${where}`;
}

/** Device status LED: 0 waiting for SY.CORE, 1 connected, 2 error (port in use…). */
function infoState({ clients = 0, error = null }) {
  return error ? 2 : clients ? 1 : 0;
}

/** Device stats line from a `stats` message (null: nothing arrived in the last second). */
function statsText(s) {
  if (!s) return 'idle';
  const lead = s.leadMinMs === null ? '' : ` · lead ${Math.round(s.leadMinMs)} ms`;
  return `${s.msgs} msgs/s · ${s.late} late · ${s.dropped} dropped${lead}`;
}

/** Parse one incoming text frame: { msg } or { error } (to send back), or {} to ignore. */
function parseMessage(text) {
  let m;
  try { m = JSON.parse(String(text)); } catch { return { error: { code: 'bad-message', message: 'not JSON' } }; }
  if (!m || typeof m !== 'object' || typeof m.type !== 'string') return { error: { code: 'bad-message', message: 'no type' } };
  if (m.v !== undefined && Math.floor(Number(m.v)) !== PROTOCOL_VERSION) {
    return { error: { code: 'version', message: `protocol v${PROTOCOL_VERSION} only` } };
  }
  return { msg: m };
}

// ── Rig Controller (SY.CORE Rig devices) ────────────────────────────────────
const RIG_ROWS = 5;
const int = (v, lo, hi, def) => { const n = Math.round(Number(v)); return Number.isFinite(n) && n >= lo && n <= hi ? n : def; };
/**
 * A 'rig' message from SY.CORE: `active` false → null (no Rig Controller open); else
 * { rows: 5 × { filled (bit mask of slots A–H), playing, queued (slot 0–7, -1 none), muted, solo (0/1) },
 *   gen (Generates done on the row, a counter), section, queuedSection (0–7, -1 none), fill (0/1: the Drum Machine's Fill is on) }. Undefined when it is not one.
 */
function parseRig(m) {
  if (!m || m.type !== 'rig') return undefined;
  if (m.active === false) return null;
  if (!Array.isArray(m.rows)) return undefined;
  const rows = Array.from({ length: RIG_ROWS }, (_, i) => {
    const r = m.rows[i] || {};
    return { filled: int(r.filled, 0, 255, 0), playing: int(r.playing, -1, 7, -1), queued: int(r.queued, -1, 7, -1), muted: r.muted ? 1 : 0, solo: r.solo ? 1 : 0, gen: int(r.gen, 0, 2147483647, 0) };
  });
  return { rows, section: int(m.section, -1, 7, -1), queuedSection: int(m.queuedSection, -1, 7, -1), fill: m.fill ? 1 : 0, chord: rigChord(m.chord) };
}
/** The chord sounding and the next one, as Max symbols: no spaces, '-' for none (an empty symbol
 *  would be lost in a Max message), at most 12 characters. */
const sym = v => (String(v == null ? '' : v).replace(/\s+/g, '').slice(0, 12) || '-');
function rigChord(c) {
  if (!c || typeof c !== 'object') return null;
  return {
    now: sym(c.now), dur: sym(c.dur), next: sym(c.next), nextDur: sym(c.nextDur),
    ms: int(c.ms, 0, 600000, 0), bars: Math.max(0, Math.min(64, Number(c.bars) || 0)), seq: int(c.seq, 0, 2147483647, 0),
  };
}
/** A rig action a Rig device may send (rig-actions.ts in SY.CORE): slots, mute, solo, GEN, sections, Fill. */
const rigName = n => /^rig_(slot_(chord|drum|seq|bass|arp)_[a-h]|(mute|solo|gen)_(chord|drum|seq|bass|arp)|section_[1-8]|fill)$/.test(String(n));


// ── SY.CORE Map (P12): Live's instruments driven by table ──────────────────
// SY.CORE → bridge: `map-tables` (the tables by Live class_name), `map` (a slot moved),
// `map-target` (follow the selected track, or one track), `map-params-request` (the full list).
// The map device (Max [js]) → bridge → SY.CORE: `map-info`, `map-value`, `map-tracks`, `map-params`.
const MAP_SLOTS = 16;
const MAP_CLASSES = 64;
const MAP_PARAMS = 512;
const text = (v, n = 64) => String(v == null ? '' : v).slice(0, n);
const finite = v => (v !== null && v !== '' && Number.isFinite(Number(v)) ? Number(v) : undefined);
const clamp01 = v => Math.max(0, Math.min(1, Number(v) || 0));
const CLASS_RE = /^[A-Za-z0-9_]{1,64}$/;

/** A table slot: { param (original_name), min?, max? (the parameter's units), int? } or null (empty). */
function mapSlot(x) {
  if (!x || typeof x !== 'object' || !x.param) return null;
  const r = { param: text(x.param) };
  const lo = finite(x.min), hi = finite(x.max);
  if (lo !== undefined) r.min = lo;
  if (hi !== undefined) r.max = hi;
  if (x.int) r.int = 1;
  return r;
}
/** `map-tables` → { <class_name>: [16 slots] } (unknown class names dropped); undefined if not one. */
function parseMapTables(m) {
  if (!m || m.type !== 'map-tables' || !m.tables || typeof m.tables !== 'object') return undefined;
  const out = {};
  for (const cls of Object.keys(m.tables).slice(0, MAP_CLASSES)) {
    const t = m.tables[cls];
    if (!CLASS_RE.test(cls) || !Array.isArray(t)) continue;
    out[cls] = Array.from({ length: MAP_SLOTS }, (_, i) => mapSlot(t[i]));
  }
  return out;
}
/** `map` → { slot 0–15, value 0–1 }; undefined if not one. */
function parseMap(m) {
  if (!m || m.type !== 'map') return undefined;
  const slot = int(m.slot, 0, MAP_SLOTS - 1, -1);
  if (slot < 0 || finite(m.value) === undefined) return undefined;
  return { slot, value: clamp01(m.value) };
}
/** `map-target` → 'follow' or a track index (0–999); undefined if not one. */
function parseMapTarget(m) {
  if (!m || m.type !== 'map-target') return undefined;
  if (m.follow) return 'follow';
  const t = int(m.track, 0, 999, -1);
  return t < 0 ? undefined : t;
}

/** JSON text from the map device ([js] → node), or null. */
function json(t) { try { const o = JSON.parse(Array.isArray(t) ? t.join(' ') : String(t)); return o && typeof o === 'object' ? o : null; } catch { return null; } }
/** The map device's `mapinfo <json>` → the `map-info` message for SY.CORE (clamped), or null. */
function mapInfoFromDevice(t) {
  const o = json(t);
  if (!o) return null;
  const tr = o.track && typeof o.track === 'object' ? { index: int(o.track.index, -1, 999, -1), name: text(o.track.name, 128) } : null;
  const dv = o.device && typeof o.device === 'object'
    ? { name: text(o.device.name, 128), cls: text(o.device.cls), rack: o.device.rack ? text(o.device.rack, 128) : null } : null;
  const mode = ['table', 'macros', 'none'].includes(o.mode) ? o.mode : 'none';
  const slots = Array.from({ length: MAP_SLOTS }, (_, i) => {
    const x = Array.isArray(o.slots) ? o.slots[i] : null;
    return x && typeof x === 'object' ? { param: text(x.param), name: text(x.name || x.param), value: clamp01(x.value) } : null;
  });
  return { type: 'map-info', track: tr, device: dv, mode, slots };
}
/** `mapvalue <slot> <0–1>` → `map-value`, or null. */
function mapValueFromDevice(slot, value) {
  const s = int(slot, 0, MAP_SLOTS - 1, -1);
  return s < 0 || finite(value) === undefined ? null : { type: 'map-value', slot: s, value: clamp01(value) };
}
/** `maptracks <json [{ index, name }]>` → `map-tracks`, or null. */
function mapTracksFromDevice(t) {
  const o = json(t);
  if (!Array.isArray(o)) return null;
  return { type: 'map-tracks', tracks: o.slice(0, 1000).map(x => ({ index: int(x && x.index, 0, 999, 0), name: text(x && x.name, 128) })) };
}
/** `mapparams <json { cls, name, params: [{ name, shown, min, max, q }] }>` → `map-params`, or null. */
function mapParamsFromDevice(t) {
  const o = json(t);
  if (!o || !Array.isArray(o.params)) return null;
  return {
    type: 'map-params', cls: text(o.cls), name: text(o.name, 128),
    params: o.params.slice(0, MAP_PARAMS).map(x => ({
      name: text(x && x.name), shown: text(x && (x.shown || x.name)),
      min: finite(x && x.min) ?? 0, max: finite(x && x.max) ?? 1, quantized: x && x.q ? 1 : 0,
    })),
  };
}

module.exports = { MAP_SLOTS, parseMapTables, parseMap, parseMapTarget, mapInfoFromDevice, mapValueFromDevice, mapTracksFromDevice, mapParamsFromDevice, parseRig, rigName, PROTOCOL_VERSION, infoText, infoState, statsText, LATE_TOLERANCE_MS, Transport, NoteTracker, MidiScheduler, validMidi, parseMessage, isNoteOn, isNoteOff };
