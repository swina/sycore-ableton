# SY.CORE Live

*The generative part of your set, inside Ableton Live, while you play*

November 4, 2026, updated November 16, 2026 · Devices: SY.CORE Live Devices 1.8.0 · Italian version: [SYCORE_LIVE_paper_IT.md](SYCORE_LIVE_paper_IT.md) · Online version: https://claude.ai/artifact/HW1Hr9GHfMYk7pxcBc78sc

## In short

SY.CORE is a performance environment that runs in the browser: a Drum Machine with bass lines and fills, a Chord Prog, a step Sequencer, an Arpeggiator and a **Rig Controller** that launches them like clips. **SY.CORE Live** puts it inside an Ableton Live set: SY.CORE follows Live's clock and plays on Live's tracks, through a Max for Live device, **SY.CORE Link**.

Live stays the DAW: it records, arranges, mixes and plays your instruments. SY.CORE generates and changes the parts **while the song plays**, in time with Live, and everything it plays is recorded in Live as ordinary MIDI clips.

**Who it is for:** musicians who play live or jam with Live and want generative parts on stage, not only in the studio; and anyone who wants their controllers to drive the whole rig, not one device at a time.

**Status:** available today. The devices are at version 1.8.0, as a zip (GitHub release `link-v1.8.0`); SY.CORE opens from its address in Chrome or Edge. The *Status and roadmap* section lists what is done and what is still open.

## The problem: generate first, play later

There are many MIDI generators, AI-based ones included, and nearly all of them work upstream of the performance: you generate a clip, drag it onto a track, and only then launch it. A different progression or an unplanned break in the middle of a set means going back to the editor.

The rest of the rig has its own weak spots when you play live:

| Area | With Live alone | Effect on stage |
| --- | --- | --- |
| Generation | Clip generators and Live 12's MIDI Generators work while you edit, not while the song plays | No patterns that change on the bar without stopping |
| Controllers | A knob is mapped to one parameter of one device; a new track, set or synth means mapping again | Every set starts with remapping |
| Performance | Session View launches clips; nothing launches, thins out or regenerates a *generator* | Build-ups and breaks need prepared clips |
| External tools | A browser app reaches Live through virtual MIDI ports: their timing, their setup, ports that aren't multi-client on Windows | Notes off the grid, fragile setups |

None of this concerns Live's audio. It concerns what happens around it, and that is the space SY.CORE fills.

## The solution: SY.CORE Link

```
SY.CORE (browser)                          Ableton Live
┌──────────────────────┐   WebSocket   ┌───────────────────────────────┐
│ Drum Machine  ch 10  │ ───────────▶  │ SY.CORE Link        (bridge)   │
│ Chord Prog    ch 1   │  127.0.0.1    │   ├─▶ Link Receive ch 10       │──▶ Drum Rack
│ Sequencer     ch 2   │    :9400      │   ├─▶ Link Receive ch 1        │──▶ synth
│ Rig Controller       │ ◀───────────  │   └─▶ …                        │──▶ …
└──────────────────────┘  Live's tempo, └───────────────────────────────┘
                          position, Play / Stop
```

- **SY.CORE Link** (`sycore-link.amxd`, one per set) runs a small server inside Live. It sends Live's transport to SY.CORE (Play, Stop, tempo, position, time signature) and receives SY.CORE's notes.
- SY.CORE **follows Live's clock** and sends each note **with the Live beat it must play on**: the device plays it on that beat, so the browser's delays don't move the notes.
- **SY.CORE Link Receive** (`sycore-link-receive.amxd`) sits on each track that plays a part and lets one MIDI channel through: Drums on 10, Chords on 1, and so on. Your own instruments play the notes: Drum Racks, Wavetable, Drift, hardware synths through External Instrument.
- **No virtual MIDI ports and no plugins.** SY.CORE is not a VST or AU: nothing to scan or authorize. In Live you drop in Max for Live devices.

