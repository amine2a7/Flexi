import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Clés autorisées dans le stockage sécurisé.
///
/// Uniquement des jetons et des préférences non sensibles :
/// **jamais de PIN ni de mot de passe** sur le téléphone.
enum SecureKey { accessToken, refreshToken, deviceToken, onboardingDone }

/// Stockage chiffré (Keychain iOS, Keystore Android).
abstract interface class SecureStore {
  Future<String?> read(SecureKey key);
  Future<void> write(SecureKey key, String value);
  Future<void> delete(SecureKey key);
  Future<void> clearSession();
}

class FlutterSecureStore implements SecureStore {
  FlutterSecureStore([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(SecureKey key) => _storage.read(key: key.name);

  @override
  Future<void> write(SecureKey key, String value) =>
      _storage.write(key: key.name, value: value);

  @override
  Future<void> delete(SecureKey key) => _storage.delete(key: key.name);

  @override
  Future<void> clearSession() async {
    await delete(SecureKey.accessToken);
    await delete(SecureKey.refreshToken);
    await delete(SecureKey.deviceToken);
  }
}

/// Implémentation en mémoire pour les tests.
class MemorySecureStore implements SecureStore {
  MemorySecureStore([Map<SecureKey, String>? initial])
    : _values = {...?initial};

  final Map<SecureKey, String> _values;

  @override
  Future<String?> read(SecureKey key) async => _values[key];

  @override
  Future<void> write(SecureKey key, String value) async => _values[key] = value;

  @override
  Future<void> delete(SecureKey key) async => _values.remove(key);

  @override
  Future<void> clearSession() async {
    _values
      ..remove(SecureKey.accessToken)
      ..remove(SecureKey.refreshToken)
      ..remove(SecureKey.deviceToken);
  }
}

final secureStoreProvider = Provider<SecureStore>(
  (ref) => FlutterSecureStore(),
);
