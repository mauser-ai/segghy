import 'package:flutter/material.dart';

/// Ambientazioni visive disponibili per le schermate di gioco (narrativa e
/// dialogo). Ognuna racconta, solo con colore e sagome, il luogo o il
/// momento della storia in cui si trova Segghy in quell'istante.
enum SceneBackgroundType {
  /// Capitolo 1 — la villa e la festa a Golasecca, la notte del delitto.
  villaFesta,

  /// Capitolo 2 — la riva del Ticino a Sesto Calende.
  rivaFiume,

  /// Capitolo 3 — il maneggio di Manuela, di giorno.
  maneggio,

  /// Capitolo 4 — l'officina di Kledian a Vergiate.
  officina,

  /// Capitolo 5 — il rifugio per gattini di Gaia e Anna.
  rifugioGattini,

  /// Capitolo 6 — il bosco e lo scavo archeologico ad Arsago Seprio.
  scavoArcheologico,

  /// Capitolo 7 — la riva sorvegliata di Castelletto sopra Ticino, di notte.
  guardianoNotte,

  /// Capitolo 8 — il bar di Sandra a Golasecca.
  bar,

  /// Capitolo 9 — il maneggio, di notte, quando il segreto viene a galla.
  maneggioNotte,

  /// Capitolo 10 — il confronto finale sulla riva del Ticino.
  confrontoFinale,
}

/// Coppia di colori (alto/basso) usata come gradiente di base per ogni
/// ambientazione, più un colore di accento per le sagome disegnate sopra.
class SceneBackgroundPalette {
  final Color top;
  final Color bottom;
  final Color accent;

  const SceneBackgroundPalette({
    required this.top,
    required this.bottom,
    required this.accent,
  });
}

const Map<SceneBackgroundType, SceneBackgroundPalette> kScenePalettes = {
  SceneBackgroundType.villaFesta: SceneBackgroundPalette(
    top: Color(0xFF1A1230),
    bottom: Color(0xFF0B0E14),
    accent: Color(0xFFE0B85C),
  ),
  SceneBackgroundType.rivaFiume: SceneBackgroundPalette(
    top: Color(0xFF122A33),
    bottom: Color(0xFF0B0E14),
    accent: Color(0xFF6FB8C9),
  ),
  SceneBackgroundType.maneggio: SceneBackgroundPalette(
    top: Color(0xFF2A2013),
    bottom: Color(0xFF14100A),
    accent: Color(0xFFD9A45C),
  ),
  SceneBackgroundType.officina: SceneBackgroundPalette(
    top: Color(0xFF1B222B),
    bottom: Color(0xFF0B0E14),
    accent: Color(0xFF8FAFC2),
  ),
  SceneBackgroundType.rifugioGattini: SceneBackgroundPalette(
    top: Color(0xFF241A22),
    bottom: Color(0xFF0F0C11),
    accent: Color(0xFFE0A9B8),
  ),
  SceneBackgroundType.scavoArcheologico: SceneBackgroundPalette(
    top: Color(0xFF1B2417),
    bottom: Color(0xFF0B0E14),
    accent: Color(0xFFA9C97E),
  ),
  SceneBackgroundType.guardianoNotte: SceneBackgroundPalette(
    top: Color(0xFF10131F),
    bottom: Color(0xFF07080D),
    accent: Color(0xFF5C7FE0),
  ),
  SceneBackgroundType.bar: SceneBackgroundPalette(
    top: Color(0xFF2A1B12),
    bottom: Color(0xFF120C08),
    accent: Color(0xFFE0955C),
  ),
  SceneBackgroundType.maneggioNotte: SceneBackgroundPalette(
    top: Color(0xFF161328),
    bottom: Color(0xFF0B0E14),
    accent: Color(0xFF9C7CE0),
  ),
  SceneBackgroundType.confrontoFinale: SceneBackgroundPalette(
    top: Color(0xFF1A1230),
    bottom: Color(0xFF120A08),
    accent: Color(0xFFE0B85C),
  ),
};

/// Ogni capitolo ha un'ambientazione dominante: tutte le sue scene
/// condividono lo stesso luogo/momento della giornata.
const Map<String, SceneBackgroundType> kChapterBackgrounds = {
  'c1': SceneBackgroundType.villaFesta,
  'c2': SceneBackgroundType.rivaFiume,
  'c2b': SceneBackgroundType.officina,
  'c3': SceneBackgroundType.maneggio,
  'c3b': SceneBackgroundType.maneggio,
  'c4': SceneBackgroundType.officina,
  'c5': SceneBackgroundType.rifugioGattini,
  'c6': SceneBackgroundType.scavoArcheologico,
  'c7': SceneBackgroundType.guardianoNotte,
  'c8': SceneBackgroundType.bar,
  'c9': SceneBackgroundType.maneggioNotte,
  'c10': SceneBackgroundType.confrontoFinale,
};

SceneBackgroundType backgroundForChapter(String chapterId) =>
    kChapterBackgrounds[chapterId] ?? SceneBackgroundType.rivaFiume;
