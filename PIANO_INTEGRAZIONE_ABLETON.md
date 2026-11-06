# SY.CORE × Ableton Live — Piano di integrazione

*Rev. 7 · 2026-11-06 · Repository di riferimento: `D:\personal\apps\sycore-refactor` (branch `feat/rig-controller-ui`, merge `8cf2a2d`; F1 completata, scheduler nel Worker compreso, vedi §4)*
*Questo piano vive fuori dal repository. Gli eventuali tool esterni (bridge, device Max for Live, template) andranno in `D:\personal\apps\sycore-ableton\`. Versione inglese: `ABLETON_INTEGRATION_PLAN.md`.*

---

## 1. Obiettivo

Ableton Live resta il DAW: arrangiamento, registrazione, mix, Session View. **SY.CORE diventa il cervello MIDI del rig.**

1. **Hub di routing.** Tutto il MIDI fra Live e gli strumenti, hardware e software, passa da MIDI Flow di SY.CORE: split, filtri, fanout multicanale, Note Latch, Program Change con i banchi del dispositivo. In Live non serve nessun plugin VST di terze parti: bastano tracce MIDI e il device nativo **External Instrument**. Gli strumenti nativi di Live (Wavetable, Drift, Operator, Simpler, Drum Rack…) restano utilizzabili, anche dalle app di SY.CORE (§10.4).
2. **App MIDI di SY.CORE come strumenti generativi dentro Live.** Chord Sequencer, Drum Machine (con Bass Line), Sequencer e Arpeggiator suonano a tempo con Live, sono controllati dalle clip e dalle scene di Live e rimandano il loro output a Live per la registrazione.
3. **Generazione built-in e AI** (Song Composer, AI groove, stili, euclideo) usata *dal vivo e nel contesto del rig*, non come generatore di file da trascinare.
4. **Superare i limiti dei generatori MIDI come MIDI Agent** (vedi §7).

### 1.1 Perché: i limiti reali di Live oggi (live, jam, registrazione in studio)

In breve: il motore audio di Live, la Session View e la registrazione funzionano molto bene. I limiti veri stanno nel **livello MIDI del rig**: routing, stato dei synth hardware, sync, generazione in tempo reale e tenuta quando succede un imprevisto.

**1. Il computer è l'unico punto di rottura**
- I plugin non sono isolati: girano tutti nello stesso processo di Live, quindi se un VST si blocca si blocca il set intero (Bitwig, al contrario, li isola).
- CPU e buffer sono un compromesso: per suonare serve un buffer basso, ma un set pesante richiede un buffer alto. La compensazione del ritardo dei plugin aggiunge latenza a quello che si suona dal vivo.
- Licenze e set da portare in giro: un plugin con autorizzazione iLok che non si attiva, o mancante su un'altra macchina, apre il set con buchi.

**2. Il routing MIDI è "una traccia, un ingresso"**
- Ogni traccia ascolta una porta e un canale (o "All"). Non c'è una matrice di routing; split, layer e fanout verso più synth si ottengono solo con trucchi (più tracce armate, Instrument Rack con zone di tastiera, Max for Live).
- Durante una jam, cambiare quale tastiera suona quale synth significa ri-armare tracce e cambiare ingressi, nel momento peggiore.
- Il MIDI fra tracce si può instradare, ma è macchinoso e non permette trasformazioni senza Max for Live.

**3. I synth hardware sono "esterni" davvero**
- Live non salva lo stato dei suoni hardware: se riapri un set dopo tre mesi, i synth non tornano al suono che avevi.
- I Program Change sono solo numeri (Bank, Sub-Bank, Program 1-128 nelle proprietà della clip), senza i nomi delle patch e senza i banchi dei singoli dispositivi.
- Niente SysEx nativo: Live non invia né registra SysEx senza Max for Live, quindi niente dump di patch e niente parametri profondi.
- External Instrument funziona bene, ma serve una traccia per ogni synth e una per ogni canale multitimbrico.

**4. Sync**
- Live che segue un clock esterno è notoriamente instabile: il tempo oscilla e partire in fase è difficile. Per questo nel piano Live è sempre master.
- Il clock in uscita verso più dispositivi richiede ritocchi del ritardo di sync porta per porta. Su Windows le porte MIDI non sono multi-client, quindi due programmi sulla stessa porta creano conflitti.

**5. Generazione e improvvisazione**
- I generatori e le trasformazioni MIDI di Live 12 lavorano sulle clip in fase di editing, non in tempo reale mentre il brano suona.
- Per pattern che cambiano dal vivo, generazione in tempo reale o AI servono Max for Live o plugin di terze parti, come i generatori AI in plugin tipo MIDI Agent, che producono clip da trascinare.
- Capture MIDI recupera il MIDI suonato anche senza aver premuto Rec; per l'audio non c'è un equivalente, quindi se non eri in Rec quella take è persa.

**6. Registrare una jam multi-strumento**
- Bisogna preparare prima tracce, ingressi, armamento e monitoring per ogni sorgente: il setup "sempre pronto a registrare tutto" va costruito a mano.
- La registrazione di sequencer hardware dipende dal clock e dalla latenza del giro MIDI, senza un modo semplice per misurarla.

**Cosa copre SY.CORE e cosa no**

| Limite di Live | SY.CORE |
|---|---|
| Routing a ingresso singolo, split e fanout macchinosi | ✅ MIDI Flow: matrice, split, filtri, fanout, Note Latch |
| Nessun ricordo dei suoni dei synth, PC solo numerici | ✅ Sound Engine (S-1 via CC), banchi Multi Sound con i nomi delle patch, regole PC per dispositivo (F2) |
| SysEx | ✅ Web MIDI con SysEx (parser e import già presenti) |
| Plugin nello stesso processo di Live | ✅ con i synth hardware o standalone, Live non carica VST |
| Generazione solo in fase di editing | ✅ app che generano e cambiano slot durante la riproduzione, built-in o AI (F3, F5) |
| Live che segue un clock esterno è instabile | ✅ evitato: Live master, SY.CORE segue (F1) |
| Cambiare chi suona cosa durante una jam | ✅ configurazioni di Flow richiamabili, e in prospettiva dalle MIDI Actions |
| Latenza del giro MIDI non misurabile | ✅ loopback ping e offset per porta (F4, F6) |
| Audio, mix, take audio perse | ❌ resta compito di Live e della scheda audio |
| Il computer come unico punto di rottura | ⚠️ si aggiunge il browser come altro anello della catena: va reso robusto (scheduler in un Worker, finestra dedicata, rilevamento dei loop) |

**In sintesi:** Live è ottimo per registrare, arrangiare e mixare, ma come centro di controllo di un rig hardware e software è debole. È lo spazio che SY.CORE occupa senza chiedere a Live di diventare qualcos'altro.

## 2. Topologia

```
                 ┌──────────────────────────── Ableton Live (clock master) ─────────────────────────────┐
                 │ Tracce MIDI / External Instrument     Scene / clip di controllo   Tracce di registrazione │
                 └──────┬───────────────────────────────────────┬──────────────────────────▲─────────────┘
                        │ SYC IN (16 canali: note, CC, PC)       │ SYC CTRL (clock + azioni) │ SYC OUT (output app)
                        ▼                                        ▼                           │
 ┌─────────────────────────────────────────── SY.CORE — MIDI Flow ─────────────────────────────┴──────────────┐
 │  nodo "Ableton Live" (porta × canale)  ──►  split / filtri / fanout / Note Latch                          │
 │        │                                       │                     │                                    │
 │        ├─► app: Chord Seq · Drum Machine · Sequencer · Arp · Sampler ─┼─► fanout ─► SYC OUT (verso Live)   │
 │        └────────────────────────────────────────────────────────────►├─► synth hardware (USB / DIN)       │
 │                                                                      └─► synth software (standalone,      │
 │                                                                          via cavo virtuale)               │
 └───────────────────────────────────────────────────────────────────────────────────────────────────────────┘
   Audio: hardware → scheda audio → ritorno audio dell'External Instrument in Live
