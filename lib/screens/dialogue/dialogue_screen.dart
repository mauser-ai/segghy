import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/scene_backgrounds.dart';
import '../../core/widgets/character_avatar.dart' show colorForId;
import '../../core/widgets/character_portrait.dart';
import '../../core/widgets/scene_background.dart';
import '../../core/widgets/staggered_entrance.dart';
import '../../core/widgets/typewriter_text.dart';
import '../../data/mock/characters_data.dart';
import '../../models/character.dart';
import '../../models/choice.dart';
import '../../providers/game_provider.dart';

/// Schermata di dialogo interattivo, in stile "visual novel" (macchina da
/// scrivere alla Pokémon, ritratti cinematografici e scelte animate alla
/// Duskwood): mostra le battute della scena corrente una alla volta, poi le
/// scelte a disposizione del giocatore.
class DialogueScreen extends StatefulWidget {
  const DialogueScreen({super.key});

  @override
  State<DialogueScreen> createState() => _DialogueScreenState();
}

class _DialogueScreenState extends State<DialogueScreen> {
  int _lineIndex = 0;
  bool _submitting = false;
  final _typewriter = TypewriterController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startCurrentLine());
  }

  @override
  void dispose() {
    _typewriter.dispose();
    super.dispose();
  }

  void _startCurrentLine() {
    final scene = context.read<GameProvider>().currentScene;
    if (_lineIndex >= scene.dialoghi.length) return;
    _typewriter.start(scene.dialoghi[_lineIndex].testo);
  }

  void _handleTap(int dialogueCount) {
    if (_submitting) return;
    if (!_typewriter.isDone) {
      _typewriter.skipToEnd();
      return;
    }
    if (_lineIndex < dialogueCount - 1) {
      setState(() => _lineIndex++);
      _startCurrentLine();
    } else if (_lineIndex < dialogueCount) {
      // Ultima battuta letta: passa alla schermata delle scelte.
      setState(() => _lineIndex++);
    }
  }

  Future<void> _handleChoice(Choice choice) async {
    if (_submitting) return;
    setState(() => _submitting = true);
    final provider = context.read<GameProvider>();
    await provider.selectChoice(choice);
    if (!mounted) return;
    final nextScene = provider.currentScene;
    if (nextScene.endingId != null) {
      context.go('/ending');
    } else {
      context.go('/narrative');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final scene = provider.currentScene;
    final dialoghi = scene.dialoghi;
    final showChoices = _lineIndex >= dialoghi.length;

    return Scaffold(
      body: SceneBackground(
        type: backgroundForChapter(provider.currentChapter.id),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: showChoices ? null : () => _handleTap(dialoghi.length),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.textMuted,
                      onPressed: () => context.go('/narrative'),
                    ),
                    const Spacer(),
                    if (!showChoices && dialoghi.isNotEmpty)
                      Text(
                        '${_lineIndex + 1} / ${dialoghi.length}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.textMuted, fontSize: 12),
                      ),
                  ],
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    child: showChoices
                        ? _ChoicesView(
                            key: const ValueKey('choices'),
                            choices: scene.scelte,
                            submitting: _submitting,
                            onSelect: _handleChoice,
                          )
                        : _SpeakerView(
                            key: ValueKey('line_$_lineIndex'),
                            personaggioId: dialoghi[_lineIndex].personaggioId,
                            nome: dialoghi[_lineIndex].nomeVisualizzato,
                          ),
                  ),
                ),
                if (!showChoices && dialoghi.isNotEmpty)
                  _DialogueTextBox(
                    nome: dialoghi[_lineIndex].nomeVisualizzato,
                    personaggioId: dialoghi[_lineIndex].personaggioId,
                    typewriter: _typewriter,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Ritratto grande del personaggio che sta parlando, con entrata animata
/// (dissolvenza + scivolata + leggero "pop") ogni volta che cambia battuta.
class _SpeakerView extends StatelessWidget {
  final String personaggioId;
  final String nome;

  const _SpeakerView({super.key, required this.personaggioId, required this.nome});

  Character? get _character {
    try {
      return characterById(personaggioId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final character = _character;
    return TweenAnimationBuilder<double>(
      key: ValueKey(personaggioId),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0, 1),
          child: Transform.scale(scale: 0.85 + (0.15 * value.clamp(0, 1)), child: child),
        );
      },
      child: Center(
        child: CharacterPortrait(
          id: personaggioId,
          nome: nome,
          sospettato: character?.sospettato ?? false,
          imagePath: character?.immagine,
          size: 190,
        ),
      ),
    );
  }
}

