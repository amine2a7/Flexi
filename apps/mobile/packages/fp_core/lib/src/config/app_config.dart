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

  /// `--dart-define=FP_API_BASE_URL=https://…`
  final String apiBaseUrl;

  /// Fonctions de démonstration visibles (préremplissage, réglages du catalogue…).
  final bool demo;

  factory AppConfig.fromEnvironment() => const AppConfig(
    apiBaseUrl: String.fromEnvironment('FP_API_BASE_URL'),
    demo: kDemoBuild,
  );
}

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);