```

**Regola d'oro: SY.CORE possiede le porte hardware, Live vede solo porte virtuali.**
- Su Windows i driver MIDI classici non sono multi-client: se Live e Chrome aprono la stessa porta USB, uno dei due fallisce. In Live le porte hardware vanno quindi disattivate, così non c'è conflitto e non ci sono doppi percorsi.
- Porte virtuali (loopMIDI, oppure le loopback di Windows MIDI Services; IAC su macOS):

| Porta | Direzione | Uso |
|---|---|---|
| `SYC IN` | Live → SY.CORE | Fino a 16 canali (requisito: massimo 16 parti) di note, CC e PC dalle tracce di Live |
| `SYC CTRL` | Live → SY.CORE | Clock, Start/Stop, SPP e note o CC di controllo delle app. **Questa porta non viene mai inoltrata ai dispositivi** |
| `SYC OUT` | SY.CORE → Live | Output delle app per la registrazione in Live (Track ON, Sync e Remote OFF per evitare loop) |

## 3. Cosa c'è già e cosa manca

| Requisito | Stato | Riferimento |
|---|---|---|
| Routing device ↔ app, split per nota, filtro canale, fanout multicanale | ✅ | MIDI Flow (`MidiWizardFlow.vue`, `core/midi/midi-routing.ts`) |
| App con MIDI IN: Chord Seq, Sequencer, Drum Machine, Arp, Sampler, Note Latch | ✅ | `src/lib/midi-apps.js` |
| Porte virtuali e Virtual Instruments con porta reale associata | ✅ | `core/midi/midi-service.ts` |
| Protezione dai loop di feedback sulle porte virtuali | ✅ (parziale) | `midi-service.ts:259` |
| MIDI Actions (start, slot, preset da CC o Note) | ✅ | `src/lib/app-midi-actions.ts` |
| Generatori: stili, euclideo, AI groove, Song Composer | ✅ | `drum-engine.js`, `song-composer.ts`, `ai-service.ts` |
| Clock in con aggancio della fase (Live master) | ✅ (F1) | `core/midi/external-clock.ts`, `composables/useExternalClockSync.ts` |
| Song Position Pointer | ✅ (F1) | `core/midi/external-clock.ts` |
| **Nodo "DAW" in Flow con lane per porta e canale** | ❌ | — |
| **Mappa di controllo standard per le clip di Live** | ❌ (le Actions sono per singolo device) | — |
| **Output delle app sincronizzato verso Live per la registrazione** | ⚠️ funziona, ma serve compensare la latenza | — |
| **Scene di Live → sezioni del Song Composer** | ❌ | — |

## 4. Fasi

### Fase 1 — Live master clock, SY.CORE slave (3 giorni) · **bloccante**
Senza questa fase le app di SY.CORE non possono "vivere" dentro un set di Live.
- `clockSource: 'internal' | 'midi:<porta>'` nel transport globale (selettore nel pannello Global Transport, indicatore EXT/INT).
- `0xFA` avvia, `0xFC` ferma, `0xFB` riprende e `0xF2` (SPP) riposiziona tutte le app abilitate nella matrice Sync, partendo dal downbeat giusto.
- `Tone.Transport.bpm` segue il BPM già smussato, con aggancio della fase a ogni battuta (96 tick), così si corregge la deriva senza inseguire il jitter dei singoli tick.
- Cambi di tempo in Live (automazione) seguiti entro una battuta.
- Lo scheduler va in un Worker, così il rallentamento dei timer nelle tab in background non ferma la musica (vale anche in modalità master).
- **Perdita del clock** (Live si blocca o la porta sparisce mentre il trasporto è in Play), con un'opzione per scegliere il comportamento:
  - `stop`, il default: le app si fermano;
  - `continua in INT`: le app proseguono con il clock interno all'ultimo BPM e il clock esterno si riaggancia al successivo Start di Live (scenario S8).
- **Test:** macchina a stati del trasporto, SPP, aggancio della fase con tick simulati e jitter di ±2 ms, perdita del clock.

#### 1.1 Stato (2026-11-06) — completata, branch `feat/rig-controller-ui`, commit `49c8dad`
- **Clock › Source** nel pannello Sync della barra del trasporto: Internal (INT) o un ingresso MIDI (EXT). Alla perdita del clock: *Stop the apps* (default) o *Continue on INT*.
- Start, Stop, SPP + Continue guidano le app abilitate in "Sync Apps to Transport"; partono sul primo clock dopo lo Start, o sulla battuta successiva di Live dopo un Continue a metà battuta.
- Tempo: regressione lineare sull'ultima battuta (jitter ±2 ms → meno di 0,1 BPM). Aggancio della fase a ogni battuta: correzione PI fino a ±8% del tempo, salto quando l'errore supera 1/4 di beat.
- La perdita del clock è controllata dal timer in Worker di Tone (funziona anche con la finestra in background); un controllo arrivato in ritardo perché il thread principale era bloccato viene saltato.
- In EXT SY.CORE non genera un proprio clock. L'opzione **Forward clock to devices** (spenta di default) inoltra clock, Start/Stop e SPP di Live alle uscite con Clock / Transport attivi, mai alla porta sorgente né alla sua gemella del loopback.
- Badge EXT/INT con BPM e posizione, avviso **AUDIO** quando il clock audio scende sotto il 97%, riga di diagnostica con **Copy diagnostics** (30 s di storico).
- **Provata con Live 12 su Windows MIDI Services** (`SYC CTRL A` → Live, `SYC CTRL B` → SY.CORE) a 75 BPM: errore di fase entro ±10 ms, nessun salto, con la finestra in focus o no, finché il clock audio resta vicino al 100%.
- **Corretto durante il lavoro** (un bug di `midi-service.ts`, tutti gli ingressi): il listener poteva restare agganciato a due oggetti della stessa porta, e ogni messaggio veniva elaborato due volte (Live a 75 BPM letto come 150).
- **Scheduler nel Worker — completato** (branch `feat/11-06/midi-worker-scheduler`, mergiato come `8cf2a2d`): un interruttore **CLK AUDIO / CLK SYS** in Drum Machine, Sequencer e Chord Prog (default AUDIO, come prima). SYS fa girare gli step sull'orologio di sistema (timer in un Worker, 100 ms di anticipo), riallineati a ogni beat di Live, e manda le note da una coda temporizzata dal Worker al loro istante (strum e arpeggi compresi). Gli step trovati in ritardo dopo un blocco della pagina passano senza suonare; una partenza in ritardo entra in fase nella battuta in corso di Live. **Provato:** in sync con Live con l'FM-1 Emulator aperto (clock audio 45–70%), in focus e in background.
- **Scoperto durante il lavoro:** sui loopback di Windows MIDI Services (ad esempio `MIDIWIN (A)` → Emulator X3) un **invio Web MIDI con timestamp viene ignorato**: il messaggio parte subito, quindi Note ON e Note OFF di una nota pianificata arrivano insieme e la nota non suona. CLK SYS non si affida ai timestamp. In CLK AUDIO gli invii pianificati verso le porte reali (Arpeggiatore, MIDI Out per traccia) li usano ancora: da gestire per porta (opzione, o misura con il loopback ping della F4).
- **Ancora aperto:** le app partono dall'inizio del loro pattern sulla battuta di Live, non a metà pattern. Le app ancora in CLK AUDIO dipendono dal clock audio.

### Fase 2 — Nodo "Ableton Live" in MIDI Flow (5-6 giorni, inspector compreso)
- Un nuovo tipo di nodo raggruppa `SYC IN`, `SYC CTRL` e `SYC OUT` ed espone **16 lane, una per canale di `SYC IN`**, ognuna con un'etichetta (es. "3 · Pad").
- Ogni lane si collega come oggi a dispositivi hardware, synth software, app di SY.CORE e Note Latch, con gli split e i filtri esistenti.
- Il canale della lane in Live e quello del dispositivo sono indipendenti: SY.CORE rimappa (es. lane 5 → Roland S-1 ch 16).
- **Program Change intelligente, con una regola per ogni dispositivo:**

| Regola | Cosa fa SY.CORE con un PC dalla lane | Esempio |
|---|---|---|
| `forward` | Lo inoltra così com'è | Synth senza banchi |
| `multi-sound` | Lo traduce con il banco Multi Sound (MSB/LSB e nome della patch) | E-MU X3, MicroFreak, SEQTrak |
| `sound-engine` | **Non lo inoltra.** Carica il preset N del banco attivo del SY.CORE Sound Engine e manda al synth la sua configurazione di CC (il synth resta sul suo preset corrente o temp) | **Roland S-1** |
| `ignore` | Lo scarta | — |

  Per il Roland S-1 la regola di default è `sound-engine`. Il PC "vero" sul ch 16 dell'S-1 non viene mai inviato, e il synth resta sempre sul preset corrente o temp, che SY.CORE riscrive tramite CC. È coerente con il funzionamento attuale del Sound Engine.
- **Export della mappa per Live:** un file di riepilogo (lane → dispositivo/app → canale) e, in Fase 6, un template `.als` con tracce già nominate e configurate con External Instrument.
- Configurazioni salvate in Flow: una per ogni set di Live (es. "Live — Set Techno").

#### 2.1 Interfaccia: nodo sul canvas (vedere e collegare)
Coerente con le card attuali di MIDI Flow (porte, cavi, popover sui cavi, scorciatoie nell'intestazione, collapse).
```
┌─ Ableton Live ───────────── EXT ● 124.0 BPM  17.3.1 ─ ⚙ ▢ ✕ ┐
│ SYC IN ●  SYC CTRL ●  SYC OUT ●          clock: Song · SPP ✓ │
├──────────────────────────────────────────────────────────────┤
│  1 Drums      ▪ ──────────────────────────────○ OUT          │
│  3 Pad        ▪ ──────────────────────────────○ OUT          │
│  5 S-1 Bass   ▪ ──────────────────────────────○ OUT          │
│  … (solo le lane attive; ▾ mostra tutte e 16)                │
├──────────────────────────────────────────────────────────────┤
│ ○ TO LIVE (SYC OUT)   ← cavi dalle app, canale per cavo      │
│ CTRL: ultima azione "Drum → B" · Control Map: default        │
└──────────────────────────────────────────────────────────────┘
```
- **Intestazione:** stato delle tre porte, clock EXT/INT, BPM e posizione in battute.
- **Una riga per lane:** numero di canale, etichetta, LED di attività e una **porta OUT propria**. Ogni lane si collega con un cavo a dispositivi e app, come oggi, con il popover del cavo per note range e filtro canale.
- **Porta IN "To Live":** le app si collegano qui; il canale di `SYC OUT` si sceglie sul cavo.
- **Modalità compatta:** si vedono solo le lane in uso, oppure solo l'intestazione.

#### 2.2 Interfaccia: inspector (modificare tutto), aperto dall'icona ⚙
Il canvas e l'inspector modificano gli stessi dati: un cavo disegnato compare nell'inspector, e una destinazione scelta nell'inspector crea il cavo.

| Tab | Contenuto |
|---|---|
| **Lanes** | Tabella delle 16 lane. Per ognuna: etichetta, colore, destinazioni, rimappatura del canale, note range, regola PC (`forward`, `multi-sound`, `sound-engine`, `ignore`; la regola è del dispositivo), Latch, mute e solo della lane, apertura del Monitor filtrato |
| **Control Map** | La mappa dei ch 15 e 16 come tabella modificabile: MIDI Learn, ripristino dei default, controllo dei conflitti, quantizzazione (battuta o fine pattern), export stampabile *(attiva con la F3)* |
| **Return** | Le app collegate a `SYC OUT` con il loro canale, l'offset in ms per app, il pulsante **Loopback ping** con il valore suggerito *(attiva con la F4)* |
| **Clock** | Sorgente, comportamento alla perdita del clock (`stop` o `continua in INT`), jitter e deriva misurati, il valore consigliato per il Sync Delay di Live |
| **Export** | La mappa lane → dispositivo/app → canale in JSON e in versione stampabile, usata anche per preparare il template `.als` |

- **Nomi delle lane:** nel rig base le etichette si scrivono a mano. Con il device Max for Live (F7) si potranno leggere i nomi delle tracce di Live e associarle in automatico.
- **Persistenza:** lane, Control Map, offset e impostazioni del clock vengono salvati nella configurazione di Flow, una per set di Live.
- **Test:** sincronizzazione fra canvas e inspector (cavo ↔ riga della tabella), applicazione delle regole PC, salvataggio e ricaricamento della configurazione.

### Fase 3 — Controllare le app dalle clip di Live (3 giorni)
Una **SY.CORE Control Map** standard su `SYC CTRL`: niente MIDI Learn per ogni set, le clip di Live sono il "foglio di controllo".

| Canale | Messaggi | Azione |
|---|---|---|
| 16 | Note C1–G1 | Chord Seq: slot A–H |
| 16 | Note C2–G2 | Drum Machine: sequenza A–H |
| 16 | Note C3–G3 | Sequencer: slot A–H |
| 16 | C4 / D4 / E4 | Drum Fill, Repeater, Mute Bass Line |
| 16 | F4 / G4 | Generate (stile corrente), Generate AI (prompt corrente) |
| 16 | CC 20–40 | Parametri delle app (transpose, densità, swing, velocity…) tramite Mapping, automatizzabili in Live |
| 15 | Note | **Key follow:** la nota ricevuta ri-intona Sequencer e Chord Seq (il Sequencer lo fa già con la tastiera; da estendere al Chord Seq) |

- La mappa vive **solo sulla porta `SYC CTRL`**, che non viene mai inoltrata ai dispositivi, quindi non entra in conflitto con nessun canale del rig. Per esempio, il ch 16 dell'S-1 su `SYC IN` è una cosa diversa dal ch 16 di controllo su `SYC CTRL`. I canali 15 e 16 sono comunque configurabili.
- La mappa è un preset del registro MIDI Actions, modificabile ma con default documentati.
- Cambi di slot quantizzati alla battuta (o a fine pattern), come nella Session View di Live.

### Fase 4 — Rimandare l'output a Live (2 giorni)
- In Flow ogni app può fare fanout: verso il synth e insieme verso `SYC OUT` su un canale dedicato. In Live una traccia in ascolto su `SYC OUT ch N` registra quello che l'app ha suonato.
- **Offset di uscita** per app e per porta, in ms, per compensare il doppio passaggio Live → browser → Live. Si misura con un test "loopback ping" in SY.CORE: invia una nota, misura il ritorno e propone il valore.
- **Send to Live:** gli export `.mid` esistenti usano nomi parlanti (`DM_A_Techno_124.mid`, `Chords_B_Amin_124.mid`) per il drag & drop.

### Fase 5 — Generazione nel contesto di Live (4-5 giorni)
- **Scene di Live → sezioni del Song Composer.** Il Song Composer distribuisce le sezioni (intro, strofa, drop…) sugli slot A–H di tutte le app. Nel template ogni scena di Live contiene una clip di controllo di una battuta su `SYC CTRL` che seleziona la sezione: lanciare una scena di Live cambia accordi, batteria, basso e preset insieme.
- **AI consapevole del rig:** il prompt include il BPM esterno, la tonalità e i dispositivi con le loro categorie di preset (ci sono già `planPresetChanges` e `partCategories`). L'AI non scrive solo note, sceglie anche *quale suono del tuo synth* usare.
- **Generate e Mutate durante la riproduzione:** il risultato entra nello slot successivo e parte alla battuta successiva, senza fermare Live.
- **Undo e storico:** `undoSongPlan` esiste già; va esposto anche nella vista di controllo.

### Fase 6 — Template, wizard, vista Live Rig e documentazione (5 giorni)
- `SYCORE Template.als`, **da costruire insieme in Live 12** e compatibile con Standard (niente M4L): 16 tracce MIDI o External Instrument (una per lane), tracce di registrazione su `SYC OUT`, una traccia "SY.CORE Control" su `SYC CTRL` ch 16, scene A–H con le clip di controllo.
- **Wizard "Ableton Live" in SY.CORE:** rileva le porte `SYC IN`, `SYC CTRL` e `SYC OUT` (e se mancano spiega come crearle), avvisa se una porta hardware è aperta anche in Live, verifica che il clock arrivi, esegue il loopback ping e crea la configurazione di Flow.
- **Vista "Live Rig"** (durante l'esecuzione, quasi solo lettura):
  - clock e posizione in grande, attività delle 16 lane e slot correnti di Chord Seq, Drum Machine e Sequencer;
  - le ultime azioni arrivate dalla Control Map;
  - avvisi: loop rilevato, porta sparita, tab nascosta, clock perso, con uno stato "continua in INT" ben visibile;
  - le uniche modifiche consentite sono quelle che servono sul palco: mute delle lane, panico (All Notes Off) e passaggio manuale da EXT a INT.
- Guida `docs/guides/SYCORE_ABLETON_LIVE.md` nel repo, che riprende il §10.

### Fase 7 — Estensioni opzionali (dopo l'MVP)
- **Device Max for Live "SY.CORE Link"** (richiede Suite, o Standard con l'add-on Max for Live acquistato a parte; il rig base non ne ha bisogno): legge dal Live Object Model tonalità e scala del set, nomi delle scene e clip lanciate, e scrive clip direttamente negli slot di Live ("Send to Live" senza drag & drop).
- **Bridge Ableton Link (Node):** tempo e fase via Link invece del clock MIDI, utile con più computer. È secondario, perché in questo scenario Live è già master via MIDI.
- **Script di controllo per Push**, per pilotare la Control Map dai pad.

Tutto ciò che è opzionale resta tale: il rig base richiede solo il browser e il cavo MIDI virtuale.

### Fase 8 — Shell desktop "Pro rig" (opzionale, dopo l'MVP · 1-2 settimane)
Una shell Tauri (preferita, più leggera) o Electron che **incorpora la stessa build web** di SY.CORE, senza fork.
- **Porte virtuali create dall'app:** `SYC IN`, `SYC CTRL` e `SYC OUT` nascono con l'app, quindi niente loopMIDI. Su macOS con sorgenti e destinazioni virtuali CoreMIDI; su Windows con le API di Windows MIDI Services (da verificare la disponibilità sulle versioni di Windows di riferimento).
- **Niente rallentamento dei timer** delle tab in background e un processo separato da Live.
- **Avvio automatico,** finestra dedicata e ripristino dell'ultima configurazione di Flow.
- Contraddice il principio "zero install" del Manifesto, quindi resta un'opzione: la versione da browser rimane completa.

### Fase 9 — Rig Controller (dopo l'MVP · prototipo 5-6 giorni)
Un controller **del rig, non degli strumenti**. Non tocca i parametri del suono: governa chi suona cosa, quando e come. Il modello è una "Session View di SY.CORE".

#### 9.1 Principi
1. **Funzioni, non dispositivi.** I tasti dicono "Drum slot C", "Sezione 3", "Generate", non "CC 20 sul canale 16". La mappatura sta in SY.CORE.
2. **SY.CORE decide, il controller mostra.** Il controller non conserva nessuno stato: LED e display riflettono SY.CORE. Al riaggancio (USB o ricaricamento della pagina) riceve lo stato completo.
3. **Ogni azione musicale è quantizzata e visibile.** Il tasto lampeggia mentre aspetta la battuta, poi resta acceso.
4. **Si legge con un'occhiata, al buio.** Colori con significato fisso, niente menu, al massimo un tasto Shift.
5. **Sicurezza fisica.** Panico e passaggio a INT sono isolati e si attivano tenendo premuto.

#### 9.2 Layout di riferimento (hardware dedicato, futuro)
```
┌─ TRANSPORT / CLOCK ─┐ ┌──────────── GRIGLIA SLOT (A–H) ────────────┐ ┌─ PERFORMANCE ─┐
│ ▶ ■   EXT●INT       │ │ Chord  [A][B][C][D][E][F][G][H]  M  GEN MUT│ │ FILL  REPEAT  │
│ 124.0 BPM  17.3.1   │ │ Drum   [A][B][C][D][E][F][G][H]  M  GEN MUT│ │ LATCH  REL-ALL│
│ TAP   ● beat LED    │ │ Bass   [A][B][C][D][E][F][G][H]  M  GEN MUT│ │ KEY ◀ C# ▶    │
├─ SEZIONI (Song) ────┤ │ Seq    [A][B][C][D][E][F][G][H]  M  GEN MUT│ │ ◯ ◯ ◯ ◯       │
│ [1][2][3][4]        │ │ Arp    [A][B][C][D][E][F][G][H]  M  GEN MUT│ │ dens swing    │
│ [5][6][7][8]        │ └────────────────────────────────────────────┘ │ vel  gate     │
├─ RIG ───────────────┤ ┌─ DISPLAY ─────────────────────────────────┐ ├─ SAFETY ──────┤
│ FLOW ◯ "Set Techno" │ │ Drum → C alla battuta 18 · AI: pronto     │ │ PANIC (hold)  │
│ SPLIT [1][2][3][4]  │ │ ⚠ SYC OUT assente                         │ │ INT   (hold)  │
│ LANE mute 1–8 (+⇧)  │ └───────────────────────────────────────────┘ │ UNDO          │
└─────────────────────┘                                                └───────────────┘
```
- Push resta a Live, il Rig Controller resta a SY.CORE: nessuna sovrapposizione.
- Play/Stop di Live dal Rig Controller, se serve, passa da una porta dedicata (`SYC REMOTE`) mappata in Live, mai da `SYC OUT`.

#### 9.3 Un modello, più trasporti
Il cuore è un modello unico: le **Rig Actions** (slot, sezione, generate, mutate, fill, mute, split, key, panic, INT) e il **Rig State** (slot attivi e in coda, clock, avvisi, testo del display). È un'estensione delle MIDI Actions esistenti, con la quantizzazione della F3.

Sopra questo modello si appoggiano i trasporti:

| Trasporto | Quando | Come |
|---|---|---|
| **MIDI** (base) | Sempre: funziona nel browser e con qualsiasi controller USB | Note per i tasti, CC relativi per gli encoder (assoluti con pickup per pot e fader), velocity per i LED, SysEx per display e riepilogo dello stato |
| **OSC** (opzionale) | Superfici su tablet (TouchOSC, Open Stage Control) o controller che parlano OSC | Tramite il bridge Node della F7, che fa da ponte UDP ↔ WebSocket |

#### 9.4 OSC: soluzione o complessità in più?
**Non è troppo complesso, a una condizione: che OSC sia un secondo trasporto dello stesso modello e non il protocollo principale.**
- **A favore:**
  - è uno standard: non si inventa un protocollo, si definisce solo la mappa degli indirizzi, che serve comunque;
  - indirizzi leggibili, float e stringhe: il testo del display passa senza SysEx;
  - molte superfici già pronte su tablet.
- **Contro:**
  - **il browser non apre socket UDP**, quindi OSC richiede il bridge locale (F7): è un componente in più da installare, contro il principio "zero install";
  - sul palco il Wi-Fi è un rischio: meglio Ethernet o un tablet via USB;
  - i controller hardware come Launchpad e MIDImix parlano solo MIDI.
- **Costo:** circa 3-4 giorni sopra il bridge, perché le azioni e lo stato sono già definiti dal modello.
- **Decisione proposta:** MVP e prototipo solo in MIDI; OSC dopo, come estensione della F7.

Esempio di indirizzi, versionati:
```
/sycore/v1/app/drum/slot        i 3          → Drum slot D
/sycore/v1/app/chord/generate                → Generate sul Chord Seq
/sycore/v1/section              i 2          → Sezione 3
/sycore/v1/state/clock          s "EXT" f 124.0 s "17.3.1"
/sycore/v1/state/display        s "Drum → C alla battuta 18"
```

#### 9.5 Prototipo con Launchpad Mini MK1 + AKAI MIDImix
Il profilo `LaunchpadMiniMK1` esiste già (`src/core/controllers/profiles/LaunchpadMiniMK1.ts`: layout XY, CC 104–111 della riga in alto, LED verde 60 e ambra 51). Si aggiunge una **modalità "Rig"**, selezionabile accanto a quella attuale (che apre i pannelli), senza rompere le mappature esistenti. Il display non c'è su nessuno dei due: lo sostituisce la vista **Live Rig** sullo schermo.

**Launchpad Mini MK1: la griglia del rig** (layout XY: nota = 16 × riga + colonna, righe 0–7 dall'alto)

| Zona | Note / CC | Funzione |
|---|---|---|
| Righe 0–4 | 0–7, 16–23, 32–39, 48–55, 64–71 | Chord, Drum, Bass, Seq, Arp × slot A–H |
| Riga 5 | 80–87 | Sezioni 1–8 del Song Composer |
| Riga 6 | 96–103 | Split 1–4 · Fill · Repeater (tenuto) · Latch · Rilascia tutto |
| Riga 7 | 112–119 | Mute delle lane 1–8 (Shift: 9–16) |
| Tasti laterali, righe 0–4 | 8, 24, 40, 56, 72 | Generate dell'app della riga (Shift: Mutate) |
| Tasti laterali, righe 5–7 | 88, 104, 120 | Undo · Key − · Key + |
| Riga in alto | CC 104–111 | LED dei beat (premuto: Tap) · EXT/INT (tenuto) · Shift · Generate integrato/AI · Quantizzazione battuta/pattern · apri Live Rig · libero · Panico (tenuto) |

**Colori.** Il MK1 ha solo rosso, verde e ambra, quindi l'app si riconosce dalla riga, non dal colore.

| Colore | Stato |
|---|---|
| Spento | Slot vuoto |
| Ambra | Slot pieno |
| Ambra lampeggiante | Slot in coda per la battuta successiva |
| Verde | In riproduzione |
| Rosso | Mute, oppure panico armato |

I valori esatti per il rosso e per il lampeggio vanno verificati sul Programmer's Reference di Novation per il Launchpad Mini.

**AKAI MIDImix: i parametri continui** (8 strisce, ognuna con 3 pot, 1 fader, Mute e Rec Arm; master fader, Bank ◀ ▶, Solo)

| Controllo | Pagina "App" (default) | Pagina "Lane" (Bank ▶) |
|---|---|---|
| Strisce 1–5 | Chord, Drum, Bass, Seq, Arp | Lane 1–8 (Shift: 9–16) |
| Strisce 6–8 | Macro libere (es. transpose, rate dell'Arp) | — |
| Pot riga 1 / 2 / 3 | Densità · Swing · Gate | CC configurabili per lane (es. cutoff) |
| Fader | Intensità dell'app (scala di velocity in uscita) | CC 7 verso il synth della lane |
| Mute (con LED) | Mute dell'app | Mute della lane |
| Rec Arm (con LED) | Solo dell'app | Latch della lane |
| Master fader | Intensità globale | — |
| Solo | Shift | Shift |

- Pot e fader del MIDImix sono assoluti e senza motori. SY.CORE applica il **pickup** (soft takeover): il valore cambia solo quando il controllo raggiunge quello attuale, e la vista Live Rig mostra la posizione da raggiungere.
- Le note dei LED di Mute e Rec Arm si leggono e si configurano con il MIDI Mix Editor di AKAI.
- Si aggiunge un nuovo profilo `AkaiMidiMix` accanto a `LaunchpadMiniMK1`.

#### 9.6 Passi
1. **Layout su schermo:** preset del Controller Designer con lo stesso schema, da provare in jam (1 giorno).
2. **Profili:** modalità "Rig" del Launchpad Mini MK1 e nuovo profilo MIDImix, con LED pilotati dal Rig State e pickup (3-4 giorni).
3. **Prove reali e revisione del layout** (1 giorno).
4. **Dopo:** OSC tramite il bridge (F7, 3-4 giorni) e, solo con il layout stabile, hardware dedicato (Raspberry Pi Pico o Teensy, class compliant, LED RGB, encoder, display), fuori stima.

**Test:** traduzione Rig Action ↔ messaggi per i due profili, stato dei LED (vuoto, pieno, in coda, attivo, mute), pickup, invio dello stato completo al riaggancio.

#### 9.7 Opzioni di performance per traccia
Ogni riga di app (Chord, Drum, Bass, Seq, Arp) è una **traccia** e ogni slot A–H una **clip** con una lunghezza in battute. Per traccia, quattro opzioni ispirate ai performance mode dei DAW:

| Opzione | Valori | Effetto |
|---|---|---|
| **Press** | Retrigger · Hold & stop · Hold & motion · Latch (default) | Come reagisce il pad: riavvia (Shift + pressione ferma), suona finché tenuto, suona finché tenuto e al rilascio la pressione successiva dello stesso pad suona lo slot seguente, oppure alterna play e stop |
| **Motion** | Stay · One shot · March & wrap · March & stay · March & stop · Random · Exclusive random | Cosa succede quando lo slot finisce |
| **Trigger sync** | Off · da 1/4 di beat a 4 beat · Auto · Queue · Tolerant | Quando parte lo slot premuto. Auto: dalla lunghezza dello slot, al massimo 4 beat. Queue: gli slot premuti suonano in ordine. Tolerant: una pressione entro 1 beat dall'inizio della battuta parte subito, tagliando l'inizio |
| **Position sync** | Off · da 1/4 di beat a 4 beat · Auto | Da dove parte dentro lo slot: dall'inizio, dal punto della griglia più vicino o dalla posizione corrente nel brano |

- **Interfaccia:** sotto il nome dell'app un riepilogo (es. `LTCH · STAY · BAR`), una card "Track options" con le quattro tendine e le descrizioni. Sui pad: lunghezza in battute, barra di avanzamento, ordine di coda (`#1`, `#2`), bordo sullo slot della prossima pressione (Hold & motion). Sul Launchpad il tasto in alto "Sync" scorre la Trigger sync della traccia selezionata.
- **Clock:** il modello avanza a sedicesimi (16 step per battuta, 4/4), così la sincronia a 1/4 di beat è possibile. Le sezioni cambiano sempre a inizio battuta.

