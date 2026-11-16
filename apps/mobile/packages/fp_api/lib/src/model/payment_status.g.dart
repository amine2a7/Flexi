// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentStatus _$INITIATED = const PaymentStatus._('INITIATED');
const PaymentStatus _$CONFIRMED = const PaymentStatus._('CONFIRMED');
const PaymentStatus _$SETTLED = const PaymentStatus._('SETTLED');
const PaymentStatus _$REFUSED = const PaymentStatus._('REFUSED');
const PaymentStatus _$DISPUTED = const PaymentStatus._('DISPUTED');
const PaymentStatus _$REFUNDED = const PaymentStatus._('REFUNDED');

PaymentStatus _$valueOf(String name) {
  switch (name) {
    case 'INITIATED':
      return _$INITIATED;
    case 'CONFIRMED':
      return _$CONFIRMED;
    case 'SETTLED':
      return _$SETTLED;
    case 'REFUSED':
      return _$REFUSED;
    case 'DISPUTED':
      return _$DISPUTED;
    case 'REFUNDED':
      return _$REFUNDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentStatus> _$values = BuiltSet<PaymentStatus>(
  const <PaymentStatus>[
    _$INITIATED,
    _$CONFIRMED,
    _$SETTLED,
    _$REFUSED,
    _$DISPUTED,
    _$REFUNDED,
  ],
);

class _$PaymentStatusMeta {
  const _$PaymentStatusMeta();
  PaymentStatus get INITIATED => _$INITIATED;
  PaymentStatus get CONFIRMED => _$CONFIRMED;
  PaymentStatus get SETTLED => _$SETTLED;
  PaymentStatus get REFUSED => _$REFUSED;
  PaymentStatus get DISPUTED => _$DISPUTED;
  PaymentStatus get REFUNDED => _$REFUNDED;
  PaymentStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<PaymentStatus> get values => _$values;
}

mixin _$PaymentStatusMixin {
  // ignore: non_constant_identifier_names
  _$PaymentStatusMeta get PaymentStatus => const _$PaymentStatusMeta();
}

Serializer<PaymentStatus> _$paymentStatusSerializer =
    _$PaymentStatusSerializer();

class _$PaymentStatusSerializer implements PrimitiveSerializer<PaymentStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INITIATED': 'INITIATED',
    'CONFIRMED': 'CONFIRMED',
    'SETTLED': 'SETTLED',
    'REFUSED': 'REFUSED',
    'DISPUTED': 'DISPUTED',
    'REFUNDED': 'REFUNDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INITIATED': 'INITIATED',
    'CONFIRMED': 'CONFIRMED',
    'SETTLED': 'SETTLED',
    'REFUSED': 'REFUSED',
    'DISPUTED': 'DISPUTED',
    'REFUNDED': 'REFUNDED',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentStatus];
  @override
  final String wireName = 'PaymentStatus';

  @override
  Object serialize(
    Serializers serializers,
    PaymentStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  PaymentStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => PaymentStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
