//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/contact_requester_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_message_create.g.dart';

/// ContactMessageCreate
///
/// Properties:
/// * [name] 
/// * [email] 
/// * [phone] - Facultatif.
/// * [companyName] - Facultatif.
/// * [requesterType] 
/// * [message] 
@BuiltValue()
abstract class ContactMessageCreate implements Built<ContactMessageCreate, ContactMessageCreateBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'email')
  String get email;

  /// Facultatif.
  @BuiltValueField(wireName: r'phone')
  String? get phone;

  /// Facultatif.
  @BuiltValueField(wireName: r'companyName')
  String? get companyName;

  @BuiltValueField(wireName: r'requesterType')
  ContactRequesterType get requesterType;
  // enum requesterTypeEnum {  COMPANY,  MERCHANT,  OTHER,  };

  @BuiltValueField(wireName: r'message')
  String get message;

  ContactMessageCreate._();

  factory ContactMessageCreate([void updates(ContactMessageCreateBuilder b)]) = _$ContactMessageCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactMessageCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactMessageCreate> get serializer => _$ContactMessageCreateSerializer();
}

class _$ContactMessageCreateSerializer implements PrimitiveSerializer<ContactMessageCreate> {
  @override
  final Iterable<Type> types = const [ContactMessageCreate, _$ContactMessageCreate];

  @override
  final String wireName = r'ContactMessageCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactMessageCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    if (object.phone != null) {
      yield r'phone';
      yield serializers.serialize(
        object.phone,
        specifiedType: const FullType(String),
      );
    }
    if (object.companyName != null) {
      yield r'companyName';
      yield serializers.serialize(
        object.companyName,
        specifiedType: const FullType(String),
      );
    }
    yield r'requesterType';
    yield serializers.serialize(
      object.requesterType,
      specifiedType: const FullType(ContactRequesterType),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactMessageCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContactMessageCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'companyName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.companyName = valueDes;
          break;
        case r'requesterType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContactRequesterType),
          ) as ContactRequesterType;
          result.requesterType = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContactMessageCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactMessageCreateBuilder();
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


