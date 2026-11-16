import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

/// Code de paiement à usage unique, renouvelé toutes les 60 s.
class PaymentCode {
  const PaymentCode({
    required this.code,
    required this.type,
    required this.validity,
  });

  /// 6 chiffres, aussi encodés dans le QR.
  final String code;
  final CreditType type;
  final Duration validity;
}

/// Demande d'encaissement envoyée par le caissier après le scan.
class PaymentRequest {
  const PaymentRequest({
    required this.id,
    required this.merchantId,
    required this.merchantName,
    required this.cashier,
    required this.city,
    required this.amount,
    required this.type,
  });

  final String id;
  final String merchantId;
  final String merchantName;
  final String cashier;
  final String city;
  final int amount;
  final CreditType type;
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

/// Refus avec le contexte à afficher (aucun montant débité).
class PaymentRefusal {
  const PaymentRefusal({
    required this.reason,
    required this.merchantName,
    required this.requested,
    required this.balanceType,
    required this.balance,
    required this.acceptedTypes,
    this.missing,
  });

  final RefusalReason reason;
  final String merchantName;
  final int requested;
  final CreditType balanceType;
  final int balance;
  final List<CreditType> acceptedTypes;
  final int? missing;
}

/// Exception portant le détail d'un refus.
class PaymentRefusedException implements Exception {
  const PaymentRefusedException(this.refusal);
  final PaymentRefusal refusal;
}

abstract interface class PaymentRepository {
  Future<PaymentCode> createCode(CreditType type);

  /// Demande du caissier pour ce code. Lève [PaymentRefusedException] si le serveur refuse avant le PIN.
  Future<PaymentRequest> pendingRequest(PaymentCode code);

  /// Confirme avec le PIN (vérifié côté serveur, jamais stocké).
  /// Lève [PaymentRefusedException], `PinRefusedFailure` ou `AccountLockedFailure`.
  Future<PaymentReceipt> confirm(PaymentRequest request, String pin);
}

final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => throw UnimplementedError('paymentRepositoryProvider'),
);
