// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fraud_alert_severity.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FraudAlertSeverity _$HIGH = const FraudAlertSeverity._('HIGH');
const FraudAlertSeverity _$MEDIUM = const FraudAlertSeverity._('MEDIUM');
const FraudAlertSeverity _$LOW = const FraudAlertSeverity._('LOW');

FraudAlertSeverity _$valueOf(String name) {
  switch (name) {
    case 'HIGH':
      return _$HIGH;
    case 'MEDIUM':
      return _$MEDIUM;
    case 'LOW':
      return _$LOW;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FraudAlertSeverity> _$values = BuiltSet<FraudAlertSeverity>(
  const <FraudAlertSeverity>[_$HIGH, _$MEDIUM, _$LOW],
);

class _$FraudAlertSeverityMeta {
  const _$FraudAlertSeverityMeta();
  FraudAlertSeverity get HIGH => _$HIGH;
  FraudAlertSeverity get MEDIUM => _$MEDIUM;
  FraudAlertSeverity get LOW => _$LOW;
  FraudAlertSeverity valueOf(String name) => _$valueOf(name);
  BuiltSet<FraudAlertSeverity> get values => _$values;
}

mixin _$FraudAlertSeverityMixin {
  // ignore: non_constant_identifier_names
  _$FraudAlertSeverityMeta get FraudAlertSeverity =>
      const _$FraudAlertSeverityMeta();
}

Serializer<FraudAlertSeverity> _$fraudAlertSeveritySerializer =
    _$FraudAlertSeveritySerializer();

class _$FraudAlertSeveritySerializer
    implements PrimitiveSerializer<FraudAlertSeverity> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'HIGH': 'HIGH',
    'MEDIUM': 'MEDIUM',
    'LOW': 'LOW',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'HIGH': 'HIGH',
    'MEDIUM': 'MEDIUM',
    'LOW': 'LOW',
  };

  @override
  final Iterable<Type> types = const <Type>[FraudAlertSeverity];
  @override
  final String wireName = 'FraudAlertSeverity';

  @override
  Object serialize(
    Serializers serializers,
    FraudAlertSeverity object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  FraudAlertSeverity deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => FraudAlertSeverity.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
