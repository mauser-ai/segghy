import 'ending.dart';

/// Stato completo della partita in corso. È l'unico oggetto persistito su
/// disco (tramite SharedPreferences, come JSON) per implementare il
/// salvataggio/caricamento della partita.
class GameState {
  final String capitoloCorrenteId;
  final String scenaCorrenteId;

  /// Id degli indizi raccolti finora.
  final Set<String> indiziRaccolti;

  /// Fiducia per personaggio: characterId -> valore 0-100. Rappresenta
  /// quanto Segghy si fida personalmente di qualcuno.
  final Map<String, int> fiduciaPersonaggi;

  /// Livello di sospetto per personaggio: characterId -> valore 0-100.
  /// Rappresenta quanto le prove e i comportamenti osservati indicano
  /// quella persona come possibile colpevole. È indipendente dalla
  /// fiducia: si può sospettare di qualcuno di cui ci si fida ancora.
  final Map<String, int> sospettoPersonaggi;

  /// Storico delle scelte effettuate: sceneId -> choiceId.
  final Map<String, String> scelteEffettuate;

  /// Id dei capitoli completati.
  final Set<String> capitoliCompletati;

  /// Id delle scene-minigioco già risolte: una volta completato, un
  /// minigioco non va ripetuto se si rivisita la scena.
  final Set<String> minigiochiCompletati;

  final EndingType? finale;

  /// Id dell'ultimo personaggio formalmente accusato nel confronto finale
  /// (corretto o sbagliato che sia). Usato per personalizzare il testo
  /// della scena successiva con il suo nome.
  final String? personaggioAccusato;

  /// Id dei sospettati già accusati per errore: il giocatore può
  /// continuare a scegliere tra i rimanenti finché non individua Sandra.
  final Set<String> sospettiEsclusi;

  final bool partitaIniziata;

  /// Timestamp dell'ultimo salvataggio (millisecondi epoch), utile per la
  /// schermata "Continua partita".
  final int ultimoSalvataggio;

  const GameState({
    required this.capitoloCorrenteId,
    required this.scenaCorrenteId,
    this.indiziRaccolti = const {},
    this.fiduciaPersonaggi = const {},
    this.sospettoPersonaggi = const {},
    this.scelteEffettuate = const {},
    this.capitoliCompletati = const {},
    this.minigiochiCompletati = const {},
    this.finale,
    this.personaggioAccusato,
    this.sospettiEsclusi = const {},
    this.partitaIniziata = false,
    this.ultimoSalvataggio = 0,
  });

  /// Stato iniziale di una nuova partita: capitolo 1, prima scena.
  factory GameState.nuovaPartita({
    required String primoCapitoloId,
    required String primaScenaId,
    required Map<String, int> fiduciaIniziale,
    required Map<String, int> sospettoIniziale,
  }) {
    return GameState(
      capitoloCorrenteId: primoCapitoloId,
      scenaCorrenteId: primaScenaId,
      fiduciaPersonaggi: fiduciaIniziale,
      sospettoPersonaggi: sospettoIniziale,
      partitaIniziata: true,
      ultimoSalvataggio: DateTime.now().millisecondsSinceEpoch,
    );
  }

  GameState copyWith({
    String? capitoloCorrenteId,
    String? scenaCorrenteId,
    Set<String>? indiziRaccolti,
    Map<String, int>? fiduciaPersonaggi,
    Map<String, int>? sospettoPersonaggi,
    Map<String, String>? scelteEffettuate,
    Set<String>? capitoliCompletati,
    Set<String>? minigiochiCompletati,
    EndingType? finale,
    String? personaggioAccusato,
    Set<String>? sospettiEsclusi,
    bool? partitaIniziata,
    int? ultimoSalvataggio,
  }) {
    return GameState(
      capitoloCorrenteId: capitoloCorrenteId ?? this.capitoloCorrenteId,
      scenaCorrenteId: scenaCorrenteId ?? this.scenaCorrenteId,
      indiziRaccolti: indiziRaccolti ?? this.indiziRaccolti,
      fiduciaPersonaggi: fiduciaPersonaggi ?? this.fiduciaPersonaggi,
      sospettoPersonaggi: sospettoPersonaggi ?? this.sospettoPersonaggi,
      scelteEffettuate: scelteEffettuate ?? this.scelteEffettuate,
      capitoliCompletati: capitoliCompletati ?? this.capitoliCompletati,
      minigiochiCompletati: minigiochiCompletati ?? this.minigiochiCompletati,
      finale: finale ?? this.finale,
      personaggioAccusato: personaggioAccusato ?? this.personaggioAccusato,
      sospettiEsclusi: sospettiEsclusi ?? this.sospettiEsclusi,
      partitaIniziata: partitaIniziata ?? this.partitaIniziata,
      ultimoSalvataggio: ultimoSalvataggio ?? this.ultimoSalvataggio,
    );
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      capitoloCorrenteId: json['capitoloCorrenteId'] as String,
      scenaCorrenteId: json['scenaCorrenteId'] as String,
      indiziRaccolti: (json['indiziRaccolti'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toSet(),
      fiduciaPersonaggi: (json['fiduciaPersonaggi'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as int)) ??
          const {},
      sospettoPersonaggi: (json['sospettoPersonaggi'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as int)) ??
          const {},
      scelteEffettuate: (json['scelteEffettuate'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as String)) ??
          const {},
      capitoliCompletati: (json['capitoliCompletati'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toSet(),
      minigiochiCompletati:
          (json['minigiochiCompletati'] as List<dynamic>? ?? [])
              .map((e) => e as String)
              .toSet(),
      finale: json['finale'] == null
          ? null
          : EndingType.values.firstWhere((e) => e.name == json['finale']),
      personaggioAccusato: json['personaggioAccusato'] as String?,
      sospettiEsclusi: (json['sospettiEsclusi'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toSet(),
      partitaIniziata: json['partitaIniziata'] as bool? ?? false,
      ultimoSalvataggio: json['ultimoSalvataggio'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'capitoloCorrenteId': capitoloCorrenteId,
      'scenaCorrenteId': scenaCorrenteId,
      'indiziRaccolti': indiziRaccolti.toList(),
      'fiduciaPersonaggi': fiduciaPersonaggi,
      'sospettoPersonaggi': sospettoPersonaggi,
      'scelteEffettuate': scelteEffettuate,
      'capitoliCompletati': capitoliCompletati.toList(),
      'minigiochiCompletati': minigiochiCompletati.toList(),
      'finale': finale?.name,
      'personaggioAccusato': personaggioAccusato,
      'sospettiEsclusi': sospettiEsclusi.toList(),
      'partitaIniziata': partitaIniziata,
      'ultimoSalvataggio': ultimoSalvataggio,
    };
  }
}
