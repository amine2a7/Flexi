//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_request_create.g.dart';

/// PayoutRequestCreate
///
/// Properties:
/// * [quoteId] - Identifiant opaque de ressource.
@BuiltValue()
abstract class PayoutRequestCreate implements Built<PayoutRequestCreate, PayoutRequestCreateBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'quoteId')
  String get quoteId;

  PayoutRequestCreate._();

  factory PayoutRequestCreate([void updates(PayoutRequestCreateBuilder b)]) = _$PayoutRequestCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutRequestCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutRequestCreate> get serializer => _$PayoutRequestCreateSerializer();
}

class _$PayoutRequestCreateSerializer implements PrimitiveSerializer<PayoutRequestCreate> {
  @override
  final Iterable<Type> types = const [PayoutRequestCreate, _$PayoutRequestCreate];

  @override
  final String wireName = r'PayoutRequestCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutRequestCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'quoteId';
    yield serializers.serialize(
      object.quoteId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PayoutRequestCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutRequestCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'quoteId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quoteId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PayoutRequestCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutRequestCreateBuilder();
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


