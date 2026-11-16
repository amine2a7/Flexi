//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/temporary_credentials.dart';
import 'package:fp_api/src/model/family_relationship.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'family_member_created.g.dart';

/// FamilyMemberCreated
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [firstName] 
/// * [lastName] 
/// * [relationship] 
/// * [credentials] 
@BuiltValue()
abstract class FamilyMemberCreated implements Built<FamilyMemberCreated, FamilyMemberCreatedBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'firstName')
  String get firstName;

  @BuiltValueField(wireName: r'lastName')
  String get lastName;

  @BuiltValueField(wireName: r'relationship')
  FamilyRelationship get relationship;
  // enum relationshipEnum {  SPOUSE,  CHILD,  PARENT,  };

  @BuiltValueField(wireName: r'credentials')
  TemporaryCredentials get credentials;

  FamilyMemberCreated._();

  factory FamilyMemberCreated([void updates(FamilyMemberCreatedBuilder b)]) = _$FamilyMemberCreated;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FamilyMemberCreatedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FamilyMemberCreated> get serializer => _$FamilyMemberCreatedSerializer();
}

class _$FamilyMemberCreatedSerializer implements PrimitiveSerializer<FamilyMemberCreated> {
  @override
  final Iterable<Type> types = const [FamilyMemberCreated, _$FamilyMemberCreated];

  @override
  final String wireName = r'FamilyMemberCreated';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FamilyMemberCreated object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'firstName';
    yield serializers.serialize(
      object.firstName,
      specifiedType: const FullType(String),
    );
    yield r'lastName';
    yield serializers.serialize(
      object.lastName,
      specifiedType: const FullType(String),
    );
    yield r'relationship';
    yield serializers.serialize(
      object.relationship,
      specifiedType: const FullType(FamilyRelationship),
    );
    yield r'credentials';
    yield serializers.serialize(
      object.credentials,
      specifiedType: const FullType(TemporaryCredentials),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FamilyMemberCreated object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FamilyMemberCreatedBuilder result,
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
        case r'firstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstName = valueDes;
          break;
        case r'lastName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lastName = valueDes;
          break;
        case r'relationship':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FamilyRelationship),
          ) as FamilyRelationship;
          result.relationship = valueDes;
          break;
        case r'credentials':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TemporaryCredentials),
          ) as TemporaryCredentials;
          result.credentials.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FamilyMemberCreated deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FamilyMemberCreatedBuilder();
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


