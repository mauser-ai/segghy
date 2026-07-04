// Script di validazione una tantum: verifica che tutti i riferimenti
// incrociati nei dati mock (scene, indizi, personaggi) siano coerenti.
// Uso: dart run tool/validate_data.dart
import '../lib/data/mock/chapters_data.dart';
import '../lib/data/mock/characters_data.dart';
import '../lib/data/mock/clues_data.dart';

void main() {
  final errors = <String>[];
  final clueIds = kClues.map((c) => c.id).toSet();
  final characterIds = kCharacters.map((c) => c.id).toSet();
  final allSceneIds = <String>{};
  for (final chapter in kChapters) {
    for (final scene in chapter.scene) {
      if (!allSceneIds.add(scene.id)) {
        errors.add('ID scena duplicato: ${scene.id}');
      }
    }
  }

  for (final chapter in kChapters) {
    for (final scene in chapter.scene) {
      for (final clueId in scene.indiziOttenibili) {
        if (!clueIds.contains(clueId)) {
          errors.add('${scene.id}: indiziOttenibili riferisce clue inesistente "$clueId"');
        }
      }
      if (scene.indizioMinigioco != null &&
          !clueIds.contains(scene.indizioMinigioco)) {
        errors.add('${scene.id}: indizioMinigioco riferisce clue inesistente "${scene.indizioMinigioco}"');
      }
      for (final line in scene.dialoghi) {
        if (!characterIds.contains(line.personaggioId)) {
          errors.add('${scene.id}: dialogo riferisce personaggio inesistente "${line.personaggioId}"');
        }
      }
      for (final choice in scene.scelte) {
        if (choice.prossimoNodo != kConfrontoEsitoSentinel &&
            !allSceneIds.contains(choice.prossimoNodo)) {
          errors.add('${scene.id} -> ${choice.id}: prossimoNodo riferisce scena inesistente "${choice.prossimoNodo}"');
        }
        for (final clueId in choice.indiziSbloccati) {
          if (!clueIds.contains(clueId)) {
            errors.add('${scene.id} -> ${choice.id}: indiziSbloccati riferisce clue inesistente "$clueId"');
          }
        }
        for (final charId in choice.modificaFiducia.keys) {
          if (!characterIds.contains(charId)) {
            errors.add('${scene.id} -> ${choice.id}: modificaFiducia riferisce personaggio inesistente "$charId"');
          }
        }
        for (final charId in choice.modificaSospetto.keys) {
          if (!characterIds.contains(charId)) {
            errors.add('${scene.id} -> ${choice.id}: modificaSospetto riferisce personaggio inesistente "$charId"');
          }
        }
      }
      // Ogni scena che non è finale-capitolo deve avere dialoghi+scelte,
      // un minigioco, oppure richiedere un'accusa: altrimenti il giocatore
      // resta bloccato senza alcun modo di proseguire.
      final haContenutoSuccessivo = scene.dialoghi.isNotEmpty ||
          scene.scelte.isNotEmpty ||
          scene.minigioco != null ||
          scene.richiedeAccusa;
      if (!scene.isFinaleCapitolo && !haContenutoSuccessivo) {
        errors.add('${scene.id}: non è finale capitolo ma non ha dialoghi/scelte/minigioco/accusa (vicolo cieco)');
      }
      if (scene.dialoghi.isNotEmpty && scene.scelte.isEmpty && !scene.isFinaleCapitolo) {
        errors.add('${scene.id}: ha dialoghi ma nessuna scelta finale (la scena dialogo non saprebbe come proseguire)');
      }
    }
    // La scenaInizialeId deve esistere tra le scene del capitolo.
    if (chapter.sceneById(chapter.scenaInizialeId) == null) {
      errors.add('${chapter.id}: scenaInizialeId "${chapter.scenaInizialeId}" non trovata tra le sue scene');
    }
  }

  // Verifica che ogni indizio sia raggiungibile da almeno un punto del gioco.
  final clueReachable = <String>{};
  for (final chapter in kChapters) {
    for (final scene in chapter.scene) {
      clueReachable.addAll(scene.indiziOttenibili);
      if (scene.indizioMinigioco != null) clueReachable.add(scene.indizioMinigioco!);
      for (final choice in scene.scelte) {
        clueReachable.addAll(choice.indiziSbloccati);
      }
    }
  }
  for (final clue in kClues) {
    if (clue.id == 'clue_confessione') continue; // gestito nel finale
    if (!clueReachable.contains(clue.id)) {
      errors.add('Indizio mai raggiungibile in nessuna scena: ${clue.id}');
    }
  }

  if (errors.isEmpty) {
    print('OK: nessun problema di integrità trovato.');
    print('Capitoli: ${kChapters.length}, Scene: ${allSceneIds.length}, '
        'Indizi: ${kClues.length}, Personaggi: ${kCharacters.length}');
  } else {
    print('Trovati ${errors.length} problemi:');
    for (final e in errors) {
      print(' - $e');
    }
  }
}