#### 9.8 Posizionamento rispetto ai performance mode dei DAW
Live ha già un modello di performance per le sue clip, nella Session View. Le stesse idee esistono, con nomi diversi:

| Performance mode di FL Studio | Session View di Ableton Live | Rig Controller di SY.CORE |
|---|---|---|
| Press: Retrigger, Hold & stop, Latch | Launch Mode: Trigger, Gate, Toggle, Repeat | Press |
| Motion: March, Random… | Follow Actions: Next, Any, Other, Stop, Jump… | Motion |
| Trigger sync | Launch Quantization | Trigger sync |
| Position sync | Legato | Position sync |
| Scene, Marker Groups | Scene | Sezioni / scene del rig (F10) |

SY.CORE non porta in Live qualcosa che gli manca per le clip. Applica lo stesso modello dove Live non arriva:
- **le app generative**, i cui slot sono pattern che Generate, Mutate o l'AI riscrivono mentre il brano suona;
- **il rig hardware:** lo stesso gesto cambia pattern, suoni dei synth, routing di MIDI Flow e split (F10);
- **senza DAW:** funziona anche con il clock interno.

**Posizionamento:** "il performance mode del rig, che Live sincronizza". Nei testi pubblici (paper, sito, UI) si usa un nome proprio, per esempio "Rig Performance Mode", senza citare FL Studio, che è un marchio di Image-Line; al massimo "ispirato ai performance mode dei DAW".

