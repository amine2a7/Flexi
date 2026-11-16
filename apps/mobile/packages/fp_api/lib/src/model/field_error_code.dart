//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'field_error_code.g.dart';

/// Motif d'invalidité d'un champ. Liste extensible.
class FieldErrorCode extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUIRED')
  static const FieldErrorCode REQUIRED = _$REQUIRED;
  @BuiltValueEnumConst(wireName: r'INVALID_TYPE')
  static const FieldErrorCode INVALID_TYPE = _$INVALID_TYPE;
  @BuiltValueEnumConst(wireName: r'INVALID_FORMAT')
  static const FieldErrorCode INVALID_FORMAT = _$INVALID_FORMAT;
  @BuiltValueEnumConst(wireName: r'INVALID_ENUM')
  static const FieldErrorCode INVALID_ENUM = _$INVALID_ENUM;
  @BuiltValueEnumConst(wireName: r'NOT_INTEGER')
  static const FieldErrorCode NOT_INTEGER = _$NOT_INTEGER;
  @BuiltValueEnumConst(wireName: r'TOO_SMALL')
  static const FieldErrorCode TOO_SMALL = _$TOO_SMALL;
  @BuiltValueEnumConst(wireName: r'TOO_BIG')
  static const FieldErrorCode TOO_BIG = _$TOO_BIG;
  @BuiltValueEnumConst(wireName: r'TOO_SHORT')
  static const FieldErrorCode TOO_SHORT = _$TOO_SHORT;
  @BuiltValueEnumConst(wireName: r'TOO_LONG')
  static const FieldErrorCode TOO_LONG = _$TOO_LONG;
  @BuiltValueEnumConst(wireName: r'UNKNOWN_FIELD')
  static const FieldErrorCode UNKNOWN_FIELD = _$UNKNOWN_FIELD;
  @BuiltValueEnumConst(wireName: r'INVALID_CURSOR')
  static const FieldErrorCode INVALID_CURSOR = _$INVALID_CURSOR;
  @BuiltValueEnumConst(wireName: r'CURRENT_PASSWORD_INVALID')
  static const FieldErrorCode CURRENT_PASSWORD_INVALID = _$CURRENT_PASSWORD_INVALID;
  @BuiltValueEnumConst(wireName: r'PASSWORD_POLICY_VIOLATION')
  static const FieldErrorCode PASSWORD_POLICY_VIOLATION = _$PASSWORD_POLICY_VIOLATION;
  @BuiltValueEnumConst(wireName: r'IN_FUTURE')
  static const FieldErrorCode IN_FUTURE = _$IN_FUTURE;
  @BuiltValueEnumConst(wireName: r'GRID_OVERLAP')
  static const FieldErrorCode GRID_OVERLAP = _$GRID_OVERLAP;
  @BuiltValueEnumConst(wireName: r'GRID_DEFAULT_REQUIRED')
  static const FieldErrorCode GRID_DEFAULT_REQUIRED = _$GRID_DEFAULT_REQUIRED;
  @BuiltValueEnumConst(wireName: r'GRID_DEFAULT_DUPLICATE')
  static const FieldErrorCode GRID_DEFAULT_DUPLICATE = _$GRID_DEFAULT_DUPLICATE;
  @BuiltValueEnumConst(wireName: r'GRID_BOUNDS')
  static const FieldErrorCode GRID_BOUNDS = _$GRID_BOUNDS;

  static Serializer<FieldErrorCode> get serializer => _$fieldErrorCodeSerializer;

  const FieldErrorCode._(String name): super(name);

  static BuiltSet<FieldErrorCode> get values => _$values;
  static FieldErrorCode valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class FieldErrorCodeMixin = Object with _$FieldErrorCodeMixin;

