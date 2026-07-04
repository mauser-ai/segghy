import '../../providers/game_provider.dart';

/// Sostituisce il segnaposto `{accusato}` con il nome del personaggio
/// formalmente accusato nel confronto finale, se presente. Usato sia dal
/// testo narrativo della scena di finale errato sia dalla descrizione di
/// [EndingType.erroneo], che sono scritti in modo generico proprio per
/// poter essere personalizzati con qualunque sospettato scelto dal
/// giocatore.
String personalizeText(String text, GameProvider provider) {
  final accusato = provider.accusedCharacter;
  if (accusato == null) return text;
  return text.replaceAll('{accusato}', accusato.nome);
}
