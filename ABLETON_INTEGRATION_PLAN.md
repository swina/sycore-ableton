# SY.CORE × Ableton Live — Integration Plan

*Rev. 6 · 2026-11-06 · Reference repository: `D:\personal\apps\sycore-refactor` (branch `feat/rig-controller-ui`, merge `8cf2a2d`; P1 done, including the Worker scheduler, see §4)*
*This plan lives outside the repository. Any external tools (bridge, Max for Live device, template) go in `D:\personal\apps\sycore-ableton\`. Italian version: `PIANO_INTEGRAZIONE_ABLETON.md`.*

---

## 1. Goal

Ableton Live stays the DAW: arrangement, recording, mixing, Session View. **SY.CORE becomes the MIDI brain of the rig.**

1. **Routing hub.** All MIDI between Live and the instruments, hardware and software, goes through SY.CORE's MIDI Flow: splits, filters, multi-channel fanout, Note Latch, Program Change with each device's banks. Live needs no third-party VST plugins: MIDI tracks and Live's native **External Instrument** device are enough. Live's own instruments (Wavetable, Drift, Operator, Simpler, Drum Rack…) stay usable, from SY.CORE's apps too (§10.4).
2. **SY.CORE's MIDI apps as generative instruments inside Live.** Chord Sequencer, Drum Machine (with Bass Line), Sequencer and Arpeggiator play in time with Live, are controlled by Live's clips and scenes, and send their output back to Live for recording.
3. **Built-in and AI generation** (Song Composer, AI grooves, styles, Euclidean) used *live and in the context of the rig*, not as a generator of files to drag around.
4. **Go beyond the limits of MIDI generators such as MIDI Agent** (see §7).

### 1.1 Why: Live's real limits today (live sets, jams, studio recording)

In short: Live's audio engine, Session View and recording work very well. The real limits are in the **MIDI layer of the rig**: routing, the state of hardware synths, sync, real-time generation, and resilience when something goes wrong.

**1. The computer is the single point of failure**
- Plugins are not sandboxed: they all run inside Live's process, so if one VST crashes the whole set goes down (Bitwig, by contrast, sandboxes them).
- CPU and buffer size are a trade-off: playing needs a low buffer, a heavy set needs a high one. Plugin delay compensation adds latency to whatever is played live.
- Licenses and portable sets: an iLok-authorized plugin that fails to activate, or is missing on another machine, opens the set with holes in it.

**2. MIDI routing is "one track, one input"**
- Each track listens to one port and one channel (or "All"). There is no routing matrix; splits, layers and fanout to several synths only come through workarounds (several armed tracks, Instrument Racks with key zones, Max for Live).
- During a jam, changing which keyboard plays which synth means re-arming tracks and changing inputs, at the worst possible moment.
- MIDI can be routed between tracks, but it is clumsy and allows no transformations without Max for Live.

**3. Hardware synths really are "external"**
- Live does not save the state of hardware sounds: reopen a set after three months and the synths will not come back to the sounds you had.
- Program Changes are just numbers (Bank, Sub-Bank, Program 1–128 in the clip properties), with no patch names and no per-device banks.
- No native SysEx: Live neither sends nor records SysEx without Max for Live, so no patch dumps and no deep parameters.
- External Instrument works well, but it takes one track per synth and one per multitimbral channel.

**4. Sync**
- Live following an external clock is notoriously unstable: tempo wobbles and starting in phase is hard. That is why Live is always the master in this plan.
- Clock out to several devices needs the sync delay tuned port by port. On Windows, MIDI ports are not multi-client, so two programs on the same port conflict.

**5. Generation and improvisation**
- Live 12's MIDI Generators and Transformations work on clips at edit time, not in real time while the song plays.
- Patterns that change live, real-time generation or AI need Max for Live or third-party plugins, such as AI generator plugins like MIDI Agent, which produce clips to drag around.
- Capture MIDI recovers MIDI played without pressing Record; there is no audio equivalent, so if you were not recording, that take is lost.

**6. Recording a multi-instrument jam**
- Tracks, inputs, arming and monitoring must be prepared in advance for every source: an "always ready to record everything" setup has to be built by hand.
- Recording hardware sequencers depends on the clock and on the latency of the MIDI round trip, with no simple way to measure it.

**What SY.CORE covers and what it doesn't**

| Live's limit | SY.CORE |
|---|---|
| Single-input routing, clumsy splits and fanout | ✅ MIDI Flow: matrix, splits, filters, fanout, Note Latch |
| No recall of synth sounds, numeric-only PCs | ✅ Sound Engine (S-1 via CC), Multi Sound banks with patch names, per-device PC rules (P2) |
| SysEx | ✅ Web MIDI with SysEx (parsers and import already exist) |
| Plugins inside Live's process | ✅ with hardware or standalone synths, Live loads no VSTs |
| Generation only at edit time | ✅ apps that generate and switch slots during playback, built-in or AI (P3, P5) |
| Live following an external clock is unstable | ✅ avoided: Live is master, SY.CORE follows (P1) |
| Changing who plays what during a jam | ✅ recallable Flow configurations, and later from MIDI Actions |
| MIDI round-trip latency can't be measured | ✅ loopback ping and per-port offset (P4, P6) |
| Audio, mixing, lost audio takes | ❌ remains Live's and the audio interface's job |
| The computer as single point of failure | ⚠️ the browser becomes another link in the chain: it must be made robust (scheduler in a Worker, dedicated window, loop detection) |

**In short:** Live is excellent for recording, arranging and mixing, but weak as the control center of a hardware and software rig. That is the space SY.CORE fills, without asking Live to become something else.

## 2. Topology

```
                 ┌──────────────────────────── Ableton Live (clock master) ─────────────────────────────┐
                 │ MIDI tracks / External Instrument     Scenes / control clips      Recording tracks    │
                 └──────┬───────────────────────────────────────┬──────────────────────────▲─────────────┘
                        │ SYC IN (16 channels: notes, CC, PC)    │ SYC CTRL (clock + actions)│ SYC OUT (app output)
                        ▼                                        ▼                           │
 ┌─────────────────────────────────────────── SY.CORE — MIDI Flow ─────────────────────────────┴──────────────┐
 │  "Ableton Live" node (port × channel)  ──►  splits / filters / fanout / Note Latch                        │
 │        │                                       │                     │                                    │
 │        ├─► apps: Chord Seq · Drum Machine · Sequencer · Arp · Sampler ┼─► fanout ─► SYC OUT (to Live)      │
 │        └────────────────────────────────────────────────────────────►├─► hardware synths (USB / DIN)      │
 │                                                                      └─► software synths (standalone,     │
 │                                                                          via virtual cable)               │
 └───────────────────────────────────────────────────────────────────────────────────────────────────────────┘
   Audio: hardware → audio interface → External Instrument audio return in Live
