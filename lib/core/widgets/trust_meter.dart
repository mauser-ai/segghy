import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Barra di progresso che visualizza il livello di fiducia (0-100) di un
/// personaggio nei confronti di Segghy.
class TrustMeter extends StatelessWidget {
  final int livello;
  final bool showLabel;

  const TrustMeter({super.key, required this.livello, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    final clamped = livello.clamp(0, 100);
    final color = AppColors.trustColor(clamped);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fiducia', style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  '$clamped%',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: color),
                ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: clamped / 100,
            minHeight: 8,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
