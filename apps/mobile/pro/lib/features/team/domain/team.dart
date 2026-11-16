import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.isOwner,
    required this.active,
    this.lastAccess,
  });

  final String id;
  final String name;
  final String email;
  final bool isOwner;
  final bool active;
  final DateTime? lastAccess;
}

/// Caissier créé : le mot de passe temporaire n'est affiché qu'une fois et jamais stocké.
class CashierCreated {
  const CashierCreated({required this.member, required this.temporaryPassword});
  final TeamMember member;
  final String temporaryPassword;
}

abstract interface class TeamRepository {
  Future<List<TeamMember>> members();

  Future<CashierCreated> createCashier({
    required String fullName,
    required String email,
  });
}

final teamRepositoryProvider = Provider<TeamRepository>(
  (ref) => throw UnimplementedError('teamRepositoryProvider'),
);