```

**Golden rule: SY.CORE owns the hardware ports, Live only sees virtual ports.**
- On Windows, classic MIDI drivers are not multi-client: if Live and Chrome open the same USB port, one of them fails. Hardware ports are therefore disabled in Live, so there are no conflicts and no double paths.
- Virtual ports (loopMIDI, or Windows MIDI Services loopbacks; IAC on macOS):

| Port | Direction | Use |
|---|---|---|
| `SYC IN` | Live → SY.CORE | Up to 16 channels (requirement: 16 parts max) of notes, CC and PC from Live's tracks |
| `SYC CTRL` | Live → SY.CORE | Clock, Start/Stop, SPP, and control notes or CCs for the apps. **This port is never forwarded to devices** |
| `SYC OUT` | SY.CORE → Live | App output for recording in Live (Track ON, Sync and Remote OFF to avoid loops) |

## 3. What exists and what is missing

| Requirement | Status | Reference |
|---|---|---|
| Device ↔ app routing, note splits, channel filter, multi-channel fanout | ✅ | MIDI Flow (`MidiWizardFlow.vue`, `core/midi/midi-routing.ts`) |
| Apps with MIDI IN: Chord Seq, Sequencer, Drum Machine, Arp, Sampler, Note Latch | ✅ | `src/lib/midi-apps.js` |
| Virtual ports and Virtual Instruments bound to a real port | ✅ | `core/midi/midi-service.ts` |
| Feedback-loop protection on virtual ports | ✅ (partial) | `midi-service.ts:259` |
| MIDI Actions (start, slot, preset from CC or Note) | ✅ | `src/lib/app-midi-actions.ts` |
| Generators: styles, Euclidean, AI grooves, Song Composer | ✅ | `drum-engine.js`, `song-composer.ts`, `ai-service.ts` |
| Clock in with phase lock (Live as master) | ✅ (P1) | `core/midi/external-clock.ts`, `composables/useExternalClockSync.ts` |
| Song Position Pointer | ✅ (P1) | `core/midi/external-clock.ts` |
| **"DAW" node in Flow with per-port, per-channel lanes** | ❌ | — |
| **Standard control map for Live clips** | ❌ (Actions are per device) | — |
| **App output synced back to Live for recording** | ⚠️ works, but needs latency compensation | — |
| **Live scenes → Song Composer sections** | ❌ | — |

## 4. Phases

### Phase 1 — Live as clock master, SY.CORE as slave (3 days) · **blocking**
Without this phase, SY.CORE's apps cannot "live" inside a Live set.
- `clockSource: 'internal' | 'midi:<port>'` in the global transport (selector in the Global Transport panel, EXT/INT indicator).
- `0xFA` starts, `0xFC` stops, `0xFB` continues and `0xF2` (SPP) repositions every app enabled in the Sync matrix, from the right downbeat.
- `Tone.Transport.bpm` follows the already-smoothed BPM, with a phase lock on every bar (96 ticks), so drift is corrected without chasing per-tick jitter.
- Tempo changes in Live (automation) followed within one bar.
- The scheduler moves to a Worker, so background-tab timer throttling does not stop the music (applies to master mode too).
- **Clock loss** (Live crashes or the port disappears while the transport is playing), with an option to choose the behavior:
  - `stop`, the default: the apps stop;
  - `continue on INT`: the apps carry on with the internal clock at the last BPM, and the external clock re-locks at Live's next Start (scenario S8).
- **Tests:** transport state machine, SPP, phase lock with simulated ticks and ±2 ms jitter, clock loss.

#### 1.1 Status (2026-11-06) — done, branch `feat/rig-controller-ui`, commit `49c8dad`
- **Clock › Source** in the transport bar's sync panel: Internal (INT) or a MIDI input (EXT). Clock-loss behavior: *Stop the apps* (default) or *Continue on INT*.
- Start, Stop, SPP + Continue drive the apps enabled in "Sync Apps to Transport"; they start on the first clock after Start, or on Live's next bar line after a Continue from mid-bar.
- Tempo: least-squares fit over the last bar (±2 ms jitter → under 0.1 BPM). Phase lock per bar: PI correction up to ±8% of the tempo, a jump when the error is over 1/4 beat.
- Clock loss is checked on Tone's worker timer (works with the window in the background); a check that runs late because the main thread was blocked is skipped.
- In EXT, SY.CORE generates no clock of its own. Optional **Forward clock to devices** (off by default) sends Live's clock, Start/Stop and SPP to the outputs with Clock / Transport on, never to the source port or its loopback peer.
- EXT/INT badge with BPM and position, an **AUDIO** warning when the audio clock runs below 97%, and a diagnostics line with **Copy diagnostics** (30 s history).
- **Tested with Live 12 on Windows MIDI Services** (`SYC CTRL A` → Live, `SYC CTRL B` → SY.CORE) at 75 BPM: phase error within ±10 ms, no jumps, with the window in focus or not, as long as the audio clock stays near 100%.
- **Fixed along the way** (a bug in `midi-service.ts`, all inputs): the ingress listener could sit on two objects for the same port, so every message was handled twice (Live at 75 BPM read as 150).
- **Worker scheduler — done** (branch `feat/11-06/midi-worker-scheduler`, merged as `8cf2a2d`): a **CLK AUDIO / CLK SYS** switch in the Drum Machine, Sequencer and Chord Prog (default AUDIO, as before). SYS runs the steps on the system clock (a Worker timer, 100 ms lookahead), re-anchored on every beat of Live, and sends the notes from a Worker-timed queue at their times (strums and arps included). Steps found late after a page stall pass silently; a late start joins Live's current bar in phase. **Tested:** in sync with Live with the FM-1 Emulator open (audio clock 45–70%), in focus and in the background.
- **Found on the way:** on Windows MIDI Services loopbacks (e.g. `MIDIWIN (A)` → Emulator X3) a **timestamped Web MIDI send is ignored**: the message leaves at once, so note-on and note-off of a scheduled note arrive together and the note doesn't sound. CLK SYS doesn't rely on timestamps. In CLK AUDIO the scheduled sends to real ports (Arpeggiator, per-track MIDI Out) still use them: to be handled per port (option, or measured by P4's loopback ping).
- **Still open:** the apps start from their pattern start on Live's bar line, not mid-pattern. Apps still on CLK AUDIO depend on the audio clock.

### Phase 2 — "Ableton Live" node in MIDI Flow (5–6 days, inspector included)
- A new node type groups `SYC IN`, `SYC CTRL` and `SYC OUT` and exposes **16 lanes, one per `SYC IN` channel**, each with a label (e.g. "3 · Pad").
- Each lane connects, as today, to hardware devices, software synths, SY.CORE apps and Note Latch, with the existing splits and filters.
- The lane's channel in Live and the device's channel are independent: SY.CORE remaps them (e.g. lane 5 → Roland S-1 ch 16).
- **Smart Program Change, with one rule per device:**

| Rule | What SY.CORE does with a PC from the lane | Example |
|---|---|---|
| `forward` | Passes it through unchanged | Synths without banks |
| `multi-sound` | Translates it using the Multi Sound bank (MSB/LSB and patch name) | E-MU X3, MicroFreak, SEQTrak |
| `sound-engine` | **Does not forward it.** Loads preset N of the active SY.CORE Sound Engine bank and sends its CC configuration to the synth (the synth stays on its current or temp preset) | **Roland S-1** |
| `ignore` | Drops it | — |

  For the Roland S-1 the default rule is `sound-engine`. The "real" PC on the S-1's ch 16 is never sent, and the synth always stays on its current or temp preset, which SY.CORE rewrites via CC. This matches how the Sound Engine works today.
- **Map export for Live:** a summary file (lane → device/app → channel) and, in Phase 6, an `.als` template with tracks already named and set up with External Instrument.
- Saved Flow configurations: one per Live set (e.g. "Live — Techno Set").

#### 2.1 UI: the canvas node (view and connect)
Consistent with MIDI Flow's current cards (ports, cables, cable popovers, header shortcuts, collapse).
```
┌─ Ableton Live ───────────── EXT ● 124.0 BPM  17.3.1 ─ ⚙ ▢ ✕ ┐
│ SYC IN ●  SYC CTRL ●  SYC OUT ●          clock: Song · SPP ✓ │
├──────────────────────────────────────────────────────────────┤
│  1 Drums      ▪ ──────────────────────────────○ OUT          │
│  3 Pad        ▪ ──────────────────────────────○ OUT          │
│  5 S-1 Bass   ▪ ──────────────────────────────○ OUT          │
│  … (active lanes only; ▾ shows all 16)                       │
├──────────────────────────────────────────────────────────────┤
│ ○ TO LIVE (SYC OUT)   ← cables from the apps, channel/cable  │
│ CTRL: last action "Drum → B" · Control Map: default          │
└──────────────────────────────────────────────────────────────┘
```
- **Header:** status of the three ports, EXT/INT clock, BPM and position in bars.
- **One row per lane:** channel number, label, activity LED and **its own OUT port**. Each lane is cabled to devices and apps, as today, with the cable popover for note range and channel filter.
- **"To Live" IN port:** the apps connect here; the `SYC OUT` channel is chosen on the cable.
- **Compact mode:** only the lanes in use, or the header alone.

#### 2.2 UI: the inspector (edit everything), opened from the ⚙ icon
The canvas and the inspector edit the same data: a cable drawn on the canvas shows up in the inspector, and a destination picked in the inspector creates the cable.

| Tab | Contents |
|---|---|
| **Lanes** | Table of the 16 lanes. For each: label, color, destinations, channel remap, note range, PC rule (`forward`, `multi-sound`, `sound-engine`, `ignore`; the rule belongs to the device), Latch, lane mute and solo, open a filtered Monitor |
| **Control Map** | The ch 15 and 16 map as an editable table: MIDI Learn, reset to defaults, conflict check, quantization (bar or end of pattern), printable export *(active with P3)* |
| **Return** | The apps cabled to `SYC OUT` with their channel, the per-app offset in ms, the **Loopback ping** button with the suggested value *(active with P4)* |
| **Clock** | Source, clock-loss behavior (`stop` or `continue on INT`), measured jitter and drift, the recommended value for Live's Sync Delay |
| **Export** | The lane → device/app → channel map as JSON and as a printable sheet, also used to prepare the `.als` template |

- **Lane names:** in the base rig, labels are typed by hand. With the Max for Live device (P7), Live's track names can be read and matched automatically.
- **Persistence:** lanes, Control Map, offsets and clock settings are saved in the Flow configuration, one per Live set.
- **Tests:** canvas ↔ inspector sync (cable ↔ table row), PC rule application, saving and reloading the configuration.

### Phase 3 — Controlling the apps from Live clips (3 days)
A standard **SY.CORE Control Map** on `SYC CTRL`: no per-set MIDI Learn, Live's clips are the "control sheet".

| Channel | Messages | Action |
|---|---|---|
| 16 | Notes C1–G1 | Chord Seq: slot A–H |
| 16 | Notes C2–G2 | Drum Machine: sequence A–H |
| 16 | Notes C3–G3 | Sequencer: slot A–H |
| 16 | C4 / D4 / E4 | Drum Fill, Repeater, Mute Bass Line |
| 16 | F4 / G4 | Generate (current style), Generate AI (current prompt) |
| 16 | CC 20–40 | App parameters (transpose, density, swing, velocity…) via Mapping, automatable in Live |
| 15 | Notes | **Key follow:** the incoming note re-roots Sequencer and Chord Seq (the Sequencer already does this from a keyboard; to be extended to Chord Seq) |

- The map lives **only on the `SYC CTRL` port**, which is never forwarded to devices, so it never clashes with any channel in the rig. For example, the S-1's ch 16 on `SYC IN` is a different thing from control ch 16 on `SYC CTRL`. Channels 15 and 16 are still configurable.
- The map is a preset in the MIDI Actions registry, editable, with documented defaults.
- Slot changes are quantized to the bar (or to the end of the pattern), as in Live's Session View.

### Phase 4 — Sending output back to Live (2 days)
- In Flow every app can fan out: to the synth and, at the same time, to `SYC OUT` on a dedicated channel. In Live, a track listening to `SYC OUT ch N` records what the app played.
- **Output offset** per app and per port, in ms, to compensate the Live → browser → Live round trip. Measured with a "loopback ping" test in SY.CORE: send a note, measure its return, suggest the value.
- **Send to Live:** the existing `.mid` exports use descriptive names (`DM_A_Techno_124.mid`, `Chords_B_Amin_124.mid`) for drag & drop.

### Phase 5 — Generation in the context of Live (4–5 days)
- **Live scenes → Song Composer sections.** The Song Composer spreads its sections (intro, verse, drop…) over the A–H slots of every app. In the template, each Live scene holds a one-bar control clip on `SYC CTRL` that selects the section: launching a scene in Live changes chords, drums, bass and presets together.
- **Rig-aware AI:** the prompt includes the external BPM, the key, and the devices with their preset categories (`planPresetChanges` and `partCategories` already exist). The AI writes not just notes but also *which sound on your synth* to use.
- **Generate and Mutate during playback:** the result goes into the next slot and starts on the next bar, without stopping Live.
- **Undo and history:** `undoSongPlan` already exists; it also needs to be exposed in the control view.

### Phase 6 — Template, wizard, Live Rig view and documentation (5 days)
- `SYCORE Template.als`, **to be built together in Live 12** and Standard-compatible (no M4L): 16 MIDI or External Instrument tracks (one per lane), recording tracks on `SYC OUT`, a "SY.CORE Control" track on `SYC CTRL` ch 16, scenes A–H with the control clips.
- **"Ableton Live" wizard in SY.CORE:** detects the `SYC IN`, `SYC CTRL` and `SYC OUT` ports (and explains how to create them if they are missing), warns when a hardware port is also open in Live, checks that the clock arrives, runs the loopback ping and creates the Flow configuration.
- **"Live Rig" view** (for performance, mostly read-only):
  - large clock and position, activity of the 16 lanes, and the current Chord Seq, Drum Machine and Sequencer slots;
  - the latest actions received from the Control Map;
  - warnings: loop detected, port gone, tab hidden, clock lost, with a clearly visible "continue on INT" state;
  - the only edits allowed are the ones needed on stage: lane mute, panic (All Notes Off) and a manual EXT → INT switch.
- A `docs/guides/SYCORE_ABLETON_LIVE.md` guide in the repo, based on §10.

### Phase 7 — Optional extensions (after the MVP)
- **"SY.CORE Link" Max for Live device** (needs Suite, or Standard with the separately purchased Max for Live add-on; the base rig does not need it): reads the set's key and scale, scene names and launched clips from the Live Object Model, and writes clips straight into Live's slots ("Send to Live" without drag & drop).
- **Ableton Link bridge (Node):** tempo and phase via Link instead of MIDI clock, useful with several computers. Secondary, because in this scenario Live is already the master via MIDI.
- **Push control script**, to drive the Control Map from the pads.

Everything optional stays optional: the base rig needs only the browser and a virtual MIDI cable.

### Phase 8 — "Pro rig" desktop shell (optional, after the MVP · 1–2 weeks)
A Tauri shell (preferred, lighter) or Electron shell that **embeds the same web build** of SY.CORE, with no fork.
- **Virtual ports created by the app:** `SYC IN`, `SYC CTRL` and `SYC OUT` come with the app, so no loopMIDI. On macOS with CoreMIDI virtual sources and destinations; on Windows with the Windows MIDI Services APIs (availability on the target Windows versions to be verified).
- **No background-tab timer throttling,** and a process separate from Live.
- **Auto-start,** dedicated window, and restore of the last Flow configuration.
- It contradicts the Manifesto's "zero install" principle, so it stays an option: the browser version remains complete.

### Phase 9 — Rig Controller (after the MVP · prototype 5–6 days)
A controller **for the rig, not for the instruments**. It doesn't touch sound parameters: it governs who plays what, when and how. Its model is a "SY.CORE Session View".

#### 9.1 Principles
1. **Functions, not devices.** Buttons say "Drum slot C", "Section 3", "Generate", not "CC 20 on channel 16". The mapping lives in SY.CORE.
2. **SY.CORE decides, the controller shows.** The controller holds no state: LEDs and display mirror SY.CORE. On reconnect (USB or page reload) it receives the full state.
3. **Every musical action is quantized and visible.** The button blinks while waiting for the bar, then stays lit.
4. **Readable at a glance, in the dark.** Fixed color meanings, no menus, at most one Shift button.
5. **Physical safety.** Panic and the switch to INT are set apart and fire on hold.

#### 9.2 Reference layout (dedicated hardware, future)
```
┌─ TRANSPORT / CLOCK ─┐ ┌──────────── SLOT GRID (A–H) ───────────────┐ ┌─ PERFORMANCE ─┐
│ ▶ ■   EXT●INT       │ │ Chord  [A][B][C][D][E][F][G][H]  M  GEN MUT│ │ FILL  REPEAT  │
│ 124.0 BPM  17.3.1   │ │ Drum   [A][B][C][D][E][F][G][H]  M  GEN MUT│ │ LATCH  REL-ALL│
│ TAP   ● beat LED    │ │ Bass   [A][B][C][D][E][F][G][H]  M  GEN MUT│ │ KEY ◀ C# ▶    │
├─ SECTIONS (Song) ───┤ │ Seq    [A][B][C][D][E][F][G][H]  M  GEN MUT│ │ ◯ ◯ ◯ ◯       │
│ [1][2][3][4]        │ │ Arp    [A][B][C][D][E][F][G][H]  M  GEN MUT│ │ dens swing    │
│ [5][6][7][8]        │ └────────────────────────────────────────────┘ │ vel  gate     │
├─ RIG ───────────────┤ ┌─ DISPLAY ─────────────────────────────────┐ ├─ SAFETY ──────┤
│ FLOW ◯ "Techno Set" │ │ Drum → C on bar 18 · AI: ready            │ │ PANIC (hold)  │
│ SPLIT [1][2][3][4]  │ │ ⚠ SYC OUT missing                         │ │ INT   (hold)  │
│ LANE mute 1–8 (+⇧)  │ └───────────────────────────────────────────┘ │ UNDO          │
└─────────────────────┘                                                └───────────────┘
```
- Push stays with Live, the Rig Controller stays with SY.CORE: no overlap.
- If Live's Play/Stop is needed on the Rig Controller, it goes through a dedicated port (`SYC REMOTE`) mapped in Live, never through `SYC OUT`.

#### 9.3 One model, several transports
At the core is a single model: the **Rig Actions** (slot, section, generate, mutate, fill, mute, split, key, panic, INT) and the **Rig State** (active and queued slots, clock, warnings, display text). It extends the existing MIDI Actions, with P3's quantization.

The transports sit on top of this model:

| Transport | When | How |
|---|---|---|
| **MIDI** (base) | Always: works in the browser and with any USB controller | Notes for buttons, relative CCs for encoders (absolute with pickup for pots and faders), velocity for LEDs, SysEx for display and state dump |
| **OSC** (optional) | Tablet surfaces (TouchOSC, Open Stage Control) or OSC-capable controllers | Through P7's Node bridge, acting as a UDP ↔ WebSocket relay |

#### 9.4 OSC: a solution or extra complexity?
**Not too complex, on one condition: OSC is a second transport for the same model, not the main protocol.**
- **For:**
  - it's a standard: no protocol is invented, only the address map is defined, and that is needed anyway;
  - readable addresses, floats and strings: display text travels without SysEx;
  - many ready-made tablet surfaces.
- **Against:**
  - **the browser cannot open UDP sockets**, so OSC needs the local bridge (P7): one more component to install, against the "zero install" principle;
  - Wi-Fi on stage is a risk: better Ethernet or a tablet over USB;
  - hardware controllers like the Launchpad and MIDImix speak MIDI only.
- **Cost:** about 3–4 days on top of the bridge, since actions and state are already defined by the model.
- **Proposed decision:** MVP and prototype in MIDI only; OSC later, as an extension of P7.

Sample addresses, versioned:
```
/sycore/v1/app/drum/slot        i 3          → Drum slot D
/sycore/v1/app/chord/generate                → Generate on Chord Seq
/sycore/v1/section              i 2          → Section 3
/sycore/v1/state/clock          s "EXT" f 124.0 s "17.3.1"
/sycore/v1/state/display        s "Drum → C on bar 18"
```

#### 9.5 Prototype with Launchpad Mini MK1 + AKAI MIDImix
The `LaunchpadMiniMK1` profile already exists (`src/core/controllers/profiles/LaunchpadMiniMK1.ts`: XY layout, top-row CCs 104–111, green 60 and amber 51 LEDs). A **"Rig" mode** is added, selectable next to the current one (which opens panels), without breaking existing mappings. Neither device has a display: the on-screen **Live Rig** view takes its place.

**Launchpad Mini MK1: the rig grid** (XY layout: note = 16 × row + column, rows 0–7 from the top)

| Zone | Notes / CC | Function |
|---|---|---|
| Rows 0–4 | 0–7, 16–23, 32–39, 48–55, 64–71 | Chord, Drum, Bass, Seq, Arp × slots A–H |
| Row 5 | 80–87 | Song Composer sections 1–8 |
| Row 6 | 96–103 | Split 1–4 · Fill · Repeater (hold) · Latch · Release all |
| Row 7 | 112–119 | Lane mute 1–8 (Shift: 9–16) |
| Side buttons, rows 0–4 | 8, 24, 40, 56, 72 | Generate for that row's app (Shift: Mutate) |
| Side buttons, rows 5–7 | 88, 104, 120 | Undo · Key − · Key + |
| Top row | CC 104–111 | Beat LED (press: Tap) · EXT/INT (hold) · Shift · built-in/AI Generate · bar/pattern quantization · open Live Rig · free · Panic (hold) |

**Colors.** The MK1 only has red, green and amber, so the app is identified by its row, not by color.

| Color | State |
|---|---|
| Off | Empty slot |
| Amber | Filled slot |
| Blinking amber | Slot queued for the next bar |
| Green | Playing |
| Red | Mute, or panic armed |

The exact values for red and for blinking must be checked against Novation's Programmer's Reference for the Launchpad Mini.

**AKAI MIDImix: the continuous parameters** (8 strips, each with 3 pots, 1 fader, Mute and Rec Arm; master fader, Bank ◀ ▶, Solo)

| Control | "App" page (default) | "Lane" page (Bank ▶) |
|---|---|---|
| Strips 1–5 | Chord, Drum, Bass, Seq, Arp | Lanes 1–8 (Shift: 9–16) |
| Strips 6–8 | Free macros (e.g. transpose, Arp rate) | — |
| Pot rows 1 / 2 / 3 | Density · Swing · Gate | Configurable CCs per lane (e.g. cutoff) |
| Fader | App intensity (output velocity scale) | CC 7 to the lane's synth |
| Mute (with LED) | App mute | Lane mute |
| Rec Arm (with LED) | App solo | Lane latch |
| Master fader | Global intensity | — |
| Solo | Shift | Shift |

- The MIDImix's pots and faders are absolute and unmotorized. SY.CORE applies **pickup** (soft takeover): the value only changes once the control reaches the current one, and the Live Rig view shows the position to reach.
- The note numbers for the Mute and Rec Arm LEDs are read and set with AKAI's MIDI Mix Editor.
- A new `AkaiMidiMix` profile is added next to `LaunchpadMiniMK1`.

#### 9.6 Steps
1. **On-screen layout:** a Controller Designer preset with the same layout, to try in jams (1 day).
2. **Profiles:** "Rig" mode for the Launchpad Mini MK1 and a new MIDImix profile, with LEDs driven by the Rig State, and pickup (3–4 days).
3. **Real-world trials and layout review** (1 day).
4. **Later:** OSC through the bridge (P7, 3–4 days) and, only once the layout is stable, dedicated hardware (Raspberry Pi Pico or Teensy, class compliant, RGB LEDs, encoders, display), not estimated.

**Tests:** Rig Action ↔ message translation for both profiles, LED states (empty, filled, queued, playing, mute), pickup, full state dump on reconnect.

#### 9.7 Per-track performance options
Each app row (Chord, Drum, Bass, Seq, Arp) is a **track** and each slot A–H a **clip** with a length in bars. Per track, four options inspired by DAW performance modes:

| Option | Values | Effect |
|---|---|---|
| **Press** | Retrigger · Hold & stop · Hold & motion · Latch (default) | How the pad reacts: restarts (Shift + press stops), plays while held, plays while held and on release the next press of that pad plays the next slot, or toggles play and stop |
| **Motion** | Stay · One shot · March & wrap · March & stay · March & stop · Random · Exclusive random | What happens when the slot ends |
| **Trigger sync** | Off · 1/4 beat to 4 beats · Auto · Queue · Tolerant | When the pressed slot starts. Auto: from the slot's length, at most 4 beats. Queue: pressed slots play in order. Tolerant: a press within 1 beat of the bar line starts at once, cutting the beginning |
| **Position sync** | Off · 1/4 beat to 4 beats · Auto | Where inside the slot it starts: from the beginning, from the nearest grid point, or from the current song position |

- **UI:** a summary under the app name (e.g. `LTCH · STAY · BAR`), and a "Track options" card with the four dropdowns and their descriptions. On the pads: length in bars, a progress bar, queue order (`#1`, `#2`), and an outline on the slot the next press will play (Hold & motion). On the Launchpad, the top "Sync" button cycles the focused track's Trigger sync.
- **Clock:** the model advances in 16ths (16 steps per bar, 4/4), so 1/4-beat sync is possible. Sections always switch on the bar line.

