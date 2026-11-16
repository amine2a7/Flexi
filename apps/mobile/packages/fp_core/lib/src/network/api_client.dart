import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_api/fp_api.dart';

import '../config/app_config.dart';
import '../storage/secure_store.dart';

/// Ajoute le jeton d'accès. Le jeton n'est jamais journalisé.
class AuthTokenInterceptor extends Interceptor {
  AuthTokenInterceptor(this._store);

  final SecureStore _store;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _store.read(SecureKey.accessToken);
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }
}

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

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  dio.interceptors.add(AuthTokenInterceptor(ref.watch(secureStoreProvider)));
  return dio;
});

/// Client généré depuis le contrat OpenAPI (packages/fp_api).
final fpApiProvider = Provider<FpApi>(
  (ref) => FpApi(dio: ref.watch(dioProvider)),
);
