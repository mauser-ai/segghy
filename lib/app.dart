import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';

/// Widget radice dell'applicazione: applica il tema dark mystery globale e
/// collega la configurazione di navigazione (GoRouter) ricevuta da main().
class SegghyApp extends StatelessWidget {
  final GoRouter router;

  const SegghyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SegghysWood',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: router,
      builder: (context, child) {
        // Alcune schermate (codice a 4 cifre, ritratti) usano dimensioni
        // fisse pensate per la scala di sistema normale: se il dispositivo
        // ha il testo grande attivato nelle impostazioni di accessibilità,
        // limitiamo comunque l'ingrandimento per evitare che vadano in
        // overflow, pur restando leggermente più leggibili del minimo.
        final mediaQuery = MediaQuery.of(context);
        final clampedScaler = mediaQuery.textScaler.clamp(
          minScaleFactor: 0.9,
          maxScaleFactor: 1.2,
        );
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: clampedScaler),
          child: child!,
        );
      },
    );
  }
}
