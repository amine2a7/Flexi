//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/contact_requester_type.dart';
import 'package:fp_api/src/model/contact_message_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_message.g.dart';

/// ContactMessage
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [reference] 
/// * [name] 
/// * [email] 
/// * [phone] - Numéro tunisien au format E.164.
/// * [companyName] 
/// * [requesterType] 
/// * [message] 
/// * [status] 
/// * [receivedAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [handledAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [handledBy] - Nom de l'administrateur qui a traité le message.
/// * [note] 
@BuiltValue()
abstract class ContactMessage implements Built<ContactMessage, ContactMessageBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'email')
  String get email;

  /// Numéro tunisien au format E.164.
  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'companyName')
  String? get companyName;

  @BuiltValueField(wireName: r'requesterType')
  ContactRequesterType get requesterType;
  // enum requesterTypeEnum {  COMPANY,  MERCHANT,  OTHER,  };

  @BuiltValueField(wireName: r'message')
  String get message;

  @BuiltValueField(wireName: r'status')
  ContactMessageStatus get status;
  // enum statusEnum {  NEW,  HANDLED,  };

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'receivedAt')
  DateTime get receivedAt;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'handledAt')
  DateTime? get handledAt;

  /// Nom de l'administrateur qui a traité le message.
  @BuiltValueField(wireName: r'handledBy')
  String? get handledBy;

  @BuiltValueField(wireName: r'note')
  String? get note;

  ContactMessage._();

  factory ContactMessage([void updates(ContactMessageBuilder b)]) = _$ContactMessage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactMessageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactMessage> get serializer => _$ContactMessageSerializer();
}

class _$ContactMessageSerializer implements PrimitiveSerializer<ContactMessage> {
  @override
  final Iterable<Type> types = const [ContactMessage, _$ContactMessage];

  @override
  final String wireName = r'ContactMessage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactMessage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
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
    yield r'phone';
    yield object.phone == null ? null : serializers.serialize(
      object.phone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'companyName';
    yield object.companyName == null ? null : serializers.serialize(
      object.companyName,
      specifiedType: const FullType.nullable(String),
    );
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ContactMessageStatus),
    );
    yield r'receivedAt';
    yield serializers.serialize(
      object.receivedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'handledAt';
    yield object.handledAt == null ? null : serializers.serialize(
      object.handledAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'handledBy';
    yield object.handledBy == null ? null : serializers.serialize(
      object.handledBy,
      specifiedType: const FullType.nullable(String),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactMessage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContactMessageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContactMessageStatus),
          ) as ContactMessageStatus;
          result.status = valueDes;
          break;
        case r'receivedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.receivedAt = valueDes;
          break;
        case r'handledAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.handledAt = valueDes;
          break;
        case r'handledBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.handledBy = valueDes;
          break;
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
  ContactMessage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactMessageBuilder();
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


