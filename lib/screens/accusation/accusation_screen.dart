import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/scene_backgrounds.dart';
import '../../core/widgets/character_avatar.dart';
import '../../core/widgets/return_to_menu_button.dart';
import '../../core/widgets/scene_background.dart';
import '../../core/widgets/suspicion_meter.dart';
import '../../core/widgets/trust_meter.dart';
import '../../models/character.dart';
import '../../providers/game_provider.dart';

/// Schermata del confronto finale: il giocatore deve scegliere formalmente
/// chi accusare tra tutti i sospettati, guidato da quanto ha scoperto
/// (fiducia e sospetto accumulati per ciascuno). È un'azione irreversibile
/// che determina l'esito della partita: accusare la persona sbagliata
/// porta a un finale dedicato in cui la vera colpevole resta libera.
class AccusationScreen extends StatefulWidget {
  const AccusationScreen({super.key});

  @override
  State<AccusationScreen> createState() => _AccusationScreenState();
}

class _AccusationScreenState extends State<AccusationScreen> {
  String? _selectedId;
  bool _submitting = false;

  Future<void> _confirmAndSubmit(Character suspect) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confermi l\'accusa?'),
        content: Text(
          'Stai per accusare formalmente ${suspect.nome} davanti a tutti. '
          'Non potrai tornare indietro: pensaci bene prima di parlare.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ASPETTA'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentBlood),
            child: const Text('ACCUSO LEI/LUI'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _submitting = true);
    final provider = context.read<GameProvider>();
    await provider.submitAccusation(suspect.id);
    if (!mounted) return;
    context.go('/narrative');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final chapter = provider.currentChapter;

    if (!provider.currentScene.richiedeAccusa) {
      return Scaffold(
        appBar: AppBar(leading: const ReturnToMenuButton(), title: const Text('Accusa')),
        body: SceneBackground(
          type: backgroundForChapter(chapter.id),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Non è ancora il momento di accusare qualcuno.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/narrative'),
                    icon: const Icon(Icons.menu_book_outlined),
                    label: const Text('TORNA ALLA STORIA'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final suspects = provider.suspects;

    return Scaffold(
      appBar: AppBar(
        leading: const ReturnToMenuButton(),
        title: const Text('Il momento della verità'),
      ),
      body: SceneBackground(
        type: backgroundForChapter(chapter.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Chi accusi?', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  Text(
                    'Ripensa a indizi, fiducia e sospetto raccolti finora. '
                    'Puoi scegliere una sola persona.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                itemCount: suspects.length,
                itemBuilder: (context, index) {
                  final suspect = suspects[index];
                  final selected = _selectedId == suspect.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: selected
                          ? AppColors.accentBlood.withValues(alpha: 0.12)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: _submitting
                            ? null
                            : () => setState(() => _selectedId = suspect.id),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? AppColors.accentBlood
                                  : AppColors.surfaceHigh,
                              width: selected ? 1.6 : 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CharacterAvatar(
                                nome: suspect.nome,
                                id: suspect.id,
                                imagePath: suspect.immagine,
                                sospettato: true,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(suspect.nome,
                                            style: Theme.of(context).textTheme.titleMedium),
                                        const Spacer(),
                                        if (selected)
                                          const Icon(Icons.check_circle,
                                              color: AppColors.accentBlood, size: 20),
                                      ],
                                    ),
                                    Text('${suspect.ruolo} · ${suspect.luogo}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(fontSize: 12)),
                                    const SizedBox(height: 10),
                                    TrustMeter(livello: suspect.livelloFiducia),
                                    const SizedBox(height: 8),
                                    SuspicionMeter(
                                        livello: provider.suspicionOf(suspect.id)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: ElevatedButton.icon(
                onPressed: _selectedId == null || _submitting
                    ? null
                    : () => _confirmAndSubmit(
                        suspects.firstWhere((s) => s.id == _selectedId)),
                icon: const Icon(Icons.gavel_outlined),
                label: const Text('FORMULA L\'ACCUSA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
