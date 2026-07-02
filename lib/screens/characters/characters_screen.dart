import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/atmospheric_background.dart';
import '../../core/widgets/character_avatar.dart';
import '../../core/widgets/game_nav_bar.dart';
import '../../core/widgets/return_to_menu_button.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/suspicion_meter.dart';
import '../../core/widgets/trust_meter.dart';
import '../../models/character.dart';
import '../../providers/game_provider.dart';

/// Profilo dei personaggi incontrati durante l'indagine: descrizione,
/// livello di fiducia corrente ed eventuale stato di sospettato.
class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final characters = List<Character>.from(provider.characters)
      ..sort((a, b) => a.id == 'segghy'
          ? -1
          : b.id == 'segghy'
              ? 1
              : b.livelloFiducia.compareTo(a.livelloFiducia));

    return Scaffold(
      appBar: AppBar(
        leading: const ReturnToMenuButton(),
        title: const Text('Personaggi'),
      ),
      bottomNavigationBar: const GameNavBar(currentIndex: 3),
      body: AtmosphericBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          children: [
            const SectionHeader(
              title: 'Chi hai incontrato',
              subtitle: 'Fiducia e sospetto cambiano in base alle tue scelte.',
              icon: Icons.people_alt_outlined,
            ),
            const SizedBox(height: 16),
            ...characters.map((c) => _CharacterTile(
                  character: c,
                  sospetto: provider.suspicionOf(c.id),
                )),
          ],
        ),
      ),
    );
  }
}

class _CharacterTile extends StatelessWidget {
  final Character character;
  final int sospetto;

  const _CharacterTile({required this.character, required this.sospetto});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          leading: CharacterAvatar(
            nome: character.nome,
            id: character.id,
            sospettato: character.sospettato,
            imagePath: character.immagine,
          ),
          title: Row(
            children: [
              Text(character.nome, style: Theme.of(context).textTheme.titleMedium),
              if (character.sospettato) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlood.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.accentBlood),
                  ),
                  child: const Text(
                    'SOSPETTATO',
                    style: TextStyle(
                        color: AppColors.accentBlood,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
          subtitle: Text('${character.ruolo} · ${character.luogo}'),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Text(character.descrizione, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 14),
            if (character.id != 'mauro' && character.id != 'segghy') ...[
              TrustMeter(livello: character.livelloFiducia),
              const SizedBox(height: 12),
              SuspicionMeter(livello: sospetto),
            ],
          ],
        ),
      ),
    );
  }
}
