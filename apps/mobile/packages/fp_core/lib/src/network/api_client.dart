import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_api/fp_api.dart';

import '../auth/auth_controller.dart';
import '../config/app_config.dart';
import '../storage/secure_store.dart';

/// Clé d'idempotence (UUID v4) : une par opération financière, réutilisée en cas de nouvel essai.
String newIdempotencyKey() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}

/// Jetons de la session mobile.
///
/// Le jeton d'accès (15 min) reste **en mémoire** ; le jeton de renouvellement (usage unique,
/// rotation) est gardé dans le Keychain / Keystore. Aucun jeton n'est journalisé.
class TokenVault {
  TokenVault(this._store);

  final SecureStore _store;
  String? _access;

  String? get accessToken => _access;

  Future<String?> refreshToken() => _store.read(SecureKey.refreshToken);

  /// Garde les jetons d'une session ouverte ou renouvelée.
  Future<void> keep({
    required String accessToken,
    required String refreshToken,
  }) async {
    _access = accessToken;
    await _store.write(SecureKey.refreshToken, refreshToken);
  }

  /// Oublie la session (déconnexion, révocation, 401).
  Future<void> clear() async {
    _access = null;
    await _store.clearSession();
  }

  /// Identifiant aléatoire de l'appareil, créé une fois ; le serveur y lie la session.
  Future<String> deviceId() async {
    final known = await _store.read(SecureKey.deviceId);
    if (known != null) return known;
    final random = Random.secure();
    const alphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
    final id = List.generate(
      32,
      (_) => alphabet[random.nextInt(alphabet.length)],
    ).join();
    await _store.write(SecureKey.deviceId, id);
    return id;
  }
}

final tokenVaultProvider = Provider<TokenVault>(
  (ref) => TokenVault(ref.watch(secureStoreProvider)),
);

/// Appelé quand la session n'est plus valable (renouvellement refusé) : retour à la connexion.
final sessionExpiredProvider = Provider<void Function()>(
  (ref) =>
      () => ref.read(authControllerProvider.notifier).expire(),
);

/// Routes d'authentification : sans jeton d'accès, jamais renouvelées automatiquement.
bool _isAuthRoute(RequestOptions options) =>
    options.path.startsWith('/v1/mobile/auth/') &&
    !options.path.endsWith('/logout') &&
    !options.path.endsWith('/password/change');

/// Ajoute le jeton d'accès, le renouvelle une seule fois à la fois (rotation) et rejoue la
/// requête après un 401. Si le renouvellement est refusé, la session est oubliée et l'app
/// revient à la connexion.
class SessionInterceptor extends QueuedInterceptor {
  SessionInterceptor({
    required this.vault,
    required this.refresher,
    required this.retry,
    required this.onExpired,
  });

  final TokenVault vault;

  /// Renouvelle les jetons ; `false` si le serveur refuse (session révoquée ou expirée).
  final Future<bool> Function() refresher;

  /// Rejoue une requête (même Dio).
  final Future<Response<dynamic>> Function(RequestOptions) retry;
  final void Function() onExpired;

  static const _retried = 'fpRetried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isAuthRoute(options)) {
      // Après un redémarrage, seul le jeton de renouvellement est connu.
      if (vault.accessToken == null && await vault.refreshToken() != null) {
        try {
          await refresher();
        } on DioException catch (e) {
          handler.reject(e);
          return;
        }
      }
      final token = vault.accessToken;
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    if (err.response?.statusCode != 401 ||
        _isAuthRoute(options) ||
        options.extra[_retried] == true) {
      if (err.response?.statusCode == 401 && !_isAuthRoute(options)) {
        await vault.clear();
        onExpired();
      }
      handler.next(err);
      return;
    }
    final sent = options.headers['Authorization'];
    final current = vault.accessToken;
    // Un autre appel a déjà renouvelé pendant l'attente : on rejoue avec le nouveau jeton.
    bool renewed;
    try {
      renewed =
          (current != null && sent != 'Bearer $current') || await refresher();
    } on DioException catch (e) {
      handler.next(e);
      return;
    }
    if (!renewed) {
      await vault.clear();
      onExpired();
      handler.next(err);
      return;
    }
    options.extra[_retried] = true;
    options.headers['Authorization'] = 'Bearer ${vault.accessToken}';
    try {
      handler.resolve(await retry(options));
    } on DioException catch (again) {
      handler.next(again);
    }
  }
}

/// Renouvellement à usage unique : un seul appel en vol à la fois.
class SessionRefresher {
  SessionRefresher(this._vault, this._plain);

  final TokenVault _vault;
  final Dio _plain;
  Future<bool>? _inFlight;

  Future<bool> call() => _inFlight ??= _refresh().whenComplete(() {
    _inFlight = null;
  });

  Future<bool> _refresh() async {
    final token = await _vault.refreshToken();
    if (token == null) return false;
    try {
      final response = await _plain.post<Map<String, dynamic>>(
        '/v1/mobile/auth/refresh',
        data: {'refreshToken': token, 'deviceId': await _vault.deviceId()},
      );
      final body = response.data!;
      await _vault.keep(
        accessToken: body['accessToken'] as String,
        refreshToken: body['refreshToken'] as String,
      );
      return true;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      // Refus explicite : la session est terminée. Coupure réseau : on garde le jeton.
      if (status == 401 || status == 400) {
        await _vault.clear();
        return false;
      }
      rethrow;
    }
  }
}

BaseOptions _options(AppConfig config) => BaseOptions(
  baseUrl: config.apiBaseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 20),
  sendTimeout: const Duration(seconds: 15),
);

/// Transport HTTP de l'API, remplaçable dans les tests (faux serveur).
final httpAdapterProvider = Provider<HttpClientAdapter?>((ref) => null);

final sessionRefresherProvider = Provider<SessionRefresher>((ref) {
  final plain = Dio(_options(ref.watch(appConfigProvider)));
  final adapter = ref.watch(httpAdapterProvider);
  if (adapter != null) plain.httpClientAdapter = adapter;
  return SessionRefresher(ref.watch(tokenVaultProvider), plain);
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(_options(ref.watch(appConfigProvider)));
  final adapter = ref.watch(httpAdapterProvider);
  if (adapter != null) dio.httpClientAdapter = adapter;
  final refresher = ref.watch(sessionRefresherProvider);
  dio.interceptors.add(
    SessionInterceptor(
      vault: ref.watch(tokenVaultProvider),
      refresher: refresher.call,
      retry: dio.fetch,
      onExpired: () => ref.read(sessionExpiredProvider)(),
    ),
  );
  return dio;
});

/// Client généré depuis le contrat OpenAPI (packages/fp_api).
final fpApiProvider = Provider<FpApi>(
  (ref) => FpApi(dio: ref.watch(dioProvider), interceptors: const []),
);
