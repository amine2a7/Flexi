import 'dart:async';

import 'package:fp_core/fp_core.dart';

import '../domain/payment.dart';

/// Paiement à la caisse sur l'API (montage A) : lecture de la demande par l'autocollant, le QR
/// ou le code court, puis confirmation par PIN avec une Idempotency-Key propre au client.
///
/// La clé est gardée par demande jusqu'au résultat définitif. Après une coupure réseau, l'app
/// demande d'abord le statut par clé (`GET …/by-idempotency-key/{key}`) : jamais de second
/// paiement.
class ApiPaymentRepository implements PaymentRepository {
  ApiPaymentRepository(
    this._api, {
    required this.payerName,
    this.retryDelay = const Duration(seconds: 1),
  });

  final ApiJson _api;

  /// Prénom de la personne connectée (affiché sur le reçu).
  final String Function() payerName;

  /// Attente entre deux demandes de statut après une coupure.
  final Duration retryDelay;

  /// PIN faux consécutifs : le serveur bloque au 3e.
  int _pinFailures = 0;

  /// Clé d'idempotence de chaque demande (id → clé), jusqu'au résultat.
  final _keys = <String, String>{};

  /// Clés déjà envoyées au moins une fois : leur statut est demandé avant tout nouvel essai.
  final _sent = <String>{};

  @override
  Future<PendingCheckout> bySticker(StickerLink link) => _pending(
    () => _api.get(
      '/v1/employee/checkouts/sticker/${Uri.encodeComponent(link.publicId)}',
      query: {'s': link.signature},
    ),
  );

  @override
  Future<PendingCheckout> byCode(String shortCode) => _pending(
    () => _api.get(
      '/v1/employee/checkouts/code/${Uri.encodeComponent(shortCode)}',
    ),
  );

  Future<PendingCheckout> _pending(Future<Json> Function() load) async {
    try {
      final c = await load();
      return PendingCheckout(
        id: c['id'] as String,
        merchantId: '',
        merchantName: c['merchantName'] as String? ?? '',
        registerName: c['registerName'] as String? ?? '',
        city: c['city'] as String? ?? '',
        amount: intOf(c['amountMillimes']),
        type: CreditType.fromApi(c['creditType']) ?? CreditType.food,
        expiresAt: dateOf(c['expiresAt']),
      );
    } on ApiProblemFailure catch (e) {
      throw PaymentRefusedException(await _refusal(e, null) ?? (throw e));
    }
  }

  @override
  Future<PaymentReceipt> confirm(PendingCheckout checkout, String pin) async {
    final key = _keys.putIfAbsent(checkout.id, newIdempotencyKey);
    try {
      final receipt = _receipt(await _confirmOnce(checkout.id, pin, key));
      _pinFailures = 0;
      _settled(checkout.id, key);
      return receipt;
    } on ApiProblemFailure catch (e) {
      // PIN faux ou bloqué : rien n'a été fait avec la clé, elle reste valable.
      if (e.code == 'PIN_INVALID') throw _pinRefusal(e.details);
      _pinFailures = 0;
      final refusal = await _refusal(e, checkout);
      if (refusal == null) rethrow;
      _settled(checkout.id, key);
      throw PaymentRefusedException(refusal);
    }
  }

  /// PIN refusé par le serveur : même réponse pour faux ou bloqué ; le délai dit le palier.
  AppFailure _pinRefusal(Map<String, Object?> details) {
    if (details['reauthenticationRequired'] == true) {
      _pinFailures = 0;
      return const AccountLockedFailure(lockedFor: Duration.zero, level: 4);
    }
    final seconds = intOf(details['retryAfterSeconds']);
    if (seconds > 0) {
      _pinFailures = 0;
      return AccountLockedFailure(
        lockedFor: Duration(seconds: seconds),
        level: seconds <= 900
            ? 1
            : seconds <= 1800
            ? 2
            : 3,
      );
    }
    _pinFailures++;
    return PinRefusedFailure((3 - _pinFailures).clamp(1, 3));
  }

  void _settled(String checkoutId, String key) {
    _keys.remove(checkoutId);
    _sent.remove(key);
  }

  Future<Json> _confirmOnce(String checkoutId, String pin, String key) async {
    if (_sent.contains(key)) {
      // Déjà envoyée : le premier essai a peut-être abouti avant la coupure.
      final known = await _statusByKey(key);
      if (known != null) return known;
    }
    _sent.add(key);
    try {
      return await _post(checkoutId, pin, key);
    } on NetworkFailure {
      final known = await _statusAfterCut(key);
      if (known != null) return known;
      // Rien n'a été fait avec cette clé : un nouvel essai, avec la même clé.
      return _post(checkoutId, pin, key);
    }
  }

