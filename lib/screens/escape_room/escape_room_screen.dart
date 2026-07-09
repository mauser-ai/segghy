import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/scene_backgrounds.dart';
import '../../core/widgets/numeric_keypad.dart';
import '../../core/widgets/return_to_menu_button.dart';
import '../../core/widgets/scene_background.dart';
import '../../providers/game_provider.dart';

/// Ultimo enigma del gioco, sbloccato solo dopo aver individuato la vera
/// colpevole. In stile "escape room" a due fasi:
///
/// 1. Un cifrario di Cesare inciso sul retro della fibula: il giocatore
///    ruota una "ghiera" (0-25 posizioni) finché il testo cifrato non torna
///    a essere italiano leggibile — un vero e proprio lavoro di
///    decifrazione, non una lettura diretta.
/// 2. Una volta decifrata la frase, il giocatore compone il codice a 4
///    cifre che vi è nascosto sul tastierino numerico.
class EscapeRoomScreen extends StatefulWidget {
  const EscapeRoomScreen({super.key});

  @override
  State<EscapeRoomScreen> createState() => _EscapeRoomScreenState();
}

enum _Stage { cifrario, codice, rivelazione }

class _EscapeRoomScreenState extends State<EscapeRoomScreen>
    with SingleTickerProviderStateMixin {
  // Cifrario di Cesare: il testo cifrato qui sotto, ruotato all'indietro di
  // 12 posizioni (tante quanti i capitoli dell'indagine), torna a essere
  // "IL FIUME SUSSURRA QUATTRO QUATTRO DUE DUE".
  static const String _cipherText =
      'UX RUGYQ EGEEGDDM CGMFFDA CGMFFDA PGQ PGQ';
  static const String _targetPlaintext =
      'IL FIUME SUSSURRA QUATTRO QUATTRO DUE DUE';
  static const String _codice = '4422';

  _Stage _stage = _Stage.cifrario;

  int _shift = 0;
  String? _decodedAttempt;
  String? _cifrarioErrore;
  bool _hintVisible = false;
  int _tentativiDecifra = 0;

  String _input = '';
  String? _errore;
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  String _decode(int shift) {
    final buffer = StringBuffer();
    for (final unit in _cipherText.codeUnits) {
      if (unit == 32) {
        buffer.writeCharCode(32);
        continue;
      }
      final idx = unit - 65;
      final decoded = (idx - shift) % 26;
      buffer.writeCharCode((decoded < 0 ? decoded + 26 : decoded) + 65);
    }
    return buffer.toString();
  }

  void _changeShift(int delta) {
    setState(() {
      _shift = (_shift + delta) % 26;
      if (_shift < 0) _shift += 26;
      // Cambiare rotazione invalida il tentativo precedente: bisogna
      // decifrare di nuovo per vedere il risultato aggiornato, niente
      // anteprima automatica che regali la soluzione mentre si scorre.
      _decodedAttempt = null;
      _cifrarioErrore = null;
    });
  }

  void _decodeAttempt() {
    setState(() {
      _decodedAttempt = _decode(_shift);
      _tentativiDecifra++;
      _cifrarioErrore = null;
    });
  }

  void _confirmCifrario() {
    if (_decodedAttempt == null) return;
    if (_decodedAttempt == _targetPlaintext) {
      setState(() => _stage = _Stage.codice);
    } else {
      _shakeController.forward(from: 0);
      setState(() {
        _cifrarioErrore = 'Non sembra italiano leggibile. Prova un\'altra rotazione.';
      });
    }
  }

  void _addDigit(String d) {
    if (_input.length >= 4) return;
    setState(() {
      _input += d;
      _errore = null;
    });
    if (_input.length == 4) _checkCode();
  }

  void _removeDigit() {
    if (_input.isEmpty) return;
    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  void _checkCode() {
    if (_input == _codice) {
      setState(() => _stage = _Stage.rivelazione);
    } else {
      _shakeController.forward(from: 0);
      setState(() {
        _errore = 'Combinazione errata. Rileggi bene la frase decifrata.';
        _input = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final sbloccato = provider.state.finale != null;

    if (!sbloccato) {
      return Scaffold(
        appBar: AppBar(leading: const ReturnToMenuButton(), title: const Text('Ultimo enigma')),
        body: SceneBackground(
          type: SceneBackgroundType.scavoArcheologico,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 40, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  Text(
                    'Questo enigma si sblocca solo risolvendo correttamente '
                    'il caso: individua la vera colpevole prima di tornare qui.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/ending'),
                    icon: const Icon(Icons.flag_outlined),
                    label: const Text('TORNA AL FINALE'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const ReturnToMenuButton(),
        title: const Text('La fibula di Golasecca'),
      ),
      body: SceneBackground(
        type: SceneBackgroundType.scavoArcheologico,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: switch (_stage) {
              _Stage.cifrario => _CifrarioStage(
                  key: const ValueKey('cifrario'),
                  cipherText: _cipherText,
                  shift: _shift,
                  decodedAttempt: _decodedAttempt,
                  errore: _cifrarioErrore,
                  shakeController: _shakeController,
                  onShiftDown: () => _changeShift(-1),
                  onShiftUp: () => _changeShift(1),
                  onDecodeAttempt: _decodeAttempt,
                  onContinua: _confirmCifrario,
                  hintVisible: _hintVisible,
                  showHintButton: _tentativiDecifra > 8,
                  onToggleHint: () => setState(() => _hintVisible = !_hintVisible),
                ),
              _Stage.codice => _CodiceStage(
                  key: const ValueKey('codice'),
                  fraseDecifrata: _targetPlaintext,
                  input: _input,
                  errore: _errore,
                  shakeController: _shakeController,
                  onDigit: _addDigit,
                  onBackspace: _removeDigit,
                ),
              _Stage.rivelazione =>
                _CodeReveal(key: const ValueKey('reveal'), code: _codice),
            },
          ),
        ),
      ),
    );
  }
}

/// Fase 1: la ghiera del cifrario di Cesare. Niente anteprima in tempo
/// reale: la rotazione si imposta a scatti e va decifrata esplicitamente,
/// e il risultato non si colora mai da solo — tocca al giocatore leggerlo
/// e giudicare se è italiano corretto prima di confermarlo.
class _CifrarioStage extends StatelessWidget {
  final String cipherText;
  final int shift;
  final String? decodedAttempt;
  final String? errore;
  final AnimationController shakeController;
  final VoidCallback onShiftDown;
  final VoidCallback onShiftUp;
  final VoidCallback onDecodeAttempt;
  final VoidCallback onContinua;
  final bool hintVisible;
  final bool showHintButton;
  final VoidCallback onToggleHint;

  const _CifrarioStage({
    super.key,
    required this.cipherText,
    required this.shift,
    required this.decodedAttempt,
    required this.errore,
    required this.shakeController,
    required this.onShiftDown,
    required this.onShiftUp,
    required this.onDecodeAttempt,
    required this.onContinua,
    required this.hintVisible,
    required this.showHintButton,
    required this.onToggleHint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Il cifrario della fibula', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Sofia riconosce l\'incisione sul retro della fibula: non è '
          'decorazione, è un cifrario a rotazione — lo stesso usato dai '
          'trafficanti di reperti per nascondere le coordinate degli scavi. '
          'Imposta una rotazione, decifra, e leggi tu stessa se il '
          'risultato ha senso: la ghiera non te lo dirà da sola.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.surfaceVariant),
          ),
          child: Column(
            children: [
              Text('TESTO INCISO',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted, fontSize: 11, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              Text(
                cipherText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'monospace', letterSpacing: 2, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              onPressed: onShiftDown,
              icon: const Icon(Icons.remove),
              tooltip: 'Riduci rotazione',
            ),
            SizedBox(
              width: 96,
              child: Column(
                children: [
                  Text('ROTAZIONE',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted, fontSize: 10, letterSpacing: 1.5)),
                  Text('$shift',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: AppColors.accentGold)),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: onShiftUp,
              icon: const Icon(Icons.add),
              tooltip: 'Aumenta rotazione',
            ),
          ],
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: onDecodeAttempt,
          icon: const Icon(Icons.sync_outlined),
          label: const Text('DECIFRA CON QUESTA ROTAZIONE'),
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: shakeController,
          builder: (context, child) {
            final t = shakeController.value;
            final dx = (t == 0 || t == 1) ? 0.0 : (8 * (0.5 - (t * 4).remainder(1)).sign);
            return Transform.translate(offset: Offset(dx, 0), child: child);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: errore != null
                    ? AppColors.accentBlood
                    : AppColors.accentGold.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              children: [
                Text('DECIFRATO',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.accentGold, fontSize: 11, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                Text(
                  decodedAttempt ?? '— premi "decifra" per vedere il risultato —',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                      color: decodedAttempt == null
                          ? AppColors.textMuted
                          : AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 20,
          child: Text(
            errore ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.accentBlood, fontSize: 13),
          ),
        ),
        if (showHintButton) ...[
          Center(
            child: TextButton.icon(
              onPressed: onToggleHint,
              icon: const Icon(Icons.lightbulb_outline, size: 18),
              label: Text(hintVisible ? 'Nascondi suggerimento' : 'Suggerimento'),
            ),
          ),
          if (hintVisible)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Il numero dei capitoli della tua indagine potrebbe non essere un caso.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.accentGold),
              ),
            ),
        ],
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: decodedAttempt == null ? null : onContinua,
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('QUESTA È LA FRASE GIUSTA'),
        ),
      ],
    );
  }
}

/// Fase 2: comporre il codice trovato nella frase decifrata.
class _CodiceStage extends StatelessWidget {
  final String fraseDecifrata;
  final String input;
  final String? errore;
  final AnimationController shakeController;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  const _CodiceStage({
    super.key,
    required this.fraseDecifrata,
    required this.input,
    required this.errore,
    required this.shakeController,
    required this.onDigit,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Componi il codice', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Il cifrario è decifrato. Ora componi sul tastierino le quattro '
          'cifre nascoste nella frase.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.trustHigh.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.trustHigh.withValues(alpha: 0.5)),
          ),
          child: Text(
            fraseDecifrata,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamily: 'monospace', letterSpacing: 1.5, color: AppColors.trustHigh),
          ),
        ),
        const SizedBox(height: 24),
        AnimatedBuilder(
          animation: shakeController,
          builder: (context, child) {
            final t = shakeController.value;
            final dx = (t == 0 || t == 1) ? 0.0 : (8 * (0.5 - (t * 4).remainder(1)).sign);
            return Transform.translate(offset: Offset(dx, 0), child: child);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final filled = i < input.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 44,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: errore != null
                        ? AppColors.accentBlood
                        : AppColors.accentGold.withValues(alpha: 0.6),
                  ),
                ),
                child: Text(
                  filled ? input[i] : '',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 20,
          child: Text(
            errore ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.accentBlood, fontSize: 13),
          ),
        ),
        const SizedBox(height: 8),
        NumericKeypad(onDigit: onDigit, onBackspace: onBackspace),
      ],
    );
  }
}

class _CodeReveal extends StatelessWidget {
  final String code;
  const _CodeReveal({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 750),
          curve: Curves.elasticOut,
          builder: (context, value, child) => Transform.scale(
            scale: value.clamp(0, 1.4),
            child: child,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentGold.withValues(alpha: 0.15),
              border: Border.all(color: AppColors.accentGold, width: 1.6),
              boxShadow: [
                BoxShadow(
                    color: AppColors.accentGold.withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 4),
              ],
            ),
            child: const Icon(Icons.lock_open_rounded,
                color: AppColors.accentGold, size: 44),
          ),
        ),
        const SizedBox(height: 20),
        Text('LA FIBULA SI APRE',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.accentGold, letterSpacing: 2)),
        const SizedBox(height: 8),
        Text('Il codice segreto', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentGold, width: 1.4),
          ),
          child: Text(
            code,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  letterSpacing: 12,
                  color: AppColors.accentGold,
                ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Conserva questo codice: è il vero segreto che il Ticino custodiva.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 28),
        OutlinedButton.icon(
          onPressed: () => context.go('/ending'),
          icon: const Icon(Icons.flag_outlined),
          label: const Text('TORNA AL FINALE'),
        ),
      ],
    );
  }
}
