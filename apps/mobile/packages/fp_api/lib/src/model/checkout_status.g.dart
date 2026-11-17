// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CheckoutStatus _$PENDING = const CheckoutStatus._('PENDING');
const CheckoutStatus _$PAID = const CheckoutStatus._('PAID');
const CheckoutStatus _$EXPIRED = const CheckoutStatus._('EXPIRED');
const CheckoutStatus _$CANCELLED = const CheckoutStatus._('CANCELLED');

CheckoutStatus _$valueOf(String name) {
  switch (name) {
    case 'PENDING':
      return _$PENDING;
    case 'PAID':
      return _$PAID;
    case 'EXPIRED':
      return _$EXPIRED;
    case 'CANCELLED':
      return _$CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckoutStatus> _$values = BuiltSet<CheckoutStatus>(
  const <CheckoutStatus>[_$PENDING, _$PAID, _$EXPIRED, _$CANCELLED],
);

class _$CheckoutStatusMeta {
  const _$CheckoutStatusMeta();
  CheckoutStatus get PENDING => _$PENDING;
  CheckoutStatus get PAID => _$PAID;
  CheckoutStatus get EXPIRED => _$EXPIRED;
  CheckoutStatus get CANCELLED => _$CANCELLED;
  CheckoutStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<CheckoutStatus> get values => _$values;
}

mixin _$CheckoutStatusMixin {
  // ignore: non_constant_identifier_names
  _$CheckoutStatusMeta get CheckoutStatus => const _$CheckoutStatusMeta();
}

Serializer<CheckoutStatus> _$checkoutStatusSerializer =
    _$CheckoutStatusSerializer();

class _$CheckoutStatusSerializer
    implements PrimitiveSerializer<CheckoutStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'PAID': 'PAID',
    'EXPIRED': 'EXPIRED',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'PAID': 'PAID',
    'EXPIRED': 'EXPIRED',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[CheckoutStatus];
  @override
  final String wireName = 'CheckoutStatus';

  @override
  Object serialize(
    Serializers serializers,
    CheckoutStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CheckoutStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CheckoutStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