#### 9.9 Stato del prototipo
Branch `feat/rig-controller-ui` di `sycore-refactor`, commit `99c09f8` (pushato). Il branch contiene anche la F1 (commit `49c8dad`), che il Rig Controller userà al posto del suo clock simulato.
- **Pannello "Rig Controller"** (Performance Tools, badge Prototype), con tre viste: Rig layout, Launchpad Mini MK1, AKAI MIDImix.
- **Opzioni del §9.7** tutte funzionanti, con un clock simulato che sostituisce Live.
- **Nessun MIDI inviato.**
- **File:** `src/lib/rig-controller.ts` (modello, Rig Actions, mappa del Launchpad), `src/components/RigControllerPanel.vue`; test in `tests/unit/lib/rig-controller.test.ts`.

### Fase 10 — Scene del rig e marker (dopo la F9 · 8-10 giorni)
Oggi uno slot rappresenta solo un pattern. Questa fase lega a slot e sezioni anche **suoni, routing e valori dei controller**, e permette di richiamarli da Live, dalla Live Timeline o dal controller.

#### 10.1 La scena del rig
| Dove | Cosa si salva | Esempio |
|---|---|---|
| **Slot** di un'app | Il suono della parte: preset del Sound Engine (S-1) o banco/patch Multi Sound | Bass slot C → S-1 preset "Acid 04" |
| **Sezione** (scena del rig) | Slot di ogni app, configurazione di MIDI Flow, preset di split, mute delle lane, valori di CC (cutoff, livelli…) | Scena 3 "Drop" → Drum C, Bass C, Flow "Techno Set", split 2, lane 5 muta, cutoff del pad a 90 |

