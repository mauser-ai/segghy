import 'package:flutter/foundation.dart';

import '../data/mock/chapters_data.dart';
import '../data/mock/characters_data.dart';
import '../data/mock/clues_data.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

/// Controller centrale dello stato di gioco. Espone [GameState] arricchito
/// con i dati derivati (personaggi con fiducia aggiornata, indizi con stato
/// "trovato", capitolo/scena correnti) e gestisce tutte le transizioni
/// narrative, incluso il calcolo dinamico dei finali.
class GameProvider extends ChangeNotifier {
  GameProvider({StorageService? storageService})
      : _storage = storageService ?? StorageService();

  final StorageService _storage;

  GameState _state = const GameState(
    capitoloCorrenteId: '',
    scenaCorrenteId: '',
  );

  bool _loading = true;
  bool _hasSavedGame = false;

  GameState get state => _state;
  bool get loading => _loading;
  bool get hasSavedGame => _hasSavedGame;
  bool get partitaIniziata => _state.partitaIniziata;

  /// Personaggi con il livello di fiducia corrente sovrascritto in base
  /// allo stato di partita (i dati anagrafici restano quelli mock).
  List<Character> get characters {
    return kCharacters.map((c) {
      final fiducia = _state.fiduciaPersonaggi[c.id];
      return fiducia == null ? c : c.copyWith(livelloFiducia: fiducia);
    }).toList();
  }

  Character characterWithState(String id) =>
      characters.firstWhere((c) => c.id == id);

  /// Livello di sospetto (0-100) verso un personaggio, calcolato in base
  /// alle prove raccolte e alle scelte fatte finora. Indipendente dalla
  /// fiducia: cresce o cala man mano con le risposte del giocatore.
  int suspicionOf(String characterId) =>
      _state.sospettoPersonaggi[characterId] ?? 0;

  /// Elenco dei sospettati tra cui il giocatore può scegliere nel confronto
  /// finale, ordinati dal più sospetto al meno sospetto per aiutare la
  /// lettura (senza però nascondere nessuna opzione).
  List<Character> get suspects {
    final list = characters.where((c) => c.sospettato).toList();
    list.sort((a, b) => suspicionOf(b.id).compareTo(suspicionOf(a.id)));
    return list;
  }

  /// Personaggio formalmente accusato nel confronto finale, se già scelto.
  Character? get accusedCharacter {
    final id = _state.personaggioAccusato;
    if (id == null) return null;
    return characterWithState(id);
  }

  /// Indizi con il flag "trovato" aggiornato in base allo stato di partita.
  List<Clue> get clues {
    return kClues
        .map((c) => c.copyWith(trovato: _state.indiziRaccolti.contains(c.id)))
        .toList();
  }

  List<Clue> get collectedClues => clues.where((c) => c.trovato).toList();

  List<Chapter> get chapters => kChapters;

  Chapter get currentChapter => chapterById(_state.capitoloCorrenteId);

  Scene get currentScene => currentChapter.sceneById(_state.scenaCorrenteId)!;

  bool isChapterUnlocked(String chapterId) {
    final index = kChapters.indexWhere((c) => c.id == chapterId);
    if (index <= 0) return true;
    final previous = kChapters[index - 1];
    return _state.capitoliCompletati.contains(previous.id);
  }

  bool isChapterCompleted(String chapterId) =>
      _state.capitoliCompletati.contains(chapterId);

  // ---------------------------------------------------------------------
  // Ciclo di vita / persistenza
  // ---------------------------------------------------------------------

  Future<void> init() async {
    _hasSavedGame = await _storage.hasSavedGame();
    _loading = false;
    notifyListeners();
  }

  Future<void> startNewGame() async {
    final iniziale = <String, int>{
      for (final c in kCharacters) c.id: c.livelloFiducia,
    };
    // Il sospetto iniziale riflette solo chi aveva un motivo noto fin da
    // subito (i "sospettati" anagrafici): un punto di partenza condiviso da
    // sei persone diverse, che non svela affatto chi sia la colpevole.
    final sospettoIniziale = <String, int>{
      for (final c in kCharacters) c.id: c.sospettato ? 22 : 6,
    };
    _state = GameState.nuovaPartita(
      primoCapitoloId: kChapters.first.id,
      primaScenaId: kChapters.first.scenaInizialeId,
      fiduciaIniziale: iniziale,
      sospettoIniziale: sospettoIniziale,
    );
    _applySceneEntryEffects(currentScene);
    await _persist();
    _hasSavedGame = true;
    notifyListeners();
  }

