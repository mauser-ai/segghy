import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/scene_backgrounds.dart';
import '../../core/widgets/numeric_keypad.dart';
import '../../core/widgets/return_to_menu_button.dart';
import '../../core/widgets/scene_background.dart';
import '../../models/ending.dart';
import '../../providers/game_provider.dart';

/// Ultimo enigma del gioco, sbloccato solo risolvendo correttamente il caso
/// (qualunque finale tranne quello dell'accusa sbagliata). In stile "escape
/// room": la fibula antica recuperata durante l'indagine reca incise 4 cifre
/// in numeri romani, che il giocatore deve tradurre e comporre per ottenere
/// il codice segreto finale.
class EscapeRoomScreen extends StatefulWidget {
  const EscapeRoomScreen({super.key});

  @override
  State<EscapeRoomScreen> createState() => _EscapeRoomScreenState();
}

class _EscapeRoomScreenState extends State<EscapeRoomScreen>
    with SingleTickerProviderStateMixin {
  static const String _codice = '4422';

  String _input = '';
  String? _errore;
  bool _risolto = false;
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
      setState(() => _risolto = true);
    } else {
      _shakeController.forward(from: 0);
      setState(() {
        _errore = 'Combinazione errata. Rileggi bene i simboli sulla fibula.';
        _input = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final finale = provider.state.finale;
    final sbloccato = finale != null && finale != EndingType.erroneo;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: _risolto
                    ? _CodeReveal(key: const ValueKey('reveal'), code: _codice)
                    : _PuzzleBody(
                        key: const ValueKey('puzzle'),
                        input: _input,
                        errore: _errore,
                        shakeController: _shakeController,
                        onDigit: _addDigit,
                        onBackspace: _removeDigit,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PuzzleBody extends StatelessWidget {
  final String input;
  final String? errore;
  final AnimationController shakeController;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  const _PuzzleBody({
    super.key,
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
        Text('Il segreto della fibula', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Prima di lasciare Golasecca, Sofia ti mostra un\'ultima cosa: sul '
          'retro della fibula ritrovata, quasi invisibili, quattro simboli '
          'incisi da chissà quanti secoli.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _RomanGlyph('IV'),
              _RomanGlyph('IV'),
              _RomanGlyph('II'),
              _RomanGlyph('II'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Sofia sorride: "Sono numeri romani, Segghy. Non serve un\'esperta '
          'di archeologia per leggerli."',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontStyle: FontStyle.italic, color: AppColors.textMuted),
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

class _RomanGlyph extends StatelessWidget {
  final String numeral;
  const _RomanGlyph(this.numeral);

  @override
  Widget build(BuildContext context) {
    return Text(
      numeral,
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: AppColors.accentGold,
            fontWeight: FontWeight.w900,
          ),
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
