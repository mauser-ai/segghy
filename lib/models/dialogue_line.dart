/// Una singola battuta di dialogo pronunciata da un personaggio (o dalla
/// protagonista stessa) all'interno di una scena.
class DialogueLine {
  final String personaggioId;
  final String nomeVisualizzato;
  final String testo;

  const DialogueLine({
    required this.personaggioId,
    required this.nomeVisualizzato,
    required this.testo,
  });

  factory DialogueLine.fromJson(Map<String, dynamic> json) {
    return DialogueLine(
      personaggioId: json['personaggioId'] as String,
      nomeVisualizzato: json['nomeVisualizzato'] as String,
      testo: json['testo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personaggioId': personaggioId,
      'nomeVisualizzato': nomeVisualizzato,
      'testo': testo,
    };
  }
}