  Future<bool> loadSavedGame() async {
    final saved = await _storage.loadGame();
    if (saved == null) return false;
    _state = saved;
    notifyListeners();
    return true;
  }

  Future<void> resetGame() async {
    await _storage.deleteSavedGame();
    _state = const GameState(capitoloCorrenteId: '', scenaCorrenteId: '');
    _hasSavedGame = false;
    notifyListeners();
  }

  Future<void> _persist() async {
    _state = _state.copyWith(
      ultimoSalvataggio: DateTime.now().millisecondsSinceEpoch,
    );
    await _storage.saveGame(_state);
  }

  // ---------------------------------------------------------------------
  // Navigazione tra capitoli
  // ---------------------------------------------------------------------

  /// Consente di aprire un capitolo già sbloccato dalla schermata di
  /// selezione capitoli, ripartendo dalla sua prima scena.
  Future<void> openChapter(String chapterId) async {
    if (!isChapterUnlocked(chapterId)) return;
    final chapter = chapterById(chapterId);
    _state = _state.copyWith(
      capitoloCorrenteId: chapter.id,
      scenaCorrenteId: chapter.scenaInizialeId,
    );
    _applySceneEntryEffects(currentScene);
    await _persist();
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // Scelte e progressione narrativa
  // ---------------------------------------------------------------------

  Future<void> selectChoice(Choice choice) async {
    // 1. Applica variazioni di fiducia.
    final nuovaFiducia = Map<String, int>.from(_state.fiduciaPersonaggi);
    choice.modificaFiducia.forEach((characterId, delta) {
      final attuale = nuovaFiducia[characterId] ?? 50;
      nuovaFiducia[characterId] = (attuale + delta).clamp(0, 100);
    });

    // 1b. Applica variazioni al livello di sospetto (indipendenti dalla
    // fiducia: le prove possono insospettire anche chi si continua a
    // stimare).
    final nuovoSospetto = Map<String, int>.from(_state.sospettoPersonaggi);
    choice.modificaSospetto.forEach((characterId, delta) {
      final attuale = nuovoSospetto[characterId] ?? 0;
      nuovoSospetto[characterId] = (attuale + delta).clamp(0, 100);
    });

    // 2. Sblocca eventuali indizi legati alla scelta.
    final nuoviIndizi = Set<String>.from(_state.indiziRaccolti)
      ..addAll(choice.indiziSbloccati);

    // 3. Registra la scelta effettuata.
    final nuoveScelte = Map<String, String>.from(_state.scelteEffettuate);
    nuoveScelte[currentScene.id] = choice.id;

    _state = _state.copyWith(
      fiduciaPersonaggi: nuovaFiducia,
      sospettoPersonaggi: nuovoSospetto,
      indiziRaccolti: nuoviIndizi,
      scelteEffettuate: nuoveScelte,
    );

    // 4. Risolve la scena successiva, gestendo il caso speciale del
    // capitolo 10 in cui il "nodo" non è una scena statica ma va calcolato.
    final prossimoId = choice.prossimoNodo == kConfrontoEsitoSentinel
        ? _computeFinaleEsito()
        : choice.prossimoNodo;

    await _goToScene(prossimoId);
  }

  /// Registra l'accusa formale del giocatore nel confronto finale.
  /// Se corretta (Sandra), prosegue verso il confronto vero e proprio,
  /// dove l'esito dipende ancora da indizi e fiducia accumulati. Se
  /// sbagliata, porta direttamente al finale "errore giudiziario": il
  /// vero colpevole resta libero e la persona accusata non lo perdona.
  Future<void> submitAccusation(String characterId) async {
    _state = _state.copyWith(personaggioAccusato: characterId);
    if (characterId == 'sandra') {
      await _goToScene('c10_s2');
    } else {
      await _goToScene('c10_finale_erroneo');
    }
  }

  Future<void> _goToScene(String sceneId) async {
    final chapter = chapterContainingScene(sceneId) ?? currentChapter;
    _state = _state.copyWith(
      capitoloCorrenteId: chapter.id,
      scenaCorrenteId: sceneId,
    );
    final scene = currentScene;
    _applySceneEntryEffects(scene);

    if (scene.isFinaleCapitolo) {
      final completati = Set<String>.from(_state.capitoliCompletati)
        ..add(chapter.id);
      _state = _state.copyWith(capitoliCompletati: completati);
    }

    if (scene.endingId != null) {
      _state = _state.copyWith(
        finale: EndingType.values.firstWhere((e) => e.name == scene.endingId),
      );
    }

    await _persist();
    notifyListeners();
  }

  void _applySceneEntryEffects(Scene scene) {
    if (scene.indiziOttenibili.isEmpty) return;
    final nuoviIndizi = Set<String>.from(_state.indiziRaccolti)
      ..addAll(scene.indiziOttenibili);
    _state = _state.copyWith(indiziRaccolti: nuoviIndizi);
  }

  /// Restituisce gli indizi appena ottenuti entrando nella scena corrente,
  /// utile per mostrare una notifica nella UI senza doverli ricalcolare.
  List<Clue> get clueJustFoundInCurrentScene {
    return currentScene.indiziOttenibili.map(clueById).toList();
  }

  // ---------------------------------------------------------------------
  // Minigiochi investigativi
  // ---------------------------------------------------------------------

  bool isMinigameCompleted(String sceneId) =>
      _state.minigiochiCompletati.contains(sceneId);

  /// Segna risolto il minigioco della scena corrente e sblocca l'indizio
  /// collegato, se previsto. Va chiamato una sola volta, alla vittoria.
  Future<void> completeMinigame(String sceneId, {String? clueId}) async {
    final completati = Set<String>.from(_state.minigiochiCompletati)
      ..add(sceneId);
    final indizi = Set<String>.from(_state.indiziRaccolti);
    if (clueId != null) indizi.add(clueId);
    _state = _state.copyWith(
      minigiochiCompletati: completati,
      indiziRaccolti: indizi,
    );
    await _persist();
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // Calcolo del finale (capitolo 10)
  // ---------------------------------------------------------------------

  static const List<String> _indiziCritici = [
    'clue_ciondolo_falso',
    'clue_campanello',
    'clue_microscheda',
    'clue_mappa_alterata',
    'clue_video_incappucciato',
    'clue_frase_sandra',
    'clue_documenti_maneggio',
    'clue_impronta_estranea',
    'clue_registro_visite',
  ];

  /// Determina se il confronto finale con Sandra porta al finale "perfetto"
  /// (tutti gli indizi critici raccolti, buona fiducia con Matteo, ampia
  /// copertura investigativa e un sospetto verso Sandra abbastanza alto da
  /// reggere l'accusa) oppure al finale "buono" (innocenza comunque
  /// dimostrata, ma senza confessione completa).
  String _computeFinaleEsito() {
    final indiziCriticiTrovati =
        _indiziCritici.every((id) => _state.indiziRaccolti.contains(id));
    final totaleIndiziTrovati = _state.indiziRaccolti
        .where((id) => id != 'clue_confessione')
        .length;
    final fiduciaMatteo = _state.fiduciaPersonaggi['matteo'] ?? 50;
    final sospettoSandra = _state.sospettoPersonaggi['sandra'] ?? 0;

    final ePerfetto = indiziCriticiTrovati &&
        totaleIndiziTrovati >= 18 &&
        fiduciaMatteo >= 50 &&
        sospettoSandra >= 60;

    return ePerfetto ? 'c10_finale_perfetto' : 'c10_finale_buono';
  }

  /// Percentuale di completezza investigativa (0.0 - 1.0), usata nella UI
  /// per mostrare quanto il giocatore si è avvicinato al finale perfetto.
  double get investigationProgress {
    final totale = kClues.where((c) => c.id != 'clue_confessione').length;
    final trovati = _state.indiziRaccolti
        .where((id) => id != 'clue_confessione')
        .length;
    if (totale == 0) return 0;
    return (trovati / totale).clamp(0, 1);
  }
}
