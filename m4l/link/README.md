# SY.CORE Link — device (protocol v1)

Bridge between SY.CORE (browser) and Live, without virtual MIDI ports. Protocol: [`docs/link-protocol-v1.md`](../../docs/link-protocol-v1.md).

| File | Cosa fa |
|---|---|
| `sycore-link.js` | Server WebSocket su `ws://127.0.0.1:9400` in Node for Max; con `--sim` gira in Node puro con un Live simulato |
| `link-core.js` | Parte pura: transport di Live, timing dei messaggi MIDI, note che suonano (per `clear`) |
| `link-core.test.js` | Test (`npm test`) |
| `sycore-link.maxpat`, `make-patch.mjs` | Patch del device pronta da incollare, e lo script che la genera |

## Costruire il device
Come lo spike (`../spike/README.md`), con questa cartella e questi nomi: Max MIDI Effect → Edit → cancella `midiin`/`midiout` di default → apri `sycore-link.maxpat`, Ctrl+A, Ctrl+C, chiudi **senza salvare** → Ctrl+V nel device → Save As `sycore-link.amxd` **in questa cartella**. Console Max: `SY.CORE Link 1.0.0 on ws://127.0.0.1:9400 (Max)`.

Lo spike e questo device usano la stessa porta: tienine attivo uno solo.

## Device pronto
`node make-patch.mjs && node make-amxd.mjs` → `sycore-link.amxd`: un Max MIDI Effect già fatto, da trascinare su una traccia MIDI di Live (niente editor). Lo script va tenuto in `C:/Users/swina/Documents/sycore-link/` (percorso completo nella patch).
