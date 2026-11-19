import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Build de démonstration : `--dart-define=FP_DEMO=true`.
///
/// Constante de compilation : en production (sans ce define), le code de démonstration
/// (fausses données, mots de passe libres, PIN 0000 refusé, réglages de démo) n'est pas branché
/// et disparaît du binaire au tree-shaking.
const bool kDemoBuild = bool.fromEnvironment('FP_DEMO');

/// Configuration d'exécution, lue depuis `--dart-define` (aucun secret dans le code).
class AppConfig {
  const AppConfig({required this.apiBaseUrl, required this.demo});

  /// Adresse de l'API, passée au build : `--dart-define=API_URL=…`
  /// (émulateur Android : `http://10.0.2.2:<port>` ; téléphone : IP du PC ou tunnel HTTPS).
  final String apiBaseUrl;

  /// Fausses données et fonctions de démonstration (préremplissage, réglages du catalogue…).
  final bool demo;

  factory AppConfig.fromEnvironment() => const AppConfig(
    apiBaseUrl: String.fromEnvironment('API_URL'),
    demo: kDemoBuild,
  );
}

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);