#### 9.8 Positioning against DAW performance modes
Live already has a performance model for its clips, in Session View. The same ideas exist under different names:

| FL Studio Performance Mode | Ableton Live Session View | SY.CORE Rig Controller |
|---|---|---|
| Press: Retrigger, Hold & stop, Latch | Launch Mode: Trigger, Gate, Toggle, Repeat | Press |
| Motion: March, Random… | Follow Actions: Next, Any, Other, Stop, Jump… | Motion |
| Trigger sync | Launch Quantization | Trigger sync |
| Position sync | Legato | Position sync |
| Scenes, Marker Groups | Scenes | Sections / rig scenes (P10) |

SY.CORE doesn't bring Live something it lacks for its clips. It applies the same model where Live can't reach:
- **the generative apps**, whose slots are patterns that Generate, Mutate or AI rewrite while the song plays;
- **the hardware rig:** the same gesture changes patterns, synth sounds, MIDI Flow routing and splits (P10);
- **no DAW needed:** it also works on the internal clock.

**Positioning:** "the rig's performance mode, kept in sync by Live". Public texts (paper, website, UI) use a name of its own, e.g. "Rig Performance Mode", and don't mention FL Studio, a trademark of Image-Line; at most "inspired by DAW performance modes".

#### 9.9 Prototype status
Branch `feat/rig-controller-ui` of `sycore-refactor`, commit `99c09f8` (pushed). The branch also holds P1 (commit `49c8dad`), which the Rig Controller will use in place of its simulated clock.
- **"Rig Controller" panel** (Performance Tools, Prototype badge), with three views: Rig layout, Launchpad Mini MK1, AKAI MIDImix.
- **All §9.7 options** working, with a simulated clock standing in for Live.
- **No MIDI sent.**
- **Files:** `src/lib/rig-controller.ts` (model, Rig Actions, Launchpad map), `src/components/RigControllerPanel.vue`; tests in `tests/unit/lib/rig-controller.test.ts`.

