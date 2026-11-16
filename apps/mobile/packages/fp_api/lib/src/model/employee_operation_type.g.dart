// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_operation_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EmployeeOperationType _$PAYMENT = const EmployeeOperationType._(
  'PAYMENT',
);
const EmployeeOperationType _$ALLOCATION = const EmployeeOperationType._(
  'ALLOCATION',
);
const EmployeeOperationType _$EXPIRY = const EmployeeOperationType._('EXPIRY');
const EmployeeOperationType _$FAMILY_TRANSFER = const EmployeeOperationType._(
  'FAMILY_TRANSFER',
);

EmployeeOperationType _$valueOf(String name) {
  switch (name) {
    case 'PAYMENT':
      return _$PAYMENT;
    case 'ALLOCATION':
      return _$ALLOCATION;
    case 'EXPIRY':
      return _$EXPIRY;
    case 'FAMILY_TRANSFER':
      return _$FAMILY_TRANSFER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EmployeeOperationType> _$values =
    BuiltSet<EmployeeOperationType>(const <EmployeeOperationType>[
      _$PAYMENT,
      _$ALLOCATION,
      _$EXPIRY,
      _$FAMILY_TRANSFER,
    ]);

class _$EmployeeOperationTypeMeta {
  const _$EmployeeOperationTypeMeta();
  EmployeeOperationType get PAYMENT => _$PAYMENT;
  EmployeeOperationType get ALLOCATION => _$ALLOCATION;
  EmployeeOperationType get EXPIRY => _$EXPIRY;
  EmployeeOperationType get FAMILY_TRANSFER => _$FAMILY_TRANSFER;
  EmployeeOperationType valueOf(String name) => _$valueOf(name);
  BuiltSet<EmployeeOperationType> get values => _$values;
}

mixin _$EmployeeOperationTypeMixin {
  // ignore: non_constant_identifier_names
  _$EmployeeOperationTypeMeta get EmployeeOperationType =>
      const _$EmployeeOperationTypeMeta();
}

Serializer<EmployeeOperationType> _$employeeOperationTypeSerializer =
    _$EmployeeOperationTypeSerializer();

class _$EmployeeOperationTypeSerializer
    implements PrimitiveSerializer<EmployeeOperationType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PAYMENT': 'PAYMENT',
    'ALLOCATION': 'ALLOCATION',
    'EXPIRY': 'EXPIRY',
    'FAMILY_TRANSFER': 'FAMILY_TRANSFER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PAYMENT': 'PAYMENT',
    'ALLOCATION': 'ALLOCATION',
    'EXPIRY': 'EXPIRY',
    'FAMILY_TRANSFER': 'FAMILY_TRANSFER',
  };

  @override
  final Iterable<Type> types = const <Type>[EmployeeOperationType];
  @override
  final String wireName = 'EmployeeOperationType';

  @override
  Object serialize(
    Serializers serializers,
    EmployeeOperationType object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  EmployeeOperationType deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => EmployeeOperationType.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
