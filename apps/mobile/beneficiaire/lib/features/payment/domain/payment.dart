import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

/// Demande de paiement d'une caisse, lue sur l'autocollant NFC, le QR ou par le code court.
/// Le montant et le type sont fixés par le caissier ; le client confirme avec son PIN.
class PendingCheckout {
  const PendingCheckout({
    required this.id,
    required this.merchantId,
    required this.merchantName,
    required this.registerName,
    required this.city,
    required this.amount,
    required this.type,
    required this.expiresAt,
  });

  final String id;
  final String merchantId;
  final String merchantName;
  final String registerName;
  final String city;

  /// Millimes.
  final int amount;
  final CreditType type;
  final DateTime expiresAt;
}

/// Paiement approuvé.
class PaymentReceipt {
  const PaymentReceipt({
    required this.operationId,
    required this.merchantId,
    required this.merchantName,
    required this.cashier,
    required this.amount,
    required this.type,
    required this.remaining,
    required this.reference,
    required this.paidBy,
    required this.date,
  });

  final String operationId;
  final String merchantId;
  final String merchantName;
  final String cashier;
  final int amount;
  final CreditType type;
  final int remaining;
  final String reference;
  final String paidBy;
  final DateTime date;
}

/// Refus avec le contexte à afficher (aucun montant débité). Les montants absents ne sont pas
/// connus du client pour ce motif (autocollant invalide, demande déjà payée…).
class PaymentRefusal {
  const PaymentRefusal({
    required this.reason,
    this.merchantName,
    this.requested,
    this.balanceType,
    this.balance,
    this.acceptedTypes = const [],
    this.missing,
  });

  final RefusalReason reason;
  final String? merchantName;
  final int? requested;
  final CreditType? balanceType;
  final int? balance;
  final List<CreditType> acceptedTypes;

  /// Manque (solde) ou reste du jour (plafond famille), en millimes.
  final int? missing;
}

/// Exception portant le détail d'un refus.
class PaymentRefusedException implements Exception {
  const PaymentRefusedException(this.refusal);
  final PaymentRefusal refusal;
}

abstract interface class PaymentRepository {
  /// Demande en attente à la caisse de l'autocollant (signature vérifiée par le serveur).
  Future<PendingCheckout> bySticker(StickerLink link);

  /// Demande en attente du code à 4 chiffres affiché en caisse.
  Future<PendingCheckout> byCode(String shortCode);

  /// Confirme avec le PIN (vérifié côté serveur, jamais stocké).
  /// Lève [PaymentRefusedException], `PinRefusedFailure` ou `AccountLockedFailure`.
  Future<PaymentReceipt> confirm(PendingCheckout checkout, String pin);
}

final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => throw UnimplementedError('paymentRepositoryProvider'),
);