### Phase 10 — Rig scenes and markers (after P9 · 8–10 days)
Today a slot only stands for a pattern. This phase also ties **sounds, routing and controller values** to slots and sections, and lets Live, the Live Timeline or the controller recall them.

#### 10.1 The rig scene
| Where | What is saved | Example |
|---|---|---|
| **Slot** of an app | The part's sound: a Sound Engine preset (S-1) or a Multi Sound bank/patch | Bass slot C → S-1 preset "Acid 04" |
| **Section** (rig scene) | Each app's slot, MIDI Flow configuration, split preset, lane mutes, CC values (cutoff, levels…) | Scene 3 "Drop" → Drum C, Bass C, Flow "Techno Set", split 2, lane 5 muted, pad cutoff at 90 |

- **Programmed** with two inspectors in the Rig Controller:
  - the **slot**: pick its sound;
  - the **section**: a name, each app's slot, and a "capture rig state" command that saves the current Flow, split, mutes and CCs.
- **Already there:** the Song Composer plans presets per section (`planPresetChanges`, `sendPartPresets`), but only for generated songs and without routing or CCs. The rig scene generalizes it; a Song Composer song becomes a set of scenes.

#### 10.2 Three ways to make changes
1. **Programmed in SY.CORE:** in scenes and slots (§10.1), applied on the bar together with the pattern change.
2. **Live, from the controller:** splits and Flow configuration from the Rig zone (Launchpad row 7), lane mutes, CCs from the MIDImix pots and faders (Lane page). Applied at once or on the bar, by choice.
3. **Programmed in Live:** control clips and lanes in the arrangement (Program Change in clips, CC automation), translated by P2's per-device rules.

