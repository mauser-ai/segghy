/// Rappresenta un personaggio del gioco: protagonista, alleati, sospettati.
class Character {
  final String id;
  final String nome;
  final String descrizione;
  final String ruolo;
  final String luogo;

  /// Livello di fiducia che Segghy ripone nel personaggio (0-100).
  /// Cambia in base alle scelte del giocatore nei dialoghi.
  final int livelloFiducia;

  /// Indica se il personaggio è (o è stato) un sospettato nell'indagine.
  final bool sospettato;

  /// Percorso di un'immagine asset, oppure null: in quel caso la UI
  /// disegna un avatar generato dalle iniziali e da un colore stabile.
  final String? immagine;

  const Character({
    required this.id,
    required this.nome,
    required this.descrizione,
    required this.ruolo,
    required this.luogo,
    this.livelloFiducia = 50,
    this.sospettato = false,
    this.immagine,
  });

  Character copyWith({
    int? livelloFiducia,
    bool? sospettato,
  }) {
    return Character(
      id: id,
      nome: nome,
      descrizione: descrizione,
      ruolo: ruolo,
      luogo: luogo,
      livelloFiducia: livelloFiducia ?? this.livelloFiducia,
      sospettato: sospettato ?? this.sospettato,
      immagine: immagine,
    );
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      nome: json['nome'] as String,
      descrizione: json['descrizione'] as String,
      ruolo: json['ruolo'] as String,
      luogo: json['luogo'] as String,
      livelloFiducia: json['livelloFiducia'] as int? ?? 50,
      sospettato: json['sospettato'] as bool? ?? false,
      immagine: json['immagine'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descrizione': descrizione,
      'ruolo': ruolo,
      'luogo': luogo,
      'livelloFiducia': livelloFiducia,
      'sospettato': sospettato,
      'immagine': immagine,
    };
  }
}
