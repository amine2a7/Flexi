import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Langues proposées : français (défaut), arabe (RTL), anglais.
const supportedAppLocales = [Locale('fr'), Locale('ar'), Locale('en')];

/// Langue choisie dans Profil › Langue.
class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => const Locale('fr');

  void select(Locale locale) => state = locale;
}

final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

/// `true` pour l'arabe : les écrans passent de droite à gauche.
bool isRtl(Locale locale) => locale.languageCode == 'ar';
