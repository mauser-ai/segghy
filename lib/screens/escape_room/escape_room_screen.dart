import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/scene_backgrounds.dart';
import '../../core/widgets/numeric_keypad.dart';
import '../../core/widgets/return_to_menu_button.dart';
import '../../core/widgets/scene_background.dart';
import '../../providers/game_provider.dart';

/// Un simbolo del rebus: un'emoji incisa sulla fibula, una didascalia
/// evocativa (non la parola diretta) e la parola italiana a cui allude —
/// la cui prima lettera è la lettera nascosta.
class _RebusSymbol {
  final String icon;
  final String caption;
  final String word;
  const _RebusSymbol({required this.icon, required this.caption, required this.word});
}

/// Ultimo enigma del gioco, sbloccato solo dopo aver individuato la vera
/// colpevole. In stile "escape room" a due fasi:
///
/// 1. Un rebus per immagini inciso sulla fibula: ogni lettera del
///    messaggio nascosto è stata sostituita con un'emoji legata al caso.
///    Una legenda descrive cosa raffigura ciascun simbolo, ma solo con un
///    indizio — tocca al giocatore indovinare la parola e prenderne la
///    prima lettera, per ogni simbolo, per ricostruire la frase.
/// 2. Una volta ricostruita la frase, il giocatore compone il codice a 4
///    cifre che vi è nascosto sul tastierino numerico.
class EscapeRoomScreen extends StatefulWidget {
  const EscapeRoomScreen({super.key});

  @override
  State<EscapeRoomScreen> createState() => _EscapeRoomScreenState();
}

enum _Stage { cifrario, codice, rivelazione }

class _EscapeRoomScreenState extends State<EscapeRoomScreen>
    with SingleTickerProviderStateMixin {
  static const String _targetPlaintext =
      'IL FIUME SUSSURRA QUATTRO QUATTRO DUE DUE';
  static const String _codice = '4422';

  // Alfabeto del rebus: un simbolo per ogni lettera distinta del messaggio,
  // in ordine di prima apparizione. La legenda mostrata al giocatore dà
  // solo la didascalia (non la "word"): la parola va indovinata.
  static const Map<String, _RebusSymbol> _rebusAlphabet = {
    'I': _RebusSymbol(
        icon: '🔍',
        caption: 'Quel che si raccoglie lungo il fiume per risolvere il caso.',
        word: 'INDIZIO'),
    'L': _RebusSymbol(
        icon: '🔒',
        caption: 'Protegge un segreto, finché qualcuno non lo forza.',
        word: 'LUCCHETTO'),
    'F': _RebusSymbol(
        icon: '🌊',
        caption: 'Scorre silenzioso sotto Golasecca.',
        word: 'FIUME'),
    'U': _RebusSymbol(
        icon: '🍇', caption: 'Un frutto che cresce a grappoli.', word: 'UVA'),
    'M': _RebusSymbol(
        icon: '🐱',
        caption: 'Il cucciolo che Segghy accudisce ogni giorno.',
        word: 'MICIO'),
    'E': _RebusSymbol(
        icon: '🌿',
        caption: 'Cresce spontanea lungo i sentieri del fiume.',
        word: 'ERBA'),
    'S': _RebusSymbol(
        icon: '⭐', caption: 'Brilla nel cielo la notte della festa.', word: 'STELLA'),
    'R': _RebusSymbol(
        icon: '🏞️', caption: 'La sponda dove tutto è cominciato.', word: 'RIVA'),
    'A': _RebusSymbol(
        icon: '🐝', caption: 'Un piccolo insetto operoso.', word: 'APE'),
    'Q': _RebusSymbol(
        icon: '📓',
        caption: 'Dove si annotano indizi e sospetti.',
        word: 'QUADERNO'),
    'T': _RebusSymbol(
        icon: '📱',
        caption: 'L\'oggetto che Kledian custodiva nella sua officina.',
        word: 'TELEFONO'),
    'O': _RebusSymbol(
        icon: '⏰',
        caption: 'Segna l\'ora esatta della festa fatale.',
        word: 'OROLOGIO'),
    'D': _RebusSymbol(
        icon: '📄',
        caption: 'Un foglio che racconta i fatti, nero su bianco.',
        word: 'DOCUMENTO'),
  };

  static List<String> get _rebusWords => _targetPlaintext.split(' ').map((word) {
        return word.split('').map((ch) => _rebusAlphabet[ch]!.icon).join();
      }).toList();

  _Stage _stage = _Stage.cifrario;
  bool _hintVisible = false;

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
                  rebusWords: _rebusWords,
                  legend: _rebusAlphabet,
                  onContinua: () => setState(() => _stage = _Stage.codice),
                  hintVisible: _hintVisible,
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

/// Fase 1: il rebus della fibula. Ogni lettera del messaggio è
/// un'immagine; la legenda descrive solo cosa raffigura ciascun simbolo,
/// non la parola né la lettera — tocca al giocatore indovinare la parola
/// e prenderne la prima lettera, per ogni simbolo, per ricostruire la
/// frase da solo, leggendola mentalmente prima di proseguire.
class _CifrarioStage extends StatelessWidget {
  final List<String> rebusWords;
  final Map<String, _RebusSymbol> legend;
  final VoidCallback onContinua;
  final bool hintVisible;
  final VoidCallback onToggleHint;

  const _CifrarioStage({
    super.key,
    required this.rebusWords,
    required this.legend,
    required this.onContinua,
    required this.hintVisible,
    required this.onToggleHint,
  });

  @override
  Widget build(BuildContext context) {
    final hintEntry = legend.entries.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Il rebus della fibula', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Sofia riconosce l\'incisione sul retro della fibula: non sono '
          'decorazioni, sono simboli — ognuno al posto di una lettera. '
          'La legenda sotto ti dice solo cosa raffigura ogni simbolo: sta '
          'a te capire a quale parola italiana corrisponde, e prenderne '
          'la prima lettera. Nessuno ti dirà se hai letto giusto: solo tu '
          'puoi giudicarlo.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.surfaceVariant),
          ),
          child: Column(
            children: [
              Text('INCISIONE SULLA FIBULA',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted, fontSize: 11, letterSpacing: 1.5)),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 18,
                runSpacing: 12,
                children: rebusWords
                    .map((word) => Text(word, style: const TextStyle(fontSize: 26)))
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('LEGENDA',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMuted, fontSize: 11, letterSpacing: 1.5)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: legend.values
                .map((symbol) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(symbol.icon, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              symbol.caption,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton.icon(
            onPressed: onToggleHint,
            icon: const Icon(Icons.lightbulb_outline, size: 18),
            label: Text(hintVisible ? 'Nascondi esempio' : 'Come si legge un simbolo?'),
          ),
        ),
        if (hintVisible)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${hintEntry.value.icon}  →  "${hintEntry.value.word}"  →  '
              'la lettera nascosta è la prima: "${hintEntry.key}".',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.accentGold),
            ),
          ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: onContinua,
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('HO LETTO LA FRASE, PROSEGUI'),
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
