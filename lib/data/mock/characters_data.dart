import '../../models/character.dart';

/// Elenco completo dei personaggi del gioco. La fiducia iniziale riflette
/// il punto di partenza narrativo (es. Manuela parte alta perché è quasi
/// una madre per Segghy, Sandra parte alta perché nessuno la sospetta).
final List<Character> kCharacters = [
  const Character(
    id: 'segghy',
    nome: 'Segghy',
    immagine: 'assets/images/characters/segghy.png',
    descrizione:
        'Protagonista della storia. Cresciuta a Golasecca, lavora saltuariamente '
        'al maneggio di Manuela e porta sempre al collo un ciondolo a forma di '
        'cavallo, dono di sua madre. Determinata, testarda, ingiustamente '
        'sospettata dell\'omicidio di Mauro.',
    ruolo: 'Protagonista',
    luogo: 'Golasecca',
    livelloFiducia: 100,
  ),
  const Character(
    id: 'riccardo',
    nome: 'Riccardo',
    immagine: 'assets/images/characters/riccardo.png',
    descrizione:
        'Amico d\'infanzia di Segghy, sviluppatore informatico con il vizio di '
        'ficcare il naso dove non dovrebbe. La aiuta a raccogliere e collegare '
        'gli indizi con strumenti digitali.',
    ruolo: 'Amico tecnico',
    luogo: 'Golasecca',
    livelloFiducia: 80,
  ),
  const Character(
    id: 'matteo',
    nome: 'Matteo',
    immagine: 'assets/images/characters/matteo.png',
    descrizione:
        'Maresciallo dei Carabinieri di Sesto Calende. Conosce Segghy da anni: '
        'sembra volerla proteggere, ma nasconde informazioni sull\'indagine '
        'ufficiale che non può condividere apertamente.',
    ruolo: 'Carabiniere',
    luogo: 'Sesto Calende',
    livelloFiducia: 55,
  ),
  const Character(
    id: 'kledian',
    nome: 'Kledian',
    immagine: 'assets/images/characters/kledian.png',
    descrizione:
        'Meccanico di Vergiate, ultimo ad aver visto Mauro vivo prima della '
        'festa. Recupera dall\'auto della vittima un vecchio telefono rotto.',
    ruolo: 'Meccanico',
    luogo: 'Vergiate',
    livelloFiducia: 50,
  ),
  const Character(
    id: 'manuela',
    nome: 'Manuela',
    immagine: 'assets/images/characters/manuela.png',
    descrizione:
        'Proprietaria del maneggio di Somma Lombardo, figura quasi materna per '
        'Segghy. Legata a Mauro da un vecchio debito mai del tutto chiarito.',
    ruolo: 'Proprietaria del maneggio',
    luogo: 'Somma Lombardo',
    livelloFiducia: 85,
    sospettato: true,
  ),
  const Character(
    id: 'sandra',
    nome: 'Sandra',
    immagine: 'assets/images/characters/sandra.png',
    descrizione:
        'Barista di Golasecca, gentile e sempre pronta ad ascoltare tutti al '
        'bancone del suo bar. Sa più di quanto lascia intendere.',
    ruolo: 'Barista',
    luogo: 'Golasecca',
    livelloFiducia: 70,
    sospettato: true,
  ),
  const Character(
    id: 'gaia',
    nome: 'Gaia',
    immagine: 'assets/images/characters/gaia.png',
    descrizione:
        'Gestisce insieme alla sorella Anna un piccolo rifugio per gattini '
        'vicino al Ticino. Ha trovato una microscheda nel collare di un gatto.',
    ruolo: 'Rifugio gattini',
    luogo: 'Golasecca',
    livelloFiducia: 65,
  ),
  const Character(
    id: 'anna',
    nome: 'Anna',
    immagine: 'assets/images/characters/anna.png',
    descrizione:
        'Sorella di Gaia, più intuitiva e silenziosa. Nota dettagli che agli '
        'altri sfuggono, come il fango sulle zampe dei gattini.',
    ruolo: 'Rifugio gattini',
    luogo: 'Golasecca',
    livelloFiducia: 65,
  ),
  const Character(
    id: 'sofia',
    nome: 'Sofia',
    immagine: 'assets/images/characters/sofia.png',
    descrizione:
        'Studentessa appassionata di archeologia. Capisce che la microscheda '
        'contiene fotografie di una tomba nascosta legata alla cultura di '
        'Golasecca.',
    ruolo: 'Studentessa di archeologia',
    luogo: 'Arsago Seprio',
    livelloFiducia: 60,
  ),
  const Character(
    id: 'adriano',
    nome: 'Adriano',
    immagine: 'assets/images/characters/adriano.png',
    descrizione:
        'Ex socio in affari di Mauro, da cui questi aveva sottratto quote '
        'societarie con un contratto firmato in un momento di debolezza.',
    ruolo: 'Ex socio della vittima',
    luogo: 'Sesto Calende',
    livelloFiducia: 35,
    sospettato: true,
  ),
  const Character(
    id: 'cinzia',
    nome: 'Cinzia',
    immagine: 'assets/images/characters/cinzia.png',
    descrizione:
        'Donna legata al passato del maneggio, che aveva perso anni prima a '
        'causa di un prestito capestro concesso da Mauro.',
    ruolo: 'Legata al maneggio',
    luogo: 'Somma Lombardo',
    livelloFiducia: 40,
    sospettato: true,
  ),
  const Character(
    id: 'mauro',
    nome: 'Mauro',
    immagine: 'assets/images/characters/mauro.png',
    descrizione:
        'La vittima. Uomo conosciuto per affari poco chiari legati a terreni, '
        'eredità contese e vecchie mappe archeologiche della zona. Ricattava '
        'diverse persone del paese.',
    ruolo: 'Vittima',
    luogo: 'Golasecca',
    livelloFiducia: 0,
  ),
  const Character(
    id: 'moreno',
    nome: 'Moreno',
    immagine: 'assets/images/characters/moreno.png',
    descrizione:
        'Guardiano notturno della zona fluviale, pagato in nero da Mauro per '
        'chiudere un occhio su alcuni scavi abusivi lungo l\'argine.',
    ruolo: 'Guardiano',
    luogo: 'Castelletto sopra Ticino',
    livelloFiducia: 45,
    sospettato: true,
  ),
  const Character(
    id: 'alessandra',
    nome: 'Alessandra',
    descrizione:
        'Restauratrice, costretta da Mauro a falsificare la datazione di '
        'alcuni reperti per coprire un traffico di scavi clandestini.',
    ruolo: 'Restauratrice',
    luogo: 'Arsago Seprio',
    livelloFiducia: 40,
    sospettato: true,
  ),
];

Character characterById(String id) =>
    kCharacters.firstWhere((c) => c.id == id);
