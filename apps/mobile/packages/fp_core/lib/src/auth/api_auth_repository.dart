import 'dart:convert';

import '../errors/app_failure.dart';
import '../network/api_client.dart';
import '../network/api_json.dart';
import '../storage/secure_store.dart';
import 'auth_repository.dart';
import 'session.dart';

/// Application qui se connecte : seuls ses rôles sont acceptés.
enum FlexiApp {
  /// FlexiPay : salarié bénéficiaire ou membre famille, PIN de paiement.
  beneficiary({UserRole.employee, UserRole.familyMember}),

  /// FlexiPay Pro : propriétaire du commerce ou caissier.
  pro({UserRole.merchantOwner, UserRole.cashier});

  const FlexiApp(this.roles);
  final Set<UserRole> roles;
}

/// Connexion mobile sur l'API (`/v1/mobile/auth/*`) : jeton d'accès en mémoire, jeton de
/// renouvellement dans le Keychain / Keystore, session liée à l'appareil, révoquée à la
/// déconnexion. Le mot de passe et le PIN ne font que passer.
class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this.app, this._api, this._vault, this._store);

  final FlexiApp app;
  final ApiJson _api;
  final TokenVault _vault;
  final SecureStore _store;

  /// Défi MFA en cours (5 min, usage unique), jamais stocké.
  String? _challengeId;

  /// PIN faux consécutifs depuis le dernier bon : le serveur bloque au 3e.
  int _pinFailures = 0;

  @override
  Future<Session?> knownSession() async {
    if (await _vault.refreshToken() == null) return null;
    final raw = await _store.read(SecureKey.sessionProfile);
    if (raw == null) return null;
    final decoded = jsonDecode(raw);
    return decoded is Map ? Session.fromJson(decoded.cast()) : null;
  }

  @override
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    await _vault.clear();
    final body = await _api.post(
      '/v1/mobile/auth/login',
      body: {
        'identifier': email.trim(),
        'password': password,
        'deviceId': await _vault.deviceId(),
      },
    );
    if (body['nextStep'] == 'MFA_CHALLENGE') {
      _challengeId = body['challengeId'] as String?;
      return const LoginResult(
        session: null,
        mustChangePassword: false,
        needsPin: false,
        needsMfaCode: true,
      );
    }
    return _opened(body);
  }

  @override
  Future<LoginResult> verifyMfa(String code) async {
    final challenge = _challengeId;
    if (challenge == null) throw const UnauthorizedFailure();
    final body = await _api.post(
      '/v1/mobile/auth/mfa/verify',
      body: {
        'challengeId': challenge,
        'code': code,
        'deviceId': await _vault.deviceId(),
      },
    );
    _challengeId = null;
    return _opened(body);
  }

  @override
  Future<LoginResult> changePassword({required String newPassword}) async {
    final body = await _api.post(
      '/v1/mobile/auth/password/change',
      body: {'newPassword': newPassword},
    );
    return _opened(body);
  }

  /// Garde les jetons puis lit l'identité si la session est complète.
  Future<LoginResult> _opened(Json body) async {
    await _vault.keep(
      accessToken: body['accessToken'] as String,
      refreshToken: body['refreshToken'] as String,
    );
    switch (body['nextStep']) {
      case 'PASSWORD_CHANGE':
        return const LoginResult(
          session: null,
          mustChangePassword: true,
          needsPin: false,
        );
      case 'MFA_ENROLL':
        await _revoke();
        return const LoginResult(
          session: null,
          mustChangePassword: false,
          needsPin: false,
          needsMfaEnrollment: true,
        );
      case 'NONE':
        break;
      default:
        // Étape inconnue (liste extensible) : retour à la connexion.
        await _revoke();
        throw const UnauthorizedFailure();
    }
    final session = await _identity();
    var needsPin = false;
    if (app == FlexiApp.beneficiary) {
      final profile = await _api.get('/v1/employee/profile');
      needsPin = profile['pinSet'] != true;
    }
    _pinFailures = 0;
    return LoginResult(
      session: session,
      mustChangePassword: false,
      needsPin: needsPin,
    );
  }

  /// `GET /v1/me` : prénom, rôle et organisation ; refuse un compte d'une autre app.
  Future<Session> _identity() async {
    final me = await _api.get('/v1/me');
    final role = switch ((me['role'], me['subRole'])) {
      ('EMPLOYEE', _) => UserRole.employee,
      ('FAMILY_MEMBER', _) => UserRole.familyMember,
      ('MERCHANT', 'CASHIER') => UserRole.cashier,
      ('MERCHANT', _) => UserRole.merchantOwner,
      _ => null,
    };
    if (role == null || !app.roles.contains(role)) {
      await _revoke();
      throw const UnauthorizedFailure();
    }
    final display = (me['displayName'] as String? ?? '').trim();
    final tenant = me['tenant'];
    final session = Session(
      userId: me['id'] as String? ?? '',
      firstName: display.split(' ').first,
      role: role,
      organization: tenant is Map ? tenant['label'] as String? : null,
    );
    await _store.write(SecureKey.sessionProfile, jsonEncode(session.toJson()));
    return session;
  }

  @override
  Future<void> createPin(String pin) async {
    try {
      await _api.post('/v1/employee/pin', body: {'newPin': pin});
    } on ApiProblemFailure catch (e) {
      // PIN trop simple (0000, 1234…) : refusé par le serveur.
      if (e.code == 'VALIDATION_FAILED') {
        throw const ValidationFailure('pinWeak');
      }
      rethrow;
    }
  }

  @override
  Future<Session> verifyPin(String pin) async {
    try {
      await _api.post('/v1/employee/pin/verify', body: {'pin': pin});
    } on ApiProblemFailure catch (e) {
      if (e.code != 'PIN_INVALID') rethrow;
      throw _pinRefusal(e.details);
    }
    _pinFailures = 0;
    return await knownSession() ?? await _identity();
  }

  /// Même réponse pour un PIN faux ou bloqué ; le délai restant dit le palier (15/30/60).
  AppFailure _pinRefusal(Map<String, Object?> details) {
    if (details['reauthenticationRequired'] == true) {
      _pinFailures = 0;
      return const AccountLockedFailure(lockedFor: Duration.zero, level: 4);
    }
    final seconds = intOf(details['retryAfterSeconds']);
    if (seconds > 0) {
      _pinFailures = 0;
      final level = seconds <= 15 * 60
          ? 1
          : seconds <= 30 * 60
          ? 2
          : 3;
      return AccountLockedFailure(
        lockedFor: Duration(seconds: seconds),
        level: level,
      );
    }
    _pinFailures++;
    return PinRefusedFailure((3 - _pinFailures).clamp(1, 3));
  }

  @override
  Future<Session> unlockWithDevice() async {
    final known = await knownSession();
    if (known == null) throw const UnauthorizedFailure();
    // Le jeton de renouvellement prouve l'appareil : un appel authentifié le fait tourner.
    await _api.get('/v1/me');
    return known;
  }

  @override
  Future<void> logout() async {
    await _revoke();
  }

  /// Révocation côté serveur (au mieux), puis oubli local des jetons dans tous les cas.
  Future<void> _revoke() async {
    try {
      if (_vault.accessToken != null || await _vault.refreshToken() != null) {
        await _api.post('/v1/mobile/auth/logout');
      }
    } on AppFailure {
      // Hors ligne ou déjà révoquée : le jeton est quand même oublié sur le téléphone.
    } finally {
      _challengeId = null;
      await _vault.clear();
    }
  }
}
