import '../../models/clue.dart';

/// Elenco completo degli indizi raccoglibili durante l'indagine, distribuiti
/// tra i vari capitoli e luoghi. `trovato` parte sempre da false: lo stato
/// reale di ritrovamento è tenuto in [GameState.indiziRaccolti].
final List<Clue> kClues = [
  const Clue(
    id: 'clue_ciondolo_falso',
    titolo: 'Il ciondolo piazzato',
    descrizione:
        'Il ciondolo a forma di cavallo ritrovato accanto al corpo di Mauro è '
        'identico a quello di Segghy, ma lei lo ha perso durante la festa: '
        'qualcuno lo ha raccolto e messo lì apposta.',
    luogo: 'Golasecca',
    importanza: ClueImportance.critica,
  ),
  const Clue(
    id: 'clue_vaso_rovesciato',
    titolo: 'Il vaso rovesciato',
    descrizione:
        'Nella serra della villa, un vaso rovesciato suggerisce una colluttazione '
        'avvenuta poco prima della morte di Mauro.',
    luogo: 'Golasecca',
    importanza: ClueImportance.media,
  ),
  const Clue(
    id: 'clue_orario_festa',
    titolo: "L'orario esatto della festa",
    descrizione:
        'Confrontando gli inviti e i racconti degli ospiti, Segghy ricostruisce '
        'una finestra oraria precisa in cui Mauro è stato visto vivo l\'ultima volta.',
    luogo: 'Golasecca',
    importanza: ClueImportance.bassa,
  ),
  const Clue(
    id: 'clue_impronte_doppie',
    titolo: 'Impronte doppie nel fango',
    descrizione:
        'Lungo la riva del Ticino, delle impronte doppie e profonde suggeriscono '
        'che qualcuno abbia trascinato un peso verso l\'acqua.',
    luogo: 'Sesto Calende',
    importanza: ClueImportance.alta,
  ),
  const Clue(
    id: 'clue_biglietto_bagnato',
    titolo: 'Il biglietto bagnato',
    descrizione:
        'Un biglietto quasi illeggibile, recuperato tra i canneti: si legge solo '
        '"...al maneggio, dopo mezzanotte...".',
    luogo: 'Sesto Calende',
    importanza: ClueImportance.alta,
  ),
  const Clue(
    id: 'clue_campanello',
    titolo: 'Il campanello da bicicletta',
    descrizione:
        'Un vecchio campanello da bicicletta, dello stesso modello di quello che '
        'Sandra tiene agganciata alla sua bici. Nebbia si agita ogni volta che lo sente.',
    luogo: 'Somma Lombardo',
    importanza: ClueImportance.critica,
  ),
  const Clue(
    id: 'clue_microscheda',
    titolo: 'La microscheda nel collare',
    descrizione:
        'Una piccola scheda di memoria, sporca di fango, agganciata al collare di '
        'uno dei gattini del rifugio. Contiene fotografie compromettenti.',
    luogo: 'Golasecca',
    importanza: ClueImportance.critica,
  ),
  const Clue(
    id: 'clue_telefono_mauro',
    titolo: 'Il telefono rotto di Mauro',
    descrizione:
        'Recuperato dall\'auto della vittima, portato in officina da Kledian per '
        'un finto controllo. Protetto da un codice di sblocco.',
    luogo: 'Vergiate',
    importanza: ClueImportance.alta,
  ),
  const Clue(
    id: 'clue_messaggi_cancellati',
    titolo: 'Messaggi cancellati',
    descrizione:
        'Una cronologia di chiamate e messaggi cancellati, recuperata dal telefono '
        'di Mauro: prova che ricattava più persone contemporaneamente.',
    luogo: 'Vergiate',
    importanza: ClueImportance.alta,
  ),
  const Clue(
    id: 'clue_gattino_infreddolito',
    titolo: 'Il gattino trovato vicino alla villa',
    descrizione:
        'Uno dei gattini del rifugio è stato trovato la notte dell\'omicidio a '
        'poca distanza dalla villa, infreddolito e spaventato.',
    luogo: 'Golasecca',
    importanza: ClueImportance.media,
  ),
  const Clue(
    id: 'clue_fango_zampe',
    titolo: 'Fango sulle zampe',
    descrizione:
        'Il fango sulle zampe del gattino è identico a quello della riva del '
        'Ticino vicino al maneggio, non a quello della villa.',
    luogo: 'Golasecca',
    importanza: ClueImportance.media,
  ),
  const Clue(
    id: 'clue_foto_tomba',
    titolo: 'Fotografie della tomba nascosta',
    descrizione:
        'Le foto nella microscheda ritraggono una tomba nascosta nel bosco, '
        'legata all\'antica cultura di Golasecca.',
    luogo: 'Arsago Seprio',
    importanza: ClueImportance.alta,
  ),
  const Clue(
    id: 'clue_mappa_alterata',
    titolo: 'La mappa archeologica alterata',
    descrizione:
        'Le coordinate sulla mappa usata da Mauro per orientare gli scavi abusivi '
        'sono state falsificate da Alessandra per proteggere il sito reale.',
    luogo: 'Arsago Seprio',
    importanza: ClueImportance.critica,
  ),
  const Clue(
    id: 'clue_leggenda_fibula',
    titolo: 'La leggenda della fibula',
    descrizione:
        'Una leggenda locale narra di una fibula in bronzo che protegge chi la '
        'possiede, ma porta rovina a chi la ruba: l\'oggetto che Mauro cercava.',
    luogo: 'Arsago Seprio',
    importanza: ClueImportance.bassa,
  ),
  const Clue(
    id: 'clue_video_incappucciato',
    titolo: 'Il video della figura incappucciata',
    descrizione:
        'Una telecamera privata riprende, la notte dell\'omicidio, una figura '
        'incappucciata che getta qualcosa nel fiume, sulla riva opposta.',
    luogo: 'Castelletto sopra Ticino',
    importanza: ClueImportance.critica,
  ),
  const Clue(
    id: 'clue_telecamera_spenta',
    titolo: 'La telecamera spenta',
    descrizione:
        'Moreno ammette di aver spento una delle telecamere della zona fluviale '
        'quella notte, dietro minaccia di Mauro.',
    luogo: 'Castelletto sopra Ticino',
    importanza: ClueImportance.alta,
  ),
  const Clue(
    id: 'clue_frase_sandra',
    titolo: 'La frase di troppo di Sandra',
    descrizione:
        'Al bar, Sandra lascia scappare un dettaglio sulla posizione esatta del '
        'corpo di Mauro: un particolare mai reso pubblico.',
    luogo: 'Golasecca',
    importanza: ClueImportance.critica,
  ),
  const Clue(
    id: 'clue_bottone_strappato',
    titolo: 'Il bottone strappato',
    descrizione:
        'Nel fienile del maneggio, sotto una tavola smossa di recente, Segghy '
        'trova un bottone strappato durante una colluttazione.',
    luogo: 'Somma Lombardo',
    importanza: ClueImportance.alta,
  ),
  const Clue(
    id: 'clue_documenti_maneggio',
    titolo: 'I documenti del ricatto',
    descrizione:
        'I documenti che Manuela cercava disperatamente di recuperare da Mauro '
        'la notte dell\'omicidio, prova del vecchio debito.',
    luogo: 'Somma Lombardo',
    importanza: ClueImportance.critica,
  ),
  const Clue(
    id: 'clue_macchia_scura',
    titolo: 'La macchia scura sul pavimento',
    descrizione:
        'Una macchia scura sul pavimento del fienile, nello stesso angolo verso '
        'cui Nebbia continua a tirare quando sente il campanello.',
    luogo: 'Somma Lombardo',
    importanza: ClueImportance.media,
  ),
  const Clue(
    id: 'clue_confessione',
    titolo: 'La confessione di Sandra',
    descrizione:
        'Messa di fronte a tutte le prove raccolte, Sandra confessa: aveva '
        'scoperto che Mauro era responsabile della morte di suo fratello sul Ticino.',
    luogo: 'Golasecca',
    importanza: ClueImportance.critica,
  ),
  const Clue(
    id: 'clue_impronta_estranea',
    titolo: "L'impronta estranea",
    descrizione:
        'Tra le impronte rilevate sullo scafo della barca, una è più piccola '
        'delle altre e non corrisponde a nessun ospite noto della festa: '
        'qualcuno di corporatura minuta è salito a bordo quella notte.',
    luogo: 'Sesto Calende',
    importanza: ClueImportance.critica,
  ),
  const Clue(
    id: 'clue_contratto_adriano',
    titolo: 'Il contratto capestro',
    descrizione:
        'Il contratto con cui Mauro si è impossessato delle quote societarie '
        'di Adriano, firmato subito dopo la morte del padre di lui, in un '
        'momento di fragilità.',
    luogo: 'Sesto Calende',
    importanza: ClueImportance.alta,
  ),
  const Clue(
    id: 'clue_alibi_adriano',
    titolo: 'Il buco nell\'alibi di Adriano',
    descrizione:
        'Adriano sostiene di essere stato altrove quella notte, ma il suo '
        'racconto lascia scoperta quasi un\'ora, proprio a cavallo '
        'dell\'omicidio.',
    luogo: 'Sesto Calende',
    importanza: ClueImportance.media,
  ),
  const Clue(
    id: 'clue_prestito_cinzia',
    titolo: 'Il prestito capestro di Cinzia',
    descrizione:
        'I documenti del prestito concesso da Mauro a Cinzia anni prima, con '
        'clausole scritte apposta per farla fallire e prendersi il maneggio.',
    luogo: 'Somma Lombardo',
    importanza: ClueImportance.alta,
  ),
  const Clue(
    id: 'clue_promessa_manuela',
    titolo: 'La promessa di Manuela a Cinzia',
    descrizione:
        'Manuela aveva promesso a Cinzia, un giorno, di aiutarla a '
        'riprendersi il maneggio: un legame antico che nessuna delle due ha '
        'mai raccontato del tutto.',
    luogo: 'Somma Lombardo',
    importanza: ClueImportance.media,
  ),
  const Clue(
    id: 'clue_registro_visite',
    titolo: 'Il registro delle visite notturne',
    descrizione:
        'Ricostruendo con cura gli orari di quella notte, risulta che '
        'qualcuno ha lasciato il maneggio molto dopo l\'ora dichiarata '
        'ufficialmente.',
    luogo: 'Somma Lombardo',
    importanza: ClueImportance.critica,
  ),
];

Clue clueById(String id) => kClues.firstWhere((c) => c.id == id);
