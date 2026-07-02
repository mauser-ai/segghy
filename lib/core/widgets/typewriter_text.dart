import 'dart:async';

import 'package:flutter/material.dart';

/// Rivela una stringa un carattere alla volta, in stile "macchina da
/// scrivere" (JRPG/visual novel). È un [ChangeNotifier] indipendente dal
/// widget tree così che [DialogueScreen] possa comandarlo dall'esterno
/// (avviare una nuova battuta, saltare subito alla fine con un tap).
class TypewriterController extends ChangeNotifier {
  String _fullText = '';
  int _charCount = 0;
  Timer? _timer;
  VoidCallback? _onDone;

  String get visibleText => _fullText.substring(0, _charCount);
  bool get isDone => _charCount >= _fullText.length;

  void start(
    String text, {
    Duration charDelay = const Duration(milliseconds: 18),
    VoidCallback? onDone,
  }) {
    _timer?.cancel();
    _fullText = text;
    _charCount = 0;
    _onDone = onDone;
    notifyListeners();
    if (_fullText.isEmpty) {
      _onDone?.call();
      return;
    }
    _timer = Timer.periodic(charDelay, (timer) {
      _charCount++;
      if (_charCount >= _fullText.length) {
        _charCount = _fullText.length;
        timer.cancel();
        notifyListeners();
        _onDone?.call();
      } else {
        notifyListeners();
      }
    });
  }

  /// Rivela immediatamente tutto il testo (tap dell'utente durante
  /// l'animazione), senza attendere il timer carattere per carattere.
  void skipToEnd() {
    if (isDone) return;
    _timer?.cancel();
    _charCount = _fullText.length;
    notifyListeners();
    _onDone?.call();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Widget che mostra il testo rivelato da un [TypewriterController].
class TypewriterText extends StatelessWidget {
  final TypewriterController controller;
  final TextStyle? style;

  const TypewriterText({super.key, required this.controller, this.style});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => Text(controller.visibleText, style: style),
    );
  }
}
