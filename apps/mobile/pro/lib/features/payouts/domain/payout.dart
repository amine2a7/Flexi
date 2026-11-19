import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

/// Devis de reversement calculé **par le serveur** (millimes, taux en points de base).
/// Le taux de commission est figé dans la demande. Un virement porte sur un seul type de
/// crédit ([creditType]) ; [byType] donne le solde à reverser de chaque type.
class PayoutQuote {
  const PayoutQuote({
    required this.gross,
    this.quoteId,
    this.creditType,
    this.serverNet,
    required this.byType,
    required this.commissionBps,
    required this.commission,
    required this.vatBps,
    required this.vat,
    required this.withholding,
    required this.withholdingThreshold,
    required this.stampDuty,
    required this.transferFee,
  });

  final int gross;

  /// Devis du serveur (taux figé jusqu'à son expiration) ; `null` en démonstration.
  final String? quoteId;
  final CreditType? creditType;

  /// Net calculé par le serveur (fait foi quand il est connu).
  final int? serverNet;
  final Map<CreditType, int> byType;
  final int commissionBps;
  final int commission;
  final int vatBps;
  final int vat;
  final int withholding;
  final int withholdingThreshold;
  final int stampDuty;
  final int transferFee;

  int get feesInclTax => commission + vat;
  int get net =>
      serverNet ?? gross - feesInclTax - withholding - stampDuty - transferFee;

  /// Solde à reverser, tous types confondus.
  int get total => byType.values.fold(0, (s, v) => s + v);
}

enum PayoutStatus { requested, accepted, paid, rejected }

class Payout {
  const Payout({
    required this.reference,
    required this.net,
    required this.gross,
    required this.status,
    required this.requestedAt,
    this.bankReference,
    this.paidAt,
  });

  final String reference;
  final int net;
  final int gross;
  final PayoutStatus status;
  final DateTime requestedAt;
  final String? bankReference;
  final DateTime? paidAt;
}

abstract interface class PayoutRepository {
  /// Devis pour [type] (par défaut le type qui a le plus à reverser).
  Future<PayoutQuote> quote({CreditType? type});

  /// Demande le reversement du devis. [idempotencyKey] évite un double virement en cas de
  /// nouvel essai.
  Future<Payout> request({
    required PayoutQuote quote,
    required String idempotencyKey,
  });

  /// Demande en cours en premier, puis l'historique.
  Future<List<Payout>> list();
}

final payoutRepositoryProvider = Provider<PayoutRepository>(
  (ref) => throw UnimplementedError('payoutRepositoryProvider'),
);
