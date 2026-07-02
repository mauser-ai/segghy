import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/atmospheric_background.dart';
import '../../core/widgets/game_nav_bar.dart';
import '../../core/widgets/return_to_menu_button.dart';
import '../../core/widgets/section_header.dart';
import '../../providers/game_provider.dart';
import 'package:provider/provider.dart';

/// Rappresentazione stilizzata dei luoghi dell'indagine, disposti lungo il
/// corso del Ticino. Toccando un luogo si apre un riepilogo di capitoli,
/// personaggi e indizi ad esso collegati.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static const List<_MapLocation> _locations = [
    _MapLocation('Golasecca', Offset(0.30, 0.14)),
    _MapLocation('Sesto Calende', Offset(0.62, 0.30)),
    _MapLocation('Somma Lombardo', Offset(0.20, 0.48)),
    _MapLocation('Vergiate', Offset(0.72, 0.55)),
    _MapLocation('Castelletto sopra Ticino', Offset(0.42, 0.72)),
    _MapLocation('Arsago Seprio', Offset(0.15, 0.86)),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: const ReturnToMenuButton(),
        title: const Text('Mappa dei luoghi'),
      ),
      bottomNavigationBar: const GameNavBar(currentIndex: 2),
      body: AtmosphericBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: SectionHeader(
                title: 'Lungo il Ticino',
                subtitle: 'Tocca un luogo per rivedere cosa hai scoperto lì.',
                icon: Icons.map_outlined,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.surfaceHigh),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.nightBlue, AppColors.surface],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(painter: _RiverPainter()),
                          ),
                          for (final loc in _locations)
                            Positioned(
                              left: loc.position.dx * constraints.maxWidth - 60,
                              top: loc.position.dy * constraints.maxHeight - 20,
                              width: 120,
                              child: _LocationPin(
                                name: loc.name,
                                cluesFound: provider.clues
                                    .where((c) => c.luogo == loc.name && c.trovato)
                                    .length,
                                cluesTotal: provider.clues
                                    .where((c) => c.luogo == loc.name)
                                    .length,
                                onTap: () => _showLocationSheet(
                                    context, provider, loc.name),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationSheet(
      BuildContext context, GameProvider provider, String luogo) {
    final clues = provider.clues.where((c) => c.luogo == luogo).toList();
    final characters =
        provider.characters.where((c) => c.luogo == luogo).toList();
    final chapters =
        provider.chapters.where((c) => c.luogo == luogo).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(luogo, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              if (chapters.isNotEmpty) ...[
                Text('Capitoli', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                ...chapters.map((c) => Text('· ${c.numero}. ${c.titolo}',
                    style: Theme.of(context).textTheme.bodyMedium)),
                const SizedBox(height: 14),
              ],
              if (characters.isNotEmpty) ...[
                Text('Personaggi', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                ...characters.map((c) => Text('· ${c.nome} (${c.ruolo})',
                    style: Theme.of(context).textTheme.bodyMedium)),
                const SizedBox(height: 14),
              ],
              Text('Indizi trovati qui', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              if (clues.where((c) => c.trovato).isEmpty)
                Text('Nessun indizio trovato ancora in questo luogo.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.textMuted))
              else
                ...clues.where((c) => c.trovato).map((c) => Text('· ${c.titolo}',
                    style: Theme.of(context).textTheme.bodyMedium)),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _MapLocation {
  final String name;
  final Offset position;
  const _MapLocation(this.name, this.position);
}

class _LocationPin extends StatelessWidget {
  final String name;
  final int cluesFound;
  final int cluesTotal;
  final VoidCallback onTap;

  const _LocationPin({
    required this.name,
    required this.cluesFound,
    required this.cluesTotal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = cluesFound > 0;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? AppColors.accentGold : AppColors.surfaceHigh,
              border: Border.all(
                  color: active ? AppColors.accentAmber : AppColors.textMuted,
                  width: 2),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: AppColors.accentGold.withValues(alpha: 0.5),
                        blurRadius: 8,
                      )
                    ]
                  : null,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              cluesTotal > 0 ? '$name\n$cluesFound/$cluesTotal' : name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Disegna una linea sinuosa stilizzata che rappresenta il corso del Ticino
/// sullo sfondo della mappa, senza bisogno di asset immagine.
class _RiverPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.riverMist.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.1, 0)
      ..quadraticBezierTo(
          size.width * 0.6, size.height * 0.25, size.width * 0.35, size.height * 0.5)
      ..quadraticBezierTo(
          size.width * 0.1, size.height * 0.7, size.width * 0.55, size.height * 0.95);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
