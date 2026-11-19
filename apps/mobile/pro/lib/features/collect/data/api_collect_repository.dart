import 'dart:async';
import 'dart:typed_data';

import 'package:fp_core/fp_core.dart';

import '../domain/collect.dart';

/// Encaissement à la caisse sur l'API (montage A) : demande avec Idempotency-Key gardée
/// jusqu'au résultat, suivi en temps réel par Server-Sent Events, code court, annulation.
/// Après une coupure réseau, le statut est demandé par la clé avant tout nouvel essai.
class ApiCollectRepository implements CollectRepository {
  ApiCollectRepository(
    this._api,
    this._now, {
    this.cashierName,
    this.retryDelay = const Duration(seconds: 1),
  });

  final ApiJson _api;
  final DateTime Function() _now;

  /// Prénom de la personne connectée (affiché sur le résultat).
  final String Function()? cashierName;

  /// Attente entre deux demandes de statut après une coupure.
  final Duration retryDelay;

  /// Caisse de chaque demande créée (le flux SSE est celui de la caisse).
  final _registerOf = <String, TillRegister>{};

  /// Clés déjà envoyées au moins une fois.
  final _sent = <String>{};

  TillRegister _register(Json r) => TillRegister(
    id: r['id'] as String,
    name: r['name'] as String? ?? '',
    active: r['status'] == 'ACTIVE',
  );

  @override
  Future<List<CreditType>> acceptedTypes() async {
    final profile = await _api.get('/v1/merchant/profile');
    return [
      for (final t in (profile['acceptedCreditTypes'] as List? ?? const []))
        ?CreditType.fromApi(t),
    ];
  }

  @override
  Future<List<TillRegister>> registers() async {
    final body = await _api.get('/v1/merchant/registers');
    return [for (final r in listOf(body['data'])) _register(r)];
  }

  /// Le caissier ne voit que sa caisse ; le propriétaire encaisse sur la première active.
  @override
  Future<TillRegister?> myRegister() async =>
      (await registers()).where((r) => r.active).firstOrNull;

  @override
  Future<TillCheckout> request({
    required int amount,
    required CreditType type,
    required String idempotencyKey,
  }) async {
    final register = await myRegister();
    if (register == null) throw const ValidationFailure('noRegister');
    Json body;
    if (_sent.contains(idempotencyKey)) {
      final known = await _byKey(idempotencyKey);
      body = known ?? await _create(register, amount, type, idempotencyKey);
    } else {
      body = await _create(register, amount, type, idempotencyKey);
    }
    _sent.remove(idempotencyKey);
    final checkout = _checkout(body, register.name);
    _registerOf[checkout.id] = register;
    return checkout;
  }

  Future<Json> _create(
    TillRegister register,
    int amount,
    CreditType type,
    String key,
  ) async {
    _sent.add(key);
    Future<Json> post() => _api.post(
      '/v1/merchant/registers/${register.id}/checkouts',
      idempotencyKey: key,
      body: {'amountMillimes': amount, 'creditType': type.apiName},
    );
    try {
      return await post();
    } on NetworkFailure {
      // La demande est peut-être arrivée avant la coupure : on la cherche par sa clé.
      for (var attempt = 1; ; attempt++) {
        try {
          return await _byKey(key) ?? await post();
        } on NetworkFailure {
          if (attempt >= 3) rethrow;
          await Future<void>.delayed(retryDelay * attempt);
        }
      }
    }
  }

  /// Demande créée avec cette clé, `null` si aucune.
  Future<Json?> _byKey(String key) async {
    try {
      return await _api.get('/v1/merchant/checkouts/by-idempotency-key/$key');
    } on ApiProblemFailure catch (e) {
      if (e.code == 'NOT_FOUND') return null;
      rethrow;
    }
  }

  TillCheckout _checkout(Json c, String registerName) {
    final created = dateOf(c['createdAt']);
    final expires = dateOf(c['expiresAt']);
    final refusal = c['lastRefusal'];
    final paid = c['status'] == 'PAID';
    final status = switch (c['status']) {
      'PAID' => CheckoutStatus.paid,
      'EXPIRED' => CheckoutStatus.expired,
      'CANCELLED' => CheckoutStatus.cancelled,
      _ when refusal is Json => CheckoutStatus.refused,
      _ => CheckoutStatus.pending,
    };
    return TillCheckout(
      id: c['id'] as String,
      registerName: registerName,
      amount: intOf(c['amountMillimes']),
      type: CreditType.fromApi(c['creditType']) ?? CreditType.food,
      shortCode: c['shortCode'] as String? ?? '',
      // Validité mesurée par le serveur (120 s), indépendante de l'horloge du téléphone.
      validity: expires.difference(created),
      status: status,
      customerFirstName: paid
          ? c['customerFirstName'] as String?
          : refusal is Json
          ? refusal['customerFirstName'] as String?
          : null,
      refusal: !paid && refusal is Json ? _reason(refusal) : null,
      reference: c['paymentReference'] as String?,
      cashier: cashierName?.call(),
      time: paid ? optionalDateOf(c['paidAt']) ?? _now() : _now(),
    );
  }

  /// Motif vu par la caisse : jamais un montant ni un solde du client.
  static RefusalReason _reason(Json refusal) => switch (refusal['code']) {
    'INSUFFICIENT_FUNDS' => RefusalReason.insufficientFunds,
    'LIMIT_EXCEEDED' => RefusalReason.familyLimit,
    'PAYMENT_DECLINED' => RefusalReason.declined,
    _ => switch (refusal['reason']) {
      'CREDIT_TYPE_NOT_ACCEPTED' => RefusalReason.typeNotAccepted,
      'MERCHANT_NOT_ACTIVE' => RefusalReason.merchantInactive,
      'CHECKOUT_EXPIRED' => RefusalReason.codeExpired,
      'ALREADY_PAID' => RefusalReason.alreadyPaid,
      _ => RefusalReason.declined,
    },
  };

  @override
  Future<void> cancel(String checkoutId) async {
    await _api.post('/v1/merchant/checkouts/$checkoutId/cancel');
  }

  /// Événements de la caisse filtrés sur la demande ; un refus n'est signalé que s'il est
  /// postérieur à l'ouverture du suivi.
  @override
  Stream<TillCheckout> watch(String checkoutId) {
    final register = _registerOf[checkoutId];
    if (register == null) return const Stream.empty();
    String? lastRefusal;
    return _api
        .events('/v1/merchant/registers/${register.id}/checkouts/events')
        .where((c) => c['id'] == checkoutId)
        .map((c) {
          final checkout = _checkout(c, register.name);
          final refusal = c['lastRefusal'];
          if (checkout.status == CheckoutStatus.refused && refusal is Json) {
            final at = refusal['occurredAt'] as String?;
            // Le même refus renvoyé à l'ouverture du flux n'est pas un nouveau refus.
            if (at == lastRefusal) {
              return checkout.copyWith(status: CheckoutStatus.pending);
            }
            lastRefusal = at;
          }
          return checkout;
        });
  }

  @override
  Future<String> stickerUrl(String registerId) async =>
      (await _api.get('/v1/merchant/registers/$registerId/sticker'))['url']
          as String;

  @override
  Future<Uint8List> stickerPdf(String registerId) =>
      _api.bytes('/v1/merchant/registers/$registerId/sticker/pdf');
}
