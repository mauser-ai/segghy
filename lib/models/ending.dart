/// I tre possibili finali della storia. Si raggiungono tutti solo dopo aver
/// individuato correttamente Sandra come colpevole nel confronto finale:
/// un'accusa sbagliata non chiude la partita, ma riporta il giocatore a
/// scegliere di nuovo (vedi `GameProvider.submitAccusation`).
enum EndingType {
  buono,
  oscuro,
  perfetto;

  String get titolo {
    switch (this) {
      case EndingType.buono:
        return "L'innocenza ritrovata";
      case EndingType.oscuro:
        return 'Il segreto custodito';
      case EndingType.perfetto:
        return 'La confessione sul fiume';
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
    }
  }

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
    }
  }
}
