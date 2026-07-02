import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Minigioco: sbloccare il telefono di Mauro componendo un codice a 4
/// cifre, dedotto da un indizio raccolto poco prima nella stessa scena.
class PhoneUnlockMinigame extends StatefulWidget {
  final VoidCallback onSolved;

  const PhoneUnlockMinigame({super.key, required this.onSolved});

  static const String _codice = '0919';

  @override
  State<PhoneUnlockMinigame> createState() => _PhoneUnlockMinigameState();
}

class _PhoneUnlockMinigameState extends State<PhoneUnlockMinigame>
    with SingleTickerProviderStateMixin {
  String _input = '';
  String? _errore;
  bool _hintVisibile = false;
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
    if (_input == PhoneUnlockMinigame._codice) {
      widget.onSolved();
    } else {
      _shakeController.forward(from: 0);
      setState(() {
        _errore = 'Codice errato. Riprova.';
        _input = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Sblocca il telefono', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Un codice a 4 cifre protegge il telefono di Mauro. Kledian ricorda '
          'un dettaglio sull\'ultima manutenzione dell\'auto...',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            final t = _shakeController.value;
            final dx = (t == 0 || t == 1) ? 0.0 : (8 * (0.5 - (t * 4).remainder(1)).sign);
            return Transform.translate(offset: Offset(dx, 0), child: child);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final filled = i < _input.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 44,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _errore != null
                        ? AppColors.accentBlood
                        : AppColors.accentGold.withValues(alpha: 0.6),
                  ),
                ),
                child: Text(
                  filled ? _input[i] : '',
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
            _errore ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.accentBlood, fontSize: 13),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton.icon(
            onPressed: () => setState(() => _hintVisibile = !_hintVisibile),
            icon: const Icon(Icons.lightbulb_outline, size: 18),
            label: Text(_hintVisibile ? 'Nascondi suggerimento' : 'Suggerimento'),
          ),
        ),
        if (_hintVisibile)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Il registro dell\'officina segna: "ultimo tagliando 19/09".',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.accentGold),
            ),
          ),
        const SizedBox(height: 8),
        _Keypad(onDigit: _addDigit, onBackspace: _removeDigit),
      ],
    );
  }
}

class _Keypad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  const _Keypad({required this.onDigit, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: keys.map((k) {
        if (k.isEmpty) return const SizedBox.shrink();
        return Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => k == '⌫' ? onBackspace() : onDigit(k),
            child: Center(
              child: Text(k, style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
        );
      }).toList(),
    );
  }
}