#### 10.3 Technical issues to handle
- **Hanging notes on a routing change:** before changing a lane's channel or destination, SY.CORE closes the notes still sounding on the old destination. The change always happens on the bar.
- **Synth loading times:** a Program Change on hardware can leave a gap while the synth loads the patch, and an S-1 preset is dozens of CCs. Two per-device options: early send (e.g. on the last beat of the previous bar, in configurable ms) and CCs spread over a few milliseconds.
- **Pickup:** a scene's CC values change the current value. The MIDImix's absolute pots re-engage through P9's pickup.

#### 10.4 Markers from Ableton: three paths
SY.CORE's Live Timeline already has many marker types (Program Change, Select Chord Prog Slot, start and stop of Sequencer, Drum Machine and Loop Machine, Tempo, Performance Set). Today, though, it has a clock of its own (its own BPM, `requestAnimationFrame`) and sends Start and Stop itself: it is a master timeline.

| | Where the markers live | How it works | Pros | Cons |
|---|---|---|---|---|
| **A** | In SY.CORE's Live Timeline | The timeline follows Live's position (clock and SPP, P1) and fires its markers | Readable markers, already there | Two timelines to keep aligned: move a section in Live and SY.CORE's markers don't move |
| **B** | In Live's arrangement | One control clip on `SYC CTRL` per section: its note names the rig scene | A single timeline, Live's; markers follow arrangement edits. Works on Live Standard | The clip holds only a number: it must be named (e.g. "Drop → Scene 3") |
| **C** | Live's locators (named markers) | The Max for Live device (P7) reads the locators; SY.CORE applies the scene with the same name | The cleanest: a "Drop" locator triggers the "Drop" scene | Needs Max for Live |

