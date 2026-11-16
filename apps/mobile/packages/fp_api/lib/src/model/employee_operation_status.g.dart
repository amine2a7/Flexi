// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_operation_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EmployeeOperationStatus _$COMPLETED = const EmployeeOperationStatus._(
  'COMPLETED',
);
const EmployeeOperationStatus _$PENDING = const EmployeeOperationStatus._(
  'PENDING',
);
const EmployeeOperationStatus _$REFUSED = const EmployeeOperationStatus._(
  'REFUSED',
);

EmployeeOperationStatus _$valueOf(String name) {
  switch (name) {
    case 'COMPLETED':
      return _$COMPLETED;
    case 'PENDING':
      return _$PENDING;
    case 'REFUSED':
      return _$REFUSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EmployeeOperationStatus> _$values =
    BuiltSet<EmployeeOperationStatus>(const <EmployeeOperationStatus>[
      _$COMPLETED,
      _$PENDING,
      _$REFUSED,
    ]);

class _$EmployeeOperationStatusMeta {
  const _$EmployeeOperationStatusMeta();
  EmployeeOperationStatus get COMPLETED => _$COMPLETED;
  EmployeeOperationStatus get PENDING => _$PENDING;
  EmployeeOperationStatus get REFUSED => _$REFUSED;
  EmployeeOperationStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<EmployeeOperationStatus> get values => _$values;
}

mixin _$EmployeeOperationStatusMixin {
  // ignore: non_constant_identifier_names
  _$EmployeeOperationStatusMeta get EmployeeOperationStatus =>
      const _$EmployeeOperationStatusMeta();
}

Serializer<EmployeeOperationStatus> _$employeeOperationStatusSerializer =
    _$EmployeeOperationStatusSerializer();

class _$EmployeeOperationStatusSerializer
    implements PrimitiveSerializer<EmployeeOperationStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COMPLETED': 'COMPLETED',
    'PENDING': 'PENDING',
    'REFUSED': 'REFUSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COMPLETED': 'COMPLETED',
    'PENDING': 'PENDING',
    'REFUSED': 'REFUSED',
  };

  @override
  final Iterable<Type> types = const <Type>[EmployeeOperationStatus];
  @override
  final String wireName = 'EmployeeOperationStatus';

  @override
  Object serialize(
    Serializers serializers,
    EmployeeOperationStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  EmployeeOperationStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => EmployeeOperationStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
