import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Intestazione di sezione riutilizzabile: titolo in stile "mystery" con
/// una linea dorata decorativa sotto.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.accentGold, size: 22),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
            ),
          ],
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
          ),
        const SizedBox(height: 10),
        Container(
          height: 2,
          width: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.accentGold, AppColors.accentGold.withValues(alpha: 0)],
            ),
          ),
        ),
      ],
    );
  }
}