**Proposed decision:** with Live, the main path is **B**, because time has a single source; **C** comes with P7. The Live Timeline (**A**) stays the tool for playing without a DAW, with SY.CORE as master; optionally, with P1's external clock, it can also follow Live.

#### 10.5 A marker names a scene, not actions
- A scene's content lives in SY.CORE and is edited only there.
- Control clips in Live, locators via Max for Live, a new **"Rig Scene"** marker type in the Live Timeline and the controller's section buttons all recall **the same scene**: it is programmed once.
- Control clip map: on `SYC CTRL` ch 16, the Control Map's (P3) notes C2–G2 currently select the Drum Machine sequence. For scenes, a dedicated octave is proposed (e.g. C5–G6 = scenes 1–16), to be fixed in the Control Map.

#### 10.6 States instead of events: "chase"
- Today, when you start the Live Timeline mid-song, it treats earlier markers as already fired and skips them. That is wrong for a rig: restarting from the second chorus, synths, routing and slots must be those of the section you are in.
- **Scenes are states.** When an SPP or a jump arrives, SY.CORE applies the scene active at that position, like a DAW's "chase".
- **With path B:** the control clip's note lasts the whole section and **Options › Chase MIDI Notes** is on in Live. Starting mid-section, Live resends the note and SY.CORE gets the right scene. *To be checked on Live 12.*
- **With path A:** on seek, the Live Timeline applies the scene of the last "Rig Scene" marker before the position.

#### 10.7 Steps and estimates
1. Rig scene model, saved in the per-set Flow configuration (2 days).
2. Slot and section inspectors in the Rig Controller, with "capture rig state" (2 days).
3. Applying on the bar: closing notes, early PCs, spread CCs (2 days).
4. Scenes from the control clip (path B) with chase (1–2 days).
5. "Rig Scene" marker in the Live Timeline, chase on seek, "follow Live" option (1–2 days).

**Tests:** applying a scene (slots, sounds, Flow, split, mutes, CCs), closing notes on routing changes, message order and early send, chase from SPP and from seek, no double send when the same scene arrives twice.

## 5. Order and estimates

| # | Phase | Effort | Depends on |
|---|---|---|---|
| 1 | P1 Clock slave + SPP | M | — |
| 2 | P2 Ableton node in Flow + inspector + smart PC | M–L | — |
| 3 | P3 Control Map | S–M | P1 (quantization) |
| 4 | P4 Return to Live + offset | S | P2 |
| 5 | P6 Template + wizard + Live Rig view + guide | M | P2, P3 |
| 6 | P5 Scenes → sections, rig-aware AI | M | P1, P3 |
| 7 | P7 M4L / Link / Push | L | MVP |
| 8 | P8 "Pro rig" desktop shell | M–L | MVP, Live edition (§11) |
| 9 | P9 Rig Controller: Launchpad Mini MK1 + MIDImix profiles, per-track performance options, then OSC | M | P3 (quantized actions); P7 for OSC |
| 10 | P10 Rig scenes and markers (Live, Live Timeline, chase) | M–L | P1 (SPP), P2 (PC rules), P3 (Control Map), P9 |

**MVP:** P1 + P2 + P3 + P4 + P6, about 3.5 weeks. **Full version:** with P5, about 4.5 weeks.

## 6. Acceptance criteria (MVP)

- Live as master at 70–180 BPM: SY.CORE's apps start on the downbeat and drift by less than 5 ms over 10 minutes, even with the SY.CORE tab in the background.
- Stopping and restarting from any point in the arrangement (SPP): the apps restart in phase from the right bar.
- A Live track on `SYC IN ch3` plays a hardware synth through SY.CORE, with Flow's splits and filters, with no VSTs in Live.
- A PC from a Live clip selects the right patch using the device's Multi Sound bank. On the Roland S-1 lane, the same PC loads the Sound Engine preset via CC, without sending a PC to the synth.
- A scene's control clip switches the Chord Seq, Drum Machine and Sequencer slots on the next bar.
- Drum Machine output recorded in Live from `SYC OUT` sits on the grid within 1/128 after offset compensation.
- No feedback loops with the documented configuration.
- `npm test` passes with the new transport, DAW node and Control Map tests; `CHANGES.md` updated at every step.

## 7. Why SY.CORE goes beyond MIDI generators like MIDI Agent

*Comparison with the "AI MIDI generator as a DAW plugin" category. To be checked against the current version of MIDI Agent before using it in any communication.*

| | AI generator plugin (e.g. MIDI Agent) | SY.CORE + Live |
|---|---|---|
| Output | MIDI clips to drag into a track | Clips **and** live playback, in time, with slot and section changes on the bar |
| Generation | Offline, one prompt at a time | Generate and Mutate during playback, built-in (styles, Euclidean) or AI |
| Coherence across parts | Usually one part at a time | Song Composer: chords, drums, bass and sequences in one plan, by section |
| Instruments | Whatever is loaded in the DAW | Any hardware or software synth, reached through Flow routing |
| Sounds | Does not know your synths' presets | Picks presets from Multi Sound banks by category and sends the right PCs |
| Routing | The DAW's | Splits, filters, multi-channel fanout, Note Latch, one hub for the whole rig |
| Plugin in the DAW | Yes (VST/AU) | No: native MIDI tracks and External Instrument |
| Editing | In the DAW's piano roll | Dedicated editors (steps, chords, drums, accents, ratchets, probability), then Live's piano roll after recording |
| AI provider | The product's | Configurable provider (`ai-providers`), the user's own key; built-in generators need no network |
| Live use | Limited | Built for the stage: local-first, Live scenes as sections, control from clips |

## 8. Risks

| Risk | Mitigation |
|---|---|
| Latency of the Live → browser → hardware round trip | Timestamped sending (already there), negative Track Delay in Live, measurement with the loopback ping (P4) |
| Incoming clock jitter in the browser | Phase lock per bar instead of following every tick; optional Link (P7) |
| Timer throttling in background tabs | Scheduler in a Worker; UI warning |
| MIDI ports not multi-client on Windows | Rule: hardware ports only in SY.CORE; Windows MIDI Services where available |
| Feedback loops (`SYC OUT` → Live → `SYC IN`) | Remote and Sync off on `SYC OUT` in Live; loop detection already in SY.CORE; dedicated test |
| Chrome and Edge only (Web MIDI and SysEx) | Stated requirement, as today |

## 9. Decisions

1. **Live 12.x, Standard or Suite.** The base rig does not use Max for Live; M4L is needed only for the P7 extensions.
2. **16 parts max:** a single `SYC IN` port with 16 channels.
3. **Control Map on channels 15 and 16 of `SYC CTRL`**, a port never forwarded to devices. The Roland S-1 (PC on ch 16) uses the `sound-engine` rule: presets are CC configurations applied to the current or temp preset.
4. **The `.als` template will be built together** (P6).

## 10. Installation and setup for the user

### 10.1 What to install

