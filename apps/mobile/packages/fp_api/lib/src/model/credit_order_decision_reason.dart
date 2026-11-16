//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credit_order_decision_reason.g.dart';

/// CreditOrderDecisionReason
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class CreditOrderDecisionReason implements Built<CreditOrderDecisionReason, CreditOrderDecisionReasonBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  CreditOrderDecisionReason._();

  factory CreditOrderDecisionReason([void updates(CreditOrderDecisionReasonBuilder b)]) = _$CreditOrderDecisionReason;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreditOrderDecisionReasonBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreditOrderDecisionReason> get serializer => _$CreditOrderDecisionReasonSerializer();
}

class _$CreditOrderDecisionReasonSerializer implements PrimitiveSerializer<CreditOrderDecisionReason> {
  @override
  final Iterable<Type> types = const [CreditOrderDecisionReason, _$CreditOrderDecisionReason];

  @override
  final String wireName = r'CreditOrderDecisionReason';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreditOrderDecisionReason object, {
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
    CreditOrderDecisionReason object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreditOrderDecisionReasonBuilder result,
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
  CreditOrderDecisionReason deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreditOrderDecisionReasonBuilder();
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


