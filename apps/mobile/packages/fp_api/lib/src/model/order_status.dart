//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_status.g.dart';

/// Commande de crédits — En attente de confirmation (par l'administrateur), En attente de paiement (virement à déclarer par l'entreprise), En attente de validation (virement déclaré, à vérifier par l'administrateur), Validée (crédits ajoutés au solde), Refusée, Annulée. 
class OrderStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AWAITING_CONFIRMATION')
  static const OrderStatus AWAITING_CONFIRMATION = _$AWAITING_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'AWAITING_PAYMENT')
  static const OrderStatus AWAITING_PAYMENT = _$AWAITING_PAYMENT;
  @BuiltValueEnumConst(wireName: r'AWAITING_VALIDATION')
  static const OrderStatus AWAITING_VALIDATION = _$AWAITING_VALIDATION;
  @BuiltValueEnumConst(wireName: r'VALIDATED')
  static const OrderStatus VALIDATED = _$VALIDATED;
  @BuiltValueEnumConst(wireName: r'REFUSED')
  static const OrderStatus REFUSED = _$REFUSED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const OrderStatus CANCELLED = _$CANCELLED;

  static Serializer<OrderStatus> get serializer => _$orderStatusSerializer;

  const OrderStatus._(String name): super(name);

  static BuiltSet<OrderStatus> get values => _$values;
  static OrderStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class OrderStatusMixin = Object with _$OrderStatusMixin;

