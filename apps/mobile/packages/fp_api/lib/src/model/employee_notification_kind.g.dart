// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_notification_kind.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EmployeeNotificationKind _$CREDIT_RECEIVED =
    const EmployeeNotificationKind._('CREDIT_RECEIVED');
const EmployeeNotificationKind _$PAYMENT_APPROVED =
    const EmployeeNotificationKind._('PAYMENT_APPROVED');
const EmployeeNotificationKind _$FAMILY_PAYMENT =
    const EmployeeNotificationKind._('FAMILY_PAYMENT');
const EmployeeNotificationKind _$CREDIT_EXPIRING =
    const EmployeeNotificationKind._('CREDIT_EXPIRING');

EmployeeNotificationKind _$valueOf(String name) {
  switch (name) {
    case 'CREDIT_RECEIVED':
      return _$CREDIT_RECEIVED;
    case 'PAYMENT_APPROVED':
      return _$PAYMENT_APPROVED;
    case 'FAMILY_PAYMENT':
      return _$FAMILY_PAYMENT;
    case 'CREDIT_EXPIRING':
      return _$CREDIT_EXPIRING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EmployeeNotificationKind> _$values =
    BuiltSet<EmployeeNotificationKind>(const <EmployeeNotificationKind>[
      _$CREDIT_RECEIVED,
      _$PAYMENT_APPROVED,
      _$FAMILY_PAYMENT,
      _$CREDIT_EXPIRING,
    ]);

class _$EmployeeNotificationKindMeta {
  const _$EmployeeNotificationKindMeta();
  EmployeeNotificationKind get CREDIT_RECEIVED => _$CREDIT_RECEIVED;
  EmployeeNotificationKind get PAYMENT_APPROVED => _$PAYMENT_APPROVED;
  EmployeeNotificationKind get FAMILY_PAYMENT => _$FAMILY_PAYMENT;
  EmployeeNotificationKind get CREDIT_EXPIRING => _$CREDIT_EXPIRING;
  EmployeeNotificationKind valueOf(String name) => _$valueOf(name);
  BuiltSet<EmployeeNotificationKind> get values => _$values;
}

mixin _$EmployeeNotificationKindMixin {
  // ignore: non_constant_identifier_names
  _$EmployeeNotificationKindMeta get EmployeeNotificationKind =>
      const _$EmployeeNotificationKindMeta();
}

Serializer<EmployeeNotificationKind> _$employeeNotificationKindSerializer =
    _$EmployeeNotificationKindSerializer();

class _$EmployeeNotificationKindSerializer
    implements PrimitiveSerializer<EmployeeNotificationKind> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CREDIT_RECEIVED': 'CREDIT_RECEIVED',
    'PAYMENT_APPROVED': 'PAYMENT_APPROVED',
    'FAMILY_PAYMENT': 'FAMILY_PAYMENT',
    'CREDIT_EXPIRING': 'CREDIT_EXPIRING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CREDIT_RECEIVED': 'CREDIT_RECEIVED',
    'PAYMENT_APPROVED': 'PAYMENT_APPROVED',
    'FAMILY_PAYMENT': 'FAMILY_PAYMENT',
    'CREDIT_EXPIRING': 'CREDIT_EXPIRING',
  };

  @override
  final Iterable<Type> types = const <Type>[EmployeeNotificationKind];
  @override
  final String wireName = 'EmployeeNotificationKind';

  @override
  Object serialize(
    Serializers serializers,
    EmployeeNotificationKind object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  EmployeeNotificationKind deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => EmployeeNotificationKind.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
