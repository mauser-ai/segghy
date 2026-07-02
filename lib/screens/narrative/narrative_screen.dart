import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/scene_backgrounds.dart';
import '../../core/widgets/clue_found_snackbar.dart';
import '../../core/widgets/phone_message_overlay.dart';
import '../../core/widgets/return_to_menu_button.dart';
import '../../core/widgets/scene_background.dart';
import '../../providers/game_provider.dart';

/// Schermata narrativa: mostra il testo descrittivo della scena corrente,
/// con una dissolvenza in entrata ad ogni cambio scena. Da qui si prosegue
/// verso i dialoghi interattivi (se presenti) oppure, per le scene di
/// chiusura capitolo, si torna alla selezione capitoli o si passa alla
/// schermata del finale.
class NarrativeScreen extends StatefulWidget {
  const NarrativeScreen({super.key});

  @override
  State<NarrativeScreen> createState() => _NarrativeScreenState();
}

class _NarrativeScreenState extends State<NarrativeScreen> {
  // GoRouter riusa la stessa Route (e quindi lo stesso State) ogni volta che
  // si torna su '/narrative' con lo stesso path: initState() perciò NON
  // rifire ad ogni cambio scena. Per intercettare in modo affidabile "sono
  // entrata in una scena nuova" confrontiamo l'id della scena dentro build()
  // invece di affidarci a initState().
  String? _lastProcessedSceneId;

  void _processSceneEntry(String sceneId) {
    if (_lastProcessedSceneId == sceneId) return;
    _lastProcessedSceneId = sceneId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final provider = context.read<GameProvider>();
      for (final clue in provider.clueJustFoundInCurrentScene) {
        if (!mounted) return;
        showClueFoundSnackBar(context, clue);
      }
      final messaggio = provider.currentScene.messaggioAnonimo;
      if (messaggio != null) {
        await Future.delayed(const Duration(milliseconds: 1400));
        if (mounted) showAnonymousMessage(context, messaggio);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final scene = provider.currentScene;
    final chapter = provider.currentChapter;
    _processSceneEntry(scene.id);

    final minigiocoDaRisolvere =
        scene.minigioco != null && !provider.isMinigameCompleted(scene.id);
    final hasNext = scene.dialoghi.isNotEmpty || scene.scelte.isNotEmpty;
    final isEnding = scene.isFinaleCapitolo && scene.endingId != null;
    final isChapterEnd = scene.isFinaleCapitolo && scene.endingId == null;

    return Scaffold(
      appBar: AppBar(
        leading: const ReturnToMenuButton(),
        title: Text('${chapter.numero}. ${chapter.titolo}'),
        actions: [
          IconButton(
            tooltip: 'Indizi',
            icon: const Icon(Icons.search),
            onPressed: () => context.go('/inventory'),
          ),
          IconButton(
            tooltip: 'Mappa',
            icon: const Icon(Icons.map_outlined),
            onPressed: () => context.go('/map'),
          ),
        ],
      ),
      body: SceneBackground(
        type: backgroundForChapter(chapter.id),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.05),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                          parent: animation, curve: Curves.easeOutCubic)),
                      child: child,
                    ),
                  ),
                  child: SingleChildScrollView(
                    key: ValueKey(scene.id),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.place_outlined,
                                size: 16, color: AppColors.accentGold),
                            const SizedBox(width: 6),
                            Text(scene.luogo,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: AppColors.accentGold,
                                        fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          scene.testoNarrativo,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(height: 1.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (minigiocoDaRisolvere)
                _PulsingButton(
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/minigame'),
                    icon: const Icon(Icons.extension_outlined),
                    label: const Text('INDAGA'),
                  ),
                )
              else if (hasNext)
                _PulsingButton(
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/dialogue'),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('CONTINUA'),
                  ),
                )
              else if (isEnding)
                _PulsingButton(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/ending'),
                    icon: const Icon(Icons.flag_outlined),
                    label: const Text('SCOPRI IL FINALE'),
                  ),
                )
              else if (isChapterEnd)
                OutlinedButton.icon(
                  onPressed: () => context.go('/chapters'),
                  icon: const Icon(Icons.menu_book_outlined),
                  label: const Text('TORNA AI CAPITOLI'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Aggiunge un lieve respiro luminoso al pulsante di azione principale, per
/// invitare il giocatore a proseguire senza essere invadente.
class _PulsingButton extends StatefulWidget {
  final Widget child;
  const _PulsingButton({required this.child});

  @override
  State<_PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<_PulsingButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glow = 0.15 + (_controller.value * 0.25);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentGold.withValues(alpha: glow),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
