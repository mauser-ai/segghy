import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Tastierino numerico 0-9 con backspace, riutilizzato da tutti i minigiochi
/// che richiedono l'inserimento di un codice (sblocco telefono, enigma
/// finale...).
class NumericKeypad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  const NumericKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: keys.map((k) {
        if (k.isEmpty) return const SizedBox.shrink();
        return Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => k == '⌫' ? onBackspace() : onDigit(k),
            child: Center(
              child: Text(k, style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
        );
      }).toList(),
    );
  }
}
