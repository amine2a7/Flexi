//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_operation_status.g.dart';

class EmployeeOperationStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const EmployeeOperationStatus COMPLETED = _$COMPLETED;
  @BuiltValueEnumConst(wireName: r'PENDING')
  static const EmployeeOperationStatus PENDING = _$PENDING;
  @BuiltValueEnumConst(wireName: r'REFUSED')
  static const EmployeeOperationStatus REFUSED = _$REFUSED;

  static Serializer<EmployeeOperationStatus> get serializer => _$employeeOperationStatusSerializer;

  const EmployeeOperationStatus._(String name): super(name);

  static BuiltSet<EmployeeOperationStatus> get values => _$values;
  static EmployeeOperationStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class EmployeeOperationStatusMixin = Object with _$EmployeeOperationStatusMixin;

