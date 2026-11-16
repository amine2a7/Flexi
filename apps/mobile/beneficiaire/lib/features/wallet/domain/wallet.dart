import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

/// Un crédit d'un type donné. Tous les montants sont en millimes.
class Credit {
  const Credit({
    required this.type,
    required this.balance,
    required this.received,
    required this.used,
    required this.shared,
    required this.expiresOn,
    required this.paymentCount,
  });

  final CreditType type;
  final int balance;
  final int received;
  final int used;
  final int shared;
  final DateTime expiresOn;
  final int paymentCount;

  Credit copyWith({int? balance, int? shared}) => Credit(
    type: type,
    balance: balance ?? this.balance,
    received: received,
    used: used,
    shared: shared ?? this.shared,
    expiresOn: expiresOn,
    paymentCount: paymentCount,
  );
}

/// Portefeuille du bénéficiaire.
class Wallet {
  const Wallet({required this.company, required this.credits});

  final String company;

  /// Crédits reçus, dans l'ordre d'affichage (types sans crédit absents).
  final List<Credit> credits;

  int get total => credits.fold(0, (sum, c) => sum + c.balance);

  Credit? credit(CreditType type) {
    for (final c in credits) {
      if (c.type == type) return c;
    }
    return null;
  }
}

/// Nature d'une opération dans l'historique.
enum OperationKind { payment, creditReceived, familyShare, familyReclaim }

/// Une ligne d'historique. [amount] est signé : négatif pour une dépense.
class Operation {
  const Operation({
    required this.id,
    required this.kind,
    required this.amount,
    required this.date,
    this.type,
    this.merchantId,
    this.merchantName,
    this.counterpart,
    this.cashier,
    this.reference,
    this.balanceBefore,
    this.balanceAfter,
    this.breakdown = const {},
  });

  final String id;
  final OperationKind kind;
  final int amount;
  final DateTime date;
  final CreditType? type;
  final String? merchantId;
  final String? merchantName;

  /// Entreprise qui a crédité, ou membre famille.
  final String? counterpart;
  final String? cashier;
  final String? reference;
  final int? balanceBefore;
  final int? balanceAfter;

  /// Détail d'un crédit reçu sur plusieurs types.
  final Map<CreditType, int> breakdown;
}

abstract interface class WalletRepository {
  Future<Wallet> wallet();

  /// Opérations d'un mois, de la plus récente à la plus ancienne.
  Future<List<Operation>> operations({required int year, required int month});

  Future<Operation> operation(String id);
}

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => throw UnimplementedError('walletRepositoryProvider'),
);
