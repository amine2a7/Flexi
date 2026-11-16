//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pin_refused_problem_all_of_details.g.dart';

/// PinRefusedProblemAllOfDetails
///
/// Properties:
/// * [retryAfterSeconds] 
/// * [reauthenticationRequired] 
@BuiltValue()
abstract class PinRefusedProblemAllOfDetails implements Built<PinRefusedProblemAllOfDetails, PinRefusedProblemAllOfDetailsBuilder> {
  @BuiltValueField(wireName: r'retryAfterSeconds')
  int? get retryAfterSeconds;

  @BuiltValueField(wireName: r'reauthenticationRequired')
  bool? get reauthenticationRequired;

  PinRefusedProblemAllOfDetails._();

  factory PinRefusedProblemAllOfDetails([void updates(PinRefusedProblemAllOfDetailsBuilder b)]) = _$PinRefusedProblemAllOfDetails;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PinRefusedProblemAllOfDetailsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PinRefusedProblemAllOfDetails> get serializer => _$PinRefusedProblemAllOfDetailsSerializer();
}

class _$PinRefusedProblemAllOfDetailsSerializer implements PrimitiveSerializer<PinRefusedProblemAllOfDetails> {
  @override
  final Iterable<Type> types = const [PinRefusedProblemAllOfDetails, _$PinRefusedProblemAllOfDetails];

  @override
  final String wireName = r'PinRefusedProblemAllOfDetails';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PinRefusedProblemAllOfDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.retryAfterSeconds != null) {
      yield r'retryAfterSeconds';
      yield serializers.serialize(
        object.retryAfterSeconds,
        specifiedType: const FullType(int),
      );
    }
    if (object.reauthenticationRequired != null) {
      yield r'reauthenticationRequired';
      yield serializers.serialize(
        object.reauthenticationRequired,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PinRefusedProblemAllOfDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PinRefusedProblemAllOfDetailsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'retryAfterSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.retryAfterSeconds = valueDes;
          break;
        case r'reauthenticationRequired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.reauthenticationRequired = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PinRefusedProblemAllOfDetails deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PinRefusedProblemAllOfDetailsBuilder();
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


