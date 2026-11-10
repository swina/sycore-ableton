# SY.CORE Link — device (protocol v1)

Bridge between SY.CORE (browser) and Live, without virtual MIDI ports. Protocol: [`docs/link-protocol-v1.md`](../../docs/link-protocol-v1.md).

| File | Cosa fa |
|---|---|
| `sycore-link.js` | Server WebSocket su `ws://127.0.0.1:9400` in Node for Max; con `--sim` gira in Node puro con un Live simulato |
| `link-core.js` | Parte pura: transport di Live, timing dei messaggi MIDI, note che suonano (per `clear`) |
| `link-core.test.js` | Test (`npm test`) |
| `sycore-link.maxpat`, `make-patch.mjs` | Patch del device pronta da incollare, e lo script che la genera |
| `sycore-rig-grid.js` | La griglia del Rig Controller (`jsui`) usata da `sycore-rig.amxd` |

## Costruire il device
Come lo spike (`../spike/README.md`), con questa cartella e questi nomi: Max MIDI Effect → Edit → cancella `midiin`/`midiout` di default → apri `sycore-link.maxpat`, Ctrl+A, Ctrl+C, chiudi **senza salvare** → Ctrl+V nel device → Save As `sycore-link.amxd` **in questa cartella**. Console Max: `SY.CORE Link 1.0.0 on ws://127.0.0.1:9400 (Max)`.

Lo spike e questo device usano la stessa porta: tienine attivo uno solo.

## Device pronto
`node make-patch.mjs && node make-amxd.mjs` → `sycore-link.amxd`: un Max MIDI Effect già fatto, da trascinare su una traccia MIDI di Live (niente editor). Lo script va tenuto in `C:/Users/swina/Documents/sycore-link/` (percorso completo nella patch).

## La griglia del Rig in Live: SY.CORE Rig
`sycore-rig.amxd` (MIDI Effect, su una traccia qualsiasi, anche più di uno): la slot grid del Rig Controller di SY.CORE — righe Chord, Drum, Seq, Bass, Arp × slot A–H, M / S / GEN per riga (G nel device), Sections 1–8 e FILL (il Fill del Drum Machine: lampeggia mentre suona) — con gli stessi colori (pieno ambra, in play verde, in attesa/armato lampeggiante, mute rosso). Un clic fa quello che fa il pad nel pannello (Trigger sync, attesa con Live fermo, Sections). In alto l'**accordo in corso** con la sua durata e il **prossimo** (`NOW Cmaj7 1/1  NEXT Am7 1/2`) con una barra di avanzamento: verde, arancione dall'80 % dell'accordo, una tacca per battuta. **OPEN** apre la finestra flottante **SY.CORE RIG**: titolo, NOW / NEXT allineati ai pad con la barra sotto, etichette a sinistra, pad A–H (pieni: ambra scuro con lettere ambra) e M / S / GEN staccati a destra, Sections 1–8 e FILL in fondo. Il Solo: suona solo la riga in solo, le etichette delle altre si attenuano.

Passa dal device `sycore-link` del set (dentro Max: `[s sycore_rig]` / `[s sycore_rig_in]`), nessuna connessione in più. Funziona mentre in SY.CORE è aperto il **Rig Controller** (anche ridotto a icona); senza, la griglia dice *Open the Rig Controller in SY.CORE*. `sycore-rig-grid.js` va nella stessa cartella dello script (percorso completo nella patch).

## Più tracce: SY.CORE Link Receive
`sycore-link-receive.amxd` (MIDI Effect): mettilo sulle altre tracce MIDI e scegli il canale nella griglia 1–16. Riceve dal device `sycore-link` del set (uno solo, su una traccia qualsiasi) i messaggi già messi a tempo e fa passare solo quel canale. Anche `sycore-link` ha il suo **Channel** per la propria traccia (All = tutto, come prima).

In SY.CORE ogni app va su **Live (M4L)** in MIDI Flow con il suo canale (OUT CH del cavo), per esempio:

| App | Canale | Traccia Live |
|---|---|---|
| Drum Machine | 10 | Receive ch 10 → Drum Rack |
| Chord Prog | 1 | Receive ch 1 → strumento |
| Sequencer | 2 | Receive ch 2 → strumento |

Il canale si salva col set (parametro di Live). I device suonano solo il MIDI di SY.CORE: l'input della traccia non passa (prima passava, e con MIDI From = All Ins i tasti e i CC del controller, per esempio il CC#111 che seleziona l'accordo 1, arrivavano come note al Drum Rack).

Disposizione per registrare (verificata in Live):

| Traccia | MIDI From | Monitor | Device |
|---|---|---|---|
| SYC Drums | **No Input** | In | Receive ch 10, nessuno strumento |
| Drums | SYC Drums, **Post FX** o Post Mixer | Auto, armata | Drum Rack |
| SYC Chords | **No Input** | In | Receive ch 1, nessuno strumento |
| Chords | SYC Chords, **Post FX** o Post Mixer | Auto, armata | strumento |
| Arp by Chord, Bass Arp… | Chords, Post FX | Auto | arpeggiatore + strumento |

Le note escono dal Receive (Post FX), quindi la traccia che registra le prende già filtrate per canale e messe a tempo.

## SY.CORE Map (P12)
`sycore-map.amxd` (MIDI Effect, **uno per set**, su una traccia qualsiasi; il MIDI della traccia passa): comanda lo strumento di una traccia **a tabella** — slot *n* → un parametro dello strumento, per `original_name`. **FOLLOW** segue la traccia selezionata in Live; spento (**LOCK**) resta sullo strumento attuale. Una traccia senza strumento (anche quella del device) lascia l'ultimo. Un **Rack con Macro mappate** → le sue 16 Macro (con le etichette); un Rack senza → il primo strumento nelle sue catene. Tabelle di fabbrica dentro il device per Drift, Analog, Simpler (quelle di SY.CORE le sostituiscono); senza tabella: *NO TABLE*. I 16 slot mostrano nome e valore; **trascina** uno slot in su / giù per muoverlo. Parla con il bridge `sycore-link` (1.2.0) dentro Max: le tabelle e gli encoder da SY.CORE, lo strumento e i valori verso SY.CORE. Script: `sycore-map.js` (`jsui`, Live API) in questa cartella.

