import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

/// Caisse du commerce, liée à un autocollant NFC / QR.
class TillRegister {
  const TillRegister({
    required this.id,
    required this.name,
    required this.active,
  });

  final String id;
  final String name;
  final bool active;
}

enum CheckoutStatus { pending, paid, refused, expired, cancelled }

/// Demande de paiement d'une caisse : le client la lit sur l'autocollant puis confirme
/// avec son PIN. Une seule demande active par caisse ; elle expire au bout de 120 s.
class TillCheckout {
  const TillCheckout({
    required this.id,
    required this.registerName,
    required this.amount,
    required this.type,
    required this.shortCode,
    required this.validity,
    this.status = CheckoutStatus.pending,
    this.customerFirstName,
    this.refusal,
    this.missing,
    this.reference,
    this.cashier,
    this.time,
  });

  final String id;
  final String registerName;

  /// Millimes.
  final int amount;
  final CreditType type;

  /// Code à 4 chiffres affiché pour le client sans NFC ni caméra.
  final String shortCode;

  /// Durée de validité restante à la création (120 s), mesurée par le serveur.
  final Duration validity;
  final CheckoutStatus status;

  /// Prénom seul : jamais le nom complet ni le solde du client.
  final String? customerFirstName;
  final RefusalReason? refusal;

  /// Manque sur le solde (refus pour solde insuffisant), en millimes.
  final int? missing;
  final String? reference;
  final String? cashier;
  final DateTime? time;

  TillCheckout copyWith({
    CheckoutStatus? status,
    String? customerFirstName,
    RefusalReason? refusal,
    int? missing,
    String? reference,
    String? cashier,
    DateTime? time,
  }) => TillCheckout(
    id: id,
    registerName: registerName,
    amount: amount,
    type: type,
    shortCode: shortCode,
    validity: validity,
    status: status ?? this.status,
    customerFirstName: customerFirstName ?? this.customerFirstName,
    refusal: refusal ?? this.refusal,
    missing: missing ?? this.missing,
    reference: reference ?? this.reference,
    cashier: cashier ?? this.cashier,
    time: time ?? this.time,
  );
}

abstract interface class CollectRepository {
  /// Types acceptés par le commerce.
  Future<List<CreditType>> acceptedTypes();

  /// Caisse du caissier connecté (la première caisse active pour le propriétaire).
  Future<TillRegister?> myRegister();

  /// Crée la demande de la caisse (la précédente est annulée par le serveur).
  /// [idempotencyKey] est généré une fois par demande ; un nouvel essai le réutilise.
  Future<TillCheckout> request({
    required int amount,
    required CreditType type,
    required String idempotencyKey,
  });

  Future<void> cancel(String checkoutId);

  /// Suivi en temps réel (SSE) : émet la demande à chaque changement d'état.
  Stream<TillCheckout> watch(String checkoutId);

  /// Caisses du commerce (propriétaire).
  Future<List<TillRegister>> registers();

  /// Lien signé par le serveur, à écrire sur l'autocollant de la caisse.
  Future<String> stickerUrl(String registerId);
}

final collectRepositoryProvider = Provider<CollectRepository>(
  (ref) => throw UnimplementedError('collectRepositoryProvider'),
);
