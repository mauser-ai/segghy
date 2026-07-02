import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/router/app_router.dart';
import 'providers/game_provider.dart';

void main() {
  // Un'unica istanza di GameProvider è condivisa sia dall'albero widget
  // (per la UI reattiva) sia dal router (per proteggere le rotte di gioco
  // da avvii "a freddo", vedi app_router.dart).
  final gameProvider = GameProvider();

  runApp(
    ChangeNotifierProvider.value(
      value: gameProvider,
      child: SegghyApp(router: createAppRouter(gameProvider)),
    ),
  );
}
