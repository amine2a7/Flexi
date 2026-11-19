import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Requête reçue par le faux serveur.
class FakeRequest {
  FakeRequest(this.method, this.path, this.query, this.headers, this.body);

  final String method;
  final String path;
  final Map<String, dynamic> query;
  final Map<String, dynamic> headers;
  final Object? body;

  Map<String, dynamic> get json =>
      body is Map ? (body! as Map).cast<String, dynamic>() : const {};

  String? get idempotencyKey => headers['Idempotency-Key'] as String?;
  String? get authorization => headers['Authorization'] as String?;

  @override
  String toString() => '$method $path';
}

/// Réponse du faux serveur : JSON, octets (PDF) ou flux (Server-Sent Events).
class FakeResponse {
  const FakeResponse(this.status, {this.json, this.bytes, this.stream});

  /// Corps JSON (`application/json`, ou `application/problem+json` à partir de 400).
  factory FakeResponse.ok(Object json) => FakeResponse(200, json: json);

  /// Erreur RFC 9457 du contrat.
  factory FakeResponse.problem(
    int status,
    String code, {
    Map<String, Object?>? details,
  }) => FakeResponse(
    status,
    json: {
      'type': 'urn:flexipay:problem:test',
      'title': code,
      'status': status,
      'code': code,
      'messageKey': 'errors.test',
      'requestId': '00000000-0000-4000-8000-000000000000',
      'details': ?details,
    },
  );

  static const noContent = FakeResponse(204);

  final int status;
  final Object? json;
  final List<int>? bytes;
  final Stream<List<int>>? stream;
}

typedef FakeHandler = FutureOr<FakeResponse> Function(FakeRequest request);

/// Coupure réseau simulée : l'app ne reçoit aucune réponse.
class NetworkCut implements Exception {
  const NetworkCut();
}

/// Faux serveur de l'API, branché à la place du transport HTTP de Dio.
///
/// Chaque route est une méthode et un motif de chemin (`{id}` = un segment) ; une route non
/// déclarée répond `404 NOT_FOUND`. Les requêtes reçues sont gardées pour les vérifications.
class FakeApiServer implements HttpClientAdapter {
  final _routes = <(String, RegExp, FakeHandler)>[];
  final requests = <FakeRequest>[];

  /// Déclare (ou remplace) une route.
  void on(String method, String pattern, FakeHandler handler) {
    final regex = RegExp(
      '^${pattern.replaceAllMapped(RegExp(r'\{[^}]+\}'), (_) => '[^/]+')}\$',
    );
    _routes.removeWhere((r) => r.$1 == method && r.$2.pattern == regex.pattern);
    _routes.insert(0, (method, regex, handler));
  }

  /// Gestionnaire actuel d'un chemin (pour l'envelopper dans un test).
  FakeHandler handlerFor(String method, String path) =>
      _routes.where((r) => r.$1 == method && r.$2.hasMatch(path)).first.$3;

  /// Requêtes reçues sur `method path` (chemin exact).
  List<FakeRequest> calls(String method, String path) =>
      requests.where((r) => r.method == method && r.path == path).toList();

  /// Requêtes reçues dont le chemin commence par [prefix].
  List<FakeRequest> callsTo(String method, String prefix) => requests
      .where((r) => r.method == method && r.path.startsWith(prefix))
      .toList();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    Object? body = options.data;
    if (body is String && body.isNotEmpty) body = jsonDecode(body);
    final request = FakeRequest(
      options.method,
      options.uri.path,
      options.uri.queryParameters,
      options.headers,
      body,
    );
    requests.add(request);
    final route = _routes
        .where((r) => r.$1 == options.method && r.$2.hasMatch(options.uri.path))
        .firstOrNull;
    // Comme l'API : toute route hors connexion exige le jeton d'accès.
    final public =
        options.uri.path.startsWith('/v1/mobile/auth/') &&
        !options.uri.path.endsWith('/logout') &&
        !options.uri.path.endsWith('/password/change');
    final FakeResponse response;
    try {
      response = !public && request.authorization == null
          ? FakeResponse.problem(401, 'UNAUTHENTICATED')
          : route == null
          ? FakeResponse.problem(404, 'NOT_FOUND')
          : await route.$3(request);
    } on NetworkCut {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'coupure réseau simulée',
      );
    }
    if (response.stream case final stream?) {
      return ResponseBody(
        stream.map(Uint8List.fromList),
        response.status,
        headers: {
          Headers.contentTypeHeader: ['text/event-stream'],
        },
      );
    }
    if (response.bytes case final bytes?) {
      return ResponseBody.fromBytes(
        bytes,
        response.status,
        headers: {
          Headers.contentTypeHeader: ['application/pdf'],
        },
      );
    }
    if (response.json == null) {
      return ResponseBody.fromString('', response.status);
    }
    return ResponseBody.fromString(
      jsonEncode(response.json),
      response.status,
      headers: {
        Headers.contentTypeHeader: [
          response.status >= 400
              ? 'application/problem+json'
              : 'application/json',
        ],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Événement Server-Sent Events (`event: checkout`).
List<int> sseEvent(Object json) =>
    utf8.encode('event: checkout\ndata: ${jsonEncode(json)}\n\n');
