//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_notification_kind.g.dart';

class EmployeeNotificationKind extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CREDIT_RECEIVED')
  static const EmployeeNotificationKind CREDIT_RECEIVED = _$CREDIT_RECEIVED;
  @BuiltValueEnumConst(wireName: r'PAYMENT_APPROVED')
  static const EmployeeNotificationKind PAYMENT_APPROVED = _$PAYMENT_APPROVED;
  @BuiltValueEnumConst(wireName: r'FAMILY_PAYMENT')
  static const EmployeeNotificationKind FAMILY_PAYMENT = _$FAMILY_PAYMENT;
  @BuiltValueEnumConst(wireName: r'CREDIT_EXPIRING')
  static const EmployeeNotificationKind CREDIT_EXPIRING = _$CREDIT_EXPIRING;

  static Serializer<EmployeeNotificationKind> get serializer => _$employeeNotificationKindSerializer;

  const EmployeeNotificationKind._(String name): super(name);

  static BuiltSet<EmployeeNotificationKind> get values => _$values;
  static EmployeeNotificationKind valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class EmployeeNotificationKindMixin = Object with _$EmployeeNotificationKindMixin;

