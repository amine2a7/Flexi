import 'package:fp_core/fp_core.dart';

import '../domain/team.dart';

/// Équipe du commerce sur l'API (`/v1/team/users`) : liste et création d'un caissier, dont le
/// mot de passe temporaire n'est affiché qu'une fois.
class ApiTeamRepository implements TeamRepository {
  ApiTeamRepository(this._api);

  final ApiJson _api;

  TeamMember _member(Json u) => TeamMember(
    id: u['id'] as String,
    name: u['displayName'] as String? ?? '',
    email: u['email'] as String? ?? '',
    isOwner: u['subRole'] == 'OWNER',
    active: u['status'] == 'ACTIVE' || u['status'] == 'INVITED',
  );

  @override
  Future<List<TeamMember>> members() async {
    final body = await _api.get('/v1/team/users');
    return [
      for (final u in listOf(body['data']))
        if (u['status'] != 'DEACTIVATED') _member(u),
    ];
  }

  @override
  Future<CashierCreated> createCashier({
    required String fullName,
    required String email,
  }) async {
    final body = await _api.post(
      '/v1/team/users',
      body: {'displayName': fullName, 'email': email, 'subRole': 'CASHIER'},
    );
    final credentials = body['credentials'] as Json? ?? const {};
    final login = credentials['email'] as String? ?? email;
    final created = (await members())
        .where((m) => m.email.toLowerCase() == login.toLowerCase())
        .firstOrNull;
    return CashierCreated(
      member:
          created ??
          TeamMember(
            id: '',
            name: fullName,
            email: login,
            isOwner: false,
            active: true,
          ),
      temporaryPassword: credentials['temporaryPassword'] as String? ?? '',
    );
  }
}
