import 'choice.dart';
import 'dialogue_line.dart';
import 'minigame_type.dart';

/// Una scena è l'unità narrativa minima di un capitolo: testo narrativo,
/// eventuali dialoghi, indizi ottenuti automaticamente entrando nella scena
/// e le scelte che portano alla scena successiva.
class Scene {
  final String id;
  final String testoNarrativo;
  final String luogo;
  final List<DialogueLine> dialoghi;
  final List<Choice> scelte;

  /// Indizi ottenuti automaticamente (senza scelta) all'ingresso nella scena.
  final List<String> indiziOttenibili;

  /// Se valorizzato, raggiungere questa scena determina direttamente il
  /// finale della partita (usato nell'ultimo capitolo).
  final String? endingId;

  /// true se è l'ultima scena del capitolo (nessuna scelta -> si passa al
  /// capitolo successivo tramite la schermata di selezione capitoli).
  final bool isFinaleCapitolo;

  /// Messaggio anonimo ricevuto sul telefono di Segghy al termine della
  /// scena, se presente: mostrato come notifica telefonica animata invece
  /// che come semplice prosa.
  final String? messaggioAnonimo;

  /// Se valorizzato, prima di proseguire il giocatore deve risolvere questo
  /// minigioco investigativo. Una volta completato (una sola volta, il
  /// risultato resta salvato), sblocca [indizioMinigioco] e procede
  /// normalmente verso dialoghi/scelte.
  final MinigameType? minigioco;
  final String? indizioMinigioco;

  const Scene({
    required this.id,
    required this.testoNarrativo,
    required this.luogo,
    this.dialoghi = const [],
    this.scelte = const [],
    this.indiziOttenibili = const [],
    this.endingId,
    this.isFinaleCapitolo = false,
    this.messaggioAnonimo,
    this.minigioco,
    this.indizioMinigioco,
  });

  factory Scene.fromJson(Map<String, dynamic> json) {
    return Scene(
      id: json['id'] as String,
      testoNarrativo: json['testoNarrativo'] as String,
      luogo: json['luogo'] as String,
      dialoghi: (json['dialoghi'] as List<dynamic>? ?? [])
          .map((e) => DialogueLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      scelte: (json['scelte'] as List<dynamic>? ?? [])
          .map((e) => Choice.fromJson(e as Map<String, dynamic>))
          .toList(),
      indiziOttenibili: (json['indiziOttenibili'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      endingId: json['endingId'] as String?,
      isFinaleCapitolo: json['isFinaleCapitolo'] as bool? ?? false,
      messaggioAnonimo: json['messaggioAnonimo'] as String?,
      minigioco: json['minigioco'] == null
          ? null
          : MinigameType.values.firstWhere((e) => e.name == json['minigioco']),
      indizioMinigioco: json['indizioMinigioco'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testoNarrativo': testoNarrativo,
      'luogo': luogo,
      'dialoghi': dialoghi.map((e) => e.toJson()).toList(),
      'scelte': scelte.map((e) => e.toJson()).toList(),
      'indiziOttenibili': indiziOttenibili,
      'endingId': endingId,
      'isFinaleCapitolo': isFinaleCapitolo,
      'messaggioAnonimo': messaggioAnonimo,
      'minigioco': minigioco?.name,
      'indizioMinigioco': indizioMinigioco,
    };
  }
}
