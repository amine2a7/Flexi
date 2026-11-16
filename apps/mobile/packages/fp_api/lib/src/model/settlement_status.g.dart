// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SettlementStatus _$SCHEDULED = const SettlementStatus._('SCHEDULED');
const SettlementStatus _$PAID = const SettlementStatus._('PAID');

SettlementStatus _$valueOf(String name) {
  switch (name) {
    case 'SCHEDULED':
      return _$SCHEDULED;
    case 'PAID':
      return _$PAID;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SettlementStatus> _$values = BuiltSet<SettlementStatus>(
  const <SettlementStatus>[_$SCHEDULED, _$PAID],
);

class _$SettlementStatusMeta {
  const _$SettlementStatusMeta();
  SettlementStatus get SCHEDULED => _$SCHEDULED;
  SettlementStatus get PAID => _$PAID;
  SettlementStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<SettlementStatus> get values => _$values;
}

mixin _$SettlementStatusMixin {
  // ignore: non_constant_identifier_names
  _$SettlementStatusMeta get SettlementStatus => const _$SettlementStatusMeta();
}

Serializer<SettlementStatus> _$settlementStatusSerializer =
    _$SettlementStatusSerializer();

class _$SettlementStatusSerializer
    implements PrimitiveSerializer<SettlementStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SCHEDULED': 'SCHEDULED',
    'PAID': 'PAID',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SCHEDULED': 'SCHEDULED',
    'PAID': 'PAID',
  };

  @override
  final Iterable<Type> types = const <Type>[SettlementStatus];
  @override
  final String wireName = 'SettlementStatus';

  @override
  Object serialize(
    Serializers serializers,
    SettlementStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SettlementStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SettlementStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
