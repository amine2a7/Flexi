// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_request_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PayoutRequestStatus _$REQUESTED = const PayoutRequestStatus._(
  'REQUESTED',
);
const PayoutRequestStatus _$CHECKED = const PayoutRequestStatus._('CHECKED');
const PayoutRequestStatus _$SENT = const PayoutRequestStatus._('SENT');
const PayoutRequestStatus _$EXECUTED = const PayoutRequestStatus._('EXECUTED');
const PayoutRequestStatus _$REJECTED = const PayoutRequestStatus._('REJECTED');
const PayoutRequestStatus _$ON_HOLD = const PayoutRequestStatus._('ON_HOLD');

PayoutRequestStatus _$valueOf(String name) {
  switch (name) {
    case 'REQUESTED':
      return _$REQUESTED;
    case 'CHECKED':
      return _$CHECKED;
    case 'SENT':
      return _$SENT;
    case 'EXECUTED':
      return _$EXECUTED;
    case 'REJECTED':
      return _$REJECTED;
    case 'ON_HOLD':
      return _$ON_HOLD;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PayoutRequestStatus> _$values = BuiltSet<PayoutRequestStatus>(
  const <PayoutRequestStatus>[
    _$REQUESTED,
    _$CHECKED,
    _$SENT,
    _$EXECUTED,
    _$REJECTED,
    _$ON_HOLD,
  ],
);

class _$PayoutRequestStatusMeta {
  const _$PayoutRequestStatusMeta();
  PayoutRequestStatus get REQUESTED => _$REQUESTED;
  PayoutRequestStatus get CHECKED => _$CHECKED;
  PayoutRequestStatus get SENT => _$SENT;
  PayoutRequestStatus get EXECUTED => _$EXECUTED;
  PayoutRequestStatus get REJECTED => _$REJECTED;
  PayoutRequestStatus get ON_HOLD => _$ON_HOLD;
  PayoutRequestStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<PayoutRequestStatus> get values => _$values;
}

mixin _$PayoutRequestStatusMixin {
  // ignore: non_constant_identifier_names
  _$PayoutRequestStatusMeta get PayoutRequestStatus =>
      const _$PayoutRequestStatusMeta();
}

Serializer<PayoutRequestStatus> _$payoutRequestStatusSerializer =
    _$PayoutRequestStatusSerializer();

class _$PayoutRequestStatusSerializer
    implements PrimitiveSerializer<PayoutRequestStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REQUESTED': 'REQUESTED',
    'CHECKED': 'CHECKED',
    'SENT': 'SENT',
    'EXECUTED': 'EXECUTED',
    'REJECTED': 'REJECTED',
    'ON_HOLD': 'ON_HOLD',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REQUESTED': 'REQUESTED',
    'CHECKED': 'CHECKED',
    'SENT': 'SENT',
    'EXECUTED': 'EXECUTED',
    'REJECTED': 'REJECTED',
    'ON_HOLD': 'ON_HOLD',
  };

  @override
  final Iterable<Type> types = const <Type>[PayoutRequestStatus];
  @override
  final String wireName = 'PayoutRequestStatus';

  @override
  Object serialize(
    Serializers serializers,
    PayoutRequestStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  PayoutRequestStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => PayoutRequestStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
