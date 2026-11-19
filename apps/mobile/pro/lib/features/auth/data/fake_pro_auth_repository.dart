import 'package:fp_core/fp_core.dart';

import '../../../demo/pro_demo_backend.dart';

/// Connexion de démonstration : sami@… (caissier) ou carrefour@… (propriétaire).
class FakeProAuthRepository implements AuthRepository {
  FakeProAuthRepository(this._backend, this._store);

  final ProDemoBackend _backend;
  final SecureStore _store;

  Session _session(ProDemoAccount account) => switch (account) {
    ProDemoAccount.sami => const Session(
      userId: 'u-sami',
      firstName: 'Sami',
      role: UserRole.cashier,
      organization: ProDemoBackend.merchantName,
    ),
    ProDemoAccount.carrefour => const Session(
      userId: 'u-carrefour',
      firstName: 'Carrefour',
      role: UserRole.merchantOwner,
      organization: ProDemoBackend.merchantName,
    ),
  };

  @override
  Future<Session?> knownSession() async {
    final token = await _store.read(SecureKey.refreshToken);
    final name = token?.replaceFirst('demo-refresh-', '');
    final account = ProDemoAccount.values
        .where((a) => a.name == name)
        .firstOrNull;
    if (account == null) return null;
    _backend.account = account;
    return _session(account);
  }

  @override
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    final local = email.trim().toLowerCase().split('@').first;
    final account = ProDemoAccount.values
        .where((a) => a.name == local)
        .firstOrNull;
    if (account == null || password.isEmpty) throw const UnauthorizedFailure();
    _backend.account = account;
    await _store.write(SecureKey.accessToken, 'demo-access-${account.name}');
    await _store.write(SecureKey.refreshToken, 'demo-refresh-${account.name}');
    return LoginResult(
      session: _session(account),
      mustChangePassword: false,
      needsPin: false,
    );
  }

  @override
  Future<LoginResult> verifyMfa(String code) async =>
      throw const UnauthorizedFailure();

  @override
  Future<LoginResult> changePassword({required String newPassword}) async =>
      LoginResult(
        session: _session(_backend.account ?? ProDemoAccount.sami),
        mustChangePassword: false,
        needsPin: false,
      );

  @override
  Future<void> createPin(String pin) async {}

  @override
  Future<Session> verifyPin(String pin) async =>
      _session(_backend.account ?? ProDemoAccount.sami);

  @override
  Future<Session> unlockWithDevice() async =>
      _session(_backend.account ?? ProDemoAccount.sami);

  @override
  Future<void> logout() async {
    await _store.clearSession();
    _backend.account = null;
  }
}
