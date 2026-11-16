//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/family_relationship.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'family_member_create.g.dart';

/// FamilyMemberCreate
///
/// Properties:
/// * [firstName] 
/// * [lastName] 
/// * [relationship] 
/// * [phone] 
@BuiltValue()
abstract class FamilyMemberCreate implements Built<FamilyMemberCreate, FamilyMemberCreateBuilder> {
  @BuiltValueField(wireName: r'firstName')
  String get firstName;

  @BuiltValueField(wireName: r'lastName')
  String get lastName;

  @BuiltValueField(wireName: r'relationship')
  FamilyRelationship get relationship;
  // enum relationshipEnum {  SPOUSE,  CHILD,  PARENT,  };

  @BuiltValueField(wireName: r'phone')
  String get phone;

  FamilyMemberCreate._();

  factory FamilyMemberCreate([void updates(FamilyMemberCreateBuilder b)]) = _$FamilyMemberCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FamilyMemberCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FamilyMemberCreate> get serializer => _$FamilyMemberCreateSerializer();
}

class _$FamilyMemberCreateSerializer implements PrimitiveSerializer<FamilyMemberCreate> {
  @override
  final Iterable<Type> types = const [FamilyMemberCreate, _$FamilyMemberCreate];

  @override
  final String wireName = r'FamilyMemberCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FamilyMemberCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FamilyMemberCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FamilyMemberCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FamilyMemberCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FamilyMemberCreateBuilder();
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