| | Windows | macOS |
|---|---|---|
| Browser | Up-to-date Chrome or Edge | Up-to-date Chrome or Edge |
| Virtual MIDI ports | **loopMIDI** (free, by Tobias Erichsen), with auto-start on. Alternatively, Windows MIDI Services loopbacks if the system has them | Nothing: **IAC Driver** (Audio MIDI Setup) |
| Synth drivers | The manufacturer's, if the synth is not class compliant | Usually none |
| Audio driver | The audio interface's ASIO driver (for Live) | Core Audio, none |
| *Optional:* SY.CORE audio into Live | VB-Cable | BlackHole |
| *Optional:* M4L (P7) | Suite, or Standard with the add-on | same as Windows |

SY.CORE needs no installation: it opens in the browser, and MIDI with SysEx permission is granted on first launch.

### 10.2 Creating the ports (once)
Three ports with these exact names, because the wizard recognizes them by name:
`SYC IN` · `SYC CTRL` · `SYC OUT`
- loopMIDI: type the name and press "+", three times.
- IAC: Window › Show MIDI Studio › IAC Driver › "Device is online", then add three buses with those names.
- **Windows MIDI Services** (instead of loopMIDI): a loopback is a **pair of endpoints**, e.g. `SYC CTRL A` and `SYC CTRL B`; what goes out of A comes in on B. Live uses the A side, SY.CORE the B side (Clock › Source = `SYC CTRL B`). SY.CORE recognizes the pair and never sends its clock to the A side. Note: in our tests Live 12 crashed when disabling Windows MIDI Services ports in its Preferences; enable only what is needed (Output A: Sync) and leave the rest.

Each port shows up **both as an input and as an output** in every app: that is why Live needs only one direction of each (see below).

### 10.3 Ableton Live — Preferences › Link, Tempo & MIDI

**MIDI Ports table:**

| Port | Direction in Live | Track | Sync | Remote | MPE |
|---|---|---|---|---|---|
| `SYC IN` | **Output** | ✅ | — | — | — |
| `SYC IN` | Input | ✖ | ✖ | ✖ | ✖ |
| `SYC CTRL` | **Output** | ✅ | ✅ (clock) | — | — |
| `SYC CTRL` | Input | ✖ | ✖ | ✖ | ✖ |
| `SYC OUT` | **Input** | ✅ (recording) | ✖ | ✖ | ✖ |
| `SYC OUT` | Output | ✖ | ✖ | ✖ | ✖ |
| **Hardware synths** (S-1, etc.) | both | ✖ | ✖ | ✖ | ✖ |
| Live's controllers (Push, etc.) | as before | unchanged | unchanged | unchanged | unchanged |

**Sync on `SYC CTRL` (Output):**
- **MIDI Clock Type: Song**, so Live also sends Song Position Pointer.
- **MIDI Clock Sync Delay:** the value suggested by the wizard's loopback ping.
- Link: not needed, can stay off.

**Audio:** the audio interface with its ASIO or Core Audio driver. Its inputs are where the hardware synths come back in.

### 10.4 Ableton Live — tracks (ready-made in the template)
- **Part on a hardware synth:** MIDI track with **External Instrument**. MIDI To: `SYC IN`, channel N. Audio From: the interface input where the synth comes back. **Hardware Latency:** the measured value.
- **Part on a standalone software synth or a SY.CORE app:** MIDI track, MIDI To: `SYC IN`, channel N.
- **Live instrument played by its own clips:** a MIDI track with the instrument (e.g. Wavetable, Drum Rack), as always; SY.CORE is not involved.
- **Live instrument played by a SY.CORE app:**
  - a MIDI track with the instrument, MIDI From: `SYC OUT`, channel N, Monitor: **In**; arm it to record;
  - it creates no loop, because the track outputs audio and sends no MIDI back to `SYC IN`;
  - with Flow's fanout the same part can also play on a hardware synth at the same time (layer);
  - notes make the Live → SY.CORE → Live round trip, compensated with the per-app offset (P4);
  - to play a Live instrument from the keyboard with minimum latency, connect the keyboard straight to Live; on Windows, the keyboard is then not available in SY.CORE as well.
- **Control:** a "SY.CORE Control" track, MIDI To: `SYC CTRL`, ch 16 (and 15 for key follow), with the control clips in the scenes.
- **Recording app output (no instrument):** MIDI track. MIDI From: `SYC OUT`, channel N. Monitor: **Off** and MIDI To: **No Output**, to avoid loops.

### 10.5 SY.CORE (guided by the "Ableton Live" wizard)
1. MIDI Devices: the three `SYC` ports are detected and registered.
2. Global Transport: **Clock source = `SYC CTRL`** (EXT).
3. MIDI Flow: load the "Ableton Live" configuration, connect each lane to its device or app, and set the PC rule per device (S-1 = `sound-engine`).
4. Routing: no clock out to `SYC OUT`, to avoid loops.
5. Test: Play in Live, check the transport, run the loopback ping, copy the latency values into Live.
6. Tip: keep SY.CORE in its own window (not a hidden tab) during the session.

### 10.6 Common problems

| Symptom | Cause | Fix |
|---|---|---|
| The synth does not respond, or the port is "in use" | Hardware port also enabled in Live (Windows) | Disable it in Live, everything ✖ |
| Doubled notes or MIDI looping | `SYC IN` or `SYC CTRL` input enabled in Live, or Monitor on in the recording track | Follow the table in §10.3 |
| The apps start off the beat | Clock Type "Pattern" | Set it to "Song" |
| The apps drift with the tab hidden | Browser timer throttling | Separate window (and scheduler in a Worker, P1) |
| SY.CORE shows twice Live's BPM | The same clock arriving twice (a loop back into the source, or a doubled input) | Fixed in P1; the diagnostics line shows clocks/s (24 × BPM / 60) and near-duplicates |
| EXT drops to INT right after Play | The main thread busy starting the apps | Fixed in P1 (late checks skipped) |
| The apps play out of time, with pauses; amber **AUDIO** badge | The audio thread is overloaded (audio clock < 97%), e.g. FM-1 Emulator open | **CLK SYS** in the Drum Machine, Sequencer and Chord Prog; or close heavy panels |
| A synth on a Windows MIDI Services loopback shows the notes but doesn't sound | Timestamped sends ignored on that port: note-on and note-off arrive together | **CLK SYS** in the app (Worker-timed sends) |

## 11. Repository structure

**Decision: no "SY.CORE Live" fork.** One app, with a "Live" edition or profile, plus a dedicated repo only for what lives outside the browser.

**Why no fork**
- The value is in the shared core: MIDI Flow, `midi-transport`, Sound Engine, Multi Sound, generators and AI. With a fork, every routing or clock fix would have to be done twice, and the two branches drift apart.
- Development is a one-person job: two apps to maintain, test and ship double the work without adding features.
- The repo already does editions (`build:demo` and `build:website` as Vite modes), and the Module Manager hides the modules that aren't needed.

### 11.1 `sycore-refactor` — the app (with the "Live" edition)
- `dev:live` and `build:live` build modes with `VITE_EDITION=live`, or a "Live" profile chosen at startup on the same deployment.
- A Module Manager preset with only MIDI Flow, Chord Seq, Drum Machine, Sequencer, Arpeggiator, Note Latch, Multi Sound, Sound Engine and Global Transport.
- The "Ableton Live" node with its inspector (§4, P2.1–2.2) and the **"Live Rig"** view (P6): external clock status (EXT/INT, BPM, bar), the 16 `SYC IN` lanes, the Control Map, latency and loop indicators.
- The "Ableton Live" wizard (P6).
- All P1–P6 features go into the core and are useful to people who don't use Live too (external clock, PC rules, Control Map).