/// Il box di testo in basso, in stile visual novel: nameplate sporgente,
/// testo rivelato con effetto macchina da scrivere e indicatore lampeggiante
/// quando la battuta è finita di comparire.
class _DialogueTextBox extends StatelessWidget {
  final String nome;
  final String personaggioId;
  final TypewriterController typewriter;

  const _DialogueTextBox({
    required this.nome,
    required this.personaggioId,
    required this.typewriter,
  });

  @override
  Widget build(BuildContext context) {
    final color = colorForId(personaggioId);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 132),
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 18),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.8), width: 1.6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TypewriterText(
                controller: typewriter,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: ListenableBuilder(
                  listenable: typewriter,
                  builder: (context, _) => AnimatedOpacity(
                    opacity: typewriter.isDone ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const _BlinkingChevron(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -2,
          left: 18,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 10),
              ],
            ),
            child: Text(
              nome,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Piccola freccia lampeggiante che invita a toccare per proseguire, come
/// nei dialoghi dei giochi Pokémon.
class _BlinkingChevron extends StatefulWidget {
  const _BlinkingChevron();

  @override
  State<_BlinkingChevron> createState() => _BlinkingChevronState();
}

class _BlinkingChevronState extends State<_BlinkingChevron>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1).animate(_controller),
      child: const Icon(Icons.keyboard_double_arrow_down_rounded,
          color: AppColors.accentGold, size: 22),
    );
  }
}

class _ChoicesView extends StatelessWidget {
  final List<Choice> choices;
  final bool submitting;
  final ValueChanged<Choice> onSelect;

  const _ChoicesView({
    super.key,
    required this.choices,
    required this.submitting,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (choices.isEmpty) {
      // Caso limite difensivo (non dovrebbe verificarsi con i dati
      // validati): nessuna scelta disponibile, si torna alla narrativa.
      // Usa go() e non un pop() di Navigator, perché questa schermata
      // viene raggiunta con go() e non ha nulla da "poppare" nello stack.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!submitting) GoRouter.of(context).go('/narrative');
      });
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: CharacterPortrait(
            id: 'segghy',
            nome: 'Segghy',
            imagePath: characterById('segghy').immagine,
            size: 108,
          ),
        ),
        const SizedBox(height: 18),
        Text('Cosa fa Segghy?', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          'Ogni scelta può cambiare la fiducia dei personaggi coinvolti.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: ListView.separated(
            itemCount: choices.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final choice = choices[index];
              return StaggeredEntrance(
                index: index,
                child: _ChoiceCard(
                  choice: choice,
                  enabled: !submitting,
                  onTap: () => onSelect(choice),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ChoiceCard extends StatefulWidget {
  final Choice choice;
  final bool enabled;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.choice,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_ChoiceCard> createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<_ChoiceCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: widget.enabled ? (_) => setState(() => _pressed = false) : null,
      onTap: widget.enabled ? widget.onTap : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _pressed ? AppColors.accentGold : AppColors.surfaceHigh,
              width: 1.4,
            ),
            boxShadow: _pressed
                ? [
                    BoxShadow(
                      color: AppColors.accentGold.withValues(alpha: 0.3),
                      blurRadius: 16,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              const Icon(Icons.chevron_right, color: AppColors.accentGold),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.choice.testoScelta,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
