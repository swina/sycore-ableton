# SY.CORE Live

*La parte generativa del tuo set, dentro Ableton Live, mentre suoni*

4 novembre 2026, aggiornato il 16 novembre 2026 · Device: SY.CORE Live Devices 1.8.0 · English version: [SYCORE_LIVE_paper_EN.md](SYCORE_LIVE_paper_EN.md) · Versione online: https://claude.ai/artifact/DNV5wTdE2hesCpcK2qNDno

## In breve

SY.CORE è un ambiente di performance che gira nel browser: una Drum Machine con linee di basso e fill, un Chord Prog, un Sequencer a step, un Arpeggiatore e un **Rig Controller** che li lancia come clip. **SY.CORE Live** lo porta dentro un set di Ableton Live: SY.CORE segue il clock di Live e suona sulle tracce di Live, attraverso un device Max for Live, **SY.CORE Link**.

Live resta il DAW: registra, arrangia, mixa e suona i tuoi strumenti. SY.CORE genera e cambia le parti **mentre il brano suona**, a tempo con Live, e tutto quello che suona si registra in Live come normali clip MIDI.

**Per chi è:** musicisti che suonano dal vivo o in jam con Live e vogliono le parti generative sul palco, non solo in studio; e chi vuole che i propri controller guidino tutto il rig, non un device alla volta.

**Stato:** disponibile oggi. I device sono alla versione 1.8.0, come Live Pack o zip (release GitHub `link-v1.8.0`); SY.CORE si apre dal suo indirizzo in Chrome o Edge. Il paragrafo *Stato e roadmap* elenca cosa è fatto e cosa resta aperto.

## Il problema: prima generi, poi suoni

I generatori MIDI sono tanti, anche basati su AI, e quasi tutti lavorano a monte della performance: generi una clip, la trascini su una traccia e solo dopo la lanci. Una progressione diversa o un break non previsto a metà set vogliono dire tornare all'editor.

Il resto del rig ha i suoi punti deboli quando suoni dal vivo:

| Area | Con Live da solo | Effetto sul palco |
| --- | --- | --- |
| Generazione | I generatori di clip e i MIDI Generators di Live 12 lavorano mentre modifichi, non mentre il brano suona | Nessun pattern che cambia sulla battuta senza fermarsi |
| Controller | Una manopola è mappata su un parametro di un device; una nuova traccia, un nuovo set o un altro synth vogliono una nuova mappatura | Ogni set inizia rimappando |
| Performance | La Session View lancia clip; niente lancia, sfoltisce o rigenera un *generatore* | Build-up e break richiedono clip preparate |
| Strumenti esterni | Un'app nel browser raggiunge Live tramite porte MIDI virtuali: il loro timing, la loro configurazione, porte non multi-client su Windows | Note fuori griglia, configurazioni fragili |

Niente di questo riguarda l'audio di Live. Riguarda quello che gli sta intorno: è lo spazio che SY.CORE occupa.

## La soluzione: SY.CORE Link

```
SY.CORE (browser)                          Ableton Live
┌──────────────────────┐   WebSocket   ┌───────────────────────────────┐
│ Drum Machine  ch 10  │ ───────────▶  │ SY.CORE Link        (bridge)   │
│ Chord Prog    ch 1   │  127.0.0.1    │   ├─▶ Link Receive ch 10       │──▶ Drum Rack
│ Sequencer     ch 2   │    :9400      │   ├─▶ Link Receive ch 1        │──▶ synth
│ Rig Controller       │ ◀───────────  │   └─▶ …                        │──▶ …
└──────────────────────┘  tempo, posiz. └───────────────────────────────┘
                          e Play / Stop di Live
```

