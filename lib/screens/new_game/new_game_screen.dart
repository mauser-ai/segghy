import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/atmospheric_background.dart';
import '../../providers/game_provider.dart';

/// Schermata di apertura di una nuova partita: presenta la premessa della
/// storia prima di far scegliere al giocatore di iniziare l'indagine.
/// Se una partita è già salvata, avvisa che verrà sovrascritta.
class NewGameScreen extends StatelessWidget {
  const NewGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/menu')),
        title: const Text('Nuova partita'),
      ),
      body: AtmosphericBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Golasecca, fine settembre',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Text(
                'Segghy è cresciuta tra le stradine tranquille del paese e i '
                'sentieri lungo il Ticino. Lavora al maneggio di Manuela, '
                'dove si prende cura dei cavalli e di una cucciolata di '
                'gattini.\n\n'
                'Durante una festa privata, Mauro viene trovato morto. '
                'Accanto al corpo, un ciondolo a forma di cavallo identico al '
                'suo. Da quel momento, Segghy diventa la principale '
                'sospettata.\n\n'
                'Dovrai aiutarla a raccogliere indizi, decidere di chi '
                'fidarti ed esplorare Golasecca e i paesi limitrofi per '
                'scoprire la verità, prima che sia lei a pagarne le '
                'conseguenze.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              if (provider.hasSavedGame)
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlood.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accentBlood),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: AppColors.accentBlood),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Esiste già una partita salvata. Iniziandone una '
                          'nuova, verrà sovrascritta.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ElevatedButton.icon(
                onPressed: () async {
                  await provider.startNewGame();
                  if (context.mounted) context.go('/narrative');
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text("INIZIA L'INDAGINE"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
