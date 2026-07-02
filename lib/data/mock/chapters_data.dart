import '../../models/chapter.dart';
import '../../models/choice.dart';
import '../../models/dialogue_line.dart';
import '../../models/minigame_type.dart';
import '../../models/scene.dart';

/// Id sentinella usato SOLO dall'ultimo capitolo: quando una scelta porta a
/// questo "nodo", il [GameProvider] intercetta la transizione e calcola
/// dinamicamente quale scena finale raggiungere (buono o perfetto) in base
/// agli indizi raccolti, alla fiducia e al sospetto verso Sandra, invece di
/// risolverlo come una normale scena statica. Vedi `game_provider.dart`.
const String kConfrontoEsitoSentinel = 'c10_confronto_esito';

/// I dodici capitoli dell'indagine. La maggior parte è composta da 3 scene
/// (arrivo/narrazione -> indagine/dialogo con scelta -> chiusura), alcune ne
/// hanno una in più per ospitare un minigioco investigativo. L'ultimo
/// capitolo rompe lo schema con un vero bivio verso i finali multipli.
final List<Chapter> kChapters = [
  // ---------------------------------------------------------------------
  Chapter(
    id: 'c1',
    numero: 1,
    titolo: 'Il ciondolo',
    descrizione:
        'Durante una festa privata tra Golasecca e Sesto Calende, Mauro viene '
        'trovato morto. Il ciondolo di Segghy è sulla scena del crimine.',
    luogo: 'Golasecca',
    scenaInizialeId: 'c1_s1',
    scene: [
      Scene(
        id: 'c1_s1',
        luogo: 'Golasecca — Villa sul Ticino',
        testoNarrativo:
            'Le luci della festa si riflettono nebbiose sull\'acqua scura del '
            'Ticino. La musica si interrompe di colpo: un urlo arriva dalla '
            'serra in fondo al giardino. Mauro è a terra, immobile, tra vasi '
            'rovesciati e terra sparsa. Accanto al corpo, seminterrato, '
            'qualcosa luccica: un ciondolo a forma di cavallo. Il cuore di '
            'Segghy si ferma: la sua catenina si è rotta durante la festa, e '
            'quel ciondolo sembra identico al suo.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'matteo',
            nomeVisualizzato: 'Matteo',
            testo: 'Tutti indietro. Nessuno tocchi niente. Segghy... quello '
                'non è il tuo ciondolo?',
          ),
        ],
        indiziOttenibili: ['clue_vaso_rovesciato'],
        scelte: [
          Choice(
            id: 'c1_s1_a',
            testoScelta: 'Dì la verità subito: "L\'ho perso stasera, non so come sia finito qui."',
            effetto:
                'La sincerità disarma Matteo, ma alcuni ospiti iniziano a '
                'sussurrare.',
            prossimoNodo: 'c1_s2',
            modificaFiducia: {'matteo': 8, 'riccardo': 2},
          ),
          Choice(
            id: 'c1_s1_b',
            testoScelta: 'Resta in silenzio e osserva la scena con attenzione.',
            effetto:
                'Il silenzio insospettisce Matteo, ma noti un dettaglio che '
                'agli altri sfugge.',
            prossimoNodo: 'c1_s2',
            modificaFiducia: {'matteo': -4},
            indiziSbloccati: ['clue_orario_festa'],
          ),
          Choice(
            id: 'c1_s1_c',
            testoScelta: 'Chiedi di poter chiamare un avvocato prima di dire altro.',
            effetto:
                'La prudenza è legittima, ma agli occhi di alcuni sembri già '
                'sulla difensiva.',
            prossimoNodo: 'c1_s2',
            modificaFiducia: {'matteo': -6},
          ),
        ],
      ),
      Scene(
        id: 'c1_s2',
        luogo: 'Golasecca — Villa sul Ticino',
        testoNarrativo:
            'I Carabinieri isolano la serra. Matteo ti chiama in disparte per '
            'un primo interrogatorio informale, mentre Riccardo cerca di '
            'avvicinarsi senza farsi notare dagli altri ospiti. Il ciondolo '
            'ritrovato non è il tuo: è identico, ma tu il tuo lo indossavi '
            'fino a un\'ora prima. Qualcuno lo ha raccolto e piazzato lì.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'riccardo',
            nomeVisualizzato: 'Riccardo',
            testo: 'Segghy, quel ciondolo non basta a incastrarti. Ma dobbiamo '
                'muoverci prima che lo facciano loro nella loro testa.',
          ),
          DialogueLine(
            personaggioId: 'matteo',
            nomeVisualizzato: 'Matteo',
            testo: 'Non posso proteggerti ufficialmente, Segghy. Ma se trovi '
                'qualcosa, portalo prima a me.',
          ),
        ],
        scelte: [
          Choice(
            id: 'c1_s2_a',
            testoScelta: 'Accetta l\'aiuto di Riccardo e inizia a indagare insieme a lui.',
            effetto: 'Riccardo apre sul telefono la mappa investigativa dei paesi limitrofi.',
            prossimoNodo: 'c1_s3',
            modificaFiducia: {'riccardo': 6},
          ),
          Choice(
            id: 'c1_s2_b',
            testoScelta: 'Chiedi a Matteo di poter vedere il fascicolo, anche informalmente.',
            effetto: 'Matteo esita, ma ti lascia intuire un dettaglio sull\'orario della morte.',
            prossimoNodo: 'c1_s3',
            modificaFiducia: {'matteo': 6},
            indiziSbloccati: ['clue_orario_festa'],
          ),
          Choice(
            id: 'c1_s2_c',
            testoScelta: 'Proponi a entrambi di lavorare insieme, apertamente, tu compresa.',
            effetto: 'Matteo e Riccardo si guardano, sorpresi ma d\'accordo.',
            prossimoNodo: 'c1_s3',
            modificaFiducia: {'riccardo': 3, 'matteo': 3},
          ),
        ],
      ),
      Scene(
        id: 'c1_s3',
        luogo: 'Golasecca',
        testoNarrativo:
            'Torni a casa all\'alba, con la nebbia che sale dal Ticino come '
            'ogni mattina, ma questa volta sembra diversa: più fitta, più '
            'silenziosa. Sai che non sarai più la stessa finché non scoprirai '
            'chi ha voluto incastrarti. Il tuo telefono vibra.',
        isFinaleCapitolo: true,
        indiziOttenibili: ['clue_ciondolo_falso'],
        messaggioAnonimo: 'Non fidarti di chi ti ha dato da mangiare.',
      ),
    ],
  ),
  // ---------------------------------------------------------------------
  Chapter(
    id: 'c2',
    numero: 2,
    titolo: 'La riva del Ticino',
    descrizione:
        'Con Riccardo, Segghy esplora i sentieri lungo il fiume tra Golasecca '
        'e Sesto Calende. Trova impronte, fango e un biglietto bagnato.',
    luogo: 'Sesto Calende',
    scenaInizialeId: 'c2_s1',
    scene: [
      Scene(
        id: 'c2_s1',
        luogo: 'Sesto Calende — Riva del Ticino',
        testoNarrativo:
            'Il sentiero lungo il fiume è deserto a quest\'ora. Riccardo '
            'cammina qualche passo avanti, con il telefono puntato verso il '
            'terreno umido. "Qui," dice a un certo punto, indicando il fango. '
            'Delle impronte doppie, profonde, si allontanano verso l\'acqua: '
            'qualcuno ha trascinato qualcosa di pesante, di recente.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'riccardo',
            nomeVisualizzato: 'Riccardo',
            testo: 'Non sono impronte di uno che passeggia, Segghy. Qualcuno '
                'ha trascinato un peso fino alla riva.',
          ),
        ],
        indiziOttenibili: ['clue_impronte_doppie'],
        scelte: [
          Choice(
            id: 'c2_s1_a',
            testoScelta: 'Segui le impronte controcorrente, verso i canneti.',
            effetto: 'Tra i canneti trovi qualcosa di inaspettato, mezzo sepolto nel fango.',
            prossimoNodo: 'c2_s2',
            indiziSbloccati: ['clue_biglietto_bagnato'],
          ),
          Choice(
            id: 'c2_s1_b',
            testoScelta: 'Fotografa tutto con calma prima di muoverti, per non contaminare la scena.',
            effetto: 'Il metodo paga: le foto saranno utili più avanti, ma perdi tempo prezioso.',
            prossimoNodo: 'c2_s2',
            modificaFiducia: {'riccardo': 4},
          ),
          Choice(
            id: 'c2_s1_c',
            testoScelta: 'Chiama subito Matteo prima di toccare qualunque cosa.',
            effetto: 'Matteo apprezza la procedura corretta, anche se arrivi con più cautela.',
            prossimoNodo: 'c2_s2',
            modificaFiducia: {'matteo': 5},
          ),
        ],
      ),
      Scene(
        id: 'c2_s2',
        luogo: 'Sesto Calende — Riva del Ticino',
        testoNarrativo:
            'Il fiume scorre lento, quasi in ascolto. Riccardo osserva le '
            'barche ormeggiate poco più a valle: una di queste ha lo scafo '
            'lavato di fresco, in un punto solo. Troppo pulito per essere '
            'normale, in un posto dove nessuno pulisce mai niente prima '
            'dell\'inverno. Sul bordo, alcune tracce si sono impresse nella '
            'vernice ancora umida: vale la pena confrontarle con calma.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'segghy',
            nomeVisualizzato: 'Segghy',
            testo: 'Quella barca non è mai stata così pulita in vita sua. '
                'Qualcuno ha cancellato qualcosa.',
          ),
        ],
        minigioco: MinigameType.confrontoImpronte,
        indizioMinigioco: 'clue_impronta_estranea',
        scelte: [
          Choice(
            id: 'c2_s2_a',
            testoScelta: 'Sali a bordo per controllare da vicino.',
            effetto: 'Trovi tracce di sangue lavate male sul bordo dello scafo.',
            prossimoNodo: 'c2_s3',
            modificaFiducia: {'matteo': -2},
          ),
          Choice(
            id: 'c2_s2_b',
            testoScelta: 'Chiama subito Matteo per segnalare la barca.',
            effetto: 'Matteo arriva in fretta: la collaborazione rafforza la sua fiducia in te.',
            prossimoNodo: 'c2_s3',
            modificaFiducia: {'matteo': 8},
          ),
          Choice(
            id: 'c2_s2_c',
            testoScelta: 'Preleva con cura un campione del liquido di pulizia rimasto sullo scafo.',
            effetto: 'Riccardo lo etichetta per farlo analizzare: potrebbe rivelarsi utile.',
            prossimoNodo: 'c2_s3',
            modificaFiducia: {'riccardo': 3},
            modificaSospetto: {'moreno': 4},
          ),
        ],
      ),
      Scene(
        id: 'c2_s3',
        luogo: 'Sesto Calende',
        testoNarrativo:
            'Il biglietto bagnato, una volta asciugato con cura da Riccardo, '
            'rivela poche parole ancora leggibili: "...al maneggio, dopo '
            'mezzanotte...". Il pensiero corre subito a Manuela, e un brivido '
            'ti attraversa la schiena. Il fiume, pensi, non dimentica mai '
            'niente.',
        isFinaleCapitolo: true,
      ),
    ],
  ),
  // ---------------------------------------------------------------------
  Chapter(
    id: 'c2b',
    numero: 3,
    titolo: 'Il socio scomparso',
    descrizione:
        'Adriano, ex socio in affari di Mauro, nasconde un rancore vecchio di '
        'anni. Segghy scopre il contratto che gli è costato l\'azienda.',
    luogo: 'Sesto Calende',
    scenaInizialeId: 'c2b_s1',
    scene: [
      Scene(
        id: 'c2b_s1',
        luogo: 'Sesto Calende — Magazzino di Adriano',
        testoNarrativo:
            'Il nuovo "ufficio" di Adriano è un magazzino spoglio alla '
            'periferia di Sesto Calende, ben lontano dai palazzi che un '
            'tempo frequentava. Vi trovate tra scatoloni ancora da disfare. '
            'Adriano vi accoglie con un sorriso teso, le mani sporche di '
            'polvere, gli occhi che si spostano continuamente verso la '
            'porta.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'adriano',
            nomeVisualizzato: 'Adriano',
            testo: 'So cosa pensi. "Ex socio rovinato, movente perfetto." Ma '
                'io a quella festa non ci sono nemmeno andato.',
          ),
        ],
        scelte: [
          Choice(
            id: 'c2b_s1_a',
            testoScelta: 'Chiedigli direttamente cosa è successo con Mauro e la società.',
            effetto: 'Adriano si irrigidisce, poi inizia a raccontare, a fatica.',
            prossimoNodo: 'c2b_s2',
            modificaFiducia: {'adriano': 5},
          ),
          Choice(
            id: 'c2b_s1_b',
            testoScelta: 'Resta in ascolto, lasciando che sia lui a guidare la conversazione.',
            effetto: 'Adriano si rilassa leggermente, meno sulla difensiva.',
            prossimoNodo: 'c2b_s2',
            modificaFiducia: {'adriano': 8},
          ),
          Choice(
            id: 'c2b_s1_c',
            testoScelta: 'Fagli notare subito che il suo nervosismo non aiuta la sua posizione.',
            effetto: 'Adriano si chiude a riccio, sulla difensiva.',
            prossimoNodo: 'c2b_s2',
            modificaFiducia: {'adriano': -6},
            modificaSospetto: {'adriano': 6},
          ),
        ],
      ),
      Scene(
        id: 'c2b_s2',
        luogo: 'Sesto Calende — Magazzino di Adriano',
        testoNarrativo:
            'Adriano tira fuori da un cassetto una cartellina consumata: il '
            'contratto con cui, anni prima, Mauro si era impossessato delle '
            'sue quote societarie, firmato pochi giorni dopo la morte di suo '
            'padre, quando non ragionava lucidamente. "Mi ha fregato quando '
            'ero più debole," dice, con la voce che trema.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'adriano',
            nomeVisualizzato: 'Adriano',
            testo: 'Ho passato anni a immaginare cosa gli avrei detto se '
                'l\'avessi incontrato di nuovo. Ma quella sera ero a Sesto '
                'Calende, da solo, a chiudere l\'inventario.',
          ),
        ],
        indiziOttenibili: ['clue_contratto_adriano'],
        scelte: [
          Choice(
            id: 'c2b_s2_a',
            testoScelta: 'Chiedigli se qualcuno può confermare che era davvero qui, quella notte.',
            effetto: 'Adriano esita: il suo racconto lascia scoperta quasi un\'ora.',
            prossimoNodo: 'c2b_s3',
            indiziSbloccati: ['clue_alibi_adriano'],
            modificaSospetto: {'adriano': 8},
          ),
          Choice(
            id: 'c2b_s2_b',
            testoScelta: 'Digli che capisci la sua rabbia, senza indagare oltre sull\'alibi.',
            effetto: 'Adriano si commuove, sorpreso dalla tua empatia.',
            prossimoNodo: 'c2b_s3',
            modificaFiducia: {'adriano': 10},
          ),
          Choice(
            id: 'c2b_s2_c',
            testoScelta: 'Proponigli di portare il contratto a un avvocato, per farsi finalmente giustizia.',
            effetto: 'Adriano ti guarda come se nessuno gli avesse mai offerto aiuto vero.',
            prossimoNodo: 'c2b_s3',
            modificaFiducia: {'adriano': 12},
          ),
        ],
      ),
      Scene(
        id: 'c2b_s3',
        luogo: 'Sesto Calende',
        testoNarrativo:
            'Lasci il magazzino con la sensazione di aver visto un uomo '
            'consumato più dal rimpianto che dalla furia. Non è detto che '
            'sia innocente, ma il suo dolore sembra vero. Riccardo, in '
            'macchina, aggiorna la mappa investigativa con un nuovo nome '
            'cerchiato in rosso.',
        isFinaleCapitolo: true,
      ),
    ],
  ),
  // ---------------------------------------------------------------------
  Chapter(
    id: 'c3',
    numero: 4,
    titolo: 'Il maneggio di Manuela',
    descrizione:
        'Il cavallo Nebbia reagisce a un suono preciso. I gattini giocano con '
        'un oggetto nascosto nella paglia.',
    luogo: 'Somma Lombardo',
    scenaInizialeId: 'c3_s1',
    scene: [
      Scene(
        id: 'c3_s1',
        luogo: 'Somma Lombardo — Maneggio',
        testoNarrativo:
            'L\'odore di fieno e cavalli ti mette quasi a tuo agio, nonostante '
            'tutto. Manuela ti accoglie con un abbraccio più lungo del '
            'solito. Nebbia, la giumenta grigia, scalpita nel box, nervosa '
            'più del normale. I gattini, cresciuti in fretta, rincorrono '
            'qualcosa tra la paglia.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'manuela',
            nomeVisualizzato: 'Manuela',
            testo: 'Segghy, tesoro... non credere a quello che si dice in '
                'giro. Io so chi sei davvero.',
          ),
        ],
        scelte: [
          Choice(
            id: 'c3_s1_a',
            testoScelta: 'Chiedi a Manuela dove si trovava la notte della festa.',
            effetto: 'Manuela si irrigidisce appena, poi risponde con voce troppo controllata.',
            prossimoNodo: 'c3_s2',
            modificaFiducia: {'manuela': -3},
            modificaSospetto: {'manuela': 8},
          ),
          Choice(
            id: 'c3_s1_b',
            testoScelta: 'Rassicurala e chiedi solo di Nebbia, così nervosa.',
            effetto: 'Manuela si rilassa e ti racconta di un rumore che ha spaventato la giumenta.',
            prossimoNodo: 'c3_s2',
            modificaFiducia: {'manuela': 6},
          ),
          Choice(
            id: 'c3_s1_c',
            testoScelta: 'Osserva in silenzio la sua reazione, senza chiedere nulla.',
            effetto: 'Il tuo sguardo attento non sfugge a Manuela, che distoglie gli occhi per un istante.',
            prossimoNodo: 'c3_s2',
            modificaSospetto: {'manuela': 5},
          ),
        ],
      ),
      Scene(
        id: 'c3_s2',
        luogo: 'Somma Lombardo — Maneggio',
        testoNarrativo:
            'Tra la paglia, uno dei gattini trascina goffamente un oggetto '
            'metallico: un vecchio campanello da bicicletta, ammaccato. Nel '
            'momento in cui il campanello tintinna per caso, Nebbia si '
            'impenna, tirando con forza verso l\'angolo più buio del '
            'fienile.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'segghy',
            nomeVisualizzato: 'Segghy',
            testo: 'Tranquilla, Nebbia... cosa ti ha spaventato così tanto?',
          ),
        ],
        indiziOttenibili: ['clue_campanello'],
        scelte: [
          Choice(
            id: 'c3_s2_a',
            testoScelta: 'Prova a calmare Nebbia e osserva dove guarda.',
            effetto: 'Il cavallo si concentra su un punto preciso del fienile, per ora inaccessibile.',
            prossimoNodo: 'c3_s3',
            modificaFiducia: {'manuela': 3},
          ),
          Choice(
            id: 'c3_s2_b',
            testoScelta: 'Chiedi subito a Manuela di chi potrebbe essere quel campanello.',
            effetto: 'Manuela distoglie lo sguardo: "Non ne ho idea," dice, troppo in fretta.',
            prossimoNodo: 'c3_s3',
            modificaFiducia: {'manuela': -5},
            modificaSospetto: {'manuela': 10},
          ),
          Choice(
            id: 'c3_s2_c',
            testoScelta: 'Fotografa il campanello prima di chiedere qualsiasi cosa a chiunque.',
            effetto: 'Un buon istinto investigativo: ora hai una prova che nessuno può negare.',
            prossimoNodo: 'c3_s3',
          ),
        ],
      ),
      Scene(
        id: 'c3_s3',
        luogo: 'Somma Lombardo',
        testoNarrativo:
            'Lasci il maneggio con più domande che risposte. Il campanello, '
            'il nervosismo di Nebbia, lo sguardo sfuggente di Manuela: '
            'qualcosa in quel luogo che consideri casa non torna. Il '
            'telefono vibra di nuovo.',
        isFinaleCapitolo: true,
        messaggioAnonimo: 'Il cavallo ha visto.',
      ),
    ],
  ),
  // ---------------------------------------------------------------------
  Chapter(
    id: 'c3b',
    numero: 5,
    titolo: 'Il debito di Cinzia',
    descrizione:
        'Cinzia, legata al passato del maneggio, aiuta Segghy a ricostruire '
        'con precisione gli orari di quella notte.',
    luogo: 'Somma Lombardo',
    scenaInizialeId: 'c3b_s1',
    scene: [
      Scene(
        id: 'c3b_s1',
        luogo: 'Somma Lombardo — Casa di Cinzia',
        testoNarrativo:
            'Cinzia vive in una casetta a pochi campi dal maneggio che un '
            'tempo era suo. Dalla finestra della cucina si vedono ancora i '
            'tetti delle scuderie. Vi fa accomodare con un\'ospitalità '
            'rigida, quasi difensiva, come chi ha imparato a proprie spese a '
            'non fidarsi troppo in fretta.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'cinzia',
            nomeVisualizzato: 'Cinzia',
            testo: 'Quel maneggio doveva essere mio. Mauro me lo ha portato '
                'via con un prestito che sapeva benissimo non avrei mai '
                'potuto ripagare.',
          ),
        ],
        indiziOttenibili: ['clue_prestito_cinzia'],
        scelte: [
          Choice(
            id: 'c3b_s1_a',
            testoScelta: 'Chiedile che rapporto ha oggi con Manuela.',
            effetto: 'Cinzia esita, poi ammette un legame più profondo di quanto sembri.',
            prossimoNodo: 'c3b_s2',
            indiziSbloccati: ['clue_promessa_manuela'],
            modificaFiducia: {'cinzia': 6},
          ),
          Choice(
            id: 'c3b_s1_b',
            testoScelta: 'Chiedile direttamente dove si trovava la notte della festa.',
            effetto: 'Cinzia si offende per il tono, ma risponde comunque.',
            prossimoNodo: 'c3b_s2',
            modificaSospetto: {'cinzia': 8},
          ),
          Choice(
            id: 'c3b_s1_c',
            testoScelta: 'Ascolta senza giudicare la sua rabbia verso Mauro.',
            effetto: 'Cinzia si scioglie un po\', sollevata di non sentirsi accusata.',
            prossimoNodo: 'c3b_s2',
            modificaFiducia: {'cinzia': 9},
          ),
        ],
      ),
      Scene(
        id: 'c3b_s2',
        luogo: 'Somma Lombardo — Casa di Cinzia',
        testoNarrativo:
            'Cinzia tira fuori un vecchio quaderno in cui, per anni, ha '
            'annotato ogni movimento sospetto legato al maneggio: un\'abitudine '
            'quasi ossessiva, dice, "per non impazzire". Insieme provate a '
            'incrociare i suoi appunti con quello che sapete già, per '
            'ricostruire l\'esatta sequenza di quella notte.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'cinzia',
            nomeVisualizzato: 'Cinzia',
            testo: 'Se mettiamo in ordine gli orari, forse salta fuori chi '
                'mente e chi no.',
          ),
        ],
        minigioco: MinigameType.ricostruzioneTimeline,
        indizioMinigioco: 'clue_registro_visite',
        scelte: [
          Choice(
            id: 'c3b_s2_a',
            testoScelta: 'Ringrazia Cinzia per l\'aiuto e prometti di tenerla informata.',
            effetto: 'Cinzia annuisce, per la prima volta con un mezzo sorriso.',
            prossimoNodo: 'c3b_s3',
            modificaFiducia: {'cinzia': 6},
          ),
          Choice(
            id: 'c3b_s2_b',
            testoScelta: 'Chiedile se ha mai pensato di vendicarsi di persona.',
            effetto: 'Cinzia si irrigidisce: "Ci ho pensato. Non l\'ho fatto."',
            prossimoNodo: 'c3b_s3',
            modificaSospetto: {'cinzia': 10},
          ),
          Choice(
            id: 'c3b_s2_c',
            testoScelta: 'Proponile di condividere il quaderno con Matteo, ufficialmente.',
            effetto: 'Cinzia accetta, sollevata di non dover portare da sola quel peso.',
            prossimoNodo: 'c3b_s3',
            modificaFiducia: {'matteo': 4, 'cinzia': 4},
          ),
        ],
      ),
      Scene(
        id: 'c3b_s3',
        luogo: 'Somma Lombardo',
        testoNarrativo:
            'Il registro di Cinzia, incrociato con quanto già sapete, '
            'restituisce un\'incongruenza precisa: qualcuno ha lasciato il '
            'maneggio molto più tardi di quanto dichiarato. Riccardo fischia '
            'piano, guardando la mappa investigativa aggiornarsi da sola sul '
            'suo schermo.',
        isFinaleCapitolo: true,
      ),
    ],
  ),
  // ---------------------------------------------------------------------
  Chapter(
    id: 'c4',
    numero: 6,
    titolo: 'Il telefono di Kledian',
    descrizione:
        'A Vergiate, Kledian consegna un telefono rotto. Il giocatore deve '
        'sbloccarlo per recuperare messaggi cancellati.',
    luogo: 'Vergiate',
    scenaInizialeId: 'c4_s1',
    scene: [
      Scene(
        id: 'c4_s1',
        luogo: 'Vergiate — Officina',
        testoNarrativo:
            'L\'officina di Kledian sa di olio motore e metallo caldo. Lui ti '
            'aspetta con le mani ancora sporche di grasso, nervoso, come chi '
            'ha tenuto un segreto troppo a lungo. Sul banco, un telefono con '
            'lo schermo incrinato: quello di Mauro, portato "per un finto '
            'controllo" e mai restituito.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'kledian',
            nomeVisualizzato: 'Kledian',
            testo: 'Ero l\'ultimo ad averlo visto vivo, lo so cosa pensi. Ma '
                'io ho solo riparato la sua auto, quella sera.',
          ),
        ],
        scelte: [
          Choice(
            id: 'c4_s1_a',
            testoScelta: 'Chiedi a Kledian di raccontarti esattamente cosa è successo quella sera.',
            effetto: 'Kledian si apre e ti offre un dettaglio in più sull\'orario.',
            prossimoNodo: 'c4_s2',
            modificaFiducia: {'kledian': 8},
          ),
          Choice(
            id: 'c4_s1_b',
            testoScelta: 'Vai dritta al punto e chiedi il telefono.',
            effetto: 'Kledian te lo consegna, un po\' sulla difensiva.',
            prossimoNodo: 'c4_s2',
            modificaFiducia: {'kledian': -2},
          ),
          Choice(
            id: 'c4_s1_c',
            testoScelta: 'Offriti di pagare tu la riparazione dell\'auto, come segno di fiducia.',
            effetto: 'Kledian sembra sinceramente sorpreso dal gesto.',
            prossimoNodo: 'c4_s2',
            modificaFiducia: {'kledian': 10},
          ),
        ],
      ),
      Scene(
        id: 'c4_s2',
        luogo: 'Vergiate — Officina',
        testoNarrativo:
            'Riccardo collega il telefono a un piccolo dispositivo che ha '
            'costruito lui stesso. "Serve un codice a quattro cifre," dice. '
            '"Proviamo con qualcosa che Mauro avrebbe usato: una data, un '
            'nome, un luogo importante per lui." Kledian, rovistando tra i '
            'documenti dell\'ultima manutenzione dell\'auto, potrebbe avere '
            'proprio il dettaglio che serve.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'riccardo',
            nomeVisualizzato: 'Riccardo',
            testo: 'Se troviamo la combinazione giusta, dentro c\'è tutto '
                'quello che Mauro voleva tenere nascosto.',
          ),
        ],
        minigioco: MinigameType.sbloccoTelefono,
        indizioMinigioco: 'clue_telefono_mauro',
        scelte: [
          Choice(
            id: 'c4_s2_a',
            testoScelta: 'Leggi con cura tutti i messaggi recuperati, uno per uno.',
            effetto: 'Trovi tracce di ricatti multipli, con nomi che conosci fin troppo bene.',
            prossimoNodo: 'c4_s3',
            indiziSbloccati: ['clue_messaggi_cancellati'],
          ),
          Choice(
            id: 'c4_s2_b',
            testoScelta: 'Passa subito i dati a Matteo, per fare le cose in modo corretto.',
            effetto: 'Matteo apprezza la trasparenza, ma perdi tempo prima di poter leggere tutto tu stessa.',
            prossimoNodo: 'c4_s3',
            modificaFiducia: {'matteo': 6},
          ),
          Choice(
            id: 'c4_s2_c',
            testoScelta: 'Cerca solo i messaggi con Manuela, per rispetto della privacy degli altri.',
            effetto: 'Una scelta discreta: trovi quello che cercavi, senza scavare oltre.',
            prossimoNodo: 'c4_s3',
            modificaFiducia: {'manuela': 4},
          ),
        ],
      ),
      Scene(
        id: 'c4_s3',
        luogo: 'Vergiate',
        testoNarrativo:
            'Nella lista dei contatti ricattati compaiono nomi che ti '
            'gelano il sangue: persone che conosci, che frequenti, di cui ti '
            'fidi. La lista di sospettati si allarga, ma allo stesso tempo '
            'la verità sembra più vicina.',
        isFinaleCapitolo: true,
      ),
    ],
  ),
  // ---------------------------------------------------------------------
  Chapter(
    id: 'c5',
    numero: 7,
    titolo: 'Le sorelle del rifugio',
    descrizione:
        'Gaia e Anna rivelano che uno dei gattini è stato trovato vicino alla '
        'villa la notte dell\'omicidio.',
    luogo: 'Golasecca',
    scenaInizialeId: 'c5_s1',
    scene: [
      Scene(
        id: 'c5_s1',
        luogo: 'Golasecca — Rifugio per gattini',
        testoNarrativo:
            'Il piccolo rifugio di Gaia e Anna, a due passi dal Ticino, è '
            'pieno di scatole di cartone trasformate in cucce e di miagolii. '
            'Anna ti osserva in silenzio per un attimo, poi ti porge un '
            'gattino tremante. "Questo l\'abbiamo trovato la notte della '
            'festa," dice, "vicino alla villa. Aveva le zampe sporche di '
            'fango."',
        dialoghi: [
          DialogueLine(
            personaggioId: 'gaia',
            nomeVisualizzato: 'Gaia',
            testo: 'Non l\'avevamo mai visto prima. È comparso dal nulla, '
                'quella notte, infreddolito.',
          ),
        ],
        indiziOttenibili: ['clue_gattino_infreddolito'],
        scelte: [
          Choice(
            id: 'c5_s1_a',
            testoScelta: 'Esamina con calma il collare del gattino.',
            effetto: 'Sotto le dita senti qualcosa di rigido cucito nella fodera del collare.',
            prossimoNodo: 'c5_s2',
          ),
          Choice(
            id: 'c5_s1_b',
            testoScelta: 'Chiedi ad Anna di descrivere esattamente dove l\'ha trovato.',
            effetto: 'Anna, più precisa della sorella, disegna una mappa a mano sul retro di uno scontrino.',
            prossimoNodo: 'c5_s2',
            modificaFiducia: {'anna': 8},
          ),
          Choice(
            id: 'c5_s1_c',
            testoScelta: 'Chiedi a Gaia se il gattino si aggirava già prima vicino al bar di Sandra.',
            effetto: 'Gaia ci pensa su: "Forse sì, qualche volta, per gli avanzi."',
            prossimoNodo: 'c5_s2',
            modificaFiducia: {'gaia': 4},
            modificaSospetto: {'sandra': 4},
          ),
        ],
      ),
      Scene(
        id: 'c5_s2',
        luogo: 'Golasecca — Rifugio per gattini',
        testoNarrativo:
            'Con delicatezza, apri la fodera interna del collare: dentro, '
            'avvolta in un fazzoletto, c\'è una microscheda sporca di fango. '
            'Anna la osserva a lungo, poi confronta il fango sulle zampe del '
            'gattino con una foto scattata da Riccardo alla riva vicino al '
            'maneggio: combaciano.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'anna',
            nomeVisualizzato: 'Anna',
            testo: 'Non è fango della villa. È lo stesso fango della riva '
                'vicino al maneggio di Manuela.',
          ),
        ],
        indiziOttenibili: ['clue_microscheda', 'clue_fango_zampe'],
        scelte: [
          Choice(
            id: 'c5_s2_a',
            testoScelta: 'Ringrazia Gaia e Anna e prometti di tenerle aggiornate.',
            effetto: 'Le due sorelle ti stringono la mano, fiduciose.',
            prossimoNodo: 'c5_s3',
            modificaFiducia: {'gaia': 6, 'anna': 6},
          ),
          Choice(
            id: 'c5_s2_b',
            testoScelta: 'Chiedi se puoi portare via subito la microscheda per farla analizzare.',
            effetto: 'Gaia esita, protettiva verso i suoi gattini, ma alla fine acconsente.',
            prossimoNodo: 'c5_s3',
            modificaFiducia: {'gaia': -3},
          ),
          Choice(
            id: 'c5_s2_c',
            testoScelta: 'Analizza tu stessa il fango con Riccardo, senza disturbare oltre le sorelle.',
            effetto: 'Un piccolo gesto di rispetto che Gaia e Anna non dimenticheranno.',
            prossimoNodo: 'c5_s3',
            modificaFiducia: {'riccardo': 4, 'gaia': 3},
          ),
        ],
      ),
      Scene(
        id: 'c5_s3',
        luogo: 'Golasecca',
        testoNarrativo:
            'Sofia, contattata da Riccardo, si offre di analizzare il '
            'contenuto della scheda: dice di riconoscere qualcosa legato ai '
            'suoi studi di archeologia. Un nuovo messaggio anonimo arriva '
            'mentre esci dal rifugio.',
        isFinaleCapitolo: true,
        messaggioAnonimo: 'I gattini hanno portato via la prova sbagliata.',
      ),
    ],
  ),
  // ---------------------------------------------------------------------
  Chapter(
    id: 'c6',
    numero: 8,
    titolo: 'La mappa falsa',
    descrizione:
        'Sofia scopre che le mappe archeologiche sono state alterate da '
        'Alessandra.',
    luogo: 'Arsago Seprio',
    scenaInizialeId: 'c6_s1',
    scene: [
      Scene(
        id: 'c6_s1',
        luogo: 'Arsago Seprio — Laboratorio di restauro',
        testoNarrativo:
            'Sofia ti aspetta davanti a un vecchio laboratorio di restauro, '
            'gli occhi accesi dall\'entusiasmo nonostante la gravità della '
            'situazione. Le fotografie della microscheda, ingrandite su uno '
            'schermo, mostrano una tomba nascosta nel bosco, di un\'epoca '
            'ben più antica di quanto chiunque sospettasse.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'sofia',
            nomeVisualizzato: 'Sofia',
            testo: 'Questa non è una tomba qualunque, Segghy. È collegata '
                'alla cultura di Golasecca. Se è autentica, vale una fortuna '
                '— e non solo in senso economico.',
          ),
        ],
        indiziOttenibili: ['clue_foto_tomba'],
        scelte: [
          Choice(
            id: 'c6_s1_a',
            testoScelta: 'Chiedi a Sofia chi altro conosce l\'esistenza di questa tomba.',
            effetto: 'Sofia esita, poi fa il nome di Alessandra, la restauratrice.',
            prossimoNodo: 'c6_s2',
            modificaFiducia: {'sofia': 7},
          ),
          Choice(
            id: 'c6_s1_b',
            testoScelta: 'Proponi di andare subito a parlare con Alessandra.',
            effetto: 'Sofia accetta di accompagnarti, un po\' nervosa.',
            prossimoNodo: 'c6_s2',
            modificaFiducia: {'sofia': 3},
          ),
          Choice(
            id: 'c6_s1_c',
            testoScelta: 'Chiedi a Sofia di tenere per ora il ritrovamento segreto, per proteggerlo.',
            effetto: 'Sofia annuisce, sollevata che qualcuno pensi prima al sito che allo scoop.',
            prossimoNodo: 'c6_s2',
            modificaFiducia: {'sofia': 6},
          ),
        ],
      ),
      Scene(
        id: 'c6_s2',
        luogo: 'Arsago Seprio — Laboratorio di restauro',
        testoNarrativo:
            'Alessandra vi riceve tra pennelli e resine, le mani che '
            'tremano appena. Sul tavolo, due copie della stessa mappa '
            'archeologica: quella originale di Sofia e quella trovata tra '
            'gli effetti di Mauro. A un primo sguardo sembrano identiche, ma '
            'qualcosa, punto per punto, non torna.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'alessandra',
            nomeVisualizzato: 'Alessandra',
            testo: 'Mauro sapeva che avevo falsificato una datazione, anni '
                'fa. Mi ha ricattata. Confronta pure le due mappe, se vuoi '
                'la prova.',
          ),
        ],
        minigioco: MinigameType.analisiMappa,
        indizioMinigioco: 'clue_mappa_alterata',
        scelte: [
          Choice(
            id: 'c6_s2_a',
            testoScelta: 'Credile e offrile il tuo aiuto per uscire dal ricatto.',
            effetto: 'Alessandra si rilassa visibilmente e ti racconta un ultimo dettaglio.',
            prossimoNodo: 'c6_s3',
            modificaFiducia: {'alessandra': 10},
            modificaSospetto: {'alessandra': -6},
            indiziSbloccati: ['clue_leggenda_fibula'],
          ),
          Choice(
            id: 'c6_s2_b',
            testoScelta: 'Fai notare che nascondere prove non l\'aiuta di certo.',
            effetto: 'Alessandra si chiude, sulla difensiva.',
            prossimoNodo: 'c6_s3',
            modificaFiducia: {'alessandra': -6},
            modificaSospetto: {'alessandra': 10},
          ),
          Choice(
            id: 'c6_s2_c',
            testoScelta: 'Proponile di denunciare formalmente il ricatto alle autorità.',
            effetto: 'Alessandra esita a lungo, poi accetta, sollevata.',
            prossimoNodo: 'c6_s3',
            modificaFiducia: {'alessandra': 8, 'matteo': 3},
            modificaSospetto: {'alessandra': -4},
          ),
        ],
      ),
      Scene(
        id: 'c6_s3',
        luogo: 'Arsago Seprio',
        testoNarrativo:
            'Mentre tornate verso l\'auto, Sofia ti confida di sentirsi '
            'osservata da giorni. Le dici di stare attenta: se Mauro '
            'cercava quella tomba, qualcun altro potrebbe cercarla ancora, '
            'ed essere disposto a tutto per trovarla.',
        isFinaleCapitolo: true,
      ),
    ],
  ),
  // ---------------------------------------------------------------------
  Chapter(
    id: 'c7',
    numero: 9,
    titolo: 'Il guardiano del fiume',
    descrizione:
        'Moreno confessa di aver spento una telecamera, ma sostiene di '
        'averlo fatto per paura.',
    luogo: 'Castelletto sopra Ticino',
    scenaInizialeId: 'c7_s1',
    scene: [
      Scene(
        id: 'c7_s1',
        luogo: 'Castelletto sopra Ticino — Riva del fiume',
        testoNarrativo:
            'Sulla riva opposta del Ticino, Moreno pattuglia ogni notte un '
            'tratto di argine per conto del comune. Lo trovi seduto su una '
            'panchina di legno consumata, lo sguardo perso sull\'acqua. '
            'Sembra invecchiato di dieci anni in una settimana.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'moreno',
            nomeVisualizzato: 'Moreno',
            testo: 'Se sei qui per la telecamera... sì, l\'ho spenta io. Ma '
                'giuro che non ho fatto niente a Mauro.',
          ),
        ],
        scelte: [
          Choice(
            id: 'c7_s1_a',
            testoScelta: 'Ascoltalo senza giudicare, lascialo raccontare.',
            effetto: 'Moreno si rilassa e ti mostra la posizione esatta della telecamera.',
            prossimoNodo: 'c7_s2',
            modificaFiducia: {'moreno': 9},
          ),
          Choice(
            id: 'c7_s1_b',
            testoScelta: 'Chiedigli direttamente perché Mauro lo minacciava.',
            effetto: 'Moreno si irrigidisce, ma risponde comunque, a denti stretti.',
            prossimoNodo: 'c7_s2',
            modificaFiducia: {'moreno': -3},
            modificaSospetto: {'moreno': 8},
          ),
          Choice(
            id: 'c7_s1_c',
            testoScelta: 'Portagli qualcosa da bere e siediti accanto a lui, in silenzio.',
            effetto: 'Il gesto disarma Moreno più di qualsiasi domanda.',
            prossimoNodo: 'c7_s2',
            modificaFiducia: {'moreno': 12},
          ),
        ],
      ),
      Scene(
        id: 'c7_s2',
        luogo: 'Castelletto sopra Ticino — Riva del fiume',
        testoNarrativo:
            'Moreno ti mostra su un vecchio computer portatile i filmati di '
            'un\'altra telecamera, quella che aveva dimenticato di spegnere. '
            'Nel video, di notte, una figura incappucciata si avvicina alla '
            'riva e getta qualcosa nell\'acqua scura, prima di sparire tra '
            'gli alberi.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'moreno',
            nomeVisualizzato: 'Moreno',
            testo: 'L\'ho vista solo stamattina, questa. Non so chi sia, ma '
                'quella sagoma non mi convince.',
          ),
        ],
        indiziOttenibili: ['clue_video_incappucciato', 'clue_telecamera_spenta'],
        scelte: [
          Choice(
            id: 'c7_s2_a',
            testoScelta: 'Studia il video fotogramma per fotogramma con Riccardo.',
            effetto: 'Notate un dettaglio: una bicicletta appoggiata poco distante, con qualcosa che tintinna.',
            prossimoNodo: 'c7_s3',
            modificaFiducia: {'riccardo': 5},
          ),
          Choice(
            id: 'c7_s2_b',
            testoScelta: 'Porta subito il video a Matteo.',
            effetto: 'Matteo promette di aprire un fascicolo ufficiale sulla figura incappucciata.',
            prossimoNodo: 'c7_s3',
            modificaFiducia: {'matteo': 7},
          ),
          Choice(
            id: 'c7_s2_c',
            testoScelta: 'Chiedi a Moreno se ha mai visto Sandra aggirarsi da queste parti, di notte.',
            effetto: 'Moreno ci pensa: "Una volta, forse. In bicicletta, tardi."',
            prossimoNodo: 'c7_s3',
            modificaSospetto: {'sandra': 6, 'moreno': -3},
          ),
        ],
      ),
      Scene(
        id: 'c7_s3',
        luogo: 'Castelletto sopra Ticino',
        testoNarrativo:
            'Tornando verso casa, ripensi al tintinnio nel video. Un '
            'campanello da bicicletta, forse lo stesso che ha spaventato '
            'Nebbia. I pezzi iniziano, lentamente, a incastrarsi. "Il '
            'Ticino restituisce tutto," pensi, ricordando l\'ultimo messaggio '
            'anonimo.',
        isFinaleCapitolo: true,
      ),
    ],
  ),
  // ---------------------------------------------------------------------
  Chapter(
    id: 'c8',
    numero: 10,
    titolo: 'La verità al bar',
    descrizione:
        'Sandra tradisce una frase che solo l\'assassino poteva conoscere.',
    luogo: 'Golasecca',
    scenaInizialeId: 'c8_s1',
    scene: [
      Scene(
        id: 'c8_s1',
        luogo: 'Golasecca — Bar di Sandra',
        testoNarrativo:
            'Il bar di Sandra è il cuore pettegolo di Golasecca: tutti '
            'passano di lì, prima o poi. Sandra ti accoglie con il solito '
            'sorriso caldo e un caffè che non hai nemmeno ordinato. È lei '
            'che, negli anni, ha ascoltato più segreti di chiunque altro in '
            'paese.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'sandra',
            nomeVisualizzato: 'Sandra',
            testo: 'Povera Segghy, con tutto quello che ti sta succedendo. '
                'Se ti serve qualcuno con cui parlare, io ci sono sempre.',
          ),
        ],
        scelte: [
          Choice(
            id: 'c8_s1_a',
            testoScelta: 'Racconta a Sandra i dettagli che hai scoperto finora, per vedere come reagisce.',
            effetto: 'Sandra ascolta con attenzione, forse troppa attenzione.',
            prossimoNodo: 'c8_s2',
            modificaFiducia: {'sandra': 5},
          ),
          Choice(
            id: 'c8_s1_b',
            testoScelta: 'Resta vaga e lasciala parlare, osservando le sue reazioni.',
            effetto: 'Sandra, senza pressioni, si lascia andare a qualche parola di troppo.',
            prossimoNodo: 'c8_s2',
          ),
          Choice(
            id: 'c8_s1_c',
            testoScelta: 'Ordina qualcosa e lascia scorrere la conversazione su altro, per ora.',
            effetto: 'Un approccio prudente: osservi il bar, i clienti, le abitudini di Sandra.',
            prossimoNodo: 'c8_s2',
          ),
        ],
      ),
      Scene(
        id: 'c8_s2',
        luogo: 'Golasecca — Bar di Sandra',
        testoNarrativo:
            'Parlando della serata della festa, Sandra dice, quasi distratta, '
            'che Mauro è stato trovato "vicino alla cassapanca, con la testa '
            'girata verso la vetrata". Un dettaglio mai comparso su nessun '
            'giornale, mai raccontato pubblicamente da nessuno. Solo chi era '
            'lì quella notte poteva saperlo.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'segghy',
            nomeVisualizzato: 'Segghy',
            testo: 'Sandra... come fai a sapere esattamente dove si trovava '
                'il corpo?',
          ),
          DialogueLine(
            personaggioId: 'sandra',
            nomeVisualizzato: 'Sandra',
            testo: 'Oh, non... l\'avrò sentito dire in giro, sai come sono i '
                'paesi piccoli.',
          ),
        ],
        indiziOttenibili: ['clue_frase_sandra'],
        scelte: [
          Choice(
            id: 'c8_s2_a',
            testoScelta: 'Non insistere oltre, ma prendi nota del dettaglio per Riccardo e Matteo.',
            effetto: 'Sandra si ricompone, ma tu non dimenticherai quella frase.',
            prossimoNodo: 'c8_s3',
            modificaSospetto: {'sandra': 8},
          ),
          Choice(
            id: 'c8_s2_b',
            testoScelta: 'Incalza Sandra, chiedendole di essere più precisa.',
            effetto: 'Sandra si irrigidisce visibilmente e cambia argomento in fretta.',
            prossimoNodo: 'c8_s3',
            modificaFiducia: {'sandra': -8},
            modificaSospetto: {'sandra': 4},
          ),
          Choice(
            id: 'c8_s2_c',
            testoScelta: 'Fingi di non aver notato nulla, ma prendi mentalmente nota di tutto.',
            effetto: 'Sandra si rilassa, convinta di essere passata inosservata.',
            prossimoNodo: 'c8_s3',
            modificaFiducia: {'sandra': 3},
            modificaSospetto: {'sandra': 12},
          ),
        ],
      ),
      Scene(
        id: 'c8_s3',
        luogo: 'Golasecca',
        testoNarrativo:
            'Esci dal bar con la testa piena di dubbi. Sandra, la persona '
            'che ascolta tutti senza mai raccontare nulla di sé: possibile '
            'che il suo silenzio nascondesse molto più di un semplice '
            'pettegolezzo?',
        isFinaleCapitolo: true,
      ),
    ],
  ),
  // ---------------------------------------------------------------------
  Chapter(
    id: 'c9',
    numero: 11,
    titolo: 'Nebbia ricorda',
    descrizione:
        'Il cavallo Nebbia guida Segghy verso una zona nascosta del '
        'maneggio.',
    luogo: 'Somma Lombardo',
    scenaInizialeId: 'c9_s1',
    scene: [
      Scene(
        id: 'c9_s1',
        luogo: 'Somma Lombardo — Maneggio',
        testoNarrativo:
            'Torni al maneggio con il campanello da bicicletta ritrovato tra '
            'gli effetti recuperati. Manuela non c\'è: è il momento giusto '
            'per capire cosa nasconda davvero quel fienile. Fai suonare il '
            'campanello vicino al box di Nebbia: la giumenta si agita di '
            'nuovo, tirando verso lo stesso angolo buio di sempre.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'segghy',
            nomeVisualizzato: 'Segghy',
            testo: 'Lo so, Nebbia. Andiamo a vedere insieme, allora.',
          ),
        ],
        scelte: [
          Choice(
            id: 'c9_s1_a',
            testoScelta: 'Porta Nebbia fuori dal box e lasciala guidarti.',
            effetto: 'Il cavallo cammina sicuro fino a una tavola di legno smossa di recente.',
            prossimoNodo: 'c9_s2',
          ),
          Choice(
            id: 'c9_s1_b',
            testoScelta: 'Ispeziona da sola l\'angolo del fienile, senza coinvolgere Nebbia.',
            effetto: 'Impieghi più tempo, ma eviti di agitare ulteriormente il cavallo.',
            prossimoNodo: 'c9_s2',
          ),
          Choice(
            id: 'c9_s1_c',
            testoScelta: 'Chiedi mentalmente permesso a Manuela, anche se non può sentirti.',
            effetto: 'Un gesto quasi superstizioso, ma ti fa sentire meno una traditrice.',
            prossimoNodo: 'c9_s2',
            modificaFiducia: {'manuela': 5},
          ),
        ],
      ),
      Scene(
        id: 'c9_s2',
        luogo: 'Somma Lombardo — Maneggio',
        testoNarrativo:
            'Sotto la tavola smossa trovi i segni di una colluttazione: un '
            'bottone strappato, incastrato tra le assi, e una macchia scura '
            'sul pavimento che qualcuno ha provato a coprire con la paglia '
            'fresca. In una piccola cassa di metallo, nascosti, i documenti '
            'che Manuela cercava disperatamente di recuperare da Mauro.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'riccardo',
            nomeVisualizzato: 'Riccardo',
            testo: 'Segghy... questi documenti provano che Manuela doveva '
                'soldi a Mauro da anni. Un movente enorme.',
          ),
        ],
        indiziOttenibili: [
          'clue_bottone_strappato',
          'clue_documenti_maneggio',
          'clue_macchia_scura',
        ],
        scelte: [
          Choice(
            id: 'c9_s2_a',
            testoScelta: 'Vai a cercare Manuela e chiedile una spiegazione, faccia a faccia.',
            effetto: 'Manuela, in lacrime, ammette di aver incontrato Mauro quella notte — ma giura di non averlo ucciso.',
            prossimoNodo: 'c9_s3',
            modificaFiducia: {'manuela': -5},
            modificaSospetto: {'manuela': 10},
          ),
          Choice(
            id: 'c9_s2_b',
            testoScelta: 'Porta tutto a Matteo prima di parlare con Manuela.',
            effetto: 'Matteo promette discrezione, ma ora l\'indagine ufficiale si stringe intorno al maneggio.',
            prossimoNodo: 'c9_s3',
            modificaFiducia: {'matteo': 8, 'manuela': -8},
            modificaSospetto: {'manuela': 14},
          ),
          Choice(
            id: 'c9_s2_c',
            testoScelta: 'Custodisci tu stessa i documenti finché non avrai capito tutto.',
            effetto: 'Riccardo non è del tutto d\'accordo, ma rispetta la tua scelta.',
            prossimoNodo: 'c9_s3',
            modificaFiducia: {'riccardo': -3},
            modificaSospetto: {'manuela': 6},
          ),
        ],
      ),
      Scene(
        id: 'c9_s3',
        luogo: 'Somma Lombardo',
        testoNarrativo:
            'Manuela ti confessa, con la voce spezzata, di aver attirato '
            'Mauro al maneggio quella notte per riprendersi i documenti sul '
            'debito, e che altri — Adriano, Moreno, Alessandra — avevano '
            'ciascuno un motivo per essere lì. Ma nessuno, giura, gli ha '
            'dato il colpo finale. Manca ancora un nome. Il tuo telefono '
            'vibra un\'ultima volta.',
        isFinaleCapitolo: true,
        messaggioAnonimo: 'Il Ticino restituisce tutto.',
      ),
    ],
  ),
  // ---------------------------------------------------------------------
  Chapter(
    id: 'c10',
    numero: 12,
    titolo: 'Il silenzio del Ticino',
    descrizione:
        'Confronto finale sulle rive del fiume. Le scelte del giocatore '
        'determinano il finale.',
    luogo: 'Golasecca',
    scenaInizialeId: 'c10_s1',
    scene: [
      Scene(
        id: 'c10_s1',
        luogo: 'Golasecca — Riva del Ticino',
        testoNarrativo:
            'Riccardo ha ricostruito l\'intera catena di eventi collegando '
            'ogni indizio: il campanello, il fango, la microscheda, la frase '
            'di troppo al bar. Un solo tassello manca ancora, ma tutto porta '
            'nello stesso punto: la riva del Ticino, dove tutto è iniziato '
            'molto prima della morte di Mauro. Convochi Sandra lì, con la '
            'scusa di una passeggiata.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'riccardo',
            nomeVisualizzato: 'Riccardo',
            testo: 'Sei sicura di voler fare questo da sola? Posso avvertire '
                'Matteo, farlo venire con noi.',
          ),
        ],
        scelte: [
          Choice(
            id: 'c10_s1_a',
            testoScelta: 'Chiedi a Riccardo di avvertire Matteo e farlo arrivare sulla riva.',
            effetto: 'Matteo si nasconde a distanza, pronto a intervenire.',
            prossimoNodo: 'c10_s2',
            modificaFiducia: {'matteo': 5},
          ),
          Choice(
            id: 'c10_s1_b',
            testoScelta: 'Vai da sola: vuoi guardare Sandra negli occhi senza testimoni.',
            effetto: 'Riccardo non è convinto, ma rispetta la tua scelta.',
            prossimoNodo: 'c10_s2',
            modificaFiducia: {'riccardo': -3},
          ),
          Choice(
            id: 'c10_s1_c',
            testoScelta: 'Porta con te Riccardo, ma non Matteo: vuoi testimoni di cui ti fidi.',
            effetto: 'Riccardo, teso ma presente, ti segue sulla riva a distanza di sicurezza.',
            prossimoNodo: 'c10_s2',
            modificaFiducia: {'riccardo': 6},
          ),
        ],
      ),
      Scene(
        id: 'c10_s2',
        luogo: 'Golasecca — Riva del Ticino',
        testoNarrativo:
            'Sandra ti aspetta già sulla riva, le mani strette intorno a una '
            'tazza di caffè da asporto, come sempre. La nebbia sale lenta '
            'dall\'acqua. È il momento di scegliere come affrontarla: con '
            'tutte le prove che hai raccolto, o lasciando che il fiume '
            'custodisca ancora il suo silenzio.',
        dialoghi: [
          DialogueLine(
            personaggioId: 'sandra',
            nomeVisualizzato: 'Sandra',
            testo: 'Bella giornata per una passeggiata, vero? Anche se so che '
                'non sei qui solo per quello.',
          ),
        ],
        scelte: [
          Choice(
            id: 'c10_s2_a',
            testoScelta: 'Affronta Sandra con tutte le prove raccolte e chiedile la verità.',
            effetto: 'Sandra impallidisce, poi inizia lentamente a raccontare.',
            prossimoNodo: kConfrontoEsitoSentinel,
          ),
          Choice(
            id: 'c10_s2_b',
            testoScelta: 'Lasciale intendere che sai tutto, ma dalle la possibilità di sparire in silenzio.',
            effetto: 'Sandra ti guarda a lungo, poi annuisce piano, in lacrime.',
            prossimoNodo: 'c10_finale_oscuro',
          ),
        ],
      ),
      // Le tre scene di finale: raggiunte direttamente (oscuro) o tramite
      // il calcolo dinamico del provider (buono / perfetto).
      Scene(
        id: 'c10_finale_oscuro',
        luogo: 'Golasecca — Riva del Ticino',
        testoNarrativo:
            'Sandra ti racconta tutto, in un filo di voce rotto dal pianto: '
            'suo fratello, il Ticino, l\'incidente archiviato in fretta, la '
            'rabbia sopita per anni dietro il bancone del bar. Mauro l\'ha '
            'provocata con la sua confessione fredda, quella notte al '
            'maneggio, e lei ha perso il controllo. Ti guarda negli occhi: '
            '"Ora tocca a te decidere." Scegli di lasciare che il fiume '
            'custodisca ancora questo segreto. Il caso si chiude come '
            'irrisolto. Porterai questo peso con te, chiedendoti per sempre '
            'se sia stata la scelta giusta.',
        endingId: 'oscuro',
        isFinaleCapitolo: true,
        indiziOttenibili: ['clue_confessione'],
      ),
      Scene(
        id: 'c10_finale_buono',
        luogo: 'Golasecca — Riva del Ticino',
        testoNarrativo:
            'Le prove che hai raccolto bastano a ricostruire la verità e a '
            'scagionarti definitivamente agli occhi di Matteo e dei '
            'Carabinieri. Sandra viene affidata alla giustizia, Manuela '
            'evita le conseguenze peggiori del ricatto, e il reperto '
            'archeologico viene consegnato alle autorità competenti. '
            'Decidi di restare a Golasecca: il maneggio di Manuela diventerà, '
            'con il tuo aiuto, un vero rifugio per cavalli e gattini '
            'abbandonati. Nebbia, finalmente tranquilla, sarà la prima '
            'guardiana del nuovo progetto.',
        endingId: 'buono',
        isFinaleCapitolo: true,
        indiziOttenibili: ['clue_confessione'],
      ),
      Scene(
        id: 'c10_finale_perfetto',
        luogo: 'Golasecca — Riva del Ticino',
        testoNarrativo:
            'Ogni indizio, ogni conversazione, ogni scelta ti ha portata '
            'esattamente qui. Con le prove al completo e Matteo pronto a '
            'intervenire da dietro i canneti, Sandra crolla e confessa '
            'ogni dettaglio, davanti a un testimone ufficiale, proprio nel '
            'punto della riva dove anni prima è morto suo fratello. '
            'Giustizia e verità, per una volta, coincidono. Salvi anche '
            'Sofia da chi cercava ancora la tomba nel bosco, recuperi il '
            'reperto, e torni a casa sapendo di aver visto fino in fondo il '
            'silenzio del Ticino.',
        endingId: 'perfetto',
        isFinaleCapitolo: true,
        indiziOttenibili: ['clue_confessione'],
      ),
    ],
  ),
];

Chapter chapterById(String id) => kChapters.firstWhere((c) => c.id == id);

Chapter? chapterContainingScene(String sceneId) {
  for (final c in kChapters) {
    if (c.sceneById(sceneId) != null) return c;
  }
  return null;
}
