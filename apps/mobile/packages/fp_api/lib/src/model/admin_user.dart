//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/sub_role.dart';
import 'package:fp_api/src/model/role.dart';
import 'package:fp_api/src/model/admin_user_tenant.dart';
import 'package:fp_api/src/model/user_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_user.g.dart';

/// AdminUser
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [displayName] 
/// * [email] 
/// * [role] 
/// * [subRole] 
/// * [tenant] 
/// * [status] 
/// * [graceUntil] - Fin du délai de grâce d'un employé désactivé.
/// * [createdAt] 
@BuiltValue(instantiable: false)
abstract class AdminUser  {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'role')
  Role get role;
  // enum roleEnum {  ADMIN,  COMPANY,  MERCHANT,  EMPLOYEE,  FAMILY_MEMBER,  };

  @BuiltValueField(wireName: r'subRole')
  SubRole? get subRole;
  // enum subRoleEnum {  SUPER_ADMIN,  FINANCE,  SUPPORT,  COMPLIANCE,  OWNER,  MANAGER,  ACCOUNTANT,  READ_ONLY,  CASHIER,  };

  @BuiltValueField(wireName: r'tenant')
  AdminUserTenant? get tenant;

  @BuiltValueField(wireName: r'status')
  UserStatus get status;
  // enum statusEnum {  INVITED,  ACTIVE,  SUSPENDED,  DEACTIVATED,  };

  /// Fin du délai de grâce d'un employé désactivé.
  @BuiltValueField(wireName: r'graceUntil')
  DateTime? get graceUntil;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUser> get serializer => _$AdminUserSerializer();
}

class _$AdminUserSerializer implements PrimitiveSerializer<AdminUser> {
  @override
  final Iterable<Type> types = const [AdminUser];

  @override
  final String wireName = r'AdminUser';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUser object, {
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
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(Role),
    );
    yield r'subRole';
    yield object.subRole == null ? null : serializers.serialize(
      object.subRole,
      specifiedType: const FullType.nullable(SubRole),
    );
    yield r'tenant';
    yield object.tenant == null ? null : serializers.serialize(
      object.tenant,
      specifiedType: const FullType.nullable(AdminUserTenant),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(UserStatus),
    );
    yield r'graceUntil';
    yield object.graceUntil == null ? null : serializers.serialize(
      object.graceUntil,
      specifiedType: const FullType.nullable(DateTime),
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
    AdminUser object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  AdminUser deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($AdminUser)) as $AdminUser;
  }
}


/// a concrete implementation of [AdminUser], since [AdminUser] is not instantiable
@BuiltValue(instantiable: true)
abstract class $AdminUser implements AdminUser, Built<$AdminUser, $AdminUserBuilder> {
  $AdminUser._();

  factory $AdminUser([void Function($AdminUserBuilder)? updates]) = _$$AdminUser;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($AdminUserBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$AdminUser> get serializer => _$$AdminUserSerializer();
}

class _$$AdminUserSerializer implements PrimitiveSerializer<$AdminUser> {
  @override
  final Iterable<Type> types = const [$AdminUser, _$$AdminUser];

  @override
  final String wireName = r'$AdminUser';

  @override
  Object serialize(
    Serializers serializers,
    $AdminUser object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(AdminUser))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminUserBuilder result,
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
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Role),
          ) as Role;
          result.role = valueDes;
          break;
        case r'subRole':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SubRole),
          ) as SubRole?;
          if (valueDes == null) continue;
          result.subRole = valueDes;
          break;
        case r'tenant':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminUserTenant),
          ) as AdminUserTenant?;
          if (valueDes == null) continue;
          result.tenant.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserStatus),
          ) as UserStatus;
          result.status = valueDes;
          break;
        case r'graceUntil':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.graceUntil = valueDes;
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
  $AdminUser deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $AdminUserBuilder();
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

