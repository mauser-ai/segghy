import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/scene_backgrounds.dart';

/// Disegna, sotto forma di sagome piatte in stile "ombra cinese", l'elemento
/// visivo caratteristico di ogni ambientazione: non fotografie ma illustrazioni
/// minimali coerenti con lo stile grafico dell'app, per raccontare il luogo
/// senza distrarre dalla lettura del testo sovrapposto.
class ScenePainter extends CustomPainter {
  final SceneBackgroundType type;
  final Color accent;

  const ScenePainter({required this.type, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case SceneBackgroundType.villaFesta:
        _paintVilla(canvas, size);
      case SceneBackgroundType.rivaFiume:
        _paintFiume(canvas, size);
      case SceneBackgroundType.maneggio:
        _paintManeggio(canvas, size, notte: false);
      case SceneBackgroundType.maneggioNotte:
        _paintManeggio(canvas, size, notte: true);
      case SceneBackgroundType.officina:
        _paintOfficina(canvas, size);
      case SceneBackgroundType.rifugioGattini:
        _paintRifugio(canvas, size);
      case SceneBackgroundType.scavoArcheologico:
        _paintScavo(canvas, size);
      case SceneBackgroundType.guardianoNotte:
        _paintGuardiano(canvas, size);
      case SceneBackgroundType.bar:
        _paintBar(canvas, size);
      case SceneBackgroundType.confrontoFinale:
        _paintConfronto(canvas, size);
    }
  }

  Paint _fill(double alpha) => Paint()
    ..color = accent.withValues(alpha: alpha)
    ..style = PaintingStyle.fill;

  Paint _stroke(double alpha, double width) => Paint()
    ..color = accent.withValues(alpha: alpha)
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round;

