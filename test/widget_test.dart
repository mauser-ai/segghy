// Smoke test: verifica che l'app si avvii mostrando la splash screen con il
// titolo del gioco, senza eccezioni durante il primo frame.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:segghyswood/app.dart';
import 'package:segghyswood/core/router/app_router.dart';
import 'package:segghyswood/providers/game_provider.dart';

void main() {
  testWidgets('App avvia mostrando la splash screen', (tester) async {
    final gameProvider = GameProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: gameProvider,
        child: SegghyApp(router: createAppRouter(gameProvider)),
      ),
    );
    await tester.pump();

    expect(find.text('SEGGHYSWOOD'), findsOneWidget);
  });
}
