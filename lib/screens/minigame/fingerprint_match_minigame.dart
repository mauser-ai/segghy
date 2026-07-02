import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Minigioco "memory": individua le tre coppie di impronte identiche tra
/// quelle rilevate sulla barca, per isolare quella che non appartiene a
/// nessun ospite della festa.
class FingerprintMatchMinigame extends StatefulWidget {
  final VoidCallback onSolved;

  const FingerprintMatchMinigame({super.key, required this.onSolved});

  @override
  State<FingerprintMatchMinigame> createState() =>
      _FingerprintMatchMinigameState();
}

class _FingerprintMatchMinigameState extends State<FingerprintMatchMinigame> {
  late List<int> _patternIds;
  final Set<int> _revealed = {};
  final Set<int> _matched = {};
  int? _firstPick;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _patternIds = [0, 0, 1, 1, 2, 2]..shuffle(math.Random(DateTime.now().millisecond));
  }

  void _tap(int index) {
    if (_busy || _revealed.contains(index) || _matched.contains(index)) return;
    setState(() => _revealed.add(index));

    if (_firstPick == null) {
      _firstPick = index;
      return;
    }

    final first = _firstPick!;
    _firstPick = null;
    if (_patternIds[first] == _patternIds[index]) {
      setState(() => _matched.addAll([first, index]));
      if (_matched.length == _patternIds.length) {
        Future.delayed(const Duration(milliseconds: 400), widget.onSolved);
      }
    } else {
      _busy = true;
      Future.delayed(const Duration(milliseconds: 650), () {
        if (!mounted) return;
        setState(() {
          _revealed.removeAll([first, index]);
          _busy = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Confronta le impronte', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Tocca due tessere per volta: trova le tre coppie di impronte '
          'identiche rilevate sullo scafo della barca.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _patternIds.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final open = _revealed.contains(index) || _matched.contains(index);
            final done = _matched.contains(index);
            return GestureDetector(
              onTap: () => _tap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: done
                      ? AppColors.trustHigh.withValues(alpha: 0.18)
                      : AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: done
                        ? AppColors.trustHigh
                        : open
                            ? AppColors.accentGold
                            : AppColors.surfaceHigh,
                    width: 1.6,
                  ),
                ),
                alignment: Alignment.center,
                child: open
                    ? CustomPaint(
                        size: const Size(48, 48),
                        painter: _FingerprintPainter(
                          seed: _patternIds[index],
                          color: done ? AppColors.trustHigh : AppColors.accentGold,
                        ),
                      )
                    : const Icon(Icons.fingerprint, color: AppColors.textMuted, size: 28),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Disegna un pattern circolare pseudo-impronta, distinto e riconoscibile
/// in base al [seed] (0, 1 o 2).
class _FingerprintPainter extends CustomPainter {
  final int seed;
  final Color color;

  const _FingerprintPainter({required this.seed, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rings = 3 + seed;
    for (int i = 1; i <= rings; i++) {
      final radius = (size.width / 2) * (i / rings);
      final sweep = math.pi * (1.2 + 0.3 * ((seed + i) % 3));
      final start = (seed * 0.7) + i * 0.4;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FingerprintPainter oldDelegate) =>
      oldDelegate.seed != seed || oldDelegate.color != color;
}
