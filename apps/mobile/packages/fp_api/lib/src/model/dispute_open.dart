//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_open.g.dart';

/// DisputeOpen
///
/// Properties:
/// * [paymentId] - Identifiant opaque de ressource.
/// * [reason] 
@BuiltValue()
abstract class DisputeOpen implements Built<DisputeOpen, DisputeOpenBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'paymentId')
  String get paymentId;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  DisputeOpen._();

  factory DisputeOpen([void updates(DisputeOpenBuilder b)]) = _$DisputeOpen;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeOpenBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeOpen> get serializer => _$DisputeOpenSerializer();
}

class _$DisputeOpenSerializer implements PrimitiveSerializer<DisputeOpen> {
  @override
  final Iterable<Type> types = const [DisputeOpen, _$DisputeOpen];

  @override
  final String wireName = r'DisputeOpen';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeOpen object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'paymentId';
    yield serializers.serialize(
      object.paymentId,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeOpen object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeOpenBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'paymentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentId = valueDes;
          break;
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
  DisputeOpen deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeOpenBuilder();
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


