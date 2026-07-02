import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

/// Bottone "torna al menu principale" condiviso da tutte le schermate di
/// gioco. Senza questo pulsante, una volta entrati in partita non c'era
/// alcun modo di tornare al menu: GoRouter sostituisce lo stack di
/// navigazione ad ogni `go()`, quindi l'AppBar non mostra mai una freccia
/// "indietro" automatica durante il gioco.
class ReturnToMenuButton extends StatelessWidget {
  const ReturnToMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Menu principale',
      icon: const Icon(Icons.home_outlined),
      onPressed: () => confirmReturnToMenu(context),
    );
  }
}

/// Mostra una conferma prima di tornare al menu. La partita è comunque già
/// salvata automaticamente ad ogni scelta, quindi qui rassicuriamo solo il
/// giocatore invece di bloccare un'azione potenzialmente distruttiva.
Future<void> confirmReturnToMenu(BuildContext context) async {
  final shouldLeave = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surfaceHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Tornare al menu?'),
      content: Text(
        'La partita è già salvata automaticamente: potrai riprendere '
        'esattamente da qui.',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('ANNULLA'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('VAI AL MENU'),
        ),
      ],
    ),
  );
  if (shouldLeave == true && context.mounted) {
    context.go('/menu');
  }
}
