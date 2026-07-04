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
    );
  }
}
