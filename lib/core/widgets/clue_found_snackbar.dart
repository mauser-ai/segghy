import 'package:flutter/material.dart';

import '../../models/clue.dart';
import '../theme/app_colors.dart';

/// Notifica visiva mostrata quando il giocatore trova un nuovo indizio.
void showClueFoundSnackBar(BuildContext context, Clue clue) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.surfaceHigh,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.accentGold, width: 1),
      ),
      duration: const Duration(seconds: 3),
      content: Row(
        children: [
          const Icon(Icons.search, color: AppColors.accentGold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nuovo indizio trovato',
                  style: TextStyle(
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  clue.titolo,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