- **SY.CORE Link** (`sycore-link.amxd`, uno per set) fa girare un piccolo server dentro Live. Manda a SY.CORE il trasporto di Live (Play, Stop, tempo, posizione, metro) e riceve le note di SY.CORE.
- SY.CORE **segue il clock di Live** e manda ogni nota **con il beat di Live su cui deve suonare**: il device la suona su quel beat, così i ritardi del browser non spostano le note.
- **SY.CORE Link Receive** (`sycore-link-receive.amxd`) sta su ogni traccia che suona una parte e lascia passare un canale MIDI: Drums sul 10, Chords sull'1 e così via. Le note le suonano i tuoi strumenti: Drum Rack, Wavetable, Drift, synth hardware tramite External Instrument.
- **Niente porte MIDI virtuali e niente plugin.** SY.CORE non è un VST né un AU: niente da scansionare o autorizzare. In Live trascini device Max for Live.

**Timing misurato** (Live 12, 120 BPM, una take di 34 battute registrata in Arrangement): scarto medio dalla griglia **+0,7 ms**, deviazione tipica circa **±5 ms** (la risoluzione con cui Live registra), durate delle note stabili.

## Quattro device

| Device | Cosa fa | Quanti |
| --- | --- | --- |
| **SY.CORE Link** | Il bridge: trasporto e tempo di Live verso SY.CORE, le note di SY.CORE in Live a tempo. LED di stato: ambra in attesa, verde connesso, rosso errore | uno per set |
| **SY.CORE Link Receive** | Suona un canale (1–16) di quello che manda SY.CORE, sulla sua traccia | uno per traccia che suona SY.CORE |
| **SY.CORE Rig** | Il Rig Controller dentro Live: lo stesso layout Launchpad 9×9, con le stesse etichette e gli stessi colori; un click è la pressione di un pad. La sua finestra mostra **NOW / NEXT** (l'accordo che suona e il prossimo) con la barra di avanzamento dell'accordo | opzionale, qualsiasi traccia |
| **SY.CORE Map** | I tuoi encoder sullo strumento della traccia selezionata in Live, per tabella (vedi *Mappa il controller una volta*) | opzionale, uno per set |

## Per i musicisti

Premi Play in Live e le app di SY.CORE suonano insieme. Sono strumenti che suoni, non clip da trascinare.

- **Generazione durante la riproduzione.** **GEN** scrive al volo un nuovo pattern di batteria, una progressione o una sequenza, dal Launchpad, nello stile scelto per slot. **Shift + GEN** (Mutate) ne riscrive solo una parte, secondo *Vary*, e tiene il resto.
- **Otto slot per app, A–H**, lanciati come clip: uno slot parte, cambia o si ferma al prossimo punto di sync. Con Live fermo, un pad **arma** lo slot e il Play di Live lo fa partire.
- **Fill** suona un fill alla battuta successiva; **Repeat** (tenuto) ripete la batteria; **Density** sfoltisce batteria e sequenze con una manopola, per build-up, break e drop senza preparare altro.
- **Accordi uno alla volta.** Il Chord Prog genera progressioni, algoritmiche o con AI, e puoi suonarle accordo per accordo dai pad. **Now / Next** mostra sempre l'accordo che suona, il prossimo e quanto dura ciascuno.
- **La tonalità dal Rig.** Key − / + sposta la tonica del Chord Prog di un semitono, Shift passa maggiore ↔ minore, e le progressioni che scrive GEN sono in quella tonalità; il GEN del Sequencer la segue e, mentre suona, il Sequencer segue gli accordi del Chord Prog (trasponendo, per grado, o come arpeggio dell'accordo che suona). **Seq Free** lo sgancia per un po', per tenere un riff sopra i cambi.
- **Sequencer fino a 64 step**, una catena di 16 pattern, e generatori con linee Melody (motivo) o Classic, ritmo pesato, euclideo o casuale.
- **Trasporto e tempo di Live dal Rig.** Il Play / Stop del Rig avvia e ferma Live stesso; TAP, − / + e la manopola del tempo impostano il tempo di Live.
- **Tutto finisce in Live.** Registri in Arrangement View e ottieni normali clip MIDI: le modifichi, le quantizzi, le riusi. SY.CORE non ti chiude nel browser.

## Parla la lingua di Live

| In Live sei abituato a… | In SY.CORE |
| --- | --- |
| Lanciare una clip dalla Session View | Lanciare gli slot A–H di Drum, Chord, Seq, Bass e Arp dai pad |
| La Launch Quantization globale | **Trigger sync** per traccia: off (subito), 1 beat, 2 beat, battuta, sulla griglia del brano di Live |
| Premere una clip che suona per fermarla | Il pad dello slot che suona ferma l'app, a tempo |
| Lanciare una clip a trasporto fermo | Il pad **arma** lo slot: parte con il Play di Live |
| Le scene | **Sezioni 1–8**: un pad cambia insieme gli slot di tutte le app |
| Una Macro su un Rack | **Density**, **Intensity** (volume e velocity), Mute e Solo per traccia, anche da controller |

## Il Rig Controller

Un controller per tutto il rig, non per uno strumento. Righe **Drum, Chord, Seq, Bass, Arp**, slot A–H, Mute / Solo / GEN per riga, le sezioni, Fill, Repeat, Seq Free, la tonalità, Panic e il passaggio al clock interno (tenendo premuto).

- **Tre viste dello stesso stato:** il layout Rig in SY.CORE, un **Launchpad Mini MK1** (griglia 8×8, LED sempre allineati a SY.CORE, così dopo una disconnessione si rimette in riga da solo) e un **AKAI MIDImix** (strisce di manopole, fader e pulsanti, con pickup). Il device SY.CORE Rig mostra il layout Launchpad dentro Live.
- **Qualsiasi altro controller** con il MIDI Learn (click destro su un comando), salvato e condiviso come **template di controller** (JSON).
- **La riga Bass è una parte a sé:** la linea di basso della Drum Machine, lanciata indipendentemente dalla batteria. **La riga Arp** sceglie il modo dell'arpeggio; le sue manopole impostano l'estensione in ottave e il rate.
- **Workspace Performance:** una schermata da palco con i player come *play view* (quello che suona, con lo step e l'accordo che suonano accesi; gli step del Sequencer colorati per velocity e attivati / disattivati con un click), i comandi del Rig con Now / Next sopra un grande Play, e la griglia del Launchpad. Pannelli affiancati, ridimensionabili al tocco, effetti alleggeriti.

## Mappa il controller una volta

In Live una manopola è mappata su un parametro di un device. Con **SY.CORE Map**, l'encoder *n* guida sempre lo **slot *n*** dello strumento in primo piano:

- **Segue la selezione:** selezioni una traccia in Live e gli encoder sono sul suo strumento (FOLLOW); oppure li blocchi su una traccia (LOCK) e passi da una traccia all'altra dal controller.
- **Una tabella per tipo di strumento:** filtro sull'1, risonanza sul 2… su ogni Drift, Analog o Simpler (tabelle di fabbrica incluse).
- **Rack e preset di Live:** prima le Macro configurate del Rack, con i loro nomi, poi lo strumento interno per gli slot rimasti; le **Macro Variations** richiamate o randomizzate dai pad.
- **Pickup:** cambi traccia e giri, senza salti. Gli encoder muovono i parametri come il mouse: automazioni e mouse continuano a funzionare.
- **Su uno schermo touch:** il pannello Map mostra gli slot come riquadri o come due file di fader verticali.

## A confronto con i plugin generatori MIDI con AI

| | Plugin generatore AI | SY.CORE Live |
| --- | --- | --- |
| Risultato | Clip MIDI da trascinare | Riproduzione dal vivo a tempo, con cambi sulla battuta, e clip registrate in Live |
| Quando genera | Fuori dalla riproduzione, un prompt alla volta | Durante la riproduzione, dai pad, con i generatori integrati o con l'AI |
| Parti | Di solito una alla volta | Batteria, basso, accordi, sequenze e arpeggi che condividono tonalità e accordi |
| Strumenti | Quelli caricati nel DAW | Gli strumenti di Live, synth hardware e software |
| Nel DAW | Un plugin VST o AU | Device Max for Live su normali tracce MIDI |
| AI | Il servizio del prodotto | Il provider che scegli, con la tua chiave; i generatori integrati funzionano offline |

Il confronto riguarda la categoria di prodotto; i singoli plugin cambiano da una versione all'altra.

## Requisiti e configurazione

| | |
| --- | --- |
| **Ableton Live** | Live 12 con Max for Live (Suite, oppure Standard + Max for Live) |
| **Browser** | Chrome o Edge, con SY.CORE aperto; consenti l'*accesso alla rete locale* se Chrome lo chiede (SY.CORE parla con il bridge su `127.0.0.1:9400`) |
| **Sistema** | Windows 10/11 (testato) o macOS (dovrebbe funzionare, non ancora testato) |
| **Device** | SY.CORE Live Devices 1.8.0: Live Pack (`.alp`) o zip, dalla release GitHub `link-v1.8.0` o dalla pagina *Ableton Live* del sito di SY.CORE |

**Configurazione:**

1. **Installa i device.** Live Pack: doppio click, Live chiede dove scompattarlo, poi aggiungi quella cartella al browser (*Places › Add Folder…*). Zip: scompattalo, tieni i file insieme, metti la cartella nella User Library o aggiungila sotto Places.
2. **Trascina SY.CORE Link** su una traccia MIDI (es. *SY.CORE Control*): il LED diventa ambra, poi verde quando SY.CORE si connette.
3. **Trascina SY.CORE Link Receive** su ogni traccia che suona una parte e clicca il suo canale.
4. **In SY.CORE**, scegli la sorgente di clock **EXT · Live (M4L) — SY.CORE Link** e, in MIDI Flow, collega le app a **Live (M4L)** con i canali dei receiver.

**Buono a sapersi:** dal vivo suona in **Session View** (in Arrangement il Play di Live suona anche le clip già presenti); registra in Arrangement con un **Count-In di 1 battuta** (la prima nota dopo il Play può arrivare qualche decina di ms in ritardo). Il Launchpad usato dal Rig non deve essere una Control Surface di Live. La griglia di sync conta le battute in 4/4.

## Stato e roadmap

| Fase | Cosa comprende |
| --- | --- |
| **Disponibile oggi** | SY.CORE Link 1.8.0 (bridge, Receive, Rig, Map) come Live Pack e zip; SY.CORE segue clock, tempo e posizione di Live; Play / Stop e tempo di Live dal Rig; Rig Controller con Launchpad Mini MK1, AKAI MIDImix, MIDI Learn e template di controller; per traccia Trigger sync, Mute, Solo, Intensity, Density; sezioni; GEN e Mutate durante la riproduzione; Seq Free; Now / Next; workspace Performance; SY.CORE Map con tabelle per Drift, Analog, Simpler e Rack; P1 / P2 del Sequencer sugli slot del Map di qualsiasi traccia (1.8); registrazione in Live come clip MIDI |
| **Prossimi passi** | Scene del rig: uno slot o una sezione che richiama anche suoni e routing; richiamo dai locator o dalle scene di Live, con chase partendo a metà brano; regole di Program Change per dispositivo; un editor di tabelle per SY.CORE Map e strumenti VST |
| **Più avanti** | Scene di Live come sezioni del Song Composer; AI che conosce i synth e i preset del tuo rig; un template di Live Set; test su macOS; OSC per superfici su tablet |

## Principi

SY.CORE estende la voce di uno strumento, non la sostituisce. SY.CORE Live applica lo stesso principio ad Ableton Live.

- **Local-first.** Pattern, preset, routing e mappature restano sul computer che hai davanti. SY.CORE parla con Live su `127.0.0.1`; l'AI è un'opzione e i generatori integrati funzionano offline.
- **Niente plugin.** SY.CORE si apre nel browser; in Live ci sono solo device Max for Live su normali tracce MIDI.
- **Open source.** SY.CORE è sotto licenza MIT; i device per Live sono GPL-3.0. Si possono leggere, verificare ed estendere.
- **Donationware.** Nessuna versione Pro e nessuna funzione bloccata: le donazioni sono un grazie, non un pedaggio.
