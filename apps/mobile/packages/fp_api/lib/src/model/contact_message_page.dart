//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/contact_message.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_message_page.g.dart';

/// ContactMessagePage
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class ContactMessagePage implements Built<ContactMessagePage, ContactMessagePageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<ContactMessage> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  ContactMessagePage._();

  factory ContactMessagePage([void updates(ContactMessagePageBuilder b)]) = _$ContactMessagePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactMessagePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactMessagePage> get serializer => _$ContactMessagePageSerializer();
}

class _$ContactMessagePageSerializer implements PrimitiveSerializer<ContactMessagePage> {
  @override
  final Iterable<Type> types = const [ContactMessagePage, _$ContactMessagePage];

  @override
  final String wireName = r'ContactMessagePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactMessagePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(ContactMessage)]),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(PageInfo),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactMessagePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContactMessagePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ContactMessage)]),
          ) as BuiltList<ContactMessage>;
          result.data.replace(valueDes);
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PageInfo),
          ) as PageInfo;
          result.page.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContactMessagePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactMessagePageBuilder();
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


