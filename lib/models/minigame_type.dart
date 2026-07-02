/// Tipi di minigioco investigativo disponibili. Ogni capitolo può agganciare
/// un minigioco a una scena: il giocatore deve risolverlo per sbloccare un
/// indizio e proseguire, invece di limitarsi a leggere e scegliere.
enum MinigameType {
  /// Sblocco del telefono di Mauro tramite un codice a 4 cifre dedotto da
  /// un indizio già in possesso del giocatore.
  sbloccoTelefono,

  /// Confronto di impronte/tracce per trovare la coppia che corrisponde.
  confrontoImpronte,

  /// Analisi della mappa archeologica per individuare i punti alterati.
  analisiMappa,

  /// Ricostruzione cronologica degli eventi della notte del delitto.
  ricostruzioneTimeline,
}
