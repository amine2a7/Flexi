import '../../../demo/demo_backend.dart';
import '../domain/profile.dart';

class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository(this._backend);

  final DemoBackend _backend;

  @override
  Future<Profile> profile() async {
    final family = _backend.family.where((m) => m.active).length;
    return switch (_backend.account) {
      DemoAccount.omar => _profile('Omar', '', '', 0, 0, 0),
      DemoAccount.adam => _profile('Adam', '', '', 1, 1, 0),
      _ => _profile(
        'Yasmine Ben Ali',
        'Production',
        'Opératrice',
        2,
        2,
        family,
      ),
    };
  }

  Profile _profile(
    String name,
    String department,
    String job,
    int payments,
    int merchants,
    int family,
  ) => Profile(
    fullName: name,
    company: DemoBackend.company,
    department: department,
    jobTitle: job,
    paymentCount: payments,
    merchantCount: merchants,
    familyCount: family,
    hrName: 'Leila',
    hrEmail: 'leila@flexipay.test',
    supportEmail: 'support@flexipay.test',
  );
}
