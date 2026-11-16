//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/user_audit_entry.dart';
import 'package:fp_api/src/model/sub_role.dart';
import 'package:fp_api/src/model/temporary_credentials.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/role.dart';
import 'package:fp_api/src/model/admin_user_tenant.dart';
import 'package:fp_api/src/model/user_status.dart';
import 'package:fp_api/src/model/admin_user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_user_detail.g.dart';

/// AdminUserDetail
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
/// * [credentials] 
/// * [mfaEnabled] 
/// * [pinLocked] - PIN de paiement bloqué (employé seulement, sinon false).
/// * [graceDays] - Délai de grâce qu'appliquerait une désactivation (employé seulement).
/// * [balanceMillimes] - Solde de l'employé ; absent sans `userBalances.read` (Support) ou hors employé.
/// * [history] 
@BuiltValue()
abstract class AdminUserDetail implements AdminUser, Built<AdminUserDetail, AdminUserDetailBuilder> {
  @BuiltValueField(wireName: r'credentials')
  TemporaryCredentials? get credentials;

  /// Délai de grâce qu'appliquerait une désactivation (employé seulement).
  @BuiltValueField(wireName: r'graceDays')
  int? get graceDays;

  @BuiltValueField(wireName: r'mfaEnabled')
  bool get mfaEnabled;

  /// PIN de paiement bloqué (employé seulement, sinon false).
  @BuiltValueField(wireName: r'pinLocked')
  bool get pinLocked;

  /// Solde de l'employé ; absent sans `userBalances.read` (Support) ou hors employé.
  @BuiltValueField(wireName: r'balanceMillimes')
  int? get balanceMillimes;

  @BuiltValueField(wireName: r'history')
  BuiltList<UserAuditEntry> get history;

  AdminUserDetail._();

  factory AdminUserDetail([void updates(AdminUserDetailBuilder b)]) = _$AdminUserDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUserDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUserDetail> get serializer => _$AdminUserDetailSerializer();
}

class _$AdminUserDetailSerializer implements PrimitiveSerializer<AdminUserDetail> {
  @override
  final Iterable<Type> types = const [AdminUserDetail, _$AdminUserDetail];

  @override
  final String wireName = r'AdminUserDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUserDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(Role),
    );
    if (object.credentials != null) {
      yield r'credentials';
      yield serializers.serialize(
        object.credentials,
        specifiedType: const FullType(TemporaryCredentials),
      );
    }
    if (object.graceDays != null) {
      yield r'graceDays';
      yield serializers.serialize(
        object.graceDays,
        specifiedType: const FullType(int),
      );
    }
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'subRole';
    yield object.subRole == null ? null : serializers.serialize(
      object.subRole,
      specifiedType: const FullType.nullable(SubRole),
    );
    yield r'pinLocked';
    yield serializers.serialize(
      object.pinLocked,
      specifiedType: const FullType(bool),
    );
    if (object.balanceMillimes != null) {
      yield r'balanceMillimes';
      yield serializers.serialize(
        object.balanceMillimes,
        specifiedType: const FullType(int),
      );
    }
    yield r'history';
    yield serializers.serialize(
      object.history,
      specifiedType: const FullType(BuiltList, [FullType(UserAuditEntry)]),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'mfaEnabled';
    yield serializers.serialize(
      object.mfaEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'graceUntil';
    yield object.graceUntil == null ? null : serializers.serialize(
      object.graceUntil,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminUserDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminUserDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Role),
          ) as Role;
          result.role = valueDes;
          break;
        case r'credentials':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TemporaryCredentials),
          ) as TemporaryCredentials?;
          if (valueDes == null) continue;
          result.credentials.replace(valueDes);
          break;
        case r'graceDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.graceDays = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'subRole':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SubRole),
          ) as SubRole?;
          if (valueDes == null) continue;
          result.subRole = valueDes;
          break;
        case r'pinLocked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.pinLocked = valueDes;
          break;
        case r'balanceMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.balanceMillimes = valueDes;
          break;
        case r'history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UserAuditEntry)]),
          ) as BuiltList<UserAuditEntry>;
          result.history.replace(valueDes);
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'mfaEnabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.mfaEnabled = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'graceUntil':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.graceUntil = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminUserDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUserDetailBuilder();
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


