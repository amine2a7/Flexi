import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/app_failure.dart';
import 'auth_repository.dart';
import 'session.dart';

/// État d'authentification de l'app.
class AuthState {
  const AuthState({this.session, this.unlocked = false, this.lockedFor});

  /// Personne connue sur l'appareil (affichée sur « Bon retour, Yasmine »).
  final Session? session;

  /// `true` après PIN, biométrie ou connexion complète.
  final bool unlocked;

  /// Durée de blocage après 3 PIN faux (`null` si pas de blocage).
  final Duration? lockedFor;

  AuthState copyWith({Session? session, bool? unlocked, Duration? lockedFor}) =>
      AuthState(
        session: session ?? this.session,
        unlocked: unlocked ?? this.unlocked,
        lockedFor: lockedFor,
      );
}

/// Orchestration de la connexion. Ne garde jamais le PIN ni le mot de passe.
class AuthController extends Notifier<AuthState> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  AuthState build() => const AuthState();

  /// Recharge la session connue de l'appareil (sans la déverrouiller).
  Future<Session?> restore() async {
    final known = await _repo.knownSession();
    state = AuthState(session: known);
    return known;
  }

  Future<LoginResult> login(String email, String password) async {
    final result = await _repo.login(email: email, password: password);
    state = AuthState(
      session: result.session,
      unlocked: !result.mustChangePassword && !result.needsPin,
    );
    return result;
  }

  Future<void> changePassword(String newPassword) =>
      _repo.changePassword(newPassword: newPassword);

  Future<void> createPin(String pin) async {
    await _repo.createPin(pin);
    state = state.copyWith(unlocked: true);
  }

  /// Vérifie le PIN. Renvoie l'erreur à afficher, ou `null` si le PIN est bon.
  Future<AppFailure?> verifyPin(String pin) async {
    try {
      final session = await _repo.verifyPin(pin);
      state = AuthState(session: session, unlocked: true);
      return null;
    } on AccountLockedFailure catch (e) {
      state = state.copyWith(lockedFor: e.lockedFor);
      return e;
    } on AppFailure catch (e) {
      return e;
    }
  }

  Future<bool> unlockWithDevice() async {
    try {
      final session = await _repo.unlockWithDevice();
      state = AuthState(session: session, unlocked: true);
      return true;
    } on AppFailure {
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState();
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
