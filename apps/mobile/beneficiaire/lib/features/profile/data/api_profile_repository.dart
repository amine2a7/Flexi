import 'package:fp_core/fp_core.dart';

import '../domain/profile.dart';

/// Profil sur l'API (`/v1/employee/profile`) ; les compteurs viennent des opérations récentes.
class ApiProfileRepository implements ProfileRepository {
  ApiProfileRepository(this._api);

  final ApiJson _api;

  @override
  Future<Profile> profile() async {
    final p = await _api.get('/v1/employee/profile');
    final ops = await _api.get(
      '/v1/employee/operations',
      query: {'limit': 100},
    );
    final payments = listOf(ops['data'])
        .where((o) => o['type'] == 'PAYMENT' && o['status'] == 'COMPLETED');
    var familyCount = 0;
    try {
      final family = await _api.get('/v1/employee/family');
      familyCount = listOf(family['data'])
          .where((m) => m['status'] == 'ACTIVE' || m['status'] == 'INVITED')
          .length;
    } on ApiProblemFailure {
      // Membre famille : pas de famille à lui.
    }
    return Profile(
      fullName: '${p['firstName'] ?? ''} ${p['lastName'] ?? ''}'.trim(),
      company: p['companyName'] as String? ?? '',
      department: '',
      jobTitle: '',
      paymentCount: payments.length,
      merchantCount: payments.map((o) => o['counterpartyName']).toSet().length,
      familyCount: familyCount,
      hrName: '',
      hrEmail: '',
      supportEmail: '',
    );
  }
}
