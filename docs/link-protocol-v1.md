# SY.CORE Link — protocol v1

WebSocket between SY.CORE (browser, client) and the "SY.CORE Link" Max for Live device (Node for Max, server on `ws://127.0.0.1:9400`). Every message is one JSON object with `"v": 1` and a `type`. Unknown types are ignored; a message with another major `v` is answered with `error` (`code: "version"`).

Times:
- **beat** — Live song time in quarter notes (`current_song_time`), the same on both sides.
- **t** — the sender's own `performance.now()` in ms; only echoed back, never compared across processes.

## Handshake
| From | Message | Fields |
|---|---|---|
| client | `hello` | `client: "sycore"`, `app` (version string) |
| device | `hello` | `device: "sycore-link"`, `version`, `track` (Live track name, `""` if unknown), `sim` (true when no Live), `ports` (1.4+: true when it can play MIDI ports), `play` (1.5+: true when it takes `play`), `tempo` (1.6+: true when it takes `tempo`) |

The device sends its `hello` and a `transport` on connect, without waiting for the client's.

## Transport (device → client)
`transport`: `playing` (bool), `beat`, `tempo` (BPM), `num`, `den` (time signature).
Sent on every change of playing / tempo / signature, and every 50 ms while connected. The client interpolates the beat between reports: `beat + (now − arrival) × tempo / 60000` while playing.
`at` (bridge 1.3.4+): the device's clock (ms) when the report was made. With the offset between the two clocks (from the `pong`'s `nt`, on the ping with the shortest round trip), the client knows the report's age and corrects it — a report read late (the page busy for hundreds of ms, the reports queued) is not taken for a jump in Live's position.

## Play / Stop (client → device, 1.5+)
`play`: `on` (bool) — Live's transport started (`true`) or stopped (`false`): the device sets `live_set is_playing` ([live.object] in its patch). Sent by SY.CORE's Play button (Rig Controls, Performance) when the clock is Live's. The device's next `transport` reports the change.

## Tempo (client → device, 1.6+)
`tempo`: `bpm` (20–999) — sets Live's tempo (`live_set tempo`, the same [live.object]). Sent by SY.CORE's TAP, tempo − / + and tempo knob (Rig Controls) when the clock is Live's. The device's next `transport` reports the new tempo.

## MIDI (client → device)
`midi`: `data` (2–3 raw bytes of one channel message: note on/off, CC, pitch bend, program change, aftertouch), `beat` (when to play it; omitted = now).
- The client sends ahead (lookahead, as CLK SYS); the device plays it on Live's beat with Max's scheduler.
- A message later than 5 ms is played at once if it is a note-off or a CC; a late note-on is dropped (counted in `stats`).
- The device tracks sounding notes (per channel and pitch) so `clear` can end them.

