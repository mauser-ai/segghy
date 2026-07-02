import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/scene_backgrounds.dart';
import 'scene_background_painter.dart';

/// Sfondo tematico per le schermate di gioco: gradiente e sagome coerenti
/// con il luogo/momento della scena corrente, più un lieve pulviscolo
/// fluttuante che dà profondità senza distrarre dalla lettura. Cambia con
/// una dissolvenza morbida quando la storia si sposta altrove.
class SceneBackground extends StatelessWidget {
  final SceneBackgroundType type;
  final Widget child;

  const SceneBackground({super.key, required this.type, required this.child});

  @override
  Widget build(BuildContext context) {
    final palette = kScenePalettes[type]!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [palette.top, palette.bottom],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 700),
              child: CustomPaint(
                key: ValueKey(type),
                painter: ScenePainter(type: type, accent: palette.accent),
                size: Size.infinite,
              ),
            ),
          ),
          const Positioned.fill(child: _DriftingDust()),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

/// Pulviscolo/nebbiolina che fluttua lentamente verso l'alto, in stile
/// atmosfera fluviale: pochi punti, molto tenui, per non affaticare la vista.
class _DriftingDust extends StatefulWidget {
  const _DriftingDust();

  @override
  State<_DriftingDust> createState() => _DriftingDustState();
}

class _DriftingDustState extends State<_DriftingDust>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_DustMote> _motes = List.generate(
    14,
    (i) => _DustMote(seed: i),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _DustPainter(progress: _controller.value, motes: _motes),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _DustMote {
  final double x;
  final double startY;
  final double speed;
  final double radius;

  _DustMote({required int seed})
      : x = math.Random(seed * 17 + 1).nextDouble(),
        startY = math.Random(seed * 31 + 2).nextDouble(),
        speed = 0.4 + math.Random(seed * 53 + 3).nextDouble() * 0.8,
        radius = 0.8 + math.Random(seed * 71 + 4).nextDouble() * 1.6;
}

class _DustPainter extends CustomPainter {
  final double progress;
  final List<_DustMote> motes;

  _DustPainter({required this.progress, required this.motes});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.10);
    for (final mote in motes) {
      final y = (mote.startY - progress * mote.speed) % 1.0;
      canvas.drawCircle(
        Offset(mote.x * size.width, y * size.height),
        mote.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DustPainter oldDelegate) => true;
}
