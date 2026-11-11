# SY.CORE Link — spike "porte MIDI sul beat di Live"

**Domanda:** il bridge (Node for Max, un processo separato da Chrome) può mandare MIDI a una porta (Emulator X3, `SYC OUT A`…) **sul beat di Live, con poco jitter**? Se sì, un cavo di MIDI Flow verso una porta potrà andare "via SY.CORE Link": SY.CORE manda in anticipo con beat e porta, il bridge lo suona in tempo — senza il main thread del browser in mezzo.

Perché (2026-11-11): Chords → Ableton (Link) suona pulito; Chords → Ableton + Emulator X3 ha jitter. Verso l'X3 i messaggi partono dalla coda del browser (le loopback di Windows MIDI Services ignorano i timestamp di Web MIDI): 5–20 ms di ritardo variabile, picchi di 40–240 ms. In Live si può pilotare l'X3 da una traccia, ma una traccia = un canale: con gli strumenti multipart MIDI Flow è molto più semplice.

## Cosa fa
`port-spike.amxd` (Max MIDI Effect) segue il transport di Live e, mentre Live suona, manda **un accordo di Do (C E G, gate 90 %) su ogni beat** alla porta e al canale scelti. Ogni secondo scrive nella console di Max e nel device:

```
port-spike: sends 6 late avg 0.12 / p95 0.30 / max 0.41 ms · SYC OUT A ch 1 · playing 110.0 BPM
```

`late` = quanto dopo il suo tempo è partito ogni messaggio: **la qualità del timer** di Node su Windows (il rischio principale: 1 ms o 15,6 ms di granularità). Un timer di sistema sveglia lo script 2 ms prima, poi un'attesa attiva breve.

Il MIDI della traccia passa (`midiin` → `midiout`).

## Preparazione
1. Copia **tutta la cartella** `m4l/port-spike` (con `node_modules`: dentro ci sono già i binari Windows di `@julusian/midi`) in `C:\Users\swina\Documents\sycore-port-spike`.
2. In Live: trascina `port-spike.amxd` su una traccia MIDI qualsiasi.
3. Console di Max: `port-spike 0.0.1 (Max) · node v… · ports: …` con l'elenco delle porte. Se dice che `@julusian/midi` manca: clic su `script npm install`, poi `script start`.
4. Clic su **`port X3`** (o `port SYC OUT A`): apre la prima porta il cui nome contiene quel testo. `ports` riscrive l'elenco. Per un'altra porta: modifica il message box (`port <nome>`). `channel 1` → il canale (modifica il numero per la parte dell'X3).

## Prove
**A — il timer.** Live in Play, porta aperta. Leggi le righe `late avg / p95 / max` per 20–30 s.
- p95 sotto ~1 ms → il timer va bene.
- valori intorno a 10–16 ms → granularità di Windows a 15,6 ms: lo spike si ferma qui (serve un'altra strada).

**B — all'orecchio, con l'X3.** `port X3`, canale di una parte dell'X3 con un suono a attacco secco. Live in Play con il metronomo: l'accordo deve cadere sul click senza oscillare. Poi apri SY.CORE e fallo suonare (pannelli aperti, cambi di finestra): lo spike non deve risentirne.

**C — misura in Live (consigliata).** `port SYC OUT A` (loopback): una traccia MIDI di Live con **MIDI From: SYC OUT B**, Monitor Off, in registrazione. Registra 8 battute e mandami il `.mid`: misuro lo scarto di ogni accordo dalla griglia, come per `Chords 22.mid`.

Annota anche: la versione di Node nella console, e se Chrome con SY.CORE aperto sulla stessa porta dà problemi (Windows MIDI Services è multi-client: dovrebbe andare).

## Standalone (senza Live)
`node port-spike.js --standalone [--port "SYC OUT A"] [--bpm 110] [--channel 1]` con Node per Windows: un clock suo a quel tempo, per misurare solo il timer.

## File
| File | Cosa fa |
|---|---|
| `port-spike.js` | Lo script (Node for Max o Node standalone) |
| `make-device.mjs` | Genera `port-spike.maxpat` e `port-spike.amxd`, copia `../link/link-core.js` (il `Transport` del bridge) |
| `package.json` | Dipendenza: `@julusian/midi` (RtMidi, N-API, binari inclusi) |
