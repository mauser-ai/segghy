import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/atmospheric_background.dart';
import '../../core/widgets/game_nav_bar.dart';
import '../../core/widgets/return_to_menu_button.dart';
import '../../core/widgets/section_header.dart';
import '../../models/clue.dart';
import '../../providers/game_provider.dart';

/// Inventario delle prove: mostra tutti gli indizi trovati finora, con
/// luogo di ritrovamento e livello di importanza. Gli indizi non ancora
/// scoperti restano offuscati per non spoilerare la trama.
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final clues = provider.clues;
    final found = clues.where((c) => c.trovato).toList();
    final missingCount = clues.length - found.length;

    return Scaffold(
      appBar: AppBar(
        leading: const ReturnToMenuButton(),
        title: const Text('Inventario indizi'),
      ),
      bottomNavigationBar: const GameNavBar(currentIndex: 1),
      body: AtmosphericBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          children: [
            SectionHeader(
              title: 'Le prove raccolte',
              subtitle: '${found.length} trovate · $missingCount ancora da scoprire',
              icon: Icons.search,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: provider.investigationProgress,
              minHeight: 6,
              backgroundColor: AppColors.surfaceVariant,
            ),
            const SizedBox(height: 20),
            if (found.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'Non hai ancora raccolto nessun indizio.\nEsplora i luoghi e parla con i personaggi.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              ...found.map((clue) => _ClueCard(clue: clue)),
          ],
        ),
      ),
    );
  }
}

class _ClueCard extends StatelessWidget {
  final Clue clue;

  const _ClueCard({required this.clue});

  Color get _importanceColor {
    switch (clue.importanza) {
      case ClueImportance.critica:
        return AppColors.accentBlood;
      case ClueImportance.alta:
        return AppColors.accentAmber;
      case ClueImportance.media:
        return AppColors.accentTeal;
      case ClueImportance.bassa:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(clue.titolo,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _importanceColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _importanceColor),
                  ),
                  child: Text(
                    clue.importanza.label,
                    style: TextStyle(
                        color: _importanceColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(clue.descrizione, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.place_outlined,
                    size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(clue.luogo,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
