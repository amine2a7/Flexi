import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'session.dart';

/// Authentification côté serveur.
///
/// Le PIN et le mot de passe transitent vers le serveur et ne sont **jamais**
/// conservés sur le téléphone ; seuls des jetons vont dans [SecureStore].
abstract interface class AuthRepository {
  /// Session connue sur cet appareil (jetons valides), sans la déverrouiller.
  Future<Session?> knownSession();

  Future<LoginResult> login({required String email, required String password});

  Future<void> changePassword({required String newPassword});

  /// Envoie le PIN au serveur qui le hache ; rien n'est gardé localement.
  Future<void> createPin(String pin);

  /// Vérifie le PIN côté serveur. Lève `PinRefusedFailure` ou `AccountLockedFailure`.
  Future<Session> verifyPin(String pin);

  /// Déverrouille avec le jeton d'appareil, après une biométrie réussie.
  Future<Session> unlockWithDevice();

  Future<void> logout();
}

/// Fourni par chaque app (fausses données ou client API).
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) =>
      throw UnimplementedError('authRepositoryProvider doit être surchargé'),
);
