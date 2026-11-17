// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_refusal_reason.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CheckoutRefusalReason _$CREDIT_TYPE_NOT_ACCEPTED =
    const CheckoutRefusalReason._('CREDIT_TYPE_NOT_ACCEPTED');
const CheckoutRefusalReason _$MERCHANT_NOT_ACTIVE =
    const CheckoutRefusalReason._('MERCHANT_NOT_ACTIVE');
const CheckoutRefusalReason _$CHECKOUT_EXPIRED = const CheckoutRefusalReason._(
  'CHECKOUT_EXPIRED',
);
const CheckoutRefusalReason _$ALREADY_PAID = const CheckoutRefusalReason._(
  'ALREADY_PAID',
);
const CheckoutRefusalReason _$STICKER_INVALID = const CheckoutRefusalReason._(
  'STICKER_INVALID',
);
const CheckoutRefusalReason _$NO_PENDING_CHECKOUT =
    const CheckoutRefusalReason._('NO_PENDING_CHECKOUT');

CheckoutRefusalReason _$valueOf(String name) {
  switch (name) {
    case 'CREDIT_TYPE_NOT_ACCEPTED':
      return _$CREDIT_TYPE_NOT_ACCEPTED;
    case 'MERCHANT_NOT_ACTIVE':
      return _$MERCHANT_NOT_ACTIVE;
    case 'CHECKOUT_EXPIRED':
      return _$CHECKOUT_EXPIRED;
    case 'ALREADY_PAID':
      return _$ALREADY_PAID;
    case 'STICKER_INVALID':
      return _$STICKER_INVALID;
    case 'NO_PENDING_CHECKOUT':
      return _$NO_PENDING_CHECKOUT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckoutRefusalReason> _$values =
    BuiltSet<CheckoutRefusalReason>(const <CheckoutRefusalReason>[
      _$CREDIT_TYPE_NOT_ACCEPTED,
      _$MERCHANT_NOT_ACTIVE,
      _$CHECKOUT_EXPIRED,
      _$ALREADY_PAID,
      _$STICKER_INVALID,
      _$NO_PENDING_CHECKOUT,
    ]);

class _$CheckoutRefusalReasonMeta {
  const _$CheckoutRefusalReasonMeta();
  CheckoutRefusalReason get CREDIT_TYPE_NOT_ACCEPTED =>
      _$CREDIT_TYPE_NOT_ACCEPTED;
  CheckoutRefusalReason get MERCHANT_NOT_ACTIVE => _$MERCHANT_NOT_ACTIVE;
  CheckoutRefusalReason get CHECKOUT_EXPIRED => _$CHECKOUT_EXPIRED;
  CheckoutRefusalReason get ALREADY_PAID => _$ALREADY_PAID;
  CheckoutRefusalReason get STICKER_INVALID => _$STICKER_INVALID;
  CheckoutRefusalReason get NO_PENDING_CHECKOUT => _$NO_PENDING_CHECKOUT;
  CheckoutRefusalReason valueOf(String name) => _$valueOf(name);
  BuiltSet<CheckoutRefusalReason> get values => _$values;
}

mixin _$CheckoutRefusalReasonMixin {
  // ignore: non_constant_identifier_names
  _$CheckoutRefusalReasonMeta get CheckoutRefusalReason =>
      const _$CheckoutRefusalReasonMeta();
}

Serializer<CheckoutRefusalReason> _$checkoutRefusalReasonSerializer =
    _$CheckoutRefusalReasonSerializer();

class _$CheckoutRefusalReasonSerializer
    implements PrimitiveSerializer<CheckoutRefusalReason> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CREDIT_TYPE_NOT_ACCEPTED': 'CREDIT_TYPE_NOT_ACCEPTED',
    'MERCHANT_NOT_ACTIVE': 'MERCHANT_NOT_ACTIVE',
    'CHECKOUT_EXPIRED': 'CHECKOUT_EXPIRED',
    'ALREADY_PAID': 'ALREADY_PAID',
    'STICKER_INVALID': 'STICKER_INVALID',
    'NO_PENDING_CHECKOUT': 'NO_PENDING_CHECKOUT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CREDIT_TYPE_NOT_ACCEPTED': 'CREDIT_TYPE_NOT_ACCEPTED',
    'MERCHANT_NOT_ACTIVE': 'MERCHANT_NOT_ACTIVE',
    'CHECKOUT_EXPIRED': 'CHECKOUT_EXPIRED',
    'ALREADY_PAID': 'ALREADY_PAID',
    'STICKER_INVALID': 'STICKER_INVALID',
    'NO_PENDING_CHECKOUT': 'NO_PENDING_CHECKOUT',
  };

  @override
  final Iterable<Type> types = const <Type>[CheckoutRefusalReason];
  @override
  final String wireName = 'CheckoutRefusalReason';

  @override
  Object serialize(
    Serializers serializers,
    CheckoutRefusalReason object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CheckoutRefusalReason deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CheckoutRefusalReason.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
