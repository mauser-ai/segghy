import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class _TimelineEvent {
  final String testo;
  final int ordine;
  const _TimelineEvent(this.testo, this.ordine);
}

/// Minigioco: ricostruire l'ordine cronologico corretto degli eventi della
/// notte del delitto. Niente orari scritti sulle tessere: ogni tessera
/// rimanda testualmente a quella precedente ("poco dopo...", "quando
/// ormai...", "subito dopo..."), quindi va risolto seguendo i rimandi
/// logici tra le testimonianze, non semplicemente leggendo un numero.
class TimelineMinigame extends StatefulWidget {
  final VoidCallback onSolved;

  const TimelineMinigame({super.key, required this.onSolved});

  @override
  State<TimelineMinigame> createState() => _TimelineMinigameState();
}

class _TimelineMinigameState extends State<TimelineMinigame> {
  static const List<_TimelineEvent> _eventiInOrdine = [
    _TimelineEvent(
      'Segghy arriva alla festa con il ciondolo ancora al collo, '
      'mentre la musica è appena iniziata.',
      0,
    ),
    _TimelineEvent(
      'Poco dopo l\'arrivo di Segghy, Mauro riceve un messaggio sul '
      'telefono e si allontana verso la serra.',
      1,
    ),
    _TimelineEvent(
      'Con Mauro ormai scomparso verso la serra da un pezzo, la '
      'catenina di Segghy si rompe mentre porta delle casse in cantina.',
      2,
    ),
    _TimelineEvent(
      'Quando in giardino restano ormai pochi ospiti, un campanello '
      'di bicicletta tintinna vicino al cancello sul retro.',
      3,
    ),
    _TimelineEvent(
      'Subito dopo, un urlo squarcia il silenzio: qualcuno ha trovato '
      'Mauro a terra nella serra.',
      4,
    ),
  ];

  late List<_TimelineEvent> _ordine;
  String? _messaggio;

  @override
  void initState() {
    super.initState();
    _ordine = List.of(_eventiInOrdine)..shuffle(math.Random(DateTime.now().millisecond));
    // Evita che il mescolamento produca per caso l'ordine già corretto.
    if (_isCorrect()) _ordine.shuffle(math.Random(DateTime.now().microsecond + 7));
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
      setState(() => _messaggio = 'Uno dei rimandi non torna ancora. Rileggi con attenzione e riprova.');
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
          'Nessuna testimonianza riporta un orario preciso: ognuna rimanda a '
          'quella immediatamente precedente ("poco dopo...", "quando '
          'ormai..."). Leggile tutte, poi trascinale nell\'ordine giusto.',
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
          height: 32,
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
