/// Rôle de la personne connectée ; pilote ce que l'app affiche.
enum UserRole {
  /// Salarié bénéficiaire (app FlexiPay).
  employee,

  /// Membre famille d'un salarié (app FlexiPay, accueil réduit).
  familyMember,

  /// Propriétaire du commerce (app Pro : tout).
  merchantOwner,

  /// Caissier (app Pro : Encaisser et sa journée uniquement).
  cashier,
}

/// Identité affichable de la session. Ne contient aucun secret.
class Session {
  const Session({
    required this.userId,
    required this.firstName,
    required this.role,
    this.organization,
  });

  final String userId;
  final String firstName;
  final UserRole role;

  /// Entreprise (bénéficiaire) ou commerce (Pro).
  final String? organization;

  bool get isOwner => role == UserRole.merchantOwner;
}

/// Résultat d'une connexion par e-mail et mot de passe.
class LoginResult {
  const LoginResult({
    required this.session,
    required this.mustChangePassword,
    required this.needsPin,
  });

  final Session session;

  /// Mot de passe temporaire (RH, propriétaire) : il faut le changer.
  final bool mustChangePassword;

  /// Aucun PIN encore créé côté serveur.
  final bool needsPin;
}
