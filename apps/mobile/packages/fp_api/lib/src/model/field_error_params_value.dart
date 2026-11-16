//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'dart:core';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'field_error_params_value.g.dart';

/// FieldErrorParamsValue
@BuiltValue()
abstract class FieldErrorParamsValue implements Built<FieldErrorParamsValue, FieldErrorParamsValueBuilder> {
  /// Any Of [String], [int]
  AnyOf get anyOf;

  FieldErrorParamsValue._();

  factory FieldErrorParamsValue([void updates(FieldErrorParamsValueBuilder b)]) = _$FieldErrorParamsValue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FieldErrorParamsValueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FieldErrorParamsValue> get serializer => _$FieldErrorParamsValueSerializer();
}

class _$FieldErrorParamsValueSerializer implements PrimitiveSerializer<FieldErrorParamsValue> {
  @override
  final Iterable<Type> types = const [FieldErrorParamsValue, _$FieldErrorParamsValue];

  @override
  final String wireName = r'FieldErrorParamsValue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FieldErrorParamsValue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    FieldErrorParamsValue object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(anyOf, specifiedType: FullType(AnyOf, anyOf.types.map((type) => FullType(type)).toList()))!;
  }

  @override
  FieldErrorParamsValue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FieldErrorParamsValueBuilder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [FullType(int), FullType(String), ]);
    anyOfDataSrc = serialized;
    result.anyOf = serializers.deserialize(anyOfDataSrc, specifiedType: targetType) as AnyOf;
    return result.build();
  }
}


