import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/scene_backgrounds.dart';
import '../../core/widgets/clue_found_snackbar.dart';
import '../../core/widgets/return_to_menu_button.dart';
import '../../core/widgets/scene_background.dart';
import '../../data/mock/clues_data.dart';
import '../../models/minigame_type.dart';
import '../../providers/game_provider.dart';
import 'fingerprint_match_minigame.dart';
import 'map_analysis_minigame.dart';
import 'phone_unlock_minigame.dart';
import 'timeline_minigame.dart';

/// Schermata che ospita il minigioco investigativo agganciato alla scena
/// corrente. Risolverlo sblocca l'indizio collegato e riporta alla
/// narrazione, dove ora è possibile proseguire verso il dialogo.
class MinigameScreen extends StatefulWidget {
  const MinigameScreen({super.key});

  @override
  State<MinigameScreen> createState() => _MinigameScreenState();
}

class _MinigameScreenState extends State<MinigameScreen> {
  bool _solving = false;

  Future<void> _handleSolved(String sceneId, String? clueId) async {
    if (_solving) return;
    _solving = true;
    final provider = context.read<GameProvider>();
    await provider.completeMinigame(sceneId, clueId: clueId);
    if (!mounted) return;
    if (clueId != null) {
      showClueFoundSnackBar(context, clueById(clueId));
    }
    context.go('/narrative');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final scene = provider.currentScene;
    final chapter = provider.currentChapter;
    final tipo = scene.minigioco;

    return Scaffold(
      appBar: AppBar(
        leading: const ReturnToMenuButton(),
        title: const Text('Indagine'),
      ),
      body: SceneBackground(
        type: backgroundForChapter(chapter.id),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: tipo == null
                ? const Text('Nessun minigioco disponibile qui.')
                : switch (tipo) {
                    MinigameType.sbloccoTelefono => PhoneUnlockMinigame(
                        onSolved: () => _handleSolved(scene.id, scene.indizioMinigioco),
                      ),
                    MinigameType.confrontoImpronte => FingerprintMatchMinigame(
                        onSolved: () => _handleSolved(scene.id, scene.indizioMinigioco),
                      ),
                    MinigameType.analisiMappa => MapAnalysisMinigame(
                        onSolved: () => _handleSolved(scene.id, scene.indizioMinigioco),
                      ),
                    MinigameType.ricostruzioneTimeline => TimelineMinigame(
                        onSolved: () => _handleSolved(scene.id, scene.indizioMinigioco),
                      ),
                  },
          ),
        ),
      ),
    );
  }
}
