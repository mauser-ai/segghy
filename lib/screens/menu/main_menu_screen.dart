import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/atmospheric_background.dart';
import '../../core/widgets/staggered_entrance.dart';
import '../../providers/game_provider.dart';

/// Menu principale: nuova partita, continua partita (se esiste un
/// salvataggio) e breve nota sul gioco.
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Scaffold(
      body: AtmosphericBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StaggeredEntrance(
                index: 0,
                child: Icon(Icons.water_drop_outlined,
                    size: 40, color: AppColors.accentGold),
              ),
              const SizedBox(height: 16),
              StaggeredEntrance(
                index: 1,
                child: Text(
                  'Segghy e il\nSilenzio del Ticino',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              const SizedBox(height: 8),
              StaggeredEntrance(
                index: 2,
                child: Text(
                  'Un giallo investigativo lungo il fiume',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 56),
              StaggeredEntrance(
                index: 3,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/new-game'),
                  icon: const Icon(Icons.auto_stories_outlined),
                  label: const Text('NUOVA PARTITA'),
                ),
              ),
              const SizedBox(height: 14),
              StaggeredEntrance(
                index: 4,
                child: OutlinedButton.icon(
                  onPressed: provider.hasSavedGame
                      ? () => context.go('/continue')
                      : null,
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('CONTINUA PARTITA'),
                ),
              ),
              const SizedBox(height: 40),
              StaggeredEntrance(
                index: 5,
                child: Text(
                  'Golasecca · Sesto Calende · Somma Lombardo\n'
                  'Vergiate · Castelletto sopra Ticino · Arsago Seprio',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textMuted, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
