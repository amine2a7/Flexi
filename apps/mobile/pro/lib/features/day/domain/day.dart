import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

enum CustomerKind { employee, familyMember }

/// Encaissement de la journée (approuvé ou refusé).
class DayCollection {
  const DayCollection({
    required this.id,
    required this.customerName,
    required this.initial,
    required this.customerKind,
    required this.organization,
    required this.type,
    required this.amount,
    required this.time,
    required this.cashierId,
    required this.cashierName,
    required this.approved,
    this.refusal,
    this.reference,
  });

  final String id;
  final String customerName;
  final String initial;
  final CustomerKind customerKind;
  final String? organization;
  final CreditType type;
  final int amount;
  final DateTime time;
  final String cashierId;
  final String cashierName;
  final bool approved;
  final RefusalReason? refusal;

  /// Référence du paiement (PAY-…), pour la recherche (W-SUP).
  final String? reference;

  /// Vrai si la recherche (référence ou montant en dinars, « 12,5 ») trouve l'encaissement.
  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    if ((reference ?? '').toLowerCase().contains(q)) return true;
    final m = RegExp(r'^(\d{1,9})(?:[.,](\d{1,3}))?$')
        .firstMatch(q.replaceAll(' ', ''));
    if (m == null) return false;
    final millimes =
        int.parse(m.group(1)!) * 1000 +
        int.parse((m.group(2) ?? '').padRight(3, '0'));
    return amount == millimes;
  }
}

/// Journée du commerce, ou du caissier connecté.
class DaySummary {
  const DaySummary({required this.date, required this.collections});

  final DateTime date;
  final List<DayCollection> collections;

  List<DayCollection> get approved =>
      collections.where((c) => c.approved).toList();
  int get total => approved.fold(0, (s, c) => s + c.amount);
  int get count => approved.length;
  int get refusals => collections.length - approved.length;

  /// Panier moyen en millimes (division entière).
  int get average => count == 0 ? 0 : total ~/ count;

  /// Montant encaissé dans la tranche horaire [hour, hour + span[.
  int totalBetween(int hour, int span) => approved
      .where((c) => c.time.hour >= hour && c.time.hour < hour + span)
      .fold(0, (s, c) => s + c.amount);
}

abstract interface class DayRepository {
  /// Toute la journée (propriétaire) ou seulement celle du caissier connecté.
  Future<DaySummary> today();

  /// Caissiers à proposer dans le filtre (propriétaire).
  Future<List<({String id, String name})>> cashiers();
}

final dayRepositoryProvider = Provider<DayRepository>(
  (ref) => throw UnimplementedError('dayRepositoryProvider'),
);
