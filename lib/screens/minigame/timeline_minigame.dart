import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class _TimelineEvent {
  final String testo;
  final int ordine;
  const _TimelineEvent(this.testo, this.ordine);
}

/// Minigioco: ricostruire in ordine cronologico corretto gli eventi della
/// notte del delitto, trascinando le tessere per riordinarle.
class TimelineMinigame extends StatefulWidget {
  final VoidCallback onSolved;

  const TimelineMinigame({super.key, required this.onSolved});

  @override
  State<TimelineMinigame> createState() => _TimelineMinigameState();
}

class _TimelineMinigameState extends State<TimelineMinigame> {
  static const List<_TimelineEvent> _eventiInOrdine = [
    _TimelineEvent('20:30 — Segghy arriva alla festa con il ciondolo al collo', 0),
    _TimelineEvent('22:10 — Mauro riceve un messaggio e si allontana verso la serra', 1),
    _TimelineEvent('22:40 — Il campanello di una bicicletta tintinna vicino al cancello sul retro', 2),
    _TimelineEvent('23:05 — La catenina di Segghy si rompe mentre porta le casse in cantina', 3),
    _TimelineEvent('23:20 — Un urlo arriva dalla serra: Mauro viene trovato morto', 4),
  ];

  late List<_TimelineEvent> _ordine;
  String? _messaggio;

  @override
  void initState() {
    super.initState();
    _ordine = List.of(_eventiInOrdine)..shuffle(math.Random(DateTime.now().millisecond));
    // Evita che il mescolamento produca per caso l'ordine già corretto.
    if (_isCorrect()) _ordine = _ordine.reversed.toList();
  }

  bool _isCorrect() {
    for (int i = 0; i < _ordine.length; i++) {
      if (_ordine[i].ordine != i) return false;
    }
    return true;
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      _messaggio = null;
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _ordine.removeAt(oldIndex);
      _ordine.insert(newIndex, item);
    });
  }

  void _confirm() {
    if (_isCorrect()) {
      widget.onSolved();
    } else {
      setState(() => _messaggio = 'L\'ordine non torna ancora. Riprova.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Ricostruisci la cronologia',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Tieni premuto e trascina le tessere per rimetterle nell\'ordine '
          'cronologico corretto della notte del delitto.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: _onReorder,
          children: [
            for (int i = 0; i < _ordine.length; i++)
              Card(
                key: ValueKey(_ordine[i].ordine),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.surfaceHigh,
                    child: Icon(Icons.drag_indicator,
                        color: AppColors.accentGold, size: 18),
                  ),
                  title: Text(_ordine[i].testo,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 20,
          child: Text(
            _messaggio ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.accentBlood, fontSize: 13),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _confirm,
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('CONFERMA ORDINE'),
        ),
      ],
    );
  }
}
