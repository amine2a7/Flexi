//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_operation_type.g.dart';

/// Paiement chez un commerçant, crédits reçus de l'entreprise, crédits expirés, transfert familial (donné, reçu ou repris).
class EmployeeOperationType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PAYMENT')
  static const EmployeeOperationType PAYMENT = _$PAYMENT;
  @BuiltValueEnumConst(wireName: r'ALLOCATION')
  static const EmployeeOperationType ALLOCATION = _$ALLOCATION;
  @BuiltValueEnumConst(wireName: r'EXPIRY')
  static const EmployeeOperationType EXPIRY = _$EXPIRY;
  @BuiltValueEnumConst(wireName: r'FAMILY_TRANSFER')
  static const EmployeeOperationType FAMILY_TRANSFER = _$FAMILY_TRANSFER;

  static Serializer<EmployeeOperationType> get serializer => _$employeeOperationTypeSerializer;

  const EmployeeOperationType._(String name): super(name);

  static BuiltSet<EmployeeOperationType> get values => _$values;
  static EmployeeOperationType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class EmployeeOperationTypeMixin = Object with _$EmployeeOperationTypeMixin;

