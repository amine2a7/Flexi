import 'package:fp_core/fp_core.dart';

import '../domain/wallet.dart';

/// Soldes par type et historique sur l'API (`/v1/employee/wallet`, `/v1/employee/operations`).
/// Montants en millimes, jamais de décimal.
class ApiWalletRepository implements WalletRepository {
  ApiWalletRepository(this._api, this._now);

  final ApiJson _api;
  final DateTime Function() _now;

  @override
  Future<Wallet> wallet() async {
    final body = await _api.get('/v1/employee/wallet');
    // Reçu, utilisé, partagé et nombre de paiements : cumulés sur les opérations récentes.
    final recent = await _page(limit: 100);
    final credits = <Credit>[];
    for (final b in listOf(body['balances'])) {
      final type = CreditType.fromApi(b['creditType']);
      if (type == null || b['enabled'] == false) continue;
      final ops = recent.where((o) => o.type == type);
      int sum(OperationKind kind) => ops
          .where((o) => o.kind == kind)
          .fold(0, (total, o) => total + o.amount.abs());
      final balance = intOf(b['balanceMillimes']);
      final received = sum(OperationKind.creditReceived);
      final shared =
          (sum(OperationKind.familyShare) - sum(OperationKind.familyReclaim))
              .clamp(0, 1 << 52);
      credits.add(
        Credit(
          type: type,
          balance: balance,
          received: received < balance ? balance : received,
          used: sum(OperationKind.payment),
          shared: shared,
          expiresOn:
              optionalDateOf(b['nextExpiryDate']) ??
              DateTime(_now().year, 12, 31),
          paymentCount: ops
              .where((o) => o.kind == OperationKind.payment)
              .length,
        ),
      );
    }
    return Wallet(
      company: body['companyName'] as String? ?? '',
      credits: credits,
    );
  }

  Future<List<Operation>> _page({
    int limit = 100,
    DateTime? from,
    DateTime? to,
  }) async {
    final body = await _api.get(
      '/v1/employee/operations',
      query: {
        'limit': limit,
        if (from != null) 'createdFrom': from.toUtc().toIso8601String(),
        if (to != null) 'createdTo': to.toUtc().toIso8601String(),
      },
    );
    return [
      for (final o in listOf(body['data']))
        if (o['status'] == 'COMPLETED') operationOf(o),
    ];
  }

  @override
  Future<List<Operation>> operations({
    required int year,
    required int month,
  }) async {
    final ops = await _page(
      from: DateTime(year, month),
      to: DateTime(year, month + 1),
    );
    return ops..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<Operation> operation(String id) async =>
      operationOf(await _api.get('/v1/employee/operations/$id'));
}

/// Ligne d'historique du contrat (`EmployeeOperation` ou `EmployeeOperationDetail`).
Operation operationOf(Json o) {
  final debit = o['direction'] == 'DEBIT';
  final amount = intOf(o['amountMillimes']);
  final signed = debit ? -amount : amount;
  final type = CreditType.fromApi(o['creditType']);
  final kind = switch (o['type']) {
    'PAYMENT' => OperationKind.payment,
    'ALLOCATION' => OperationKind.creditReceived,
    'EXPIRY' => OperationKind.expiry,
    _ => debit ? OperationKind.familyShare : OperationKind.familyReclaim,
  };
  final name = o['counterpartyName'] as String?;
  final after = o['balanceAfterMillimes'];
  return Operation(
    id: o['id'] as String,
    kind: kind,
    amount: signed,
    date: dateOf(o['occurredAt']),
    type: type,
    merchantName: kind == OperationKind.payment ? name : null,
    counterpart: kind == OperationKind.payment ? null : name,
    reference: o['reference'] as String?,
    balanceAfter: after == null ? null : intOf(after),
    balanceBefore: after == null ? null : intOf(after) - signed,
    breakdown: kind == OperationKind.creditReceived && type != null
        ? {type: amount}
        : const {},
  );
}