- **Si programma** con due inspector nel Rig Controller:
  - lo **slot**: si sceglie il suono;
  - la **sezione**: un nome, gli slot di ogni app e un comando "cattura lo stato del rig" che salva Flow, split, mute e CC correnti.
- **Già esistente:** il Song Composer pianifica i preset per sezione (`planPresetChanges`, `sendPartPresets`), ma solo per i brani generati e senza routing né CC. La scena del rig lo generalizza; un brano del Song Composer diventa un insieme di scene.

#### 10.2 Tre modi di fare i cambi
1. **Programmati in SY.CORE:** nelle scene e negli slot (§10.1), applicati alla battuta insieme al cambio di pattern.
2. **Dal vivo, con il controller:** split e configurazione di Flow dalla zona Rig (Launchpad riga 7), mute delle lane, CC dai pot e fader del MIDImix (pagina Lane). Si sceglie se applicarli subito o alla battuta.
3. **Programmati in Live:** clip di controllo e lane nell'arrangement (Program Change nelle clip, automazione dei CC), tradotti con le regole per dispositivo della F2.

#### 10.3 Problemi tecnici da gestire
- **Note appese al cambio di routing:** prima di cambiare canale o destinazione di una lane, SY.CORE chiude le note attive sulla vecchia destinazione. Il cambio avviene sempre sulla battuta.
- **Tempi di caricamento dei synth:** un Program Change su hardware può creare un vuoto mentre il synth carica la patch, e il preset dell'S-1 sono decine di CC. Due opzioni per dispositivo: invio anticipato (es. sull'ultimo beat della battuta precedente, in ms configurabili) e invio dei CC distribuito su qualche millisecondo.
- **Pickup:** i valori di CC di una scena cambiano il valore corrente. I pot assoluti del MIDImix si riagganciano con il pickup della F9.

#### 10.4 Marker da Ableton: tre percorsi
La Live Timeline di SY.CORE ha già marker di molti tipi (Program Change, Select Chord Prog Slot, start e stop di Sequencer, Drum Machine e Loop Machine, Tempo, Performance Set). Oggi però ha un clock suo (BPM proprio, `requestAnimationFrame`) e manda lei Start e Stop: è una timeline master.

| | Dove stanno i marker | Come funziona | Pro | Contro |
|---|---|---|---|---|
| **A** | Nella Live Timeline di SY.CORE | La timeline segue la posizione di Live (clock e SPP, F1) e scatena i suoi marker | Marker leggibili, già esistenti | Due timeline da tenere allineate: se sposti una sezione in Live, i marker di SY.CORE non si spostano |
| **B** | Nell'arrangement di Live | Una clip di controllo su `SYC CTRL` per sezione: la nota indica la scena del rig | Una sola timeline, quella di Live; i marker seguono le modifiche dell'arrangement. Funziona su Live Standard | La clip contiene solo un numero: va nominata (es. "Drop → Scena 3") |
| **C** | I locator di Live (marker con nome) | Il device Max for Live (F7) legge i locator; SY.CORE applica la scena con lo stesso nome | Il più pulito: un locator "Drop" attiva la scena "Drop" | Richiede Max for Live |

**Decisione proposta:** con Live il percorso principale è **B**, perché il tempo ha una sola fonte; **C** arriva con la F7. La Live Timeline (**A**) resta lo strumento per suonare senza DAW, con SY.CORE come master; facoltativamente, con il clock esterno della F1, può anche seguire Live.

#### 10.5 Il marker indica la scena, non le azioni
- Il contenuto di una scena vive in SY.CORE ed è modificabile solo lì.
- Clip di controllo in Live, locator via Max for Live, nuovo tipo di marker **"Rig Scene"** nella Live Timeline e tasti delle sezioni sul controller richiamano tutti **la stessa scena**: si programma una volta sola.
- Mappa per la clip di controllo: sul ch 16 di `SYC CTRL`, le note C2–G2 della Control Map (F3) selezionano oggi la sequenza della Drum Machine. Per le scene si propone un'ottava dedicata (es. C5–G6 = scene 1–16), da fissare nella Control Map.

