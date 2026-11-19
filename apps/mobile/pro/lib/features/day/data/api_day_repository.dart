import 'package:fp_core/fp_core.dart';

import '../domain/day.dart';

/// Journée du commerce sur l'API (`/v1/merchant/payments` depuis minuit) : toute la journée
/// pour le propriétaire, celle de sa caisse pour le caissier (filtré par le serveur).
class ApiDayRepository implements DayRepository {
  ApiDayRepository(this._api, this._now);

  final ApiJson _api;
  final DateTime Function() _now;

  @override
  Future<DaySummary> today() async {
    final now = _now();
    final midnight = DateTime(now.year, now.month, now.day);
    final body = await _api.get(
      '/v1/merchant/payments',
      query: {'createdFrom': midnight.toUtc().toIso8601String(), 'limit': 100},
    );
    final collections = <DayCollection>[];
    for (final p in listOf(body['data'])) {
      final status = p['status'];
      final approved = status == 'CONFIRMED' || status == 'SETTLED';
      if (!approved && status != 'REFUSED') continue;
      final customer = p['customer'] as Json? ?? const {};
      final first = customer['firstName'] as String? ?? '';
      final initial = customer['lastInitial'] as String? ?? '';
      collections.add(
        DayCollection(
          id: p['id'] as String,
          customerName: initial.isEmpty ? first : '$first $initial.',
          initial: first.isEmpty ? '' : first[0],
          customerKind: CustomerKind.employee,
          organization: null,
          type: CreditType.fromApi(p['creditType']) ?? CreditType.food,
          amount: intOf(p['amountMillimes']),
          time: dateOf(p['createdAt']),
          cashierId: '',
          cashierName: '',
          approved: approved,
          refusal: approved ? null : RefusalReason.declined,
        ),
      );
    }
    return DaySummary(date: midnight, collections: collections);
  }

  /// Le contrat ne dit pas quel caissier a encaissé : pas de filtre par caissier.
  @override
  Future<List<({String id, String name})>> cashiers() async => const [];
}
