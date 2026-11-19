import 'dart:math';

import 'package:fp_core/fp_core.dart';

import '../../wallet/domain/wallet.dart';
import '../domain/family.dart';

/// « Ma famille » sur l'API (`/v1/employee/family`) : création du compte (mot de passe
/// temporaire affiché une seule fois), partage d'un crédit avec plafond du jour et date de fin,
/// reprise et désactivation. Chaque mouvement d'argent porte sa propre Idempotency-Key.
class ApiFamilyRepository implements FamilyRepository {
  ApiFamilyRepository(this._api, this._session, this._now);

  final ApiJson _api;
  final Session? Function() _session;
  final DateTime Function() _now;

  /// Pas de route pour un nouveau mot de passe ni pour modifier plafond et date.
  @override
  bool get canEditMember => false;

  DateTime get _farEnd => DateTime(_now().year + 1, 12, 31);

  FamilyMember _member(Json m) {
    final balances = listOf(m['balances']);
    final line =
        balances.where((b) => intOf(b['amountMillimes']) > 0).firstOrNull ??
        balances.firstOrNull;
    final amount = line == null ? 0 : intOf(line['amountMillimes']);
    final cap = line?['dailyLimitMillimes'];
    return FamilyMember(
      id: m['id'] as String,
      firstName: m['firstName'] as String? ?? '',
      contact: m['login'] as String? ?? '',
      type: CreditType.fromApi(line?['creditType']) ?? CreditType.food,
      balance: amount,
      limit: amount,
      // Sans plafond propre, celui du type s'applique : la jauge se lit sur le solde partagé.
      dailyCap: max(1, cap == null ? amount : intOf(cap)),
      spentToday: 0,
      endDate: optionalDateOf(line?['endsOn']) ?? _farEnd,
      active: m['status'] == 'ACTIVE' || m['status'] == 'INVITED',
    );
  }

  Future<List<FamilyMember>> _all() async {
    final body = await _api.get('/v1/employee/family');
    return [for (final m in listOf(body['data'])) _member(m)];
  }

  @override
  Future<List<FamilyMember>> members() async =>
      (await _all()).where((m) => m.active).toList();

  @override
  Future<FamilyMember> member(String id) async =>
      (await _all()).firstWhere((m) => m.id == id);

  @override
  Future<FamilyMemberCreated> create({
    required String firstName,
    required String lastName,
    required FamilyRelationship relationship,
    required String contact,
    required CreditType type,
    required int amount,
    required int dailyCap,
    required DateTime endDate,
  }) async {
    final created = await _api.post(
      '/v1/employee/family/members',
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'relationship': relationship.apiName,
        'phone': contact,
      },
    );
    final id = created['id'] as String;
    final credentials = created['credentials'] as Json? ?? const {};
    // Le mot de passe n'est montré qu'une fois : il est rendu même si le partage échoue.
    final password = credentials['temporaryPassword'] as String? ?? '';
    var shared = 0;
    try {
      await _api.post(
        '/v1/employee/family/transfers',
        idempotencyKey: newIdempotencyKey(),
        body: {
          'memberId': id,
          'creditType': type.apiName,
          'amountMillimes': amount,
          'dailyLimitMillimes': dailyCap > 0 ? dailyCap : null,
          'endsOn': _day(endDate),
        },
      );
      shared = amount;
    } on AppFailure {
      shared = 0;
    }
    return FamilyMemberCreated(
      member: FamilyMember(
        id: id,
        firstName: created['firstName'] as String? ?? firstName,
        contact: credentials['email'] as String? ?? contact,
        type: type,
        balance: shared,
        limit: shared,
        dailyCap: max(1, dailyCap),
        spentToday: 0,
        endDate: endDate,
        active: true,
      ),
      temporaryPassword: password,
    );
  }

  static String _day(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Future<int> reclaim(String id) async {
    final body = await _api.post(
      '/v1/employee/family/members/$id/reclaim',
      idempotencyKey: newIdempotencyKey(),
      body: {'creditType': null},
    );
    return intOf(body['reclaimedMillimes']);
  }

  @override
  Future<String> resetPassword(String id) async => throw const UnknownFailure();

  @override
  Future<void> disable(String id) async {
    await _api.delete(
      '/v1/employee/family/members/$id',
      idempotencyKey: newIdempotencyKey(),
    );
  }

  @override
  Future<FamilyMember?> myAccount() async {
    final session = _session();
    if (session?.role != UserRole.familyMember) return null;
    final wallet = await _api.get('/v1/employee/wallet');
    final balances = listOf(wallet['balances']);
    final line =
        balances.where((b) => intOf(b['balanceMillimes']) > 0).firstOrNull ??
        balances.firstOrNull;
    if (line == null) return null;
    final balance = intOf(line['balanceMillimes']);
    final cap = intOf(line['dailyLimitMillimes']);
    return FamilyMember(
      id: session!.userId,
      firstName: session.firstName,
      contact: '',
      type: CreditType.fromApi(line['creditType']) ?? CreditType.food,
      balance: balance,
      limit: balance,
      dailyCap: max(1, cap == 0 ? balance : cap),
      spentToday: intOf(line['todaySpentMillimes']),
      endDate: optionalDateOf(line['nextExpiryDate']) ?? _farEnd,
      active: true,
    );
  }

  /// Pas de route pour les dépenses d'un membre vues par le salarié.
  @override
  Future<List<Operation>> memberOperations(String id) async => const [];
}
