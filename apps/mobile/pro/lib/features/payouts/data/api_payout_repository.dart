import 'package:fp_core/fp_core.dart';

import '../domain/payout.dart';

/// Solde à reverser et reversements sur l'API : créances par type, devis du serveur (taux
/// figé), demande avec Idempotency-Key, puis suivi. Aucun montant n'est calculé par l'app.
class ApiPayoutRepository implements PayoutRepository {
  ApiPayoutRepository(this._api);

  final ApiJson _api;

  /// Créances (paiements confirmés non réglés) de chaque type accepté.
  Future<Map<CreditType, int>> _receivables() async {
    final profile = await _api.get('/v1/merchant/profile');
    final byType = <CreditType, int>{};
    for (final raw in (profile['acceptedCreditTypes'] as List? ?? const [])) {
      final type = CreditType.fromApi(raw);
      if (type == null) continue;
      final page = await _api.get(
        '/v1/merchant/receivables',
        query: {'creditType': type.apiName, 'limit': 1},
      );
      final total = intOf(page['totalMillimes']);
      if (total > 0) byType[type] = total;
    }
    return byType;
  }

  @override
  Future<PayoutQuote> quote({CreditType? type}) async {
    final byType = await _receivables();
    if (byType.isEmpty) {
      return const PayoutQuote(
        gross: 0,
        byType: {},
        commissionBps: 0,
        commission: 0,
        vatBps: 0,
        vat: 0,
        withholding: 0,
        withholdingThreshold: 0,
        stampDuty: 0,
        transferFee: 0,
        serverNet: 0,
      );
    }
    final chosen = type != null && byType.containsKey(type)
        ? type
        : (byType.entries.toList()..sort((a, b) => b.value - a.value))
              .first
              .key;
    final q = await _api.post(
      '/v1/merchant/payout-quotes',
      body: {'creditType': chosen.apiName, 'grossMillimes': byType[chosen]},
    );
    return PayoutQuote(
      quoteId: q['quoteId'] as String?,
      creditType: chosen,
      gross: intOf(q['grossMillimes']),
      byType: byType,
      commissionBps: intOf(q['commissionRateBps']),
      commission: intOf(q['commissionMillimes']),
      vatBps: intOf(q['vatRateBps']),
      vat: intOf(q['vatMillimes']),
      withholding: intOf(q['withholdingMillimes']),
      // Le seuil n'est pas dans le devis : la retenue affichée est celle du serveur.
      withholdingThreshold: 0,
      stampDuty: intOf(q['stampDutyMillimes']),
      transferFee: intOf(q['transferFeeMillimes']),
      serverNet: intOf(q['netMillimes']),
    );
  }

  @override
  Future<Payout> request({
    required PayoutQuote quote,
    required String idempotencyKey,
  }) async {
    final id = quote.quoteId;
    if (id == null) throw const ValidationFailure('quote');
    return _payout(
      await _api.post(
        '/v1/merchant/payouts',
        idempotencyKey: idempotencyKey,
        body: {'quoteId': id},
      ),
    );
  }

  @override
  Future<List<Payout>> list() async {
    final body = await _api.get('/v1/merchant/payouts', query: {'limit': 50});
    return [for (final p in listOf(body['data'])) _payout(p)];
  }

  Payout _payout(Json p) {
    final payment = p['payment'] as Json?;
    return Payout(
      reference: p['reference'] as String? ?? '',
      net: intOf(p['netMillimes']),
      gross: intOf(p['grossMillimes']),
      status: switch (p['status']) {
        'SENT' => PayoutStatus.accepted,
        'EXECUTED' => PayoutStatus.paid,
        'REJECTED' => PayoutStatus.rejected,
        _ => PayoutStatus.requested,
      },
      requestedAt: dateOf(p['requestedAt']),
      bankReference: payment?['bankReference'] as String?,
      paidAt: optionalDateOf(payment?['paidOn']),
    );
  }
}
