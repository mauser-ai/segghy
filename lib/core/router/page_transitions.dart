import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Transizione condivisa tra tutte le schermate: una dissolvenza pulita e
/// rapida, più cinematografica dello scambio a scatto di default di
/// GoRouter. Deliberatamente semplice (nessuno slide/offset): un fade puro
/// e breve riduce la finestra in cui un frame intermedio potrebbe mostrare
/// contenuto non ancora aggiornato, ed evita di sovrapporre due animazioni
/// (questa più quella interna di alcune schermate) che insieme potevano
/// dare una sensazione di "salto"/ricaricamento durante il passaggio.
CustomTransitionPage<void> buildFadeThroughPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}
