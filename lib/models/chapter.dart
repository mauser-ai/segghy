import 'scene.dart';

/// Un capitolo raggruppa un insieme di scene collegate tra loro e
/// rappresenta una tappa dell'indagine, spesso legata a un luogo preciso.
class Chapter {
  final String id;
  final int numero;
  final String titolo;
  final String descrizione;
  final String luogo;
  final List<Scene> scene;

  /// Id della prima scena del capitolo.
  final String scenaInizialeId;

  const Chapter({
    required this.id,
    required this.numero,
    required this.titolo,
    required this.descrizione,
    required this.luogo,
    required this.scene,
    required this.scenaInizialeId,
  });

  Scene? sceneById(String id) {
    for (final s in scene) {
      if (s.id == id) return s;
    }
    return null;
  }
}
