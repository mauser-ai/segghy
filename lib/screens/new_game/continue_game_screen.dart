import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/atmospheric_background.dart';
import '../../providers/game_provider.dart';

/// Schermata "Continua partita": mostra un riepilogo del salvataggio
/// (capitolo raggiunto, indizi raccolti) e permette di riprendere.
class ContinueGameScreen extends StatefulWidget {
  const ContinueGameScreen({super.key});

  @override
  State<ContinueGameScreen> createState() => _ContinueGameScreenState();
}

class _ContinueGameScreenState extends State<ContinueGameScreen> {
  late final Future<bool> _loadFuture;

  @override
  void initState() {
    super.initState();
    // Il caricamento va avviato una sola volta: eseguirlo dentro build()
    // (es. come `future:` di un FutureBuilder ricalcolato ad ogni rebuild)
    // innescherebbe un loop, perché loadSavedGame() chiama notifyListeners()
    // e questa schermata osserva il provider con watch().
    _loadFuture = context.read<GameProvider>().loadSavedGame();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/menu')),
        title: const Text('Continua partita'),
      ),
      body: AtmosphericBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.bookmark_outline,
                        color: AppColors.accentGold, size: 32),
                    const SizedBox(height: 12),
                    Text('Salvataggio trovato',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    FutureBuilder<bool>(
                      future: _loadFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState !=
                            ConnectionState.done) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 2)),
                          );
                        }
                        final chapter = provider.state.capitoloCorrenteId
                                .isEmpty
                            ? null
                            : provider.currentChapter;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _InfoRow(
                              label: 'Capitolo',
                              value: chapter == null
                                  ? '—'
                                  : '${chapter.numero}. ${chapter.titolo}',
                            ),
                            _InfoRow(
                              label: 'Indizi raccolti',
                              value: '${provider.collectedClues.length}',
                            ),
                            _InfoRow(
                              label: 'Capitoli completati',
                              value:
                                  '${provider.state.capitoliCompletati.length} / ${provider.chapters.length}',
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () => context.go('/narrative'),
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: const Text('RIPRENDI'),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
