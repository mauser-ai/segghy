import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Palette stabile usata per generare un colore coerente per ogni
/// personaggio a partire dal suo id, senza dover gestire asset immagine.
const List<Color> _avatarPalette = [
  Color(0xFF6B4C93),
  Color(0xFF3E8E86),
  Color(0xFFC9A24B),
  Color(0xFF9C4444),
  Color(0xFF4E6E9E),
  Color(0xFF7A9E4E),
  Color(0xFFB56B45),
  Color(0xFF4E9E8B),
];

Color colorForId(String id) {
  final hash = id.codeUnits.fold<int>(0, (acc, c) => acc + c);
  return _avatarPalette[hash % _avatarPalette.length];
}

/// Avatar circolare del personaggio: mostra la foto reale quando
/// disponibile (ritagliata a cerchio), altrimenti ricade su iniziali
/// colorate in modo deterministico a partire dal suo id.
class CharacterAvatar extends StatelessWidget {
  final String nome;
  final String id;
  final double radius;
  final bool sospettato;
  final String? imagePath;

  const CharacterAvatar({
    super.key,
    required this.nome,
    required this.id,
    this.radius = 28,
    this.sospettato = false,
    this.imagePath,
  });

  String get _initials {
    final parts = nome.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final color = colorForId(id);
    final diameter = radius * 2;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: sospettato
            ? Border.all(color: AppColors.accentBlood, width: 2)
            : Border.all(color: AppColors.surfaceHigh, width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: imagePath == null
          ? CircleAvatar(
              radius: radius,
              backgroundColor: color.withValues(alpha: 0.85),
              child: Text(
                _initials,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: radius * 0.7,
                ),
              ),
            )
          : ClipOval(
              child: Container(
                width: diameter,
                height: diameter,
                color: color.withValues(alpha: 0.85),
                child: Image.asset(
                  imagePath!,
                  width: diameter,
                  height: diameter,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.4),
                ),
              ),
            ),
    );
  }
}
