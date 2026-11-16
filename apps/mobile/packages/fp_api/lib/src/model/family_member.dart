//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/employee_status.dart';
import 'package:fp_api/src/model/family_member_balance.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/family_relationship.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'family_member.g.dart';

/// FamilyMember
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [firstName] 
/// * [lastName] 
/// * [relationship] 
/// * [login] - Identifiant de connexion du membre.
/// * [status] 
/// * [balances] 
@BuiltValue()
abstract class FamilyMember implements Built<FamilyMember, FamilyMemberBuilder> {
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

  /// Identifiant de connexion du membre.
  @BuiltValueField(wireName: r'login')
  String? get login;

  @BuiltValueField(wireName: r'status')
  EmployeeStatus get status;
  // enum statusEnum {  INVITED,  ACTIVE,  SUSPENDED,  DEACTIVATED,  };

  @BuiltValueField(wireName: r'balances')
  BuiltList<FamilyMemberBalance> get balances;

  FamilyMember._();

  factory FamilyMember([void updates(FamilyMemberBuilder b)]) = _$FamilyMember;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FamilyMemberBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FamilyMember> get serializer => _$FamilyMemberSerializer();
}

class _$FamilyMemberSerializer implements PrimitiveSerializer<FamilyMember> {
  @override
  final Iterable<Type> types = const [FamilyMember, _$FamilyMember];

  @override
  final String wireName = r'FamilyMember';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FamilyMember object, {
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
    yield r'login';
    yield object.login == null ? null : serializers.serialize(
      object.login,
      specifiedType: const FullType.nullable(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(EmployeeStatus),
    );
    yield r'balances';
    yield serializers.serialize(
      object.balances,
      specifiedType: const FullType(BuiltList, [FullType(FamilyMemberBalance)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FamilyMember object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FamilyMemberBuilder result,
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
        case r'login':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.login = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EmployeeStatus),
          ) as EmployeeStatus;
          result.status = valueDes;
          break;
        case r'balances':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FamilyMemberBalance)]),
          ) as BuiltList<FamilyMemberBalance>;
          result.balances.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FamilyMember deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FamilyMemberBuilder();
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


