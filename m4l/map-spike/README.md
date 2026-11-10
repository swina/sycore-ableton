# P12 spike — SY.CORE Map

Un solo device che comanda lo strumento della traccia selezionata per tabella: slot *n* → un parametro (per `original_name`) mosso con `live.remote~`. Piano: §P12 di `ABLETON_INTEGRATION_PLAN.md`.

| File | |
|---|---|
| `sycore-map-spike.js` | `[js]` con la Live API: Follow sulla traccia selezionata, primo strumento (anche dentro un Rack), parametri, tabella, tempi |
| `make-patch.mjs` | genera `sycore-map-spike.maxpat` e `.amxd` (`node make-patch.mjs`) |

Cartella su Windows: `C:\Users\swina\Documents\sycore-map-spike` (percorso dello script nella patch; `SYCORE_MAP_DIR` per cambiarlo).

## Test in Live
1. Trascina `sycore-map-spike.amxd` su una traccia MIDI qualsiasi (lascia passare il MIDI della traccia).
2. Crea 3–4 tracce: **Wavetable**, **Drift**, **Operator**, e un **Instrument Rack** con dentro uno strumento.
3. Con **Follow** acceso seleziona le tracce una per una. La prima riga mostra `traccia › (Rack ›) strumento (class_name) · n/16`, la seconda i tempi: `devices` (ricerca dello strumento), `params` (lettura dei parametri), `remotes` (16 `live.remote~` ripuntati), `total`.
4. **Slot 1** (la manopola) muove il primo parametro della tabella: guardalo muoversi nello strumento.
5. **Sweep** muove i 16 slot insieme ogni 25 ms: guarda la CPU di Live; cambia traccia mentre gira.
6. **dump** scrive nella Max Console tutti i parametri dello strumento (`original_name  [nome mostrato]  min…max`): mandami quello di Wavetable, Drift e Operator, servono per le tabelle di fabbrica.

Da riportare: i tempi del punto 3 per ogni strumento, se Slot 1 e Sweep muovono i parametri, la CPU con Sweep, cosa succede col Rack, eventuali errori in Max Console (`map spike: no "…"` = un nome della tabella di prova che non esiste).
