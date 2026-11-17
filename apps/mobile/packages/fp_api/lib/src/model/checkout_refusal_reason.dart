//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_refusal_reason.g.dart';

class CheckoutRefusalReason extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CREDIT_TYPE_NOT_ACCEPTED')
  static const CheckoutRefusalReason CREDIT_TYPE_NOT_ACCEPTED = _$CREDIT_TYPE_NOT_ACCEPTED;
  @BuiltValueEnumConst(wireName: r'MERCHANT_NOT_ACTIVE')
  static const CheckoutRefusalReason MERCHANT_NOT_ACTIVE = _$MERCHANT_NOT_ACTIVE;
  @BuiltValueEnumConst(wireName: r'CHECKOUT_EXPIRED')
  static const CheckoutRefusalReason CHECKOUT_EXPIRED = _$CHECKOUT_EXPIRED;
  @BuiltValueEnumConst(wireName: r'ALREADY_PAID')
  static const CheckoutRefusalReason ALREADY_PAID = _$ALREADY_PAID;
  @BuiltValueEnumConst(wireName: r'STICKER_INVALID')
  static const CheckoutRefusalReason STICKER_INVALID = _$STICKER_INVALID;
  @BuiltValueEnumConst(wireName: r'NO_PENDING_CHECKOUT')
  static const CheckoutRefusalReason NO_PENDING_CHECKOUT = _$NO_PENDING_CHECKOUT;

  static Serializer<CheckoutRefusalReason> get serializer => _$checkoutRefusalReasonSerializer;

  const CheckoutRefusalReason._(String name): super(name);

  static BuiltSet<CheckoutRefusalReason> get values => _$values;
  static CheckoutRefusalReason valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class CheckoutRefusalReasonMixin = Object with _$CheckoutRefusalReasonMixin;

