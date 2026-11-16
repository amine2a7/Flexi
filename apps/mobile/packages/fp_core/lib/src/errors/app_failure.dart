import 'package:dio/dio.dart';

/// Erreurs métier et techniques remontées aux écrans.
///
/// Jamais de donnée sensible (PIN, mot de passe, token, solde complet) dans un message :
/// l'écran affiche une clé i18n, pas le texte du serveur.
sealed class AppFailure implements Exception {
  const AppFailure();
}

/// Pas de réseau, délai dépassé : l'écran passe en mode hors ligne.
final class NetworkFailure extends AppFailure {
  const NetworkFailure();
}

/// Session expirée ou identifiants invalides.
final class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure();
}

/// PIN refusé par le serveur ; [remainingAttempts] avant blocage.
final class PinRefusedFailure extends AppFailure {
  const PinRefusedFailure(this.remainingAttempts);
  final int remainingAttempts;
}

/// Compte bloqué après 3 PIN faux : paliers 15, 30, 60 min puis e-mail.
final class AccountLockedFailure extends AppFailure {
  const AccountLockedFailure({required this.lockedFor, required this.level});
  final Duration lockedFor;

  /// Palier de blocage (1 à 4).
  final int level;
}

/// Motifs de refus d'un paiement (codes du contrat).
enum RefusalReason {
  typeNotAccepted,
  insufficientFunds,
  merchantInactive,
  codeExpired,
}

/// Paiement refusé ; aucun montant n'a été débité.
final class PaymentRefusedFailure extends AppFailure {
  const PaymentRefusedFailure(this.reason, {this.missingMillimes});
  final RefusalReason reason;
  final int? missingMillimes;
}

/// Saisie refusée par le serveur.
final class ValidationFailure extends AppFailure {
  const ValidationFailure(this.messageKey);
  final String messageKey;
}

/// Toute autre erreur. Le détail technique n'est jamais affiché.
final class UnknownFailure extends AppFailure {
  const UnknownFailure();
}

/// Traduit une erreur Dio en [AppFailure] sans exposer le corps de la réponse.
AppFailure mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode ?? 0;
      if (status == 401) return const UnauthorizedFailure();
      return const UnknownFailure();
    default:
      return const UnknownFailure();
  }
}
