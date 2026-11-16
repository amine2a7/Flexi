import 'package:flutter/widgets.dart';
import 'package:fp_core/fp_core.dart';
import 'package:intl/intl.dart';

/// Formats de date de l'app (locale courante), sans aucune chaîne en dur.
class Dates {
  Dates(BuildContext context, this.now)
    : l10n = FpL10n.of(context),
      locale = Localizations.localeOf(context).toLanguageTag();

  final FpL10n l10n;
  final String locale;
  final DateTime now;

  static String capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  /// « 12:41 »
  String time(DateTime d) => DateFormat.Hm(locale).format(d);

  /// « Aujourd’hui 12:41 », « Hier 19:20 », « Jeu. 18:05 », sinon « 14 nov. ».
  String relative(DateTime d, {bool withTime = true}) {
    final t = withTime ? ' ${time(d)}' : '';
    if (isSameDay(d, now)) return '${l10n.today}$t';
    if (isSameDay(d, now.subtract(const Duration(days: 1)))) {
      return '${l10n.yesterday}$t';
    }
    if (now.difference(d).inDays < 7) {
      return '${capitalize(DateFormat.E(locale).format(d))}$t';
    }
    return DateFormat('d MMM', locale).format(d);
  }

  /// En-tête de groupe : « Aujourd’hui », « Jeudi 12 novembre ».
  String dayHeader(DateTime d) => isSameDay(d, now)
      ? l10n.today
      : capitalize(DateFormat('EEEE d MMMM', locale).format(d));

  /// « 14 déc. »
  String shortDate(DateTime d) => DateFormat('d MMM', locale).format(d);

  /// « 14 nov. 2026, 12:41 »
  String longDateTime(DateTime d) =>
      '${DateFormat('d MMM y', locale).format(d)}, ${time(d)}';

  /// « 14/12/2026 »
  String numeric(DateTime d) => DateFormat('dd/MM/y', locale).format(d);

  /// « 31/12 »
  String dayMonth(DateTime d) => DateFormat('dd/MM', locale).format(d);

  /// « novembre »
  String month(DateTime d) => DateFormat.MMMM(locale).format(d);

  /// « mardi »
  String weekdayName(DateTime d) => DateFormat.EEEE(locale).format(d);

  /// Lettre du jour de la semaine (« L », « M »…).
  String weekdayLetter(DateTime d) => DateFormat.EEEEE(locale).format(d);
}

/// Initiale(s) d'un commerce pour les pastilles : « C », « EM ».
String tileInitials(String name) {
  final words = name.trim().split(RegExp(r'\s+'));
  if (words.length > 1) return (words[0][0] + words[1][0]).toUpperCase();
  return words.first[0].toUpperCase();
}

/// Deux lettres pour les grandes vignettes de Découvrir : « CA », « SE ».
String bigInitials(String name) {
  final words = name.trim().split(RegExp(r'\s+'));
  if (words.length > 1) return (words[0][0] + words[1][0]).toUpperCase();
  return words.first.substring(0, words.first.length.clamp(0, 2)).toUpperCase();
}

/// « a, b ou c » selon la langue.
String joinOr(FpL10n l10n, List<String> items) {
  if (items.isEmpty) return '';
  if (items.length == 1) return items.first;
  final head = items.sublist(0, items.length - 1).join(', ');
  return l10n.listOr(head, items.last);
}

/// « a et b » selon la langue.
String joinAnd(FpL10n l10n, List<String> items) {
  if (items.isEmpty) return '';
  if (items.length == 1) return items.first;
  final head = items.sublist(0, items.length - 1).join(', ');
  return l10n.listAnd(head, items.last);
}

/// Élision française devant une voyelle (« d’Adam »).
String elide(String name) =>
    RegExp(r'^[aeiouyhâàéèêîïôûAEIOUYHÂÀÉÈÊÎÏÔÛ]').hasMatch(name)
    ? 'yes'
    : 'no';
