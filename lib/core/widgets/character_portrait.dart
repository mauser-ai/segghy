import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'character_avatar.dart' show colorForId;

/// Icona di ruolo mostrata come badge sul ritratto, per dare carattere ad
/// ogni personaggio anche senza illustrazioni vere e proprie.
const Map<String, IconData> _roleIcons = {
  'segghy': Icons.female_rounded,
  'riccardo': Icons.memory_rounded,
  'matteo': Icons.local_police_rounded,
  'kledian': Icons.build_rounded,
  'manuela': Icons.pets_rounded,
  'sandra': Icons.local_cafe_rounded,
  'gaia': Icons.favorite_rounded,
  'anna': Icons.visibility_rounded,
  'sofia': Icons.auto_stories_rounded,
  'adriano': Icons.business_center_rounded,
  'cinzia': Icons.history_edu_rounded,
  'mauro': Icons.help_outline_rounded,
  'moreno': Icons.nightlight_round,
  'alessandra': Icons.brush_rounded,
};

/// Ritratto cinematografico di un personaggio: grande, con lieve movimento
/// di "respiro" continuo (idle animation) tipico dei visual novel, un
/// bagliore colorato coerente col personaggio e un badge con l'icona del
/// suo ruolo nella storia.
class CharacterPortrait extends StatefulWidget {
  final String id;
  final String nome;
  final double size;
  final bool sospettato;
  final String? imagePath;

  const CharacterPortrait({
    super.key,
    required this.id,
    required this.nome,
    this.size = 176,
    this.sospettato = false,
    this.imagePath,
  });

  @override
  State<CharacterPortrait> createState() => _CharacterPortraitState();
}

class _CharacterPortraitState extends State<CharacterPortrait>
    with SingleTickerProviderStateMixin {
  late final AnimationController _idleController;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
    _float = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _idleController.dispose();
    super.dispose();
  }

  String get _initials {
    final parts = widget.nome.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final color = colorForId(widget.id);
    final icon = _roleIcons[widget.id] ?? Icons.person_rounded;

    return AnimatedBuilder(
      animation: _float,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _float.value),
          child: child,
        );
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: 0.95),
                    color.withValues(alpha: 0.55),
                  ],
                ),
                border: Border.all(
                  color: widget.sospettato
                      ? AppColors.accentBlood
                      : AppColors.accentGold.withValues(alpha: 0.7),
                  width: widget.sospettato ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.55),
                    blurRadius: 36,
                    spreadRadius: 4,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: widget.imagePath == null
                  ? Text(
                      _initials,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.size * 0.34,
                      ),
                    )
                  : ClipOval(
                      child: Image.asset(
                        widget.imagePath!,
                        width: widget.size,
                        height: widget.size,
                        fit: BoxFit.cover,
                        alignment: const Alignment(0, -0.4),
                      ),
                    ),
            ),
            Positioned(
              bottom: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.accentGold, width: 1.4),
                ),
                child: Icon(icon, size: 18, color: AppColors.accentGold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
