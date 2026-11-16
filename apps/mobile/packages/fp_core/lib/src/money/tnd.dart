/// Seul point de formatage des montants FlexiPay.
///
/// Les montants circulent partout en **millimes entiers** (1 TND = 1 000 millimes).
/// Aucun `double` n'est utilisé : la conversion est faite par division entière.
abstract final class Tnd {
  /// Nombre de millimes dans un dinar.
  static const int millimesPerDinar = 1000;

  /// Signe moins typographique (U+2212), utilisé par le prototype.
  static const String minus = '−';

  /// Espace insécable fine pour séparer les milliers (« 1 250,000 »).
  static const String groupSeparator = ' ';

  /// Formate [millimes] : « 57,500 TND ».
  ///
  /// * [currency] : libellé de la devise (« TND », « د.ت ») ; `null` pour le nombre seul.
  /// * [signed] : préfixe « + » ou « − » (activité, mouvements).
  /// * [compact] : « 200 » au lieu de « 200,000 » quand le montant tombe sur un dinar entier.
  static String format(
    int millimes, {
    String? currency = 'TND',
    bool signed = false,
    bool compact = false,
  }) {
    final negative = millimes < 0;
    final abs = negative ? -millimes : millimes;
    final dinars = abs ~/ millimesPerDinar;
    final rest = abs % millimesPerDinar;

    final buffer = StringBuffer();
    if (negative) {
      buffer.write(minus);
    } else if (signed && abs > 0) {
      buffer.write('+');
    }
    buffer.write(_group(dinars));
    if (!(compact && rest == 0)) {
      buffer
        ..write(',')
        ..write(rest.toString().padLeft(3, '0'));
    }
    if (currency != null) {
      buffer
        ..write(' ')
        ..write(currency);
    }
    return buffer.toString();
  }

  /// Convertit des dinars entiers en millimes (constantes, données de démonstration).
  static int dinars(int value) => value * millimesPerDinar;

  /// Lit une saisie utilisateur « 57,500 », « 57.5 » ou « 57 » et renvoie des millimes.
  /// Renvoie `null` si la saisie n'est pas un montant valide (plus de 3 décimales…).
  static int? parse(String input) {
    final cleaned = input
        .replaceAll(groupSeparator, '')
        .replaceAll(' ', '')
        .replaceAll('.', ',')
        .trim();
    final match = RegExp(r'^(\d{1,9})(?:,(\d{0,3}))?$').firstMatch(cleaned);
    if (match == null) return null;
    final whole = int.parse(match.group(1)!);
    final decimals = (match.group(2) ?? '').padRight(3, '0');
    return whole * millimesPerDinar + int.parse(decimals);
  }

  static String _group(int value) {
    final digits = value.toString();
    final out = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) out.write(groupSeparator);
      out.write(digits[i]);
    }
    return out.toString();
  }
}
