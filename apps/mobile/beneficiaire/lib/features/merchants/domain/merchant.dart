import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_core/fp_core.dart';

enum MerchantKind { supermarket, fuelStation, restaurant, shop }

/// Commerce partenaire.
class Merchant {
  const Merchant({
    required this.id,
    required this.name,
    required this.shortName,
    required this.kind,
    required this.city,
    required this.address,
    required this.distanceMeters,
    required this.acceptedTypes,
    required this.active,
  });

  final String id;
  final String name;

  /// Nom court (« El Medina ») pour les pastilles.
  final String shortName;
  final MerchantKind kind;
  final String city;
  final String address;
  final int distanceMeters;
  final List<CreditType> acceptedTypes;

  /// Dossier validé par FlexiPay ; un commerce inactif n'apparaît pas dans Découvrir.
  final bool active;
}

abstract interface class MerchantRepository {
  /// Commerces actifs, triés par distance.
  Future<List<Merchant>> nearby();

  Future<Merchant> byId(String id);
}

final merchantRepositoryProvider = Provider<MerchantRepository>(
  (ref) => throw UnimplementedError('merchantRepositoryProvider'),
);
