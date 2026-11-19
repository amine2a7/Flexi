import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/app_failure.dart';
import 'api_client.dart';

typedef Json = Map<String, dynamic>;

/// Appels JSON de l'API (contrat OpenAPI) avec les erreurs traduites en [AppFailure] :
/// coupure réseau, 401, ou problème RFC 9457 avec son code. Aucun corps n'est journalisé.
class ApiJson {
  ApiJson(this._dio);

  final Dio _dio;

  Options _options(String? idempotencyKey) =>
      Options(headers: {'Idempotency-Key': ?idempotencyKey});

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Json> get(String path, {Map<String, Object?>? query}) => _guard(
    () async =>
        (await _dio.get<Json>(path, queryParameters: query)).data ?? const {},
  );

  Future<Json> post(String path, {Object? body, String? idempotencyKey}) =>
      _guard(
        () async =>
            (await _dio.post<Json>(
              path,
              data: body,
              options: _options(idempotencyKey),
            )).data ??
            const {},
      );

  /// Multipart (`multipart/form-data`) : champs texte et un fichier facultatif (W-SUP).
  Future<Json> postForm(
    String path, {
    required Map<String, String> fields,
    String? fileField,
    Uint8List? fileBytes,
    String? fileName,
    String? fileType,
  }) => _guard(() async {
    final form = FormData.fromMap(fields);
    if (fileField != null && fileBytes != null) {
      form.files.add(
        MapEntry(
          fileField,
          MultipartFile.fromBytes(
            fileBytes,
            filename: fileName,
            contentType: fileType == null ? null : DioMediaType.parse(fileType),
          ),
        ),
      );
    }
    return (await _dio.post<Json>(path, data: form)).data ?? const {};
  });

  Future<Json> put(String path, {Object? body}) =>
      _guard(() async => (await _dio.put<Json>(path, data: body)).data ?? {});

  Future<Json> delete(String path, {String? idempotencyKey}) => _guard(
    () async =>
        (await _dio.delete<Json>(
          path,
          options: _options(idempotencyKey),
        )).data ??
        const {},
  );

  Future<Uint8List> bytes(String path) => _guard(() async {
    final response = await _dio.get<List<int>>(
      path,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data ?? const []);
  });

  /// Server-Sent Events : chaque `data:` d'un événement, décodé en JSON. Le flux se ferme
  /// quand on annule l'abonnement.
  Stream<Json> events(String path) {
    final cancel = CancelToken();
    late final StreamController<Json> controller;
    controller = StreamController<Json>(
      onListen: () async {
        try {
          final response = await _dio.get<ResponseBody>(
            path,
            cancelToken: cancel,
            options: Options(
              responseType: ResponseType.stream,
              receiveTimeout: Duration.zero,
              headers: {'Accept': 'text/event-stream'},
            ),
          );
          final lines = response.data!.stream
              .cast<List<int>>()
              .transform(utf8.decoder)
              .transform(const LineSplitter());
          final data = StringBuffer();
          await for (final line in lines) {
            if (line.startsWith('data:')) {
              data.write(line.substring(5).trimLeft());
            } else if (line.isEmpty && data.isNotEmpty) {
              final decoded = jsonDecode(data.toString());
              data.clear();
              if (decoded is Json) controller.add(decoded);
            }
          }
        } on DioException catch (e) {
          if (!CancelToken.isCancel(e)) controller.addError(mapDioException(e));
        } on FormatException {
          controller.addError(const UnknownFailure());
        }
        await controller.close();
      },
      onCancel: () => cancel.cancel(),
    );
    return controller.stream;
  }
}

final apiJsonProvider = Provider<ApiJson>(
  (ref) => ApiJson(ref.watch(dioProvider)),
);

/// Lit un entier JSON (millimes) ; l'API n'envoie jamais de décimal.
int intOf(Object? value) => switch (value) {
  final int v => v,
  final num v => v.toInt(),
  final String v => int.tryParse(v) ?? 0,
  _ => 0,
};

DateTime dateOf(Object? value) =>
    DateTime.tryParse(value is String ? value : '')?.toLocal() ??
    DateTime.fromMillisecondsSinceEpoch(0);

DateTime? optionalDateOf(Object? value) =>
    value is String ? DateTime.tryParse(value)?.toLocal() : null;

List<Json> listOf(Object? value) =>
    value is List ? value.whereType<Json>().toList() : const [];
