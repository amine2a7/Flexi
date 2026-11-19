import 'package:fp_core/fp_core.dart';

import '../../../demo/pro_demo_backend.dart';
import '../domain/payout.dart';

class FakePayoutRepository implements PayoutRepository {
  FakePayoutRepository(this._backend);

  final ProDemoBackend _backend;
  final _requests = <String, Payout>{};

  @override
  Future<PayoutQuote> quote({CreditType? type}) async {
    final byType = <CreditType, int>{};
    for (final c in _backend.collections.where((c) => c.approved)) {
      byType[c.type] = (byType[c.type] ?? 0) + c.amount;
    }
    return ProDemoBackend.computeQuote(byType);
  }

  @override
  Future<Payout> request({
    required PayoutQuote quote,
    required String idempotencyKey,
  }) async {
    // Même clé, même réponse : pas de double demande.
    final previous = _requests[idempotencyKey];
    if (previous != null) return previous;
    final q = quote;
    final payout = Payout(
      reference: 'RV-0012',
      net: q.net,
      gross: q.gross,
      status: PayoutStatus.requested,
      requestedAt: DateTime(2026, 11, 14, 13, 10),
    );
    _requests[idempotencyKey] = payout;
    if (!_backend.payouts.any((p) => p.reference == payout.reference)) {
      _backend.payouts = [payout, ..._backend.payouts];
    }
    return payout;
  }

  @override
  Future<List<Payout>> list() async {
    if (!_backend.payouts.any((p) => p.status != PayoutStatus.paid)) {
      final q = await quote();
      _backend.payouts = [
        Payout(
          reference: 'RV-0012',
          net: q.net,
          gross: q.gross,
          status: PayoutStatus.requested,
          requestedAt: DateTime(2026, 11, 14, 13, 10),
        ),
        ..._backend.payouts,
      ];
    }
    return _backend.payouts;
  }
}
