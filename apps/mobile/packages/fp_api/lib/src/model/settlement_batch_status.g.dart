// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_batch_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SettlementBatchStatus _$SCHEDULED = const SettlementBatchStatus._(
  'SCHEDULED',
);
const SettlementBatchStatus _$RELEASED = const SettlementBatchStatus._(
  'RELEASED',
);
const SettlementBatchStatus _$SENT = const SettlementBatchStatus._('SENT');
const SettlementBatchStatus _$PAID = const SettlementBatchStatus._('PAID');

SettlementBatchStatus _$valueOf(String name) {
  switch (name) {
    case 'SCHEDULED':
      return _$SCHEDULED;
    case 'RELEASED':
      return _$RELEASED;
    case 'SENT':
      return _$SENT;
    case 'PAID':
      return _$PAID;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SettlementBatchStatus> _$values =
    BuiltSet<SettlementBatchStatus>(const <SettlementBatchStatus>[
      _$SCHEDULED,
      _$RELEASED,
      _$SENT,
      _$PAID,
    ]);

class _$SettlementBatchStatusMeta {
  const _$SettlementBatchStatusMeta();
  SettlementBatchStatus get SCHEDULED => _$SCHEDULED;
  SettlementBatchStatus get RELEASED => _$RELEASED;
  SettlementBatchStatus get SENT => _$SENT;
  SettlementBatchStatus get PAID => _$PAID;
  SettlementBatchStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<SettlementBatchStatus> get values => _$values;
}

mixin _$SettlementBatchStatusMixin {
  // ignore: non_constant_identifier_names
  _$SettlementBatchStatusMeta get SettlementBatchStatus =>
      const _$SettlementBatchStatusMeta();
}

Serializer<SettlementBatchStatus> _$settlementBatchStatusSerializer =
    _$SettlementBatchStatusSerializer();

class _$SettlementBatchStatusSerializer
    implements PrimitiveSerializer<SettlementBatchStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SCHEDULED': 'SCHEDULED',
    'RELEASED': 'RELEASED',
    'SENT': 'SENT',
    'PAID': 'PAID',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SCHEDULED': 'SCHEDULED',
    'RELEASED': 'RELEASED',
    'SENT': 'SENT',
    'PAID': 'PAID',
  };

  @override
  final Iterable<Type> types = const <Type>[SettlementBatchStatus];
  @override
  final String wireName = 'SettlementBatchStatus';

  @override
  Object serialize(
    Serializers serializers,
    SettlementBatchStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SettlementBatchStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SettlementBatchStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