#### 10.6 Stati invece di eventi: il "chase"
- Oggi la Live Timeline, se parti a metà brano, considera già scattati i marker precedenti e non li esegue. Per il rig è sbagliato: ripartendo dal secondo ritornello, synth, routing e slot devono essere quelli della sezione in cui ti trovi.
- **Le scene sono stati.** Quando arriva un SPP o un salto, SY.CORE applica la scena attiva in quella posizione, come il "chase" dei DAW.
- **Con il percorso B:** la nota della clip di controllo dura quanto tutta la sezione e in Live è attivo **Options › Chase MIDI Notes**. Partendo a metà sezione, Live rimanda la nota e SY.CORE riceve la scena giusta. *Da verificare su Live 12.*
- **Con il percorso A:** la Live Timeline, al seek, applica la scena dell'ultimo marker "Rig Scene" prima della posizione.

#### 10.7 Passi e stime
1. Modello della scena del rig e salvataggio nella configurazione di Flow per set (2 giorni).
2. Inspector di slot e sezione nel Rig Controller, con "cattura lo stato del rig" (2 giorni).
3. Applicazione alla battuta: chiusura delle note, invio anticipato dei PC, invio distribuito dei CC (2 giorni).
4. Scene dalla clip di controllo (percorso B) con chase (1-2 giorni).
5. Marker "Rig Scene" nella Live Timeline, chase al seek, opzione "segui Live" (1-2 giorni).

**Test:** applicazione di una scena (slot, suoni, Flow, split, mute, CC), chiusura delle note al cambio di routing, ordine e anticipo dei messaggi, chase da SPP e da seek, nessun doppio invio quando la stessa scena arriva due volte.

## 5. Ordine e stime

| # | Fase | Sforzo | Dipendenze |
|---|---|---|---|
| 1 | F1 Clock slave + SPP | M | — |
| 2 | F2 Nodo Ableton in Flow + inspector + PC intelligente | M-L | — |
| 3 | F3 Control Map | S-M | F1 (quantizzazione) |
| 4 | F4 Ritorno a Live + offset | S | F2 |
| 5 | F6 Template + wizard + vista Live Rig + guida | M | F2, F3 |
| 6 | F5 Scene → sezioni, AI consapevole del rig | M | F1, F3 |
| 7 | F7 M4L / Link / Push | L | MVP |
| 8 | F8 Shell desktop "Pro rig" | M-L | MVP, edizione Live (§11) |
| 9 | F9 Rig Controller: profili Launchpad Mini MK1 + MIDImix, opzioni di performance per traccia, poi OSC | M | F3 (azioni quantizzate); F7 per OSC |
| 10 | F10 Scene del rig e marker (Live, Live Timeline, chase) | M-L | F1 (SPP), F2 (regole PC), F3 (Control Map), F9 |

**MVP:** F1 + F2 + F3 + F4 + F6, circa 3,5 settimane. **Versione completa:** con F5, circa 4,5 settimane.

## 6. Criteri di accettazione (MVP)

- Live master a 70-180 BPM: le app di SY.CORE partono al downbeat ed entro 10 minuti la fase si sposta di meno di 5 ms, anche con la tab di SY.CORE in background.
- Stop e ripartenza da un punto qualsiasi dell'arrangement (SPP): le app ripartono in fase dalla battuta giusta.
- Una traccia di Live su `SYC IN ch3` suona un synth hardware attraverso SY.CORE, con split e filtri di Flow, senza VST in Live.
- Un PC da una clip di Live seleziona la patch giusta con il banco Multi Sound del dispositivo. Sulla lane del Roland S-1, lo stesso PC carica il preset del Sound Engine via CC, senza inviare un PC al synth.
- La clip di controllo di una scena cambia gli slot di Chord Seq, Drum Machine e Sequencer alla battuta successiva.
- L'output della Drum Machine registrato in Live su `SYC OUT` è a griglia entro 1/128 dopo la compensazione dell'offset.
- Nessun loop di feedback con la configurazione documentata.
- `npm test` passa con i nuovi test di transport, nodo DAW e Control Map; `CHANGES.md` aggiornato a ogni passo.

## 7. Perché SY.CORE supera i generatori MIDI come MIDI Agent

*Confronto con la categoria "generatore MIDI AI come plugin del DAW". Da verificare sulla versione corrente di MIDI Agent prima di usarlo in comunicazione.*

| | Generatore AI in plugin (es. MIDI Agent) | SY.CORE + Live |
|---|---|---|
| Uscita | Clip MIDI da trascinare in una traccia | Clip **e** riproduzione dal vivo, a tempo, con cambi di slot e sezione alla battuta |
| Generazione | Offline, un prompt alla volta | Generate e Mutate durante la riproduzione, built-in (stili, euclideo) o AI |
| Coerenza fra parti | Di solito una parte per volta | Song Composer: accordi, batteria, basso e sequenze in un unico piano, per sezioni |
| Strumenti | Quelli caricati nel DAW | Qualsiasi synth hardware o software, raggiunto con il routing di Flow |
| Suoni | Non conosce i preset dei tuoi synth | Sceglie i preset dai banchi Multi Sound per categoria e manda i PC giusti |
| Routing | Quello del DAW | Split, filtri, fanout multicanale, Note Latch, un hub per tutto il rig |
| Plugin nel DAW | Sì (VST/AU) | No: tracce MIDI e External Instrument nativi |
| Editing | Nel piano roll del DAW | Editor dedicati (step, accordi, drum, accent, ratchet, probabilità) e piano roll di Live dopo la registrazione |
| Provider AI | Quello del prodotto | Provider configurabile (`ai-providers`), chiave dell'utente; generatori built-in senza rete |
| Uso dal vivo | Limitato | Pensato per il palco: local-first, scene di Live come sezioni, controllo dalle clip |

## 8. Rischi

