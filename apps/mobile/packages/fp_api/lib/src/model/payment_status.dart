//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_status.g.dart';

/// Paiement — Initié, Confirmé, Réglé, Refusé, En litige (cahier v4.1 §8).
class PaymentStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INITIATED')
  static const PaymentStatus INITIATED = _$INITIATED;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const PaymentStatus CONFIRMED = _$CONFIRMED;
  @BuiltValueEnumConst(wireName: r'SETTLED')
  static const PaymentStatus SETTLED = _$SETTLED;
  @BuiltValueEnumConst(wireName: r'REFUSED')
  static const PaymentStatus REFUSED = _$REFUSED;
  @BuiltValueEnumConst(wireName: r'DISPUTED')
  static const PaymentStatus DISPUTED = _$DISPUTED;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const PaymentStatus REFUNDED = _$REFUNDED;

  static Serializer<PaymentStatus> get serializer => _$paymentStatusSerializer;

  const PaymentStatus._(String name): super(name);

  static BuiltSet<PaymentStatus> get values => _$values;
  static PaymentStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PaymentStatusMixin = Object with _$PaymentStatusMixin;

