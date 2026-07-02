import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Minigioco: individuare, tra i punti segnati sulla mappa archeologica, i
/// tre le cui coordinate sono state alterate da Alessandra rispetto alla
/// copia originale mostrata come riferimento.
class MapAnalysisMinigame extends StatefulWidget {
  final VoidCallback onSolved;

  const MapAnalysisMinigame({super.key, required this.onSolved});

  @override
  State<MapAnalysisMinigame> createState() => _MapAnalysisMinigameState();
}

class _MapAnalysisMinigameState extends State<MapAnalysisMinigame> {
  static const List<Offset> _positions = [
    Offset(0.18, 0.20),
    Offset(0.55, 0.15),
    Offset(0.82, 0.30),
    Offset(0.30, 0.45),
    Offset(0.65, 0.48),
    Offset(0.15, 0.72),
    Offset(0.48, 0.78),
    Offset(0.85, 0.75),
  ];

  late final List<int> _alterati;
  final Set<int> _selezionati = {};
  String? _messaggio;

  @override
  void initState() {
    super.initState();
    final indices = List.generate(_positions.length, (i) => i)
      ..shuffle(math.Random(DateTime.now().millisecond));
    _alterati = indices.take(3).toList();
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
        _messaggio = 'Non corrisponde ancora alla mappa originale. Riprova.';
        _selezionati.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Analizza la mappa', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Confrontando a memoria la copia di Mauro con quella originale di '
          'Sofia, tocca i 3 punti le cui coordinate non coincidono.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        AspectRatio(
          aspectRatio: 1.1,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceVariant),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: _GridPainter()),
                    ),
                    for (int i = 0; i < _positions.length; i++)
                      Positioned(
                        left: _positions[i].dx * constraints.maxWidth - 16,
                        top: _positions[i].dy * constraints.maxHeight - 16,
                        child: GestureDetector(
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
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 20,
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
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textMuted.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    for (double x = 0; x <= size.width; x += size.width / 8) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += size.height / 8) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
