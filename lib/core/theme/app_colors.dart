import 'package:flutter/material.dart';

/// Palette "dark mystery" del gioco: blu notte profondi, nebbia del Ticino,
/// e un accento ambra/oro per richiamare la luce dei lampioni e i segreti
/// che affiorano.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0B0E14);
  static const Color surface = Color(0xFF141A24);
  static const Color surfaceVariant = Color(0xFF1C2430);
  static const Color surfaceHigh = Color(0xFF232C3A);

  static const Color riverMist = Color(0xFF2E4756);
  static const Color nightBlue = Color(0xFF13202E);

  static const Color accentGold = Color(0xFFC9A24B);
  static const Color accentAmber = Color(0xFFE0B85C);
  static const Color accentBlood = Color(0xFF8A2E2E);
  static const Color accentTeal = Color(0xFF3E8E86);

  static const Color textPrimary = Color(0xFFEDEBE5);
  static const Color textSecondary = Color(0xFFA9B0BC);
  static const Color textMuted = Color(0xFF6C7686);

  static const Color trustHigh = Color(0xFF4E9E6B);
  static const Color trustMid = Color(0xFFC9A24B);
  static const Color trustLow = Color(0xFF9C4444);

  static Color trustColor(int level) {
    if (level >= 66) return trustHigh;
    if (level >= 33) return trustMid;
    return trustLow;
  }

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [nightBlue, background],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceVariant, surface],
  );
}
