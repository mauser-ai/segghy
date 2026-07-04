import 'package:go_router/go_router.dart';

import '../../providers/game_provider.dart';
import '../../screens/accusation/accusation_screen.dart';
import '../../screens/chapter_select/chapter_select_screen.dart';
import 'page_transitions.dart';
import '../../screens/characters/characters_screen.dart';
import '../../screens/dialogue/dialogue_screen.dart';
import '../../screens/ending/ending_screen.dart';
import '../../screens/escape_room/escape_room_screen.dart';
import '../../screens/inventory/inventory_screen.dart';
import '../../screens/map/map_screen.dart';
import '../../screens/menu/main_menu_screen.dart';
import '../../screens/minigame/minigame_screen.dart';
import '../../screens/narrative/narrative_screen.dart';
import '../../screens/new_game/continue_game_screen.dart';
import '../../screens/new_game/new_game_screen.dart';
import '../../screens/splash/splash_screen.dart';

/// Rotte che presuppongono una partita già caricata in memoria (leggono
/// [GameProvider.currentScene]/[GameProvider.currentChapter]). Se l'utente
/// vi arriva "a freddo" — refresh del browser, link diretto, tab riaperta —
/// il [GameProvider] è appena stato ricreato e non ha ancora nessuno stato:
/// senza una guardia qui l'app andrebbe in crash (schermata vuota).
const Set<String> _gameRoutes = {
  '/narrative',
  '/dialogue',
  '/minigame',
  '/accusation',
  '/inventory',
  '/map',
  '/characters',
  '/chapters',
  '/ending',
  '/escape-room',
};

/// Costruisce la configurazione delle rotte (Navigator 2.0 via GoRouter),
/// collegata a un'unica istanza di [GameProvider] così da poter proteggere
/// le rotte di gioco con un redirect asincrono in caso di avvio "a freddo".
GoRouter createAppRouter(GameProvider provider) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) async {
      final location = state.matchedLocation;
      // La splash screen gestisce da sé il proprio bootstrap e la propria
      // animazione: non intercettarla qui.
      if (location == '/splash') return null;

      if (provider.loading) {
        await provider.init();
      }

      if (_gameRoutes.contains(location) &&
          provider.state.capitoloCorrenteId.isEmpty) {
        if (provider.hasSavedGame) {
          final loaded = await provider.loadSavedGame();
          if (!loaded) return '/menu';
        } else {
          return '/menu';
        }
      }

      // La schermata del finale ha senso solo se un finale è stato
      // davvero raggiunto: altrimenti sarebbe un vicolo cieco senza
      // pulsanti utili, il che "blocca" il giocatore.
      if (location == '/ending' && provider.state.finale == null) {
        return '/chapters';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) =>
            buildFadeThroughPage(key: state.pageKey, child: const SplashScreen()),
      ),
      GoRoute(
        path: '/menu',
        pageBuilder: (context, state) =>
            buildFadeThroughPage(key: state.pageKey, child: const MainMenuScreen()),
      ),
      GoRoute(
        path: '/new-game',
        pageBuilder: (context, state) =>
            buildFadeThroughPage(key: state.pageKey, child: const NewGameScreen()),
      ),
      GoRoute(
        path: '/continue',
        pageBuilder: (context, state) => buildFadeThroughPage(
            key: state.pageKey, child: const ContinueGameScreen()),
      ),
      GoRoute(
        path: '/chapters',
        pageBuilder: (context, state) => buildFadeThroughPage(
            key: state.pageKey, child: const ChapterSelectScreen()),
      ),
      GoRoute(
        path: '/narrative',
        pageBuilder: (context, state) =>
            buildFadeThroughPage(key: state.pageKey, child: const NarrativeScreen()),
      ),
      GoRoute(
        path: '/dialogue',
        pageBuilder: (context, state) =>
            buildFadeThroughPage(key: state.pageKey, child: const DialogueScreen()),
      ),
      GoRoute(
        path: '/minigame',
        pageBuilder: (context, state) =>
            buildFadeThroughPage(key: state.pageKey, child: const MinigameScreen()),
      ),
      GoRoute(
        path: '/accusation',
        pageBuilder: (context, state) =>
            buildFadeThroughPage(key: state.pageKey, child: const AccusationScreen()),
      ),
      GoRoute(
        path: '/inventory',
        pageBuilder: (context, state) =>
            buildFadeThroughPage(key: state.pageKey, child: const InventoryScreen()),
      ),
      GoRoute(
        path: '/map',
        pageBuilder: (context, state) =>
            buildFadeThroughPage(key: state.pageKey, child: const MapScreen()),
      ),
      GoRoute(
        path: '/characters',
        pageBuilder: (context, state) => buildFadeThroughPage(
            key: state.pageKey, child: const CharactersScreen()),
      ),
      GoRoute(
        path: '/ending',
        pageBuilder: (context, state) =>
            buildFadeThroughPage(key: state.pageKey, child: const EndingScreen()),
      ),
      GoRoute(
        path: '/escape-room',
        pageBuilder: (context, state) =>
            buildFadeThroughPage(key: state.pageKey, child: const EscapeRoomScreen()),
      ),
    ],
  );
}