  // -- Capitolo 1: la villa e la festa -------------------------------------
  void _paintVilla(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    // Luna
    canvas.drawCircle(Offset(w * 0.82, h * 0.1), 26, _fill(0.18));
    // Sagoma del tetto della villa lungo il bordo inferiore.
    final roof = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.72)
      ..lineTo(w * 0.12, h * 0.6)
      ..lineTo(w * 0.24, h * 0.72)
      ..lineTo(w * 0.24, h * 0.66)
      ..lineTo(w * 0.34, h * 0.66)
      ..lineTo(w * 0.34, h * 0.78)
      ..lineTo(w * 0.5, h * 0.6)
      ..lineTo(w * 0.66, h * 0.78)
      ..lineTo(w * 0.66, h * 0.66)
      ..lineTo(1, h * 0.66)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(roof, _fill(0.10));
    // Finestre illuminate.
    for (final dx in [0.14, 0.4, 0.58]) {
      canvas.drawRect(
        Rect.fromCenter(center: Offset(w * dx, h * 0.82), width: 10, height: 14),
        _fill(0.28),
      );
    }
    // Lucine da giardino sospese.
    final lights = Path()
      ..moveTo(w * 0.05, h * 0.5)
      ..quadraticBezierTo(w * 0.3, h * 0.42, w * 0.55, h * 0.52)
      ..quadraticBezierTo(w * 0.8, h * 0.6, w, h * 0.48);
    canvas.drawPath(lights, _stroke(0.22, 1.5));
    for (final t in [0.1, 0.3, 0.5, 0.7, 0.9]) {
      final pos = _pointOnQuadPath(
          Offset(w * 0.05, h * 0.5), Offset(w * 0.3, h * 0.42), Offset(w * 0.55, h * 0.52), t);
      canvas.drawCircle(pos, 2.4, _fill(0.5));
    }
  }

  // -- Capitolo 2: la riva del Ticino --------------------------------------
  void _paintFiume(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    for (int i = 0; i < 3; i++) {
      final y = h * (0.78 + i * 0.06);
      final wave = Path()..moveTo(0, y);
      for (double x = 0; x <= w; x += w / 8) {
        wave.quadraticBezierTo(x + w / 16, y - 6, x + w / 8, y);
      }
      canvas.drawPath(wave, _stroke(0.14 - i * 0.03, 2));
    }
    // Canneti sulla riva.
    for (final dx in [0.06, 0.1, 0.15, 0.85, 0.92]) {
      final base = Offset(w * dx, h * 0.98);
      final path = Path()
        ..moveTo(base.dx, base.dy)
        ..quadraticBezierTo(base.dx - 6, base.dy - 60, base.dx + 4, base.dy - 110);
      canvas.drawPath(path, _stroke(0.22, 2));
    }
    // Barca in lontananza.
    final boat = Path()
      ..moveTo(w * 0.62, h * 0.85)
      ..lineTo(w * 0.74, h * 0.85)
      ..lineTo(w * 0.70, h * 0.90)
      ..lineTo(w * 0.66, h * 0.90)
      ..close();
    canvas.drawPath(boat, _fill(0.16));
  }

  // -- Capitoli 3/9: il maneggio -------------------------------------------
  void _paintManeggio(Canvas canvas, Size size, {required bool notte}) {
    final w = size.width, h = size.height;
    final baseAlpha = notte ? 0.16 : 0.12;
    // Staccionata.
    for (double x = -10; x < w + 10; x += w / 7) {
      canvas.drawLine(Offset(x, h * 0.86), Offset(x, h * 0.98), _stroke(baseAlpha + 0.06, 3));
    }
    canvas.drawLine(Offset(0, h * 0.88), Offset(w, h * 0.88), _stroke(baseAlpha + 0.04, 2));
    canvas.drawLine(Offset(0, h * 0.94), Offset(w, h * 0.94), _stroke(baseAlpha + 0.04, 2));
    // Sagoma stilizzata di un cavallo (Nebbia) sulla destra.
    final hx = w * 0.72, hy = h * 0.78, s = w * 0.22;
    final horse = Path()
      ..moveTo(hx, hy)
      ..cubicTo(hx + s * 0.1, hy - s * 0.5, hx + s * 0.35, hy - s * 0.65, hx + s * 0.5, hy - s * 0.55)
      ..cubicTo(hx + s * 0.58, hy - s * 0.7, hx + s * 0.62, hy - s * 0.95, hx + s * 0.5, hy - s * 1.05)
      ..cubicTo(hx + s * 0.46, hy - s * 0.92, hx + s * 0.4, hy - s * 0.8, hx + s * 0.32, hy - s * 0.78)
      ..cubicTo(hx + s * 0.1, hy - s * 0.75, hx - s * 0.05, hy - s * 0.4, hx, hy)
      ..close();
    canvas.drawPath(horse, _fill(baseAlpha + (notte ? 0.14 : 0.08)));
    if (notte) {
      // Un unico lume acceso nel fienile.
      canvas.drawCircle(Offset(w * 0.18, h * 0.7), 14, _fill(0.22));
      canvas.drawCircle(Offset(w * 0.18, h * 0.7), 26, _fill(0.08));
    }
  }

  // -- Capitolo 4: l'officina di Kledian ------------------------------------
  void _paintOfficina(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    _drawGear(canvas, Offset(w * 0.18, h * 0.16), 34, 8, _fill(0.16));
    _drawGear(canvas, Offset(w * 0.86, h * 0.85), 46, 10, _fill(0.12));
    _drawGear(canvas, Offset(w * 0.08, h * 0.82), 24, 7, _fill(0.14));
    // Lampada a sospensione.
    canvas.drawLine(Offset(w * 0.5, 0), Offset(w * 0.5, h * 0.14), _stroke(0.2, 2));
    final shade = Path()
      ..moveTo(w * 0.5 - 16, h * 0.14)
      ..lineTo(w * 0.5 + 16, h * 0.14)
      ..lineTo(w * 0.5 + 22, h * 0.19)
      ..lineTo(w * 0.5 - 22, h * 0.19)
      ..close();
    canvas.drawPath(shade, _fill(0.18));
    canvas.drawCircle(Offset(w * 0.5, h * 0.22), 30, _fill(0.05));
  }

  // -- Capitolo 5: il rifugio per gattini -----------------------------------
  void _paintRifugio(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    _drawCat(canvas, Offset(w * 0.18, h * 0.88), 46, _fill(0.20));
    _drawCat(canvas, Offset(w * 0.8, h * 0.92), 32, _fill(0.14));
    // Zampette sparse.
    final rnd = math.Random(7);
    for (int i = 0; i < 10; i++) {
      final pos = Offset(w * rnd.nextDouble(), h * (0.3 + rnd.nextDouble() * 0.4));
      canvas.drawCircle(pos, 2.5, _fill(0.10));
    }
  }

  // -- Capitolo 6: lo scavo archeologico -------------------------------------
  void _paintScavo(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    for (final t in [
      (0.06, 0.5, 0.9),
      (0.18, 0.35, 0.85),
      (0.92, 0.55, 0.95),
      (0.82, 0.3, 0.8),
    ]) {
      final tree = Path()
        ..moveTo(w * t.$1, h * t.$3)
        ..lineTo(w * t.$1, h * t.$2)
        ..moveTo(w * t.$1 - 14, h * t.$2 + 10)
        ..quadraticBezierTo(w * t.$1, h * t.$2 - 24, w * t.$1 + 14, h * t.$2 + 10)
        ..close();
      canvas.drawPath(tree, _stroke(0.2, 3));
    }
    // Pietra tombale/reperto al centro basso.
    final stone = Path()
      ..moveTo(w * 0.42, h * 0.98)
      ..lineTo(w * 0.44, h * 0.8)
      ..quadraticBezierTo(w * 0.5, h * 0.74, w * 0.56, h * 0.8)
      ..lineTo(w * 0.58, h * 0.98)
      ..close();
    canvas.drawPath(stone, _fill(0.16));
    canvas.drawCircle(Offset(w * 0.5, h * 0.79), 8, _fill(0.3));
  }

  // -- Capitolo 7: il guardiano del fiume, di notte --------------------------
  void _paintGuardiano(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.drawCircle(Offset(w * 0.2, h * 0.12), 20, _fill(0.16));
    // Riflesso della luna sull'acqua.
    for (final t in [0.86, 0.90, 0.94]) {
      canvas.drawLine(
        Offset(w * 0.14, h * t),
        Offset(w * 0.26, h * t),
        _stroke(0.12, 2),
      );
    }
    // Torretta del guardiano.
    canvas.drawRect(Rect.fromLTWH(w * 0.78, h * 0.5, w * 0.05, h * 0.4), _fill(0.18));
    canvas.drawRect(Rect.fromLTWH(w * 0.75, h * 0.44, w * 0.11, h * 0.08), _fill(0.2));
    // Occhio della telecamera: un piccolo punto che pulsa (colore pieno).
    canvas.drawCircle(Offset(w * 0.805, h * 0.47), 3, Paint()..color = accent.withValues(alpha: 0.6));
  }

  // -- Capitolo 8: il bar di Sandra -------------------------------------------
  void _paintBar(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    // Scaffale con bottiglie.
    canvas.drawLine(Offset(0, h * 0.14), Offset(w * 0.4, h * 0.14), _stroke(0.18, 2));
    for (final dx in [0.05, 0.12, 0.19, 0.26, 0.33]) {
      canvas.drawRect(
        Rect.fromLTWH(w * dx, h * 0.14 - 22, 8, 22),
        _fill(0.14),
      );
    }
    // Tazzina con vapore.
    final cx = w * 0.82, cy = h * 0.86;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy), width: 34, height: 22), const Radius.circular(4)),
      _fill(0.18),
    );
    for (final dx in [-8.0, 0.0, 8.0]) {
      final steam = Path()
        ..moveTo(cx + dx, cy - 14)
        ..quadraticBezierTo(cx + dx - 6, cy - 26, cx + dx, cy - 38);
      canvas.drawPath(steam, _stroke(0.14, 1.6));
    }
    // Lampade pendenti.
    for (final dx in [0.55, 0.68]) {
      canvas.drawLine(Offset(w * dx, 0), Offset(w * dx, h * 0.1), _stroke(0.16, 1.6));
      canvas.drawCircle(Offset(w * dx, h * 0.12), 6, _fill(0.22));
    }
  }

  // -- Capitolo 10: il confronto finale sul fiume -----------------------------
  void _paintConfronto(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.drawCircle(Offset(w * 0.5, h * 0.14), 34, _fill(0.14));
    // Nebbia sul fiume.
    for (int i = 0; i < 3; i++) {
      final y = h * (0.82 + i * 0.05);
      canvas.drawLine(Offset(0, y), Offset(w, y), _stroke(0.08, 10));
    }
    // Due sagome, distanti, una di fronte all'altra.
    _drawFigure(canvas, Offset(w * 0.28, h * 0.86), 60, _fill(0.22));
    _drawFigure(canvas, Offset(w * 0.72, h * 0.86), 60, _fill(0.16));
  }

  // -- Helpers ---------------------------------------------------------------

  void _drawGear(Canvas canvas, Offset center, double radius, int teeth, Paint paint) {
    final path = Path();
    final toothAngle = (2 * math.pi) / teeth;
    for (int i = 0; i < teeth; i++) {
      final a0 = i * toothAngle;
      final outer = radius;
      final inner = radius * 0.72;
      final p0 = center + Offset(math.cos(a0) * inner, math.sin(a0) * inner);
      final p1 = center + Offset(math.cos(a0 + toothAngle * 0.2) * outer, math.sin(a0 + toothAngle * 0.2) * outer);
      final p2 = center + Offset(math.cos(a0 + toothAngle * 0.5) * outer, math.sin(a0 + toothAngle * 0.5) * outer);
      final p3 = center + Offset(math.cos(a0 + toothAngle * 0.7) * inner, math.sin(a0 + toothAngle * 0.7) * inner);
      if (i == 0) path.moveTo(p0.dx, p0.dy);
      path.lineTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(p3.dx, p3.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(center, radius * 0.3, Paint()..color = paint.color);
  }

  void _drawCat(Canvas canvas, Offset base, double s, Paint paint) {
    final body = Path()
      ..addOval(Rect.fromCenter(center: base, width: s, height: s * 0.7));
    final head = Path()
      ..addOval(Rect.fromCenter(center: base.translate(-s * 0.42, -s * 0.32), width: s * 0.42, height: s * 0.4));
    final earL = Path()
      ..moveTo(base.dx - s * 0.58, base.dy - s * 0.46)
      ..lineTo(base.dx - s * 0.5, base.dy - s * 0.66)
      ..lineTo(base.dx - s * 0.42, base.dy - s * 0.48)
      ..close();
    final earR = Path()
      ..moveTo(base.dx - s * 0.3, base.dy - s * 0.5)
      ..lineTo(base.dx - s * 0.24, base.dy - s * 0.68)
      ..lineTo(base.dx - s * 0.16, base.dy - s * 0.48)
      ..close();
    final tail = Path()
      ..moveTo(base.dx + s * 0.42, base.dy)
      ..quadraticBezierTo(base.dx + s * 0.7, base.dy - s * 0.3, base.dx + s * 0.5, base.dy - s * 0.55);
    canvas.drawPath(body, paint);
    canvas.drawPath(head, paint);
    canvas.drawPath(earL, paint);
    canvas.drawPath(earR, paint);
    canvas.drawPath(tail, _stroke(paint.color.a, s * 0.08));
  }

  void _drawFigure(Canvas canvas, Offset feet, double h, Paint paint) {
    // Sagoma umana essenziale: testa + mantello triangolare.
    canvas.drawCircle(feet.translate(0, -h), h * 0.14, paint);
    final cloak = Path()
      ..moveTo(feet.dx, feet.dy)
      ..lineTo(feet.dx - h * 0.22, feet.dy - h * 0.02)
      ..lineTo(feet.dx - h * 0.12, feet.dy - h * 0.78)
      ..lineTo(feet.dx + h * 0.12, feet.dy - h * 0.78)
      ..lineTo(feet.dx + h * 0.22, feet.dy - h * 0.02)
      ..close();
    canvas.drawPath(cloak, paint);
  }

  Offset _pointOnQuadPath(Offset p0, Offset p1, Offset p2, double t) {
    final x = (1 - t) * (1 - t) * p0.dx + 2 * (1 - t) * t * p1.dx + t * t * p2.dx;
    final y = (1 - t) * (1 - t) * p0.dy + 2 * (1 - t) * t * p1.dy + t * t * p2.dy;
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant ScenePainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.accent != accent;
}
