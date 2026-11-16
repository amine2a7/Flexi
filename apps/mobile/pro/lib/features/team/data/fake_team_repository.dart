import '../../../demo/pro_demo_backend.dart';
import '../domain/team.dart';

class FakeTeamRepository implements TeamRepository {
  FakeTeamRepository(this._backend);

  final ProDemoBackend _backend;

  @override
  Future<List<TeamMember>> members() async => _backend.team;

  @override
  Future<CashierCreated> createCashier({
    required String fullName,
    required String email,
  }) async {
    final member = TeamMember(
      id: _backend.nextId('u'),
      name: fullName,
      email: email,
      isOwner: false,
      active: true,
    );
    _backend.team = [..._backend.team, member];
    // Généré par le serveur, affiché une seule fois, jamais stocké sur le téléphone.
    return CashierCreated(member: member, temporaryPassword: 'Pq9-73Lm');
  }
}
