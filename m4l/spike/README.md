# SY.CORE Link — spike (P11, step 1)

Prova se un device Max for Live può fare da ponte tra Live e SY.CORE via **WebSocket su localhost**, senza porte MIDI virtuali. Misura tre cose:

1. **Connessione dal browser:** da `http://127.0.0.1` (sicuro) e da una pagina **https** (Chrome *Local Network Access*: blocco o richiesta di permesso?).
2. **Latenza:** RTT dei ping browser ↔ device.
3. **Timing delle note:** le note partono dal browser in anticipo (lookahead) con la loro posizione in beat; il device misura con quanto anticipo arrivano (`lead`) e le emette nello scheduler di Max (`pipe`). Poi si registra la traccia in Live e si confronta con la griglia, come per CLK SYS.

## File
| File | Cosa fa |
|---|---|
| `sycore-link-spike.js` | Server WebSocket + pagina di test sulla porta 9400. In Node for Max riceve il transport di Live e manda le note a Max; con `--sim` gira in Node puro con un Live simulato a 120 BPM |
| `test.html` | Pagina di test (servita anche da `http://127.0.0.1:9400/`): Connect, Ping test, Note test 1/16 per 8 battute |
| `sycore-link-spike.maxpat`, `make-patch.mjs` | La patch del device, pronta da incollare, e lo script che la genera |
| `bench.mjs` | Lo stesso test da riga di comando, senza browser né Live (`npm run sim`, poi `npm run bench`) |

Risultato in simulazione (WSL, 2026-11-08): ping 200/200, RTT medio 0,3 ms, max 1,2 ms; note arrivate 90–96 ms prima del beat (lookahead 100 ms), nessuna in ritardo.

## Costruire il device in Live
Patch già pronta: `sycore-link-spike.maxpat` (generata da `node make-patch.mjs`). Una copia della cartella, con `node_modules`, è in `C:\Users\swina\Documents\sycore-link-spike`.
1. In Live: una traccia MIDI con uno strumento → trascina un **Max MIDI Effect** → **Edit**.
2. Nell'editor Max: **File › Open** `sycore-link-spike.maxpat` → nella patch aperta sblocca (Ctrl+E), **Ctrl+A**, **Ctrl+C** → torna al device, cancella gli oggetti di default (`midiin`/`midiout`), **Ctrl+V**.
3. **Salva il device in quella cartella** come `sycore-link-spike.amxd` (così `node.script` trova lo script), bloccalo e chiudi l'editor.
4. Nella console di Max: `SY.CORE Link spike on ws://127.0.0.1:9400 (Max)`. Se manca `ws`, clicca il message box `script npm install`, poi `script start`.

Cosa c'è nella patch: `live.thisdevice` → `path live_set` → `live.path` → tre `live.observer` (is_playing, current_song_time, tempo) → `pak` → `prepend transport` → `node.script`; uscita → `route note status`; `note` → `pipe 0 0 0 0` (l'ultimo elemento è il ritardo in ms) → `makenote` → `pack` → `midiformat` → `midiout`; `status` → numero di client; `midiin` → `midiout` per il MIDI della traccia.

## Prova
1. Live in **Play**.
2. Chrome su Windows: apri `http://127.0.0.1:9400/` → **Connect** (la riga *Live* deve seguire i beat) → **Ping test** → **Note test** con la traccia in registrazione.
3. Annota: RTT (avg / p99 / max), le righe `device: … notes on time, … late · lead min / avg`, e lo scostamento delle note registrate rispetto alla griglia di Live.
4. Ripeti con la finestra di Chrome in background e con SY.CORE aperto in un'altra scheda.
5. **Test https:** la stessa pagina aperta da un indirizzo https deve collegarsi a `ws://127.0.0.1:9400`. Da annotare: si collega, viene chiesto un permesso, o è bloccata (errore in console).

## Da sapere
- Lo spike accetta connessioni da qualunque pagina (registra solo l'`Origin`). Nella versione vera servirà un elenco di origini permesse.
- Se le note registrate oscillano anche con `lead` sempre positivo, il limite è il passaggio Node → Max (IPC) o la risoluzione di `pipe`. Prossimo tentativo: scheduling sui tick del transport di Max invece che in ms.
