import 'package:fp_core/fp_core.dart';

import '../../../demo/demo_backend.dart';

/// Authentification de démonstration. Les jetons vont dans le stockage sécurisé ;
/// le PIN et le mot de passe ne sont jamais conservés.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(this._backend, this._store);

  final DemoBackend _backend;
  final SecureStore _store;

  static const _lockSteps = [
    Duration(minutes: 15),
    Duration(minutes: 30),
    Duration(minutes: 60),
  ];

  Session _session(DemoAccount account) => switch (account) {
    DemoAccount.yasmine => const Session(
      userId: 'u-yasmine',
      firstName: 'Yasmine',
      role: UserRole.employee,
      organization: DemoBackend.company,
    ),
    DemoAccount.omar => const Session(
      userId: 'u-omar',
      firstName: 'Omar',
      role: UserRole.employee,
      organization: DemoBackend.company,
    ),
    DemoAccount.adam => const Session(
      userId: 'u-adam',
      firstName: 'Adam',
      role: UserRole.familyMember,
      organization: 'Yasmine',
    ),
  };

  @override
  Future<Session?> knownSession() async {
    final token = await _store.read(SecureKey.refreshToken);
    final name = token?.replaceFirst('demo-refresh-', '');
    final account = DemoAccount.values.where((a) => a.name == name).firstOrNull;
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
    final account = DemoAccount.values
        .where((a) => a.name == local)
        .firstOrNull;
    if (account == null || password.isEmpty) throw const UnauthorizedFailure();
    _backend
      ..account = account
      ..failedPins = 0;
    await _store.write(SecureKey.accessToken, 'demo-access-${account.name}');
    await _store.write(SecureKey.refreshToken, 'demo-refresh-${account.name}');
    final firstLogin = account == DemoAccount.yasmine;
    return LoginResult(
      session: _session(account),
      mustChangePassword: firstLogin,
      needsPin: firstLogin,
    );
  }

  @override
  Future<void> changePassword({required String newPassword}) async {}

  @override
  Future<void> createPin(String pin) async {
    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      throw const ValidationFailure('pinFormat');
    }
  }

  @override
  Future<Session> verifyPin(String pin) async {
    final account = _backend.account ?? DemoAccount.yasmine;
    if (pin != DemoBackend.refusedDemoPin) {
      _backend.failedPins = 0;
      return _session(account);
    }
    _backend.failedPins++;
    if (_backend.failedPins >= 3) {
      final level = ((_backend.failedPins ~/ 3) - 1).clamp(0, 2);
      throw AccountLockedFailure(
        lockedFor: _lockSteps[level],
        level: level + 1,
      );
    }
    throw PinRefusedFailure(3 - _backend.failedPins);
  }

  @override
  Future<Session> unlockWithDevice() async {
    final token = await _store.read(SecureKey.refreshToken);
    if (token == null) throw const UnauthorizedFailure();
    return _session(_backend.account ?? DemoAccount.yasmine);
  }

  @override
  Future<void> logout() async {
    await _store.clearSession();
    _backend.account = null;
  }
}
