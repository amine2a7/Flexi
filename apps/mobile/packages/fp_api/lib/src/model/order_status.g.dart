// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderStatus _$AWAITING_CONFIRMATION = const OrderStatus._(
  'AWAITING_CONFIRMATION',
);
const OrderStatus _$AWAITING_PAYMENT = const OrderStatus._('AWAITING_PAYMENT');
const OrderStatus _$AWAITING_VALIDATION = const OrderStatus._(
  'AWAITING_VALIDATION',
);
const OrderStatus _$VALIDATED = const OrderStatus._('VALIDATED');
const OrderStatus _$REFUSED = const OrderStatus._('REFUSED');
const OrderStatus _$CANCELLED = const OrderStatus._('CANCELLED');

OrderStatus _$valueOf(String name) {
  switch (name) {
    case 'AWAITING_CONFIRMATION':
      return _$AWAITING_CONFIRMATION;
    case 'AWAITING_PAYMENT':
      return _$AWAITING_PAYMENT;
    case 'AWAITING_VALIDATION':
      return _$AWAITING_VALIDATION;
    case 'VALIDATED':
      return _$VALIDATED;
    case 'REFUSED':
      return _$REFUSED;
    case 'CANCELLED':
      return _$CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderStatus> _$values = BuiltSet<OrderStatus>(
  const <OrderStatus>[
    _$AWAITING_CONFIRMATION,
    _$AWAITING_PAYMENT,
    _$AWAITING_VALIDATION,
    _$VALIDATED,
    _$REFUSED,
    _$CANCELLED,
  ],
);

class _$OrderStatusMeta {
  const _$OrderStatusMeta();
  OrderStatus get AWAITING_CONFIRMATION => _$AWAITING_CONFIRMATION;
  OrderStatus get AWAITING_PAYMENT => _$AWAITING_PAYMENT;
  OrderStatus get AWAITING_VALIDATION => _$AWAITING_VALIDATION;
  OrderStatus get VALIDATED => _$VALIDATED;
  OrderStatus get REFUSED => _$REFUSED;
  OrderStatus get CANCELLED => _$CANCELLED;
  OrderStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<OrderStatus> get values => _$values;
}

mixin _$OrderStatusMixin {
  // ignore: non_constant_identifier_names
  _$OrderStatusMeta get OrderStatus => const _$OrderStatusMeta();
}

Serializer<OrderStatus> _$orderStatusSerializer = _$OrderStatusSerializer();

class _$OrderStatusSerializer implements PrimitiveSerializer<OrderStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AWAITING_CONFIRMATION': 'AWAITING_CONFIRMATION',
    'AWAITING_PAYMENT': 'AWAITING_PAYMENT',
    'AWAITING_VALIDATION': 'AWAITING_VALIDATION',
    'VALIDATED': 'VALIDATED',
    'REFUSED': 'REFUSED',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AWAITING_CONFIRMATION': 'AWAITING_CONFIRMATION',
    'AWAITING_PAYMENT': 'AWAITING_PAYMENT',
    'AWAITING_VALIDATION': 'AWAITING_VALIDATION',
    'VALIDATED': 'VALIDATED',
    'REFUSED': 'REFUSED',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderStatus];
  @override
  final String wireName = 'OrderStatus';

  @override
  Object serialize(
    Serializers serializers,
    OrderStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  OrderStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => OrderStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
