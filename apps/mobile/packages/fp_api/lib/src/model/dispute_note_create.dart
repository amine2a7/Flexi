//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_note_create.g.dart';

/// DisputeNoteCreate
///
/// Properties:
/// * [text] 
@BuiltValue()
abstract class DisputeNoteCreate implements Built<DisputeNoteCreate, DisputeNoteCreateBuilder> {
  @BuiltValueField(wireName: r'text')
  String get text;

  DisputeNoteCreate._();

  factory DisputeNoteCreate([void updates(DisputeNoteCreateBuilder b)]) = _$DisputeNoteCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeNoteCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeNoteCreate> get serializer => _$DisputeNoteCreateSerializer();
}

class _$DisputeNoteCreateSerializer implements PrimitiveSerializer<DisputeNoteCreate> {
  @override
  final Iterable<Type> types = const [DisputeNoteCreate, _$DisputeNoteCreate];

  @override
  final String wireName = r'DisputeNoteCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeNoteCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeNoteCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeNoteCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeNoteCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeNoteCreateBuilder();
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


