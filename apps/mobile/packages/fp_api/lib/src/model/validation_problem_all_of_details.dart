//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/field_error.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'validation_problem_all_of_details.g.dart';

/// ValidationProblemAllOfDetails
///
/// Properties:
/// * [fields] 
@BuiltValue()
abstract class ValidationProblemAllOfDetails implements Built<ValidationProblemAllOfDetails, ValidationProblemAllOfDetailsBuilder> {
  @BuiltValueField(wireName: r'fields')
  BuiltList<FieldError> get fields;

  ValidationProblemAllOfDetails._();

  factory ValidationProblemAllOfDetails([void updates(ValidationProblemAllOfDetailsBuilder b)]) = _$ValidationProblemAllOfDetails;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ValidationProblemAllOfDetailsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ValidationProblemAllOfDetails> get serializer => _$ValidationProblemAllOfDetailsSerializer();
}

class _$ValidationProblemAllOfDetailsSerializer implements PrimitiveSerializer<ValidationProblemAllOfDetails> {
  @override
  final Iterable<Type> types = const [ValidationProblemAllOfDetails, _$ValidationProblemAllOfDetails];

  @override
  final String wireName = r'ValidationProblemAllOfDetails';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ValidationProblemAllOfDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fields';
    yield serializers.serialize(
      object.fields,
      specifiedType: const FullType(BuiltList, [FullType(FieldError)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ValidationProblemAllOfDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ValidationProblemAllOfDetailsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fields':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FieldError)]),
          ) as BuiltList<FieldError>;
          result.fields.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ValidationProblemAllOfDetails deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ValidationProblemAllOfDetailsBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


