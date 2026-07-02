// Smoke test: verifica che l'app si avvii mostrando la splash screen con il
// titolo del gioco, senza eccezioni durante il primo frame.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:segghy_ticino/app.dart';
import 'package:segghy_ticino/core/router/app_router.dart';
import 'package:segghy_ticino/providers/game_provider.dart';

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

    expect(find.text('SEGGHY'), findsOneWidget);
  });
}