  Future<Json> _post(String checkoutId, String pin, String key) async {
    try {
      return await _api.post(
        '/v1/employee/checkouts/$checkoutId/confirm',
        body: {'pin': pin},
        idempotencyKey: key,
      );
    } on ApiProblemFailure catch (e) {
      // Un autre essai avec cette clé est en cours : on attend son résultat.
      if (e.code != 'IDEMPOTENCY_REQUEST_IN_PROGRESS') rethrow;
      final known = await _statusAfterCut(key);
      if (known != null) return known;
      throw const NetworkFailure();
    }
  }

  /// Statut par clé, en réessayant tant que le réseau manque (3 fois au plus).
  Future<Json?> _statusAfterCut(String key) async {
    for (var attempt = 1; ; attempt++) {
      try {
        return await _statusByKey(key);
      } on NetworkFailure {
        if (attempt >= 3) rethrow;
        await Future<void>.delayed(retryDelay * attempt);
      }
    }
  }

  /// Reçu enregistré pour la clé, `null` si rien n'a été fait ; un refus est relancé.
  Future<Json?> _statusByKey(String key) async {
    for (var attempt = 1; ; attempt++) {
      try {
        return await _api.get('/v1/employee/checkouts/by-idempotency-key/$key');
      } on ApiProblemFailure catch (e) {
        if (e.code == 'NOT_FOUND') return null;
        if (e.code != 'IDEMPOTENCY_REQUEST_IN_PROGRESS' || attempt >= 5) {
          rethrow;
        }
        await Future<void>.delayed(retryDelay);
      }
    }
  }

  PaymentReceipt _receipt(Json r) => PaymentReceipt(
    operationId: r['id'] as String,
    merchantId: '',
    merchantName: r['counterpartyName'] as String? ?? '',
    cashier: '',
    amount: intOf(r['amountMillimes']),
    type: CreditType.fromApi(r['creditType']) ?? CreditType.food,
    remaining: intOf(r['balanceAfterMillimes']),
    reference: r['reference'] as String? ?? '',
    paidBy: payerName(),
    date: dateOf(r['occurredAt']),
  );

  /// Motif de refus de l'API → écran Refusé (aucun montant débité) ; `null` si ce n'en est pas un.
  Future<PaymentRefusal?> _refusal(
    ApiProblemFailure e,
    PendingCheckout? c,
  ) async {
    final reason = switch (e.code) {
      'INSUFFICIENT_FUNDS' => RefusalReason.insufficientFunds,
      'LIMIT_EXCEEDED' => RefusalReason.familyLimit,
      'PAYMENT_DECLINED' => RefusalReason.declined,
      'NOT_FOUND' => RefusalReason.noPendingCheckout,
      'CHECKOUT_REFUSED' => switch (e.details['reason']) {
        'CREDIT_TYPE_NOT_ACCEPTED' => RefusalReason.typeNotAccepted,
        'MERCHANT_NOT_ACTIVE' => RefusalReason.merchantInactive,
        'CHECKOUT_EXPIRED' => RefusalReason.codeExpired,
        'ALREADY_PAID' => RefusalReason.alreadyPaid,
        'STICKER_INVALID' => RefusalReason.stickerInvalid,
        _ => RefusalReason.noPendingCheckout,
      },
      _ => null,
    };
    if (reason == null) return null;
    final missing = switch (reason) {
      RefusalReason.insufficientFunds => e.details['missingMillimes'],
      RefusalReason.familyLimit => e.details['remainingMillimes'],
      _ => null,
    };
    return PaymentRefusal(
      reason: reason,
      merchantName: c?.merchantName,
      requested: c?.amount,
      balanceType: c?.type,
      balance: reason == RefusalReason.insufficientFunds && c != null
          ? await _balanceOf(c.type)
          : null,
      missing: missing == null ? null : intOf(missing),
    );
  }

  /// Solde du type (l'API ne le met jamais dans un refus) ; `null` hors ligne.
  Future<int?> _balanceOf(CreditType type) async {
    try {
      final wallet = await _api.get('/v1/employee/wallet');
      final line = listOf(wallet['balances'])
          .where((b) => b['creditType'] == type.apiName)
          .firstOrNull;
      return line == null ? null : intOf(line['balanceMillimes']);
    } on AppFailure {
      return null;
    }
  }
}
