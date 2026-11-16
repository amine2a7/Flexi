import 'package:fp_core/fp_core.dart';

import '../../../demo/pro_demo_backend.dart';
import '../../day/domain/day.dart';
import '../domain/collect.dart';

class FakeCollectRepository implements CollectRepository {
  FakeCollectRepository(this._backend, this._now);

  final ProDemoBackend _backend;
  final DateTime Function() _now;

  String get _cashier =>
      _backend.account == ProDemoAccount.carrefour ? 'Carrefour' : 'Sami';

  @override
  Future<List<CreditType>> acceptedTypes() async =>
      ProDemoBackend.acceptedTypes;

  @override
  Future<Customer> lookup(String code, CreditType type) async {
    final customer = _backend.customers[code.replaceAll(' ', '')];
    if (customer == null) throw const ValidationFailure('unknownCode');
    return customer;
  }

  @override
  Future<CollectResult> collect({
    required String code,
    required int amount,
    required CreditType type,
    required String idempotencyKey,
  }) async {
    final customer = await lookup(code, type);
    final approved = amount > 0 && amount <= customer.available;
    final existing = _backend.collections.where(
      (c) =>
          c.customerName == customer.displayName &&
          c.approved == approved &&
          (!approved || c.amount == amount),
    );
    // Rejoue la transaction du prototype au lieu de la dupliquer.
    final time = existing.isNotEmpty ? existing.first.time : _now();
    if (existing.isEmpty) {
      _backend.collections = [
        ..._backend.collections,
        DayCollection(
          id: _backend.nextId('c'),
          customerName: customer.displayName,
          initial: customer.initial,
          customerKind: CustomerKind.employee,
          organization: customer.organization,
          type: type,
          amount: approved ? amount : 0,
          time: time,
          cashierId: _backend.account == ProDemoAccount.carrefour
              ? 'u-carrefour'
              : 'u-sami',
          cashierName: _cashier,
          approved: approved,
          refusal: approved ? null : RefusalReason.insufficientFunds,
        ),
      ];
    }
    return CollectResult(
      approved: approved,
      amount: amount,
      customerName: '${customer.displayName} · ${customer.organization}',
      type: type,
      cashier: _cashier,
      time: time,
      reference: approved ? 'TX-7F3A21' : null,
      missing: approved ? null : amount - customer.available,
    );
  }
}
