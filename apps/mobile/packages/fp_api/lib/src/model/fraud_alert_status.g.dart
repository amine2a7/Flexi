// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fraud_alert_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FraudAlertStatus _$OPEN = const FraudAlertStatus._('OPEN');
const FraudAlertStatus _$IN_PROGRESS = const FraudAlertStatus._('IN_PROGRESS');
const FraudAlertStatus _$CLOSED = const FraudAlertStatus._('CLOSED');

FraudAlertStatus _$valueOf(String name) {
  switch (name) {
    case 'OPEN':
      return _$OPEN;
    case 'IN_PROGRESS':
      return _$IN_PROGRESS;
    case 'CLOSED':
      return _$CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FraudAlertStatus> _$values = BuiltSet<FraudAlertStatus>(
  const <FraudAlertStatus>[_$OPEN, _$IN_PROGRESS, _$CLOSED],
);

class _$FraudAlertStatusMeta {
  const _$FraudAlertStatusMeta();
  FraudAlertStatus get OPEN => _$OPEN;
  FraudAlertStatus get IN_PROGRESS => _$IN_PROGRESS;
  FraudAlertStatus get CLOSED => _$CLOSED;
  FraudAlertStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<FraudAlertStatus> get values => _$values;
}

mixin _$FraudAlertStatusMixin {
  // ignore: non_constant_identifier_names
  _$FraudAlertStatusMeta get FraudAlertStatus => const _$FraudAlertStatusMeta();
}

Serializer<FraudAlertStatus> _$fraudAlertStatusSerializer =
    _$FraudAlertStatusSerializer();

class _$FraudAlertStatusSerializer
    implements PrimitiveSerializer<FraudAlertStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'IN_PROGRESS': 'IN_PROGRESS',
    'CLOSED': 'CLOSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'IN_PROGRESS': 'IN_PROGRESS',
    'CLOSED': 'CLOSED',
  };

  @override
  final Iterable<Type> types = const <Type>[FraudAlertStatus];
  @override
  final String wireName = 'FraudAlertStatus';

  @override
  Object serialize(
    Serializers serializers,
    FraudAlertStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  FraudAlertStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => FraudAlertStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
