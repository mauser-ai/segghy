/// Rappresenta una scelta disponibile per il giocatore all'interno di una
/// scena. Ogni scelta può modificare la fiducia e il livello di sospetto
/// verso i personaggi, sbloccare indizi e determinare la scena successiva.
class Choice {
  final String id;
  final String testoScelta;

  /// Breve descrizione dell'effetto narrativo della scelta, mostrata
  /// come feedback dopo la selezione.
  final String effetto;

  /// Id della scena verso cui questa scelta porta.
  final String prossimoNodo;

  /// Variazione di fiducia per personaggio: chiave = characterId, valore =
  /// delta da applicare (può essere negativo).
  final Map<String, int> modificaFiducia;

  /// Variazione del livello di sospetto per personaggio: chiave =
  /// characterId, valore = delta da applicare (può essere negativo).
  /// Indipendente dalla fiducia: le prove possono insospettire Segghy
  /// anche verso qualcuno di cui si fida ancora.
  final Map<String, int> modificaSospetto;

  /// Id degli indizi sbloccati selezionando questa scelta.
  final List<String> indiziSbloccati;

  const Choice({
    required this.id,
    required this.testoScelta,
    this.effetto = '',
    required this.prossimoNodo,
    this.modificaFiducia = const {},
    this.modificaSospetto = const {},
    this.indiziSbloccati = const [],
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'] as String,
      testoScelta: json['testoScelta'] as String,
      effetto: json['effetto'] as String? ?? '',
      prossimoNodo: json['prossimoNodo'] as String,
      modificaFiducia: (json['modificaFiducia'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as int)) ??
          const {},
      modificaSospetto: (json['modificaSospetto'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as int)) ??
          const {},
      indiziSbloccati: (json['indiziSbloccati'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testoScelta': testoScelta,
      'effetto': effetto,
      'prossimoNodo': prossimoNodo,
      'modificaFiducia': modificaFiducia,
      'modificaSospetto': modificaSospetto,
      'indiziSbloccati': indiziSbloccati,
    };
  }
}
