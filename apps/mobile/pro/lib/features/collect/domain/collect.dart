import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

/// Client reconnu après le scan ou la saisie du code.
class Customer {
  const Customer({
    required this.displayName,
    required this.initial,
    required this.organization,
    required this.availableType,
    required this.available,
  });

  /// « Yasmine B. » : jamais le nom complet ni le solde global.
  final String displayName;
  final String initial;
  final String organization;
  final CreditType availableType;

  /// Solde disponible du type demandé, renvoyé par le serveur.
  final int available;
}

/// Résultat d'un encaissement.
class CollectResult {
  const CollectResult({
    required this.approved,
    required this.amount,
    required this.customerName,
    required this.type,
    required this.cashier,
    required this.time,
    this.reference,
    this.missing,
  });

  final bool approved;
  final int amount;
  final String customerName;
  final CreditType type;
  final String cashier;
  final DateTime time;
  final String? reference;
  final int? missing;
}

abstract interface class CollectRepository {
  /// Types acceptés par le commerce.
  Future<List<CreditType>> acceptedTypes();

  /// Identifie le client à partir du code à 6 chiffres (QR ou saisie).
  Future<Customer> lookup(String code, CreditType type);

  /// Envoie la demande ; le client confirme avec son PIN sur son téléphone.
  /// [idempotencyKey] est généré une fois par encaissement.
  Future<CollectResult> collect({
    required String code,
    required int amount,
    required CreditType type,
    required String idempotencyKey,
  });
}

final collectRepositoryProvider = Provider<CollectRepository>(
  (ref) => throw UnimplementedError('collectRepositoryProvider'),
);
