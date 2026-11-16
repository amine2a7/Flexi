//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'first_validation.g.dart';

/// FirstValidation
///
/// Properties:
/// * [actorName] 
/// * [occurredAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [byMe] - Vrai si l'administrateur connecté a fait cette première validation (il ne peut pas faire la seconde).
@BuiltValue()
abstract class FirstValidation implements Built<FirstValidation, FirstValidationBuilder> {
  @BuiltValueField(wireName: r'actorName')
  String get actorName;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'occurredAt')
  DateTime get occurredAt;

  /// Vrai si l'administrateur connecté a fait cette première validation (il ne peut pas faire la seconde).
  @BuiltValueField(wireName: r'byMe')
  bool get byMe;

  FirstValidation._();

  factory FirstValidation([void updates(FirstValidationBuilder b)]) = _$FirstValidation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FirstValidationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FirstValidation> get serializer => _$FirstValidationSerializer();
}

class _$FirstValidationSerializer implements PrimitiveSerializer<FirstValidation> {
  @override
  final Iterable<Type> types = const [FirstValidation, _$FirstValidation];

  @override
  final String wireName = r'FirstValidation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FirstValidation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'actorName';
    yield serializers.serialize(
      object.actorName,
      specifiedType: const FullType(String),
    );
    yield r'occurredAt';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'byMe';
    yield serializers.serialize(
      object.byMe,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FirstValidation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FirstValidationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'actorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actorName = valueDes;
          break;
        case r'occurredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        case r'byMe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.byMe = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FirstValidation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FirstValidationBuilder();
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


