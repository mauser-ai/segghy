import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/text_placeholders.dart';
import '../../core/widgets/atmospheric_background.dart';
import '../../core/widgets/character_portrait.dart';
import '../../core/widgets/staggered_entrance.dart';
import '../../data/mock/characters_data.dart';
import '../../models/ending.dart';
import '../../providers/game_provider.dart';

/// Schermata finale: rivela quale dei quattro finali il giocatore ha
/// ottenuto, con un riepilogo del percorso investigativo compiuto.
class EndingScreen extends StatelessWidget {
  const EndingScreen({super.key});

  Color _colorFor(EndingType type) {
    switch (type) {
      case EndingType.buono:
        return AppColors.trustHigh;
      case EndingType.oscuro:
        return AppColors.textMuted;
      case EndingType.perfetto:
        return AppColors.accentGold;
      case EndingType.erroneo:
        return AppColors.accentBlood;
    }
  }

  IconData _iconFor(EndingType type) {
    switch (type) {
      case EndingType.buono:
        return Icons.wb_sunny_outlined;
      case EndingType.oscuro:
        return Icons.nights_stay_outlined;
      case EndingType.perfetto:
        return Icons.emoji_events_outlined;
      case EndingType.erroneo:
        return Icons.gavel_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final ending = provider.state.finale;

    if (ending == null) {
      // Non dovrebbe accadere (il router reindirizza altrove se non c'è
      // ancora un finale), ma teniamo comunque un'uscita di sicurezza:
      // una schermata senza alcun pulsante sarebbe un vicolo cieco.
      return Scaffold(
        body: AtmosphericBackground(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Nessun finale raggiunto ancora.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/chapters'),
                    icon: const Icon(Icons.menu_book_outlined),
                    label: const Text('TORNA AI CAPITOLI'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final color = _colorFor(ending);

    return Scaffold(
      body: AtmosphericBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 750),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) => Transform.scale(
                    scale: value.clamp(0, 1.4),
                    child: child,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.15),
                      border: Border.all(color: color, width: 1.6),
                      boxShadow: [
                        BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 30,
                            spreadRadius: 4),
                      ],
                    ),
                    child: Icon(_iconFor(ending), color: color, size: 44),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              StaggeredEntrance(
                index: 1,
                child: Center(
                  child: Text(
                    ending.sottotitolo.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: color, letterSpacing: 2),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              StaggeredEntrance(
                index: 2,
                child: Text(
                  ending.titolo,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              const SizedBox(height: 20),
              StaggeredEntrance(
                index: 3,
                child: Text(
                  personalizeText(ending.descrizione, provider),
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.7),
                ),
              ),
              const SizedBox(height: 28),
              StaggeredEntrance(
                index: 4,
                child: _CulpritReveal(
                  ending: ending,
                  accusedName: provider.accusedCharacter?.nome,
                ),
              ),
              const SizedBox(height: 28),
              StaggeredEntrance(
                index: 5,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Riepilogo indagine',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 10),
                        _StatRow(
                          label: 'Indizi raccolti',
                          value:
                              '${provider.collectedClues.length} / ${provider.clues.length}',
                        ),
                        _StatRow(
                          label: 'Capitoli completati',
                          value:
                              '${provider.state.capitoliCompletati.length} / ${provider.chapters.length}',
                        ),
                        _StatRow(
                          label: 'Fiducia di Matteo',
                          value:
                              '${provider.characterWithState('matteo').livelloFiducia}%',
                        ),
                        _StatRow(
                          label: 'Fiducia di Manuela',
                          value:
                              '${provider.characterWithState('manuela').livelloFiducia}%',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              StaggeredEntrance(
                index: 6,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await provider.resetGame();
                    if (context.mounted) context.go('/menu');
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text('NUOVA PARTITA'),
                ),
              ),
              const SizedBox(height: 10),
              StaggeredEntrance(
                index: 7,
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/menu'),
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('MENU PRINCIPALE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rivela esplicitamente chi è la colpevole, con un tocco: prima di
/// premere, il ritratto resta un'ombra senza nome, per non spoilerare nulla
/// a chi sta ancora leggendo il resoconto del finale sopra di essa.
class _CulpritReveal extends StatefulWidget {
  final EndingType ending;
  final String? accusedName;
  const _CulpritReveal({required this.ending, this.accusedName});

  @override
  State<_CulpritReveal> createState() => _CulpritRevealState();
}

class _CulpritRevealState extends State<_CulpritReveal> {
  bool _revealed = false;

  String get _caption {
    switch (widget.ending) {
      case EndingType.perfetto:
        return 'Sandra ha confessato davanti a Matteo: il caso è ufficialmente chiuso.';
      case EndingType.buono:
        return 'Le prove raccolte bastano a farla incriminare, anche senza una confessione piena.';
      case EndingType.oscuro:
        return 'Solo tu, ora, sai la verità. Il fascicolo resterà chiuso come "irrisolto".';
      case EndingType.erroneo:
        final accusato = widget.accusedName ?? 'la persona sbagliata';
        return 'Hai accusato $accusato: il vero colpevole non è mai stato scoperto. '
            'Sandra resta libera, e il caso si chiude senza giustizia.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sandra = characterById('sandra');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('IL COLPEVOLE',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.accentBlood, letterSpacing: 2)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => setState(() => _revealed = true),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: _revealed
                    ? Column(
                        key: const ValueKey('revealed'),
                        children: [
                          CharacterPortrait(
                            id: 'sandra',
                            nome: sandra.nome,
                            imagePath: sandra.immagine,
                            sospettato: true,
                            size: 140,
                          ),
                          const SizedBox(height: 12),
                          Text('Sandra', style: Theme.of(context).textTheme.headlineMedium),
                          Text(sandra.ruolo,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.textMuted)),
                        ],
                      )
                    : Column(
                        key: const ValueKey('hidden'),
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surfaceHigh,
                              border: Border.all(color: AppColors.accentBlood, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.person_search_rounded,
                                size: 56, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 12),
                          Text('Tocca per scoprire chi è stato',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.accentGold)),
                        ],
                      ),
              ),
            ),
            if (_revealed) ...[
              const SizedBox(height: 14),
              Text(
                _caption,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textMuted)),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
