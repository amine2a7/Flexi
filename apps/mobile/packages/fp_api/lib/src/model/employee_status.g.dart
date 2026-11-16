// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EmployeeStatus _$INVITED = const EmployeeStatus._('INVITED');
const EmployeeStatus _$ACTIVE = const EmployeeStatus._('ACTIVE');
const EmployeeStatus _$SUSPENDED = const EmployeeStatus._('SUSPENDED');
const EmployeeStatus _$DEACTIVATED = const EmployeeStatus._('DEACTIVATED');

EmployeeStatus _$valueOf(String name) {
  switch (name) {
    case 'INVITED':
      return _$INVITED;
    case 'ACTIVE':
      return _$ACTIVE;
    case 'SUSPENDED':
      return _$SUSPENDED;
    case 'DEACTIVATED':
      return _$DEACTIVATED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EmployeeStatus> _$values = BuiltSet<EmployeeStatus>(
  const <EmployeeStatus>[_$INVITED, _$ACTIVE, _$SUSPENDED, _$DEACTIVATED],
);

class _$EmployeeStatusMeta {
  const _$EmployeeStatusMeta();
  EmployeeStatus get INVITED => _$INVITED;
  EmployeeStatus get ACTIVE => _$ACTIVE;
  EmployeeStatus get SUSPENDED => _$SUSPENDED;
  EmployeeStatus get DEACTIVATED => _$DEACTIVATED;
  EmployeeStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<EmployeeStatus> get values => _$values;
}

mixin _$EmployeeStatusMixin {
  // ignore: non_constant_identifier_names
  _$EmployeeStatusMeta get EmployeeStatus => const _$EmployeeStatusMeta();
}

Serializer<EmployeeStatus> _$employeeStatusSerializer =
    _$EmployeeStatusSerializer();

class _$EmployeeStatusSerializer
    implements PrimitiveSerializer<EmployeeStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INVITED': 'INVITED',
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
    'DEACTIVATED': 'DEACTIVATED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INVITED': 'INVITED',
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
    'DEACTIVATED': 'DEACTIVATED',
  };

  @override
  final Iterable<Type> types = const <Type>[EmployeeStatus];
  @override
  final String wireName = 'EmployeeStatus';

  @override
  Object serialize(
    Serializers serializers,
    EmployeeStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  EmployeeStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => EmployeeStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