### 11.2 `sycore-ableton` — the pieces around Live (this repo)
```
sycore-ableton/
├─ PIANO_INTEGRAZIONE_ABLETON.md   (Italian)
├─ ABLETON_INTEGRATION_PLAN.md     (English)
├─ paper/           "SY.CORE Live" paper for musicians and audio engineers (IT, EN), images in assets/
├─ template/        SYCORE Template.als (Live 12, Standard-compatible) and Ableton Project
├─ m4l/             "SY.CORE Link" device (P7)
├─ bridge/          Node bridge for Ableton Link (P7)
├─ docs/            user guides, printable Control Map, MIDI Agent comparison
└─ tools/           test scripts (command-line loopback ping, port monitor)
```

### 11.3 `sycore-desktop` — only if P8 is done
- Holds **only the shell** (Tauri), which loads the `build:live` build of `sycore-refactor` and adds the native features (virtual ports, auto-start, dedicated window).
- No app code copied. Native APIs reach the app through an adapter (`window.sycoreNative`); without the adapter, the app behaves as it does in the browser.

### 11.4 Rules
- Music and MIDI code lives **only** in `sycore-refactor`.
- External repos depend on the app, never the other way round: the app works without any of them.
- The protocol between app, bridge, M4L and shell is versioned JSON (`"v": 1`), documented in `sycore-ableton/docs/`.

## 12. Usage scenarios

What SY.CORE makes possible with Live, on stage and in the studio. Each scenario lists the plan phases it needs. **"Today"** means it already works with SY.CORE's existing features, by registering the `SYC` ports as virtual devices.

### S1 — Hybrid live set on stage
**Context:** a 45-minute set with Live, a Roland S-1, a multitimbral module (e.g. E-MU X3) and a standalone software synth, with no VSTs in Live.
**How it works:**
- Live is the clock master; SY.CORE's Chord Seq, Drum Machine with Bass Line and Sequencer follow.
- Each Live scene is a section of the song: the control clip on `SYC CTRL` switches the A–H slots of every app and the synth presets together.
- Live's clips play the fixed parts (lead, pads) through the `SYC IN` lanes; SY.CORE dispatches them to the synths.
- The Roland S-1 changes sound through the Sound Engine (presets as CC configurations on the current or temp preset).

**Phases:** P1, P2, P3, P5 (scenes → sections), P6 (template).

### S2 — A studio jam that is "always recording"
**Context:** an hour-long free jam: you play the keyboard, SY.CORE generates chords and drums, and nothing must be lost.
**How it works:**
- In the template, Live's tracks on `SYC OUT` (one per app) are always armed. The External Instrument tracks record the synths' audio.
- When the idea works, Generate or Mutate from the controller: the variation comes in on the next bar and gets recorded.
- SY.CORE's MIDI Capture records in parallel as a safety net, exportable as `.mid`.
- Live's Capture MIDI also recovers what was played before pressing Record.

**Phases:** P1, P4 (return and offset), P3 (Generate from the controller).

### S3 — Writing a song with AI
**Context:** you start from scratch, with a key, a style and a tempo.
**How it works:**
- The Song Composer generates a complete plan: sections, chords, drums, bass, sequences and suggested presets for your synths.
- You hear it all immediately on the rig's real sounds, not on General MIDI.
- You refine it in the dedicated editors (chords, steps, accents, ratchets, probability), then record into Live or drag the `.mid` files.
- Final editing happens in Live's piano roll.

**Phases:** **today** with `.mid` export and drag & drop; P1 + P4 to record in real time; P5 for a rig-aware AI.

### S4 — One keyboard for the whole rig
**Context:** a single master keyboard, three synths, no re-arming of tracks during the jam.
**How it works:**
- The keyboard belongs to SY.CORE. MIDI Flow does the split (bass on the S-1 in the low zone, pads on the X3 in the high zone), the layering and the multi-channel fanout for multitimbral synths.
- Note Latch holds a drone and releases it with a single command.
- One Flow configuration per song, recallable on the fly.
- Live records what you play through a Flow cable to `SYC OUT`.

**Phases:** **today** (device→device routing, splits, filters, multi-CH out); P4 to record into Live with compensated offset.

### S5 — Reopening a project and getting the sounds back (total recall)
**Context:** you reopen a song months later; the hardware synths hold other sounds.
**How it works:**
- The first clip of each lane holds a Program Change; SY.CORE applies the device's rule.
- With `multi-sound` it selects the patch by bank and name; with `sound-engine` it rewrites the S-1's CC configuration.
- Press Play and the rig sounds like last time, with no SysEx and no Max for Live in Live.

**Phases:** P2 (smart PC).

### S6 — Software synths without plugins in Live
**Context:** you want to use software synths, but without VSTs inside Live (stability, licenses, portable sets).
**How it works:**
- The synths run standalone and get MIDI from SY.CORE through a virtual cable (Virtual Instruments).
- Live sequences them as if they were hardware, through the `SYC IN` lanes. Audio comes back into Live through the audio interface (loopback) or VB-Cable or BlackHole.
- If a synth crashes, Live and the rest of the rig carry on.

**Phases:** **today** for routing; P2 for the lanes; §10 for audio.

### S7 — Two control surfaces, two brains
**Context:** Push controls Live (clips, mixer); a second controller drives SY.CORE's apps.
**How it works:**
- SY.CORE's MIDI Actions map the second controller to slots A–H, Fill, Repeater, Generate, Bass Line mute and the Note Latch stop.
- Alternatively, the same actions come from Live's control clips (Control Map), so they can be recorded and automated in the arrangement.

**Phases:** **today** with MIDI Actions; P3 for bar quantization and the Control Map; P7 for the Push script.

### S8 — Live crashes, the music goes on
**Context:** on stage, Live crashes in the middle of a song.
**How it works:**
- With the `continue on INT` option, SY.CORE detects the clock loss and carries on with its internal clock at the last BPM.
- The apps and the hardware synths keep playing, so drums, bass and chords don't stop.
- You restart Live, press Play, and SY.CORE re-locks to the new Start.
- Only the audio that went through Live is lost, not the MIDI and hardware side of the rig.

**Phases:** P1 (clock loss).

### S9 — Rehearsals and teaching with a backing track
**Context:** a band rehearsal or a lesson: Live plays the backing track, SY.CORE the variable rhythm and harmony section.
**How it works:**
- The apps follow Live; changing slot or style changes the groove without touching the arrangement.
- Key follow on ch 15 transposes Sequencer and Chord Seq, to rehearse the song in another key.

**Phases:** P1, P3.

### Summary

| Scenario | Today | With the MVP (P1–P4, P6) | With P5 / P7 |
|---|---|---|---|
| S1 Hybrid live set | — | ✅ | scenes → sections, M4L |
| S2 Always-recording jam | partial (MIDI Capture) | ✅ | — |
| S3 Writing with AI | ✅ via `.mid` | ✅ in real time | rig-aware AI |
| S4 One keyboard for the whole rig | ✅ | ✅ with offset | — |
| S5 Total recall of sounds | — | ✅ | — |
| S6 Software synths without VSTs | ✅ routing | ✅ lanes | — |
| S7 Two control surfaces | ✅ MIDI Actions | ✅ Control Map | Push script |
| S8 Live crashes, the music goes on | — | ✅ | — |
| S9 Rehearsals with a backing track | — | ✅ | — |
