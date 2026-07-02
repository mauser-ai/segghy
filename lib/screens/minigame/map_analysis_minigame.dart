import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Minigioco: confrontare la mappa originale di Sofia con la copia
/// alterata trovata tra gli effetti di Mauro, e individuare i 3 punti che
/// sono stati spostati rispetto all'originale. A differenza di una scelta
/// alla cieca, qui la mappa di riferimento è sempre visibile: va davvero
/// confrontata punto per punto.
class MapAnalysisMinigame extends StatefulWidget {
  final VoidCallback onSolved;

  const MapAnalysisMinigame({super.key, required this.onSolved});

  @override
  State<MapAnalysisMinigame> createState() => _MapAnalysisMinigameState();
}

class _MapAnalysisMinigameState extends State<MapAnalysisMinigame> {
  static const int _gridSize = 6;
  static const List<Offset> _originali = [
    Offset(0.15, 0.18),
    Offset(0.50, 0.15),
    Offset(0.82, 0.28),
    Offset(0.28, 0.45),
    Offset(0.68, 0.48),
    Offset(0.15, 0.75),
    Offset(0.50, 0.80),
    Offset(0.85, 0.72),
  ];

  late final List<Offset> _copia;
  late final List<int> _alterati;
  final Set<int> _selezionati = {};
  String? _messaggio;

  @override
  void initState() {
    super.initState();
    final rnd = math.Random(DateTime.now().millisecond);
    final indices = List.generate(_originali.length, (i) => i)..shuffle(rnd);
    _alterati = indices.take(3).toList();

    final cell = 1 / _gridSize;
    _copia = List.generate(_originali.length, (i) {
      if (!_alterati.contains(i)) return _originali[i];
      // Sposta il punto di almeno una cella intera, in una direzione
      // casuale, restando dentro i margini della mappa.
      final dx = rnd.nextBool() ? cell : -cell;
      final dy = rnd.nextBool() ? cell : -cell;
      final nx = (_originali[i].dx + dx).clamp(0.08, 0.92);
      final ny = (_originali[i].dy + dy).clamp(0.08, 0.92);
      return Offset(nx, ny);
    });
  }

  void _toggle(int index) {
    setState(() {
      _messaggio = null;
      if (_selezionati.contains(index)) {
        _selezionati.remove(index);
      } else if (_selezionati.length < 3) {
        _selezionati.add(index);
      }
    });
  }

  void _confirm() {
    final corretto = _selezionati.length == 3 &&
        _selezionati.every(_alterati.contains);
    if (corretto) {
      widget.onSolved();
    } else {
      setState(() {
        _messaggio = 'Non corrisponde ancora alla mappa originale. Confronta di nuovo i punti.';
        _selezionati.clear();
      });
    }
  }

  Widget _buildMap({
    required List<Offset> points,
    required bool interactive,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(interactive ? 16 : 10),
        border: Border.all(
          color: interactive ? AppColors.surfaceVariant : AppColors.accentGold.withValues(alpha: 0.5),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _GridPainter(_gridSize))),
              for (int i = 0; i < points.length; i++)
                Positioned(
                  left: points[i].dx * constraints.maxWidth - (interactive ? 16 : 9),
                  top: points[i].dy * constraints.maxHeight - (interactive ? 16 : 9),
                  child: interactive
                      ? GestureDetector(
                          onTap: () => _toggle(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selezionati.contains(i)
                                  ? AppColors.accentBlood.withValues(alpha: 0.85)
                                  : AppColors.accentGold.withValues(alpha: 0.75),
                              border: Border.all(color: Colors.white, width: 1.4),
                            ),
                            alignment: Alignment.center,
                            child: Text('${i + 1}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                      : Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accentTeal.withValues(alpha: 0.85),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: Text('${i + 1}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold)),
                        ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Analizza la mappa', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'A sinistra la mappa originale di Sofia, a destra la copia trovata '
          'da Mauro: confronta i punti e tocca sulla copia i 3 numeri che '
          'sono stati spostati rispetto all\'originale.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text('ORIGINALE',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.accentTeal, fontSize: 11)),
                  const SizedBox(height: 6),
                  AspectRatio(
                    aspectRatio: 1,
                    child: LayoutBuilder(
                      builder: (context, c) => _buildMap(
                        points: _originali,
                        interactive: false,
                        size: c.maxWidth,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text('COPIA DI MAURO',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.accentGold, fontSize: 11)),
                  const SizedBox(height: 6),
                  AspectRatio(
                    aspectRatio: 1,
                    child: LayoutBuilder(
                      builder: (context, c) => _buildMap(
                        points: _copia,
                        interactive: true,
                        size: c.maxWidth,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 32,
          child: Text(
            _messaggio ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.accentBlood, fontSize: 13),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _selezionati.length == 3 ? _confirm : null,
          icon: const Icon(Icons.check_circle_outline),
          label: Text('CONFERMA (${_selezionati.length}/3)'),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  final int gridSize;
  const _GridPainter(this.gridSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textMuted.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    for (int i = 0; i <= gridSize; i++) {
      final x = size.width * i / gridSize;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      final y = size.height * i / gridSize;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}
