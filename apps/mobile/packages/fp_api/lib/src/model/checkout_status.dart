//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_status.g.dart';

class CheckoutStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const CheckoutStatus PENDING = _$PENDING;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const CheckoutStatus PAID = _$PAID;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const CheckoutStatus EXPIRED = _$EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CheckoutStatus CANCELLED = _$CANCELLED;

  static Serializer<CheckoutStatus> get serializer => _$checkoutStatusSerializer;

  const CheckoutStatus._(String name): super(name);

  static BuiltSet<CheckoutStatus> get values => _$values;
  static CheckoutStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class CheckoutStatusMixin = Object with _$CheckoutStatusMixin;

