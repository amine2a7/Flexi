import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

import '../../wallet/domain/wallet.dart';

/// Nombre maximal de comptes famille par salarié.
const maxFamilyMembers = 5;

/// Compte famille. Montants en millimes.
class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.firstName,
    required this.contact,
    required this.type,
    required this.balance,
    required this.limit,
    required this.dailyCap,
    required this.spentToday,
    required this.endDate,
    required this.active,
  });

  final String id;
  final String firstName;
  final String contact;
  final CreditType type;
  final int balance;

  /// Montant partagé à l'origine.
  final int limit;
  final int dailyCap;
  final int spentToday;
  final DateTime endDate;
  final bool active;

  int get leftToday => (dailyCap - spentToday).clamp(0, dailyCap);
}

/// Création réussie : le mot de passe temporaire n'est affiché qu'une fois et jamais stocké.
class FamilyMemberCreated {
  const FamilyMemberCreated({
    required this.member,
    required this.temporaryPassword,
  });
  final FamilyMember member;
  final String temporaryPassword;
}

abstract interface class FamilyRepository {
  Future<List<FamilyMember>> members();

  Future<FamilyMember> member(String id);

  Future<FamilyMemberCreated> create({
    required String firstName,
    required String contact,
    required CreditType type,
    required int amount,
    required int dailyCap,
    required DateTime endDate,
  });

  /// Le solde du membre revient sur le crédit du salarié. Renvoie le montant repris.
  Future<int> reclaim(String id);

  /// Nouveau mot de passe temporaire, affiché une seule fois.
  Future<String> resetPassword(String id);

  /// Le membre ne peut plus payer ; son solde revient au salarié.
  Future<void> disable(String id);

  /// Compte famille de la personne connectée (si c'est un membre famille).
  Future<FamilyMember?> myAccount();

  /// Dépenses d'un membre, de la plus récente à la plus ancienne.
  Future<List<Operation>> memberOperations(String id);
}

final familyRepositoryProvider = Provider<FamilyRepository>(
  (ref) => throw UnimplementedError('familyRepositoryProvider'),
);
