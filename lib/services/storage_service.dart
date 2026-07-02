import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_state.dart';

/// Incapsula la persistenza locale della partita tramite SharedPreferences.
/// Il [GameState] viene serializzato in JSON e salvato come stringa: questo
/// evita la necessità di adapter/codegen (come richiederebbe Hive) mantenendo
/// il salvataggio semplice e portabile anche su web.
class StorageService {
  static const String _saveKey = 'segghy_ticino_save_v1';

  Future<void> saveGame(GameState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_saveKey, jsonEncode(state.toJson()));
  }

  Future<GameState?> loadGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Anche prefs.getString() può lanciare, non solo jsonDecode: se il
      // valore grezzo in storage non è nel formato atteso dal plugin (dati
      // corrotti, quota superata a metà scrittura, modifiche esterne allo
      // storage del browser), l'intera chiamata va protetta, altrimenti
      // un salvataggio danneggiato manda in crash l'app invece di essere
      // trattato semplicemente come "nessun salvataggio".
      final raw = prefs.getString(_saveKey);
      if (raw == null) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return GameState.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<bool> hasSavedGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_saveKey);
    } catch (_) {
      return false;
    }
  }

  Future<void> deleteSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_saveKey);
  }
}
