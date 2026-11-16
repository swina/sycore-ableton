# sycore-ableton

[SY.CORE](https://github.com/swina/sycore-refactor) inside Ableton Live: the Max for Live devices (**SY.CORE Link**), the integration plan and the *SY.CORE Live* paper.

SY.CORE runs in the browser (Drum Machine, Chord Prog, Sequencer, Arpeggiator, Rig Controller); with SY.CORE Link it follows Live's clock and plays on Live's tracks, on time, with no virtual MIDI ports and no plugins. The SY.CORE app code lives in `sycore-refactor`; this repo holds what sits in and around Live.

## Download

**[SY.CORE Live Devices 1.8.0](https://github.com/swina/sycore-ableton/releases/tag/link-v1.8.0)**: a zip with the four devices.

| Device | What it does | How many |
| --- | --- | --- |
| `sycore-link.amxd` | **SY.CORE Link**, the bridge: Live's transport and tempo to SY.CORE, SY.CORE's notes into Live on Live's beat | one per set |
| `sycore-link-receive.amxd` | **SY.CORE Link Receive**: plays one MIDI channel (1–16) from SY.CORE on its track | one per track that plays SY.CORE |
| `sycore-rig.amxd` | **SY.CORE Rig**: the Rig Controller's Launchpad layout inside Live, with Now / Next | optional |
| `sycore-map.amxd` | **SY.CORE Map**: your encoders on the instrument of the selected track, by table | optional, one per set |

Requirements: Live 12 with Max for Live, Chrome or Edge with SY.CORE open, Windows 10/11 (macOS expected to work, not yet tested). Install and setup: [`m4l/link/README-USER.md`](m4l/link/README-USER.md); the full guide is the **Ableton Live** guide in SY.CORE (Help).

## Contents

| Path | What it is |
| --- | --- |
| `m4l/link/` | **SY.CORE Link**: the four devices (`.amxd`, generated from `.maxpat` by `make-patch.mjs` / `make-amxd.mjs`), the bridge (`sycore-link.js`, logic in `link-core.js` with tests: `npm test`), the Rig and Map scripts, `npm run package` for the release zip ([developer notes](m4l/link/README.md), Italian) |
| `docs/link-protocol-v1.md` | The WebSocket protocol between SY.CORE and the bridge (`127.0.0.1:9400`) |
| `paper/` | *SY.CORE Live*, the paper for musicians ([EN](paper/SYCORE_LIVE_paper_EN.md), [IT](paper/SYCORE_LIVE_paper_IT.md)) |
| `ABLETON_INTEGRATION_PLAN.md`, `PIANO_INTEGRAZIONE_ABLETON.md` | The integration plan (EN, IT): phases, decisions, status |
| `m4l/spike/`, `m4l/port-spike/`, `m4l/map-spike/` | The spikes that validated the bridge, the port and the Map's LiveAPI (kept for reference) |

## License

The Live devices are [GPL-3.0](LICENSE). SY.CORE itself is MIT.
