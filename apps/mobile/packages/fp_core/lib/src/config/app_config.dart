import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Configuration d'exécution, lue depuis `--dart-define` (aucun secret dans le code).
class AppConfig {
  const AppConfig({required this.apiBaseUrl, required this.useFakeData});

  /// `--dart-define=FP_API_BASE_URL=https://…` ; vide tant que l'API n'est pas branchée.
  final String apiBaseUrl;

  /// Données de démonstration derrière les Repository (par défaut tant que l'API n'est pas branchée).
  final bool useFakeData;

  factory AppConfig.fromEnvironment() {
    const url = String.fromEnvironment('FP_API_BASE_URL');
    const fake = bool.fromEnvironment('FP_FAKE_DATA', defaultValue: true);
    return AppConfig(apiBaseUrl: url, useFakeData: fake || url.isEmpty);
  }
}

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);
