# SY.CORE Link — protocol v1

WebSocket between SY.CORE (browser, client) and the "SY.CORE Link" Max for Live device (Node for Max, server on `ws://127.0.0.1:9400`). Every message is one JSON object with `"v": 1` and a `type`. Unknown types are ignored; a message with another major `v` is answered with `error` (`code: "version"`).

Times:
- **beat** — Live song time in quarter notes (`current_song_time`), the same on both sides.
- **t** — the sender's own `performance.now()` in ms; only echoed back, never compared across processes.

## Handshake
| From | Message | Fields |
|---|---|---|
| client | `hello` | `client: "sycore"`, `app` (version string) |
| device | `hello` | `device: "sycore-link"`, `version`, `track` (Live track name, `""` if unknown), `sim` (true when no Live) |

The device sends its `hello` and a `transport` on connect, without waiting for the client's.

## Transport (device → client)
`transport`: `playing` (bool), `beat`, `tempo` (BPM), `num`, `den` (time signature).
Sent on every change of playing / tempo / signature, and every 50 ms while connected. The client interpolates the beat between reports: `beat + (now − arrival) × tempo / 60000` while playing.

## MIDI (client → device)
`midi`: `data` (2–3 raw bytes of one channel message: note on/off, CC, pitch bend, program change, aftertouch), `beat` (when to play it; omitted = now).
- The client sends ahead (lookahead, as CLK SYS); the device plays it on Live's beat with Max's scheduler.
- A message later than 5 ms is played at once if it is a note-off or a CC; a late note-on is dropped (counted in `stats`).
- The device tracks sounding notes (per channel and pitch) so `clear` can end them.

`clear` (client → device): drop every pending message and send a note-off for every note sounding now. Sent by SY.CORE on stop, on panic and before closing.

The device also runs `clear` by itself when the last client disconnects.

## Health
| From | Message | Fields |
|---|---|---|
| client | `ping` | `t` |
| device | `pong` | `t` (echoed), `beat` |
| device | `stats` | every second while MIDI arrives: `msgs`, `late`, `dropped`, `leadMinMs`, `leadAvgMs` |
| device | `error` | `code` (`version`, `bad-message`), `message` |

## Rig Controller (SY.CORE Rig devices)
| From | Message | Fields |
|---|---|---|
| client | `rig` | `rows` (5: Chord, Drum, Seq, Bass, Arp — each `filled` bit mask of slots A–H, `playing`, `queued` slot 0–7 or -1, `muted`, `solo`), `section`, `queuedSection` (0–7 or -1), `chord` (`now`, `dur`, `next`, `nextDur`: the chord sounding and the next one with their duration labels, or null); or `active: false` (no Rig Controller open) |
| device | `rig-press` | `name`: the rig action clicked on a SY.CORE Rig device (`rig_slot_<app>_<a–h>`, `rig_mute_<app>`, `rig_solo_<app>`, `rig_section_<1–8>`) |

SY.CORE sends `rig` when the Rig Controller's state changes (and after a `hello`); the bridge passes it to the Rig devices inside Max and repeats it every second, so a device added later shows it. With no client left, the devices get `active` 0.

## Reconnection
The client retries with back-off (0.5 s → 5 s) while enabled. After a reconnect it waits for the device's `hello` + first `transport` before sending MIDI again.

## Not in v1
Several device instances (one per track, "SY.CORE · Track": step 3), Live API control (mixer, clips, scenes: step 4), SysEx.
