import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/atmospheric_background.dart';
import '../../core/widgets/game_nav_bar.dart';
import '../../core/widgets/return_to_menu_button.dart';
import '../../core/widgets/section_header.dart';
import '../../models/chapter.dart';
import '../../providers/game_provider.dart';

/// Elenco dei capitoli dell'indagine: quelli completati sono contrassegnati,
/// quelli bloccati non sono ancora accessibili.
class ChapterSelectScreen extends StatelessWidget {
  const ChapterSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: const ReturnToMenuButton(),
        title: const Text('Capitoli'),
      ),
      bottomNavigationBar: const GameNavBar(currentIndex: 0),
      body: AtmosphericBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          children: [
            const SectionHeader(
              title: "L'indagine",
              subtitle: 'Segui le tappe della storia, in ordine.',
              icon: Icons.menu_book_outlined,
            ),
            const SizedBox(height: 16),
            ...provider.chapters.map((chapter) {
              final unlocked = provider.isChapterUnlocked(chapter.id);
              final completed = provider.isChapterCompleted(chapter.id);
              final isCurrent = provider.state.capitoloCorrenteId == chapter.id;
              return _ChapterTile(
                chapter: chapter,
                unlocked: unlocked,
                completed: completed,
                isCurrent: isCurrent,
                onTap: unlocked
                    ? () async {
                        await provider.openChapter(chapter.id);
                        if (context.mounted) context.go('/narrative');
                      }
                    : null,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ChapterTile extends StatelessWidget {
  final Chapter chapter;
  final bool unlocked;
  final bool completed;
  final bool isCurrent;
  final VoidCallback? onTap;

  const _ChapterTile({
    required this.chapter,
    required this.unlocked,
    required this.completed,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: completed
                    ? AppColors.accentGold.withValues(alpha: 0.2)
                    : AppColors.surfaceVariant,
                child: Icon(
                  completed
                      ? Icons.check
                      : unlocked
                          ? Icons.menu_book_outlined
                          : Icons.lock_outline,
                  color: completed
                      ? AppColors.accentGold
                      : unlocked
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Capitolo ${chapter.numero} · ${chapter.luogo}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted, fontSize: 12),
                    ),
                    Text(
                      chapter.titolo,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: unlocked
                              ? AppColors.textPrimary
                              : AppColors.textMuted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chapter.descrizione,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (isCurrent && !completed)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.play_circle_fill,
                      color: AppColors.accentGold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