`port` (bridge 1.4+, when the device's `hello` has `ports: true`): the name of a MIDI output port (e.g. `MIDIWIN (B)`, a Windows MIDI Services loopback to Emulator X3). The device sends the message to that port itself, at its Live beat, from a timed queue in its own process (Node, `@julusian/midi`) — instead of the device's track. Name match: exact, case-insensitive, else the first port containing it. A port not found is counted in `stats` (`portMissing`) and logged once in Max's console. Used by SY.CORE for the MIDI Flow cables marked "via SY.CORE Link": the browser's main thread no longer decides when they leave (it delayed them by 5–240 ms; Windows loopbacks ignore Web MIDI timestamps).

`ports` (client → device, 1.4+): the device answers `ports` with `names` (its MIDI output ports).

`clear` (client → device): drop every pending message and send a note-off for every note sounding now — on the device's track and on the ports. Sent by SY.CORE on stop, on panic and before closing.

The device also runs `clear` by itself when the last client disconnects.

## Health
| From | Message | Fields |
|---|---|---|
| client | `ping` | `t` |
| device | `pong` | `t` (echoed), `beat`, `nt` (the device's clock, ms; 1.3.4+) |
| device | `stats` | every second while MIDI arrives: `msgs`, `late`, `dropped`, `leadMinMs`, `leadAvgMs`; 1.4+: `portMsgs`, `portLate`, `portDropped`, `portMissing`, `portTimerMaxMs` (how late the timed queue sent, max) |
| device | `error` | `code` (`version`, `bad-message`), `message` |

## Rig Controller (SY.CORE Rig devices)
| From | Message | Fields |
|---|---|---|
| client | `rig` | `rows` (5: Chord, Drum, Seq, Bass, Arp — each `filled` bit mask of slots A–H, `playing`, `queued` slot 0–7 or -1, `muted`, `solo`), `section`, `queuedSection` (0–7 or -1), `chord` (`now`, `dur`, `next`, `nextDur`, `ms` the chord's length, `bars`, `seq` one per step: the chord sounding and the next one with their duration labels, or null); or `active: false` (no Rig Controller open) |
| device | `rig-press` | `name`: the rig action clicked on a SY.CORE Rig device (`rig_slot_<app>_<a–h>`, `rig_mute_<app>`, `rig_solo_<app>`, `rig_section_<1–8>`) |

SY.CORE sends `rig` when the Rig Controller's state changes (and after a `hello`); the bridge passes it to the Rig devices inside Max and repeats it every second, so a device added later shows it. With no client left, the devices get `active` 0.

## SY.CORE Map (P12: Live's instruments driven by table)
One **SY.CORE Map** device in the set drives the instrument of a track — the selected one (follow) or a chosen one — by table: slot *n* (an encoder in SY.CORE) → a parameter of the instrument, by `original_name`. A Rack with mapped Macros: slot *n* = Macro *n*.

| From | Type | Fields |
|---|---|---|
| client | `map-tables` | `tables`: `{ <class_name>: [16 slots] }` — a slot is `{ param, min?, max?, int? }` (`param` = the parameter's `original_name`, `min` / `max` in its own units, default its full range; `int` = whole numbers) or `null`; class names `[A-Za-z0-9_]` — for Max for Live devices and plugins (`MxDeviceInstrument`, `PluginDevice`, `AuPluginDevice`) `class:device name`, e.g. `MxDeviceInstrument:Cheese Grater` — at most 64 |
| client | `map` | `slot` (0–15), `value` (0–1, clamped): a slot moved |
| client | `map-target` | `follow: true`, or `track` (index from 0) |
| client | `map-params-request` | — (answered with `map-params`) |
| client | `map-variation` | `index` (0–127), or `step` (1 next, -1 previous, wrapping): recall a Macro Variation of the Rack in focus; or `action`: `store` (the Macros now, as a new variation) / `delete` (the selected one) |
| client | `map-randomize` | — : randomize the Rack's Macros |
| device | `map-info` | `track` (`index`, `name`), `device` (`name`, `cls` = class_name, `rack` or null), `mode` (`table`, `macros`, `mixed` = a Rack's configured Macros then the instrument's table, `auto` = no table: the instrument's first 16 parameters, `none`), `slots` (16: `{ param, name, value 0–1 }` or null), `variations` (`count`, `selected` -1 = none; null when no Rack) — on each change of target or variation |
| device | `map-value` | `slot`, `value` (0–1): a slot's parameter moved in Live (mouse, automation, preset) |
| device | `map-tracks` | `tracks`: `[{ index, name, instrument }]` (`instrument`: its first instrument's name, '' = none) |
| device | `map-params` | `cls`, `name`, `params`: `[{ name (original_name), shown, min, max, quantized }]` (at most 512) |

The bridge keeps the last `map-tables` and `map-target` for a Map device loaded later (it says `mapready`), and the last `map-info` and `map-tracks` for a client connecting later. Inside Max: bridge → `[s sycore_map]` (`map tables <json>`, `map value <slot> <v>`, `map target <follow|track>`, `map params`), device → `[s sycore_map_in]` (`mapready`, `mapinfo <json>`, `mapvalue <slot> <v>`, `maptracks <json>`, `mapparams <json>`). Bridge 1.2.0.

## Reconnection
The client retries with back-off (0.5 s → 5 s) while enabled. After a reconnect it waits for the device's `hello` + first `transport` before sending MIDI again.

## Not in v1
Several device instances (one per track, "SY.CORE · Track": step 3), Live API control (mixer, clips, scenes: step 4), SysEx.
