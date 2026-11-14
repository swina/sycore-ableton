# SY.CORE devices for Ableton Live

Max for Live devices that connect [SY.CORE](https://sycoreapp.vercel.app) (in your browser) to Ableton Live: no virtual MIDI ports, no plugin to install.

| Device | What it does | How many |
|---|---|---|
| `sycore-link.amxd` | **SY.CORE Link**, the bridge: Live's transport and tempo to SY.CORE, SY.CORE's notes into Live on time | **one per set**, on a MIDI track |
| `sycore-link-receive.amxd` | **SY.CORE Link Receive**: plays one MIDI channel (1–16) from SY.CORE on its track | one per track that plays SY.CORE |
| `sycore-rig.amxd` | **SY.CORE Rig**: the Rig Controller's slot grid inside Live (pads, Now / Next chord, Sections, Fill) | optional, any track |
| `sycore-map.amxd` | **SY.CORE Map**: your encoders on the instrument of the selected track, by table | optional, one per set |

## Requirements

- Ableton Live 12 with Max for Live (Suite, or Standard + Max for Live).
- Windows 10/11 or macOS (tested on Windows; macOS should work but has not been tested yet).
- Chrome or Edge, with SY.CORE open. Allow *local network access* if Chrome asks: SY.CORE talks to the bridge on `127.0.0.1:9400`.

## Install

1. **Unzip** the folder `SYCORE-Live-Devices-<version>` and keep its files together: the devices load the scripts and `node_modules` next to them.
2. **Put it where Live can see it**, for example in your User Library:
   - Windows: `Documents\Ableton\User Library\Presets\MIDI Effects\Max MIDI Effect\`
   - macOS: `~/Music/Ableton/User Library/Presets/MIDI Effects/Max MIDI Effect/`

   (Or any folder, added to Live's browser with *Add Folder…* under Places.)
3. In Live's browser, drag **`sycore-link.amxd`** onto a MIDI track (e.g. a track called *SY.CORE Control*). Its LED turns **amber** (waiting for SY.CORE), then **green** once SY.CORE connects.
4. Drag **`sycore-link-receive.amxd`** onto each track that should play a SY.CORE app and click its channel: e.g. Drums 10, Chords 1, Sequencer 2.
5. In SY.CORE: the clock source **EXT · Live (M4L) — SY.CORE Link**, and in **MIDI Flow** cable each app to **Live (M4L)** with the cable's OUT channel matching the receiver.

Press Play in Live: SY.CORE plays along.

## Updating

Quit Live, replace the folder's files with the new version's (if Live was open, `node_modules` may be locked: close Live first), open Live again, reload SY.CORE.

## Good to know

- **Launchpad in SY.CORE's Rig mode**: in Live's *Settings › Link, Tempo & MIDI*, set its **Control Surface to None** and turn off its Track / Remote. With the *Launchpad* surface on, Live launches and records its own clips from the pads, even with the ports off. Live saves these settings only when it quits cleanly (*File › Quit*): check them again after a crash.
- Only one SY.CORE Link per set (port 9400). A second one, or another app on that port, turns the LED red.
- To record what SY.CORE plays: a track with the Receive and no instrument (*MIDI From: No Input*, Monitor In), and the recording track's *MIDI From* = that track, **Post FX**.

Full guide: the **Ableton Live** guide in SY.CORE (Help), or the *Ableton Live* page of the SY.CORE website.