| Rischio | Mitigazione |
|---|---|
| Latenza del doppio passaggio Live → browser → hardware | Invio con timestamp (c'è già), Track Delay negativo in Live, misura con il loopback ping (F4) |
| Jitter del clock in ingresso nel browser | Aggancio della fase a ogni battuta invece di seguire ogni tick; Link opzionale (F7) |
| Timer rallentati con la tab in background | Scheduler in un Worker; avviso in UI |
| Porte MIDI non multi-client su Windows | Regola: le porte hardware solo in SY.CORE; Windows MIDI Services dove disponibile |
| Loop di feedback (`SYC OUT` → Live → `SYC IN`) | Remote e Sync disattivati su `SYC OUT` in Live; rilevamento dei loop già presente in SY.CORE; test dedicato |
| Solo Chrome ed Edge (Web MIDI e SysEx) | Requisito dichiarato, come oggi |

## 9. Decisioni

1. **Live 12.x, Standard o Suite.** Il rig base non usa Max for Live; M4L serve solo per le estensioni della F7.
2. **Massimo 16 parti:** una sola porta `SYC IN` con 16 canali.
3. **Control Map sui ch 15 e 16 di `SYC CTRL`**, porta mai inoltrata ai dispositivi. Il Roland S-1 (PC sul ch 16) usa la regola `sound-engine`: i preset sono configurazioni di CC applicate al preset corrente o temp.
4. **Il template `.als` lo costruiamo insieme** (F6).

## 10. Installazione e configurazione per l'utente

### 10.1 Cosa installare

| | Windows | macOS |
|---|---|---|
| Browser | Chrome o Edge aggiornato | Chrome o Edge aggiornato |
| Porte MIDI virtuali | **loopMIDI** (gratuito, Tobias Erichsen), con l'avvio automatico attivo. In alternativa, le loopback di Windows MIDI Services se il sistema le ha | Nulla: **IAC Driver** (Configurazione MIDI Audio) |
| Driver dei synth | Quelli del produttore, se il synth non è class compliant | Di solito nessuno |
| Driver audio | ASIO della scheda audio (per Live) | Core Audio, nessuno |
| *Opzionale:* audio di SY.CORE in Live | VB-Cable | BlackHole |
| *Opzionale:* M4L (F7) | Suite, o Standard con l'add-on | come Windows |

SY.CORE non si installa: si apre nel browser e si dà il permesso MIDI con SysEx alla prima apertura.

### 10.2 Creare le porte (una volta sola)
Tre porte con questi nomi esatti, perché il wizard le riconosce per nome:
`SYC IN` · `SYC CTRL` · `SYC OUT`
- loopMIDI: scrivi il nome e premi "+", tre volte.
- IAC: Finestra › Mostra Studio MIDI › IAC Driver › "Il dispositivo è online", poi aggiungi tre bus con quei nomi.
- **Windows MIDI Services** (al posto di loopMIDI): un loopback è una **coppia di endpoint**, ad esempio `SYC CTRL A` e `SYC CTRL B`; quello che esce da A entra su B. Live usa il lato A, SY.CORE il lato B (Clock › Source = `SYC CTRL B`). SY.CORE riconosce la coppia e non manda mai il proprio clock al lato A. Nota: nelle nostre prove Live 12 è andato in crash disattivando le porte di Windows MIDI Services nelle Preferenze; attiva solo quello che serve (Output A: Sync) e lascia il resto com'è.

Ogni porta compare **sia come ingresso sia come uscita** in tutte le app: per questo in Live ne serve solo una direzione (vedi sotto).

### 10.3 Ableton Live — Preferences › Link, Tempo & MIDI

**Tabella MIDI Ports:**

| Porta | Direzione in Live | Track | Sync | Remote | MPE |
|---|---|---|---|---|---|
| `SYC IN` | **Output** | ✅ | — | — | — |
| `SYC IN` | Input | ✖ | ✖ | ✖ | ✖ |
| `SYC CTRL` | **Output** | ✅ | ✅ (clock) | — | — |
| `SYC CTRL` | Input | ✖ | ✖ | ✖ | ✖ |
| `SYC OUT` | **Input** | ✅ (registrazione) | ✖ | ✖ | ✖ |
| `SYC OUT` | Output | ✖ | ✖ | ✖ | ✖ |
| **Synth hardware** (S-1, ecc.) | entrambe | ✖ | ✖ | ✖ | ✖ |
| Controller di Live (Push, ecc.) | come prima | invariato | invariato | invariato | invariato |

**Sync su `SYC CTRL` (Output):**
- **MIDI Clock Type: Song**, così Live manda anche il Song Position Pointer.
- **MIDI Clock Sync Delay:** il valore proposto dal loopback ping del wizard.
- Link: non necessario, si può lasciare spento.

**Audio:** la scheda audio con il driver ASIO o Core Audio. Gli ingressi sono quelli dove rientrano i synth hardware.

### 10.4 Ableton Live — tracce (già pronte nel template)
- **Parte su un synth hardware:** traccia MIDI con **External Instrument**. MIDI To: `SYC IN`, canale N. Audio From: l'ingresso della scheda dove rientra il synth. **Hardware Latency:** il valore misurato.
- **Parte su un synth software standalone o un'app di SY.CORE:** traccia MIDI, MIDI To: `SYC IN`, canale N.
- **Strumento nativo di Live suonato dalle sue clip:** traccia MIDI con lo strumento (es. Wavetable, Drum Rack), come sempre; SY.CORE non è coinvolto.
- **Strumento nativo di Live suonato da un'app di SY.CORE:**
  - traccia MIDI con lo strumento, MIDI From: `SYC OUT`, canale N, Monitor: **In**; per registrare basta armarla;
  - non crea loop, perché la traccia produce audio e non rimanda MIDI a `SYC IN`;
  - con il fanout di Flow la stessa parte può suonare insieme anche su un synth hardware (layer);
  - le note fanno il giro Live → SY.CORE → Live, quindi si compensa con l'offset per app (F4);
  - per suonare uno strumento nativo dalla tastiera con la latenza minima, la tastiera va collegata direttamente a Live; su Windows, in quel caso, la tastiera non è disponibile anche in SY.CORE.
- **Controllo:** traccia "SY.CORE Control", MIDI To: `SYC CTRL`, ch 16 (e 15 per il key follow), con le clip di controllo nelle scene.
- **Registrazione dell'output delle app (senza strumento):** traccia MIDI. MIDI From: `SYC OUT`, canale N. Monitor: **Off** e MIDI To: **No Output**, per evitare loop.

### 10.5 SY.CORE (guidato dal wizard "Ableton Live")
1. MIDI Devices: le tre porte `SYC` vengono rilevate e registrate.
2. Global Transport: **Clock source = `SYC CTRL`** (EXT).
3. MIDI Flow: carica la configurazione "Ableton Live", collega ogni lane al dispositivo o all'app e imposta la regola PC per dispositivo (S-1 = `sound-engine`).
4. Routing: nessun clock in uscita verso `SYC OUT`, per evitare loop.
5. Test: Play in Live, verifica il trasporto, loopback ping, valori di latenza da copiare in Live.
6. Consiglio: SY.CORE in una finestra separata (non in una tab nascosta) durante la sessione.

### 10.6 Errori tipici

| Sintomo | Causa | Soluzione |
|---|---|---|
| Il synth non risponde o la porta è "occupata" | Porta hardware attiva anche in Live (Windows) | Disattivarla in Live, tutto ✖ |
| Note doppie o MIDI in loop | Input di `SYC IN` o `SYC CTRL` attivo in Live, o Monitor attivo sulla traccia di registrazione | Seguire la tabella del §10.3 |
| Le app partono fuori battuta | Clock Type "Pattern" | Impostare "Song" |
| Le app vanno fuori tempo con la tab nascosta | Rallentamento dei timer del browser | Finestra separata (e scheduler in un Worker, F1) |
| SY.CORE mostra il doppio del BPM di Live | Lo stesso clock che arriva due volte (un loop verso la sorgente, o un ingresso doppio) | Corretto nella F1; la riga di diagnostica mostra i clock/s (24 × BPM / 60) e i quasi-duplicati |
| EXT passa a INT subito dopo il Play | Il thread principale occupato ad avviare le app | Corretto nella F1 (i controlli in ritardo vengono saltati) |
| Le app suonano fuori tempo, con pause; badge **AUDIO** ambra | Thread audio sovraccarico (clock audio < 97%), ad esempio con l'FM-1 Emulator aperto | **CLK SYS** in Drum Machine, Sequencer e Chord Prog; oppure chiudere i pannelli pesanti |
| Un synth su un loopback di Windows MIDI Services mostra le note ma non suona | Invii con timestamp ignorati su quella porta: Note ON e Note OFF arrivano insieme | **CLK SYS** nell'app (invii temporizzati dal Worker) |

### 10.7 Configurazione provata: Windows MIDI Services (2026-11-06)
Il rig provato con Live 12, SY.CORE in Chrome e Windows MIDI Services, senza loopMIDI. Un loopback di Windows MIDI Services è una **coppia di endpoint**: quello che esce da A entra su B.

```
Live    ──► SYC CTRL A ══ loopback ══► SYC CTRL B ──► SY.CORE   (clock, Start/Stop, SPP)
SY.CORE ──► SYC OUT A  ══ loopback ══► SYC OUT B  ──► Live      (note delle app → strumenti nativi)
```

**Live → Preferenze › Link, Tempo & MIDI** (attiva solo queste; nelle nostre prove disattivare le porte di Windows MIDI Services ha mandato in crash Live 12):

| Porta | Track | Sync | Remote |
|---|---|---|---|
| Output `SYC CTRL A` | off | **on** (Clock Type: Song) | off |
| Input `SYC OUT B` | **on** | off | off |

**SY.CORE:**
- Pannello Sync del trasporto: **Clock › Source = `SYC CTRL B`**; alla perdita del clock come preferisci.
- Uno **strumento virtuale per parte sulla porta `SYC OUT A`** (ad esempio `Live · Drums`, `Live · Chords`, `Live · Seq`), collegato in MIDI Flow dalla sua app, con il canale impostato come **OUT CH sul cavo** (Drums 10, Chords 1, Seq 2…). La Drum Machine richiede **MIDI OUT ONLY** (esce solo verso strumenti virtuali).
- **CLK SYS** in Drum Machine, Sequencer e Chord Prog.
- Non collegare `SYC OUT B` né `SYC CTRL A` in MIDI Flow.

**Tracce di Live:** una traccia MIDI con lo strumento nativo (Drum Rack, Analog, Wavetable…), **MIDI From `SYC OUT B`**, il canale della parte, **Monitor In** (o Auto + traccia armata); arma e registra per catturare la parte. I pad del Drum Rack partono da C1 (36) in ordine GM (kick 36, rullante 38, hi-hat chiuso 42): imposta di conseguenza le note MIDI delle tracce della Drum Machine.

**Latenza:** le note fanno il giro Live → SY.CORE → Live e suonano leggermente dopo il metronomo di Live. Si compensa con un **Track Delay** negativo su quelle tracce (a orecchio, circa da −10 a −30 ms) o con un **MIDI Clock Sync Delay** negativo su `SYC CTRL A`; il loopback ping della F4 lo misurerà.

**Provato:** Drum Machine → Drum Rack, Sequencer → Emulator X3 (standalone) e Analog di Live, Chord Prog → Emulator X3, tutti in sync, anche con l'FM-1 Emulator aperto.

## 11. Struttura dei repository

**Decisione: niente fork "SY.CORE Live".** Una sola app, con un'edizione o un profilo "Live", più un repo dedicato solo per ciò che sta fuori dal browser.

**Perché niente fork**
- Il valore sta nel nucleo condiviso: MIDI Flow, `midi-transport`, Sound Engine, Multi Sound, generatori e AI. Con un fork ogni correzione al routing o al clock andrebbe fatta due volte, e i due rami divergono.
- Lo sviluppo è di una persona sola: due app da mantenere, testare e pubblicare raddoppiano il lavoro senza aggiungere funzioni.
- Il repo sa già fare edizioni (`build:demo`, `build:website` come modalità di Vite) e il Module Manager nasconde i moduli che non servono.

### 11.1 `sycore-refactor` — l'app (con l'edizione "Live")
- Modalità di build `dev:live` e `build:live` con `VITE_EDITION=live`, oppure un profilo "Live" scelto all'avvio, sullo stesso deploy.
- Un preset del Module Manager con solo MIDI Flow, Chord Seq, Drum Machine, Sequencer, Arpeggiator, Note Latch, Multi Sound, Sound Engine e Global Transport.
- Il nodo "Ableton Live" con il suo inspector (§4, F2.1-2.2) e la vista **"Live Rig"** (F6): stato del clock esterno (EXT/INT, BPM, battuta), le 16 lane di `SYC IN`, la Control Map, gli indicatori di latenza e di loop.
- Il wizard "Ableton Live" (F6).
- Tutte le funzioni di F1–F6 entrano nel nucleo e servono anche a chi non usa Live (clock esterno, regole PC, Control Map).

### 11.2 `sycore-ableton` — i pezzi intorno a Live (questo repo)
```
sycore-ableton/
├─ PIANO_INTEGRAZIONE_ABLETON.md   (italiano)
├─ ABLETON_INTEGRATION_PLAN.md     (inglese)
├─ paper/           paper "SY.CORE Live" per musicisti e tecnici audio (IT, EN) e immagini in assets/
├─ template/        SYCORE Template.als (Live 12, compatibile con Standard) e Ableton Project
├─ m4l/             device "SY.CORE Link" (F7)
├─ bridge/          bridge Node per Ableton Link (F7)
├─ docs/            guide per l'utente, Control Map stampabile, confronto con MIDI Agent
└─ tools/           script di test (loopback ping da riga di comando, monitor delle porte)
```

### 11.3 `sycore-desktop` — solo se si fa la F8
- Contiene **solo la shell** (Tauri), che carica la build `build:live` di `sycore-refactor` e aggiunge le funzioni native (porte virtuali, avvio automatico, finestra dedicata).
- Nessun codice dell'app copiato. Le API native passano all'app tramite un adattatore (`window.sycoreNative`); se l'adattatore non c'è, l'app si comporta come nel browser.

### 11.4 Regole
- Il codice musicale e MIDI vive **solo** in `sycore-refactor`.
- I repo esterni dipendono dall'app, mai il contrario: l'app funziona senza nessuno di loro.
- Il protocollo fra app, bridge, M4L e shell è JSON versionato (`"v": 1`) ed è documentato in `sycore-ableton/docs/`.

## 12. Scenari di utilizzo

Cosa permette di fare SY.CORE con Live, sul palco e in studio. Per ogni scenario sono indicate le fasi del piano necessarie. **"Oggi"** significa che funziona già con le funzioni esistenti di SY.CORE, registrando le porte `SYC` come dispositivi virtuali.

### S1 — Live set ibrido sul palco
**Contesto:** set di 45 minuti con Live, Roland S-1, un modulo multitimbrico (es. E-MU X3) e un synth software standalone, senza VST in Live.
**Come funziona:**
- Live è master del clock; Chord Seq, Drum Machine con Bass Line e Sequencer di SY.CORE seguono.
- Ogni scena di Live è una sezione del brano: la clip di controllo su `SYC CTRL` cambia insieme gli slot A–H di tutte le app e i preset dei synth.
- Le clip di Live suonano le parti fisse (lead, pad) attraverso le lane di `SYC IN`; SY.CORE le smista ai synth.
- Il Roland S-1 cambia suono via Sound Engine (preset come configurazioni di CC sul preset corrente o temp).

**Fasi:** F1, F2, F3, F5 (scene → sezioni), F6 (template).

### S2 — Jam in studio "sempre in registrazione"
**Contesto:** jam libera di un'ora: tu suoni la tastiera, SY.CORE genera accordi e batteria, e nulla deve andare perso.
**Come funziona:**
- Nel template, le tracce di Live su `SYC OUT` (una per app) sono sempre armate. Le tracce External Instrument registrano l'audio dei synth.
- Quando l'idea gira, Generate o Mutate dal controller: la variazione entra alla battuta successiva e viene registrata.
- La MIDI Capture di SY.CORE registra in parallelo come rete di sicurezza, esportabile in `.mid`.
- Capture MIDI di Live recupera anche ciò che è stato suonato prima di premere Rec.

**Fasi:** F1, F4 (ritorno e offset), F3 (Generate dal controller).

### S3 — Scrittura di un brano con l'AI
**Contesto:** parti da zero, con una tonalità, uno stile e un tempo.
**Come funziona:**
- Il Song Composer genera un piano completo: sezioni, accordi, batteria, basso, sequenze e preset suggeriti per i tuoi synth.
- Ascolti tutto subito sui suoni veri del rig, non su un General MIDI.
- Correggi negli editor dedicati (accordi, step, accent, ratchet, probabilità), poi registri in Live o trascini i `.mid`.
- L'editing finale avviene nel piano roll di Live.

**Fasi:** **oggi** con export `.mid` e drag & drop; F1 + F4 per registrare in tempo reale; F5 per un'AI che tiene conto del rig.

### S4 — Una tastiera per tutto il rig
**Contesto:** una sola master keyboard, tre synth, nessun ri-armamento di tracce durante la jam.
**Come funziona:**
- La tastiera appartiene a SY.CORE. MIDI Flow fa lo split (basso sull'S-1 nella zona bassa, pad sull'X3 in quella alta), il layer e il fanout multicanale per i synth multitimbrici.
- Note Latch tiene un drone e lo rilascia con un solo comando.
- Una configurazione di Flow per ogni brano, richiamabile al volo.
- Live registra quello che suoni tramite un cavo di Flow verso `SYC OUT`.

**Fasi:** **oggi** (routing device→device, split, filtri, multi-CH out); F4 per registrare in Live con l'offset compensato.

### S5 — Riaprire un progetto e ritrovare i suoni (total recall)
**Contesto:** riapri un brano dopo mesi; i synth hardware hanno altri suoni.
**Come funziona:**
- La prima clip di ogni lane contiene un Program Change; SY.CORE applica la regola del dispositivo.
- Con `multi-sound` seleziona la patch per banco e nome; con `sound-engine` riscrive la configurazione di CC dell'S-1.
- Premi Play e il rig suona come l'ultima volta, senza SysEx e senza Max for Live in Live.

**Fasi:** F2 (PC intelligente).

### S6 — Synth software senza plugin in Live
**Contesto:** vuoi usare synth software, ma senza VST dentro Live (stabilità, licenze, set portabili).
**Come funziona:**
- I synth girano standalone e ricevono il MIDI da SY.CORE tramite cavo virtuale (Virtual Instruments).
- Live li sequenzia come se fossero hardware, tramite le lane di `SYC IN`. L'audio rientra in Live dalla scheda audio (loopback) o con VB-Cable o BlackHole.
- Se un synth si blocca, Live e il resto del rig continuano.

**Fasi:** **oggi** per il routing; F2 per le lane; §10 per l'audio.

### S7 — Due superfici di controllo, due cervelli
**Contesto:** Push controlla Live (clip, mixer); un secondo controller controlla le app di SY.CORE.
**Come funziona:**
- Le MIDI Actions di SY.CORE mappano il secondo controller su slot A–H, Fill, Repeater, Generate, mute della Bass Line e lo stop di Note Latch.
- In alternativa, le stesse azioni partono dalle clip di controllo di Live (Control Map), così sono registrabili e automatizzabili nell'arrangement.

**Fasi:** **oggi** con le MIDI Actions; F3 per la quantizzazione alla battuta e la Control Map; F7 per lo script di Push.

### S8 — Live si blocca, la musica continua
**Contesto:** sul palco Live si blocca a metà brano.
**Come funziona:**
- Con l'opzione `continua in INT`, SY.CORE si accorge della perdita del clock e prosegue con il clock interno all'ultimo BPM.
- Le app e i synth hardware continuano a suonare, quindi batteria, basso e accordi non si fermano.
- Riavvii Live, premi Play, e SY.CORE si riaggancia al nuovo Start.
- Si perde solo l'audio passato da Live, non la parte MIDI e hardware del rig.

**Fasi:** F1 (perdita del clock).

### S9 — Prove e didattica con backing track
**Contesto:** prove di una band o lezione: Live suona la backing track, SY.CORE la sezione ritmica e armonica variabile.
**Come funziona:**
- Le app seguono Live; il cambio di slot o di stile cambia il groove senza toccare l'arrangement.
- Il Key follow sul ch 15 trasporta Sequencer e Chord Seq per provare il brano in un'altra tonalità.

**Fasi:** F1, F3.

### Riepilogo

| Scenario | Oggi | Con l'MVP (F1–F4, F6) | Con F5 / F7 |
|---|---|---|---|
| S1 Live set ibrido | — | ✅ | scene → sezioni, M4L |
| S2 Jam sempre in registrazione | parziale (MIDI Capture) | ✅ | — |
| S3 Scrittura con AI | ✅ via `.mid` | ✅ in tempo reale | AI consapevole del rig |
| S4 Una tastiera per tutto il rig | ✅ | ✅ con offset | — |
| S5 Total recall dei suoni | — | ✅ | — |
| S6 Synth software senza VST | ✅ routing | ✅ lane | — |
| S7 Due superfici di controllo | ✅ MIDI Actions | ✅ Control Map | script di Push |
| S8 Live si blocca, la musica continua | — | ✅ | — |
| S9 Prove con backing track | — | ✅ | — |
