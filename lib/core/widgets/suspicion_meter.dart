import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Barra di progresso animata che visualizza quanto le prove raccolte
/// puntano verso un personaggio come possibile colpevole (0-100). A
/// differenza della fiducia, qui un valore alto è un campanello d'allarme:
/// la barra si anima morbidamente ogni volta che il sospetto cambia, per
/// dare risalto visivo all'evoluzione dell'indagine.
class SuspicionMeter extends StatelessWidget {
  final int livello;
  final bool showLabel;

  const SuspicionMeter({
    super.key,
    required this.livello,
    this.showLabel = true,
  });

  Color _colorFor(int value) {
    if (value >= 66) return AppColors.accentBlood;
    if (value >= 33) return const Color(0xFFC97A4B);
    return AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    final clamped = livello.clamp(0, 100);
    final color = _colorFor(clamped);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.visibility_outlined, size: 14, color: color),
                    const SizedBox(width: 4),
                    Text('Sospetto', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: clamped.toDouble()),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) => Text(
                    '${value.round()}%',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: color),
                  ),
                ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: clamped / 100),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}
