//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'decision_reason.g.dart';

/// Motif obligatoire d'un refus (visible par le titulaire du compte).
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class DecisionReason implements Built<DecisionReason, DecisionReasonBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  DecisionReason._();

  factory DecisionReason([void updates(DecisionReasonBuilder b)]) = _$DecisionReason;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DecisionReasonBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DecisionReason> get serializer => _$DecisionReasonSerializer();
}

class _$DecisionReasonSerializer implements PrimitiveSerializer<DecisionReason> {
  @override
  final Iterable<Type> types = const [DecisionReason, _$DecisionReason];

  @override
  final String wireName = r'DecisionReason';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DecisionReason object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DecisionReason object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DecisionReasonBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DecisionReason deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DecisionReasonBuilder();
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


