import 'package:fp_core/fp_core.dart';

import '../../../demo/demo_backend.dart';
import '../../wallet/domain/wallet.dart';
import '../domain/family.dart';

class FakeFamilyRepository implements FamilyRepository {
  FakeFamilyRepository(this._backend);

  final DemoBackend _backend;

  @override
  Future<List<FamilyMember>> members() async =>
      _backend.family.where((m) => m.active).toList();

  @override
  Future<FamilyMember> member(String id) async =>
      _backend.family.firstWhere((m) => m.id == id);

  @override
  Future<FamilyMemberCreated> create({
    required String firstName,
    required String contact,
    required CreditType type,
    required int amount,
    required int dailyCap,
    required DateTime endDate,
  }) async {
    if (_backend.family.where((m) => m.active).length >= maxFamilyMembers) {
      throw const ValidationFailure('familyFull');
    }
    final credit = _backend.credits.where((c) => c.type == type).firstOrNull;
    if (credit == null || amount <= 0 || amount > credit.balance) {
      throw const ValidationFailure('amountTooHigh');
    }
    final member = FamilyMember(
      id: _backend.nextId('fm'),
      firstName: firstName,
      contact: contact,
      type: type,
      balance: amount,
      limit: amount,
      dailyCap: dailyCap,
      spentToday: 0,
      endDate: endDate,
      active: true,
    );
    _backend
      ..family = [..._backend.family, member]
      ..replaceCredit(
        credit.copyWith(
          balance: credit.balance - amount,
          shared: credit.shared + amount,
        ),
      );
    // Mot de passe temporaire généré par le serveur : affiché une seule fois, jamais stocké.
    return FamilyMemberCreated(member: member, temporaryPassword: 'K7m-42Qa');
  }

  @override
  Future<int> reclaim(String id) async {
    final member = _backend.family.firstWhere((m) => m.id == id);
    final credit = _backend.credits.firstWhere((c) => c.type == member.type);
    _backend
      ..replaceCredit(
        credit.copyWith(
          balance: credit.balance + member.balance,
          shared: (credit.shared - member.balance).clamp(0, credit.shared),
        ),
      )
      ..family = [
        for (final m in _backend.family)
          if (m.id != id) m,
      ];
    return member.balance;
  }

  @override
  Future<String> resetPassword(String id) async => 'R4t-81Zk';

  @override
  Future<void> disable(String id) async {
    await reclaim(id);
  }

  @override
  Future<List<Operation>> memberOperations(String id) async =>
      id == 'fm-adam' ? _backend.adamOperations : const [];

  @override
  Future<FamilyMember?> myAccount() async =>
      _backend.account == DemoAccount.adam
      ? _backend.family.where((m) => m.id == 'fm-adam').firstOrNull
      : null;
}
