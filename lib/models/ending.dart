/// I quattro possibili finali della storia.
enum EndingType {
  buono,
  oscuro,
  perfetto,

  /// Raggiunto quando il giocatore accusa formalmente la persona sbagliata
  /// nel confronto finale: la vera colpevole resta libera.
  erroneo;

  String get titolo {
    switch (this) {
      case EndingType.buono:
        return "L'innocenza ritrovata";
      case EndingType.oscuro:
        return 'Il segreto custodito';
      case EndingType.perfetto:
        return 'La confessione sul fiume';
      case EndingType.erroneo:
        return 'Il nome sbagliato';
    }
  }

  String get sottotitolo {
    switch (this) {
      case EndingType.buono:
        return 'Finale buono';
      case EndingType.oscuro:
        return 'Finale oscuro';
      case EndingType.perfetto:
        return 'Finale perfetto';
      case EndingType.erroneo:
        return 'Finale mancato';
    }
  }

  /// Testo descrittivo del finale. Per [erroneo] contiene il segnaposto
  /// `{accusato}`, sostituito a runtime con il nome della persona accusata
  /// per errore (vedi `text_placeholders.dart`).
  String get descrizione {
    switch (this) {
      case EndingType.buono:
        return 'Segghy riesce a dimostrare la propria innocenza raccogliendo '
            'abbastanza indizi. Salva Manuela dal ricatto, recupera il '
            'reperto archeologico e decide di restare a Golasecca per '
            'trasformare il maneggio in un rifugio per cavalli e gattini.';
      case EndingType.oscuro:
        return 'Segghy scopre la verità su Sandra ma, colpita dalla sua '
            'storia, sceglie di proteggerla. Il caso si chiude come '
            'irrisolto: il Ticino custodisce ancora un segreto.';
      case EndingType.perfetto:
        return 'Il giocatore ha raccolto tutti gli indizi e mantenuto la '
            'fiducia dei personaggi giusti. Segghy salva Sofia, trova la '
            'prova decisiva e fa confessare Sandra davanti a Matteo, sulle '
            'rive del fiume.';
      case EndingType.erroneo:
        return 'Sulla riva del Ticino, davanti a tutti, Segghy punta il dito '
            'contro {accusato}. Ma le prove non reggono l\'accusa: senza una '
            'confessione vera, il caso si sgretola in aula prima ancora di '
            'aprirsi. {accusato} non le perdonerà mai quel momento. Sandra '
            'continua a servire caffè al bancone del suo bar, e il fascicolo '
            'si chiude senza un colpevole vero: il Ticino, ancora una volta, '
            'ha vinto lui.';
    }
  }
}