**Measured timing** (Live 12, 120 BPM, a 34-bar take recorded in Arrangement): mean offset from the grid **+0.7 ms**, typical deviation about **±5 ms** (Live's own recording resolution), note lengths steady.

## Four devices

| Device | What it does | How many |
| --- | --- | --- |
| **SY.CORE Link** | The bridge: Live's transport and tempo to SY.CORE, SY.CORE's notes into Live on time. Status LED: amber waiting, green connected, red error | one per set |
| **SY.CORE Link Receive** | Plays one channel (1–16) of what SY.CORE sends, on its track | one per track that plays SY.CORE |
| **SY.CORE Rig** | The Rig Controller inside Live: the same 9×9 Launchpad layout, with the same labels and colours; a click is a pad press. Its window shows **NOW / NEXT** (the chord sounding and the next one) with the chord's progress bar | optional, any track |
| **SY.CORE Map** | Your encoders on the instrument of the track selected in Live, by table (see *Map your controller once*) | optional, one per set |

## For musicians

Press Play in Live and SY.CORE's apps play along. They are instruments you play, not clips you drag.

- **Generation during playback.** **GEN** writes a new drum pattern, progression or sequence on the fly, from the Launchpad, in the style chosen per slot. **Shift + GEN** (Mutate) rewrites only part of it, by the *Vary* amount, keeping the rest.
- **Eight slots per app, A–H**, launched like clips: a slot starts, switches or stops on the next sync point. With Live stopped, a pad **arms** the slot and Live's Play starts it.
- **Fill** plays a fill on the next bar; **Repeat** (held) repeats the drums; **Density** thins out drums and sequences with one knob, for build-ups, breaks and drops with nothing else prepared.
- **Chords one by one.** The Chord Prog generates progressions, algorithmic or with AI, and you can play them chord by chord from the pads. **Now / Next** always shows the chord sounding, the next one and how long each lasts.
- **The key from the Rig.** Key − / + moves the Chord Prog's tonic a semitone, Shift switches major ↔ minor, and the progressions GEN writes are in that key; the Sequencer's GEN follows it, and as it plays the Sequencer follows the Chord Prog's chords (transposing, by degree, or as an arpeggio of the chord sounding). **Seq Free** decouples it for a while to hold a riff over the changes.
- **Sequencer up to 64 steps**, a chain of 16 patterns, and generators with Melody (motif) or Classic lines, weighted, Euclidean or random rhythm.
- **Live's transport and tempo from the Rig.** The Rig's Play / Stop starts and stops Live itself; TAP, − / + and the tempo knob set Live's tempo.
- **Everything ends up in Live.** Record in Arrangement View and you get ordinary MIDI clips: you edit, quantize and reuse them. SY.CORE doesn't lock you into the browser.

## It speaks Live's language

| In Live you're used to… | In SY.CORE |
| --- | --- |
| Launching a clip from Session View | Launching slots A–H of Drum, Chord, Seq, Bass and Arp from the pads |
| Global Launch Quantization | **Trigger sync** per track: off (at once), 1 beat, 2 beats, bar, on Live's song grid |
| Pressing a playing clip to stop it | The playing slot's pad stops the app, in time |
| Launching a clip with the transport stopped | The pad **arms** the slot: it starts with Live's Play |
| Scenes | **Sections 1–8**: one pad switches the slots of every app together |
| A Macro on a Rack | **Density**, **Intensity** (volume and velocity), Mute and Solo per track, also from a controller |

## The Rig Controller

A controller for the whole rig, not for one instrument. Rows **Drum, Chord, Seq, Bass, Arp**, slots A–H, Mute / Solo / GEN per row, the sections, Fill, Repeat, Seq Free, the key, Panic and the switch to the internal clock (on hold).

- **Three views of the same state:** the Rig layout in SY.CORE, a **Launchpad Mini MK1** (8×8 grid, LEDs always in step with SY.CORE, so after a disconnect it gets back in line by itself) and an **AKAI MIDImix** (strips of knobs, faders and buttons, with pickup). The SY.CORE Rig device shows the Launchpad layout inside Live.
- **Any other controller** through MIDI Learn (right-click on a control), saved and shared as **controller templates** (JSON).
- **The Bass row is a part of its own:** the Drum Machine's bass line, launched independently of the drums. **The Arp row** picks the arpeggio mode; its knobs set the octave range and the rate.
- **Performance workspace:** one stage screen with the players as *play views* (what plays, with the step and chord sounding lit; the Sequencer's steps coloured by velocity and switched on / off with a click), the Rig's controls with Now / Next above a big Play, and the Launchpad grid. Panels side by side, resizable by touch, lighter effects.

## Map your controller once

In Live a knob is mapped to one parameter of one device. With **SY.CORE Map**, encoder *n* always drives **slot *n*** of the instrument in focus:

- **It follows the selection:** select a track in Live and the encoders are on its instrument (FOLLOW); or LOCK them on a track and step through tracks from the controller.
- **One table per instrument type:** filter on 1, resonance on 2… on every Drift, Analog or Simpler (factory tables built in).
- **Racks and Live's presets:** the Rack's configured Macros first, with their names, then the instrument inside for the slots left; **Macro Variations** recalled or randomized from pads.
- **Pickup:** change track and turn, no jumps. The encoders move parameters as the mouse does: automation and the mouse keep working.
- **On a touch screen:** the Map panel shows the slots as tiles or as two rows of vertical faders.

## Compared with AI MIDI generator plugins

| | AI generator plugin | SY.CORE Live |
| --- | --- | --- |
| Result | MIDI clips to drag | Live playback in time, with changes on the bar, and clips recorded in Live |
| When it generates | Outside playback, one prompt at a time | During playback, from the pads, with built-in generators or AI |
| Parts | Usually one at a time | Drums, bass, chords, sequences and arpeggios that share key and chords |
| Instruments | Whatever is loaded in the DAW | Live's instruments, hardware and software synths |
| In the DAW | A VST or AU plugin | Max for Live devices on ordinary MIDI tracks |
| AI | The product's own service | The provider you choose, with your own key; the built-in generators work offline |

The comparison covers the product category; individual plugins change from version to version.

## Requirements and setup

| | |
| --- | --- |
| **Ableton Live** | Live 12 with Max for Live (Suite, or Standard + Max for Live) |
| **Browser** | Chrome or Edge, with SY.CORE open; allow *local network access* if Chrome asks (SY.CORE talks to the bridge on `127.0.0.1:9400`) |
| **System** | Windows 10/11 (tested) or macOS (expected to work, not yet tested) |
| **Devices** | SY.CORE Live Devices 1.8.0: a zip, from the GitHub release `link-v1.8.0` or the *Ableton Live* page of the SY.CORE website |

**Setup:**

1. **Install the devices.** Unzip them, keep the files together, put the folder in the User Library or add it under Places.
2. **Drag SY.CORE Link** onto a MIDI track (e.g. *SY.CORE Control*): the LED turns amber, then green when SY.CORE connects.
3. **Drag SY.CORE Link Receive** onto each track that plays a part and click its channel.
4. **In SY.CORE**, pick the clock source **EXT · Live (M4L) — SY.CORE Link** and, in MIDI Flow, cable the apps to **Live (M4L)** with the receivers' channels.

**Good to know:** play live in **Session View** (in Arrangement, Live's Play also plays the clips already there); record in Arrangement with a **1-bar Count-In** (the first note after Play can be a few tens of ms late). The Launchpad used by the Rig must not be a Live Control Surface. The sync grid counts bars in 4/4.

## Status and roadmap

| Stage | What it includes |
| --- | --- |
| **Available today** | SY.CORE Link 1.8.0 (bridge, Receive, Rig, Map) as a zip; SY.CORE follows Live's clock, tempo and position; Live's Play / Stop and tempo from the Rig; Rig Controller with Launchpad Mini MK1, AKAI MIDImix, MIDI Learn and controller templates; per-track Trigger sync, Mute, Solo, Intensity, Density; sections; GEN and Mutate during playback; Seq Free; Now / Next; Performance workspace; SY.CORE Map with tables for Drift, Analog, Simpler and Racks; the Sequencer's P1 / P2 on Map slots of any track (1.8); recording in Live as MIDI clips |
| **Next** | Rig scenes: a slot or a section that also recalls sounds and routing; recall from Live's locators or scenes, with chase when starting mid-song; per-device Program Change rules; a table editor for SY.CORE Map and VST instruments |
| **Later** | Live scenes as Song Composer sections; AI that knows your rig's synths and presets; a Live Set template; macOS testing; OSC for tablet surfaces |

## Principles

SY.CORE extends an instrument's voice, it doesn't replace it. SY.CORE Live applies the same principle to Ableton Live.

- **Local-first.** Patterns, presets, routing and mappings stay on the computer in front of you. SY.CORE talks to Live on `127.0.0.1`; AI is an option, and the built-in generators work offline.
- **No plugins.** SY.CORE opens in the browser; in Live there are only Max for Live devices on ordinary MIDI tracks.
- **Open source.** SY.CORE is MIT-licensed; the Live devices are GPL-3.0. They can be read, checked and extended.
- **Donationware.** No Pro version and no locked features: donations are a thank-you, not a toll.
