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

  Map<String, String> toJson() => {
    'userId': userId,
    'firstName': firstName,
    'role': role.name,
    'organization': ?organization,
  };

  static Session? fromJson(Map<String, Object?> json) {
    final role = UserRole.values
        .where((r) => r.name == json['role'])
        .firstOrNull;
    final id = json['userId'];
    final name = json['firstName'];
    if (role == null || id is! String || name is! String) return null;
    final org = json['organization'];
    return Session(
      userId: id,
      firstName: name,
      role: role,
      organization: org is String ? org : null,
    );
  }
}

/// Résultat d'une connexion par e-mail et mot de passe.
class LoginResult {
  const LoginResult({
    required this.session,
    required this.mustChangePassword,
    required this.needsPin,
    this.needsMfaCode = false,
    this.needsMfaEnrollment = false,
  });

  /// Identité ; `null` tant qu'une étape reste à franchir (code MFA, mot de passe temporaire).
  final Session? session;

  /// Mot de passe temporaire (RH, propriétaire) : il faut le changer.
  final bool mustChangePassword;

  /// Aucun PIN encore créé côté serveur.
  final bool needsPin;

  /// Code de l'application d'authentification attendu (comptes commerçant).
  final bool needsMfaCode;

  /// Double authentification à activer d'abord depuis l'espace web.
  final bool needsMfaEnrollment;

  bool get complete =>
      session != null &&
      !mustChangePassword &&
      !needsPin &&
      !needsMfaCode &&
      !needsMfaEnrollment;
}
