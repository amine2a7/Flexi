//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/sub_role.dart';
import 'package:fp_api/src/model/user_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'team_user.g.dart';

/// TeamUser
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [displayName] 
/// * [email] 
/// * [subRole] 
/// * [status] 
/// * [createdAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class TeamUser implements Built<TeamUser, TeamUserBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'subRole')
  SubRole? get subRole;
  // enum subRoleEnum {  SUPER_ADMIN,  FINANCE,  SUPPORT,  COMPLIANCE,  OWNER,  MANAGER,  ACCOUNTANT,  READ_ONLY,  CASHIER,  };

  @BuiltValueField(wireName: r'status')
  UserStatus get status;
  // enum statusEnum {  INVITED,  ACTIVE,  SUSPENDED,  DEACTIVATED,  };

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  TeamUser._();

  factory TeamUser([void updates(TeamUserBuilder b)]) = _$TeamUser;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TeamUserBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TeamUser> get serializer => _$TeamUserSerializer();
}

class _$TeamUserSerializer implements PrimitiveSerializer<TeamUser> {
  @override
  final Iterable<Type> types = const [TeamUser, _$TeamUser];

  @override
  final String wireName = r'TeamUser';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TeamUser object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'subRole';
    yield object.subRole == null ? null : serializers.serialize(
      object.subRole,
      specifiedType: const FullType.nullable(SubRole),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(UserStatus),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TeamUser object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TeamUserBuilder result,
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
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'subRole':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SubRole),
          ) as SubRole?;
          if (valueDes == null) continue;
          result.subRole = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserStatus),
          ) as UserStatus;
          result.status = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TeamUser deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TeamUserBuilder();
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


