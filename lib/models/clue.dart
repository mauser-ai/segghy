/// Livello di importanza di un indizio ai fini della risoluzione del caso.
enum ClueImportance {
  bassa,
  media,
  alta,
  critica;

  String get label {
    switch (this) {
      case ClueImportance.bassa:
        return 'Bassa';
      case ClueImportance.media:
        return 'Media';
      case ClueImportance.alta:
        return 'Alta';
      case ClueImportance.critica:
        return 'Critica';
    }
  }
}

/// Rappresenta un indizio raccoglibile durante l'indagine.
class Clue {
  final String id;
  final String titolo;
  final String descrizione;
  final String luogo;
  final ClueImportance importanza;

  /// true se il giocatore lo ha già trovato nella partita corrente.
  final bool trovato;

  const Clue({
    required this.id,
    required this.titolo,
    required this.descrizione,
    required this.luogo,
    this.importanza = ClueImportance.media,
    this.trovato = false,
  });

  Clue copyWith({bool? trovato}) {
    return Clue(
      id: id,
      titolo: titolo,
      descrizione: descrizione,
      luogo: luogo,
      importanza: importanza,
      trovato: trovato ?? this.trovato,
    );
  }

  factory Clue.fromJson(Map<String, dynamic> json) {
    return Clue(
      id: json['id'] as String,
      titolo: json['titolo'] as String,
      descrizione: json['descrizione'] as String,
      luogo: json['luogo'] as String,
      importanza: ClueImportance.values.firstWhere(
        (e) => e.name == json['importanza'],
        orElse: () => ClueImportance.media,
      ),
      trovato: json['trovato'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titolo': titolo,
      'descrizione': descrizione,
      'luogo': luogo,
      'importanza': importanza.name,
      'trovato': trovato,
    };
  }
}
