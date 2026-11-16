//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_message_receipt.g.dart';

/// ContactMessageReceipt
///
/// Properties:
/// * [reference] 
@BuiltValue()
abstract class ContactMessageReceipt implements Built<ContactMessageReceipt, ContactMessageReceiptBuilder> {
  @BuiltValueField(wireName: r'reference')
  String get reference;

  ContactMessageReceipt._();

  factory ContactMessageReceipt([void updates(ContactMessageReceiptBuilder b)]) = _$ContactMessageReceipt;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactMessageReceiptBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactMessageReceipt> get serializer => _$ContactMessageReceiptSerializer();
}

class _$ContactMessageReceiptSerializer implements PrimitiveSerializer<ContactMessageReceipt> {
  @override
  final Iterable<Type> types = const [ContactMessageReceipt, _$ContactMessageReceipt];

  @override
  final String wireName = r'ContactMessageReceipt';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactMessageReceipt object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactMessageReceipt object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContactMessageReceiptBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContactMessageReceipt deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactMessageReceiptBuilder();
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


