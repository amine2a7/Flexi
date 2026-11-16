//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_message_handle.g.dart';

/// ContactMessageHandle
///
/// Properties:
/// * [note] 
@BuiltValue()
abstract class ContactMessageHandle implements Built<ContactMessageHandle, ContactMessageHandleBuilder> {
  @BuiltValueField(wireName: r'note')
  String? get note;

  ContactMessageHandle._();

  factory ContactMessageHandle([void updates(ContactMessageHandleBuilder b)]) = _$ContactMessageHandle;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactMessageHandleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactMessageHandle> get serializer => _$ContactMessageHandleSerializer();
}

class _$ContactMessageHandleSerializer implements PrimitiveSerializer<ContactMessageHandle> {
  @override
  final Iterable<Type> types = const [ContactMessageHandle, _$ContactMessageHandle];

  @override
  final String wireName = r'ContactMessageHandle';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactMessageHandle object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactMessageHandle object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContactMessageHandleBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContactMessageHandle deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactMessageHandleBuilder();
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


