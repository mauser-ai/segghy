import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Sfondo atmosferico riutilizzato in tutte le schermate: gradiente notturno
/// più due aloni sfumati (nebbia del Ticino) per dare profondità senza
/// bisogno di asset immagine.
class AtmosphericBackground extends StatelessWidget {
  final Widget child;

  const AtmosphericBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: _Glow(color: AppColors.riverMist.withValues(alpha: 0.35)),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: _Glow(color: AppColors.accentGold.withValues(alpha: 0.08)),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  const _Glow({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}
