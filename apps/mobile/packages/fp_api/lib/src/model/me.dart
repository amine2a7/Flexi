//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/tenant_summary.dart';
import 'package:fp_api/src/model/sub_role.dart';
import 'package:fp_api/src/model/me_mfa.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/role.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'me.g.dart';

/// Me
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [displayName] - Prénom et initiale du nom (aucune autre donnée personnelle).
/// * [role] 
/// * [subRole] 
/// * [permissions] 
/// * [tenant] - Tenant unique du compte (RG-2.5), fixé à la connexion : entreprise ou commerçant. `null` pour un administrateur. 
/// * [mfa] 
/// * [onboardingTourDone] - Visite guidée de première connexion déjà vue ou passée (Commerçant, Entreprise, Bénéficiaire). `false` : le client l'affiche à l'arrivée dans l'espace. 
@BuiltValue()
abstract class Me implements Built<Me, MeBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Prénom et initiale du nom (aucune autre donnée personnelle).
  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'role')
  Role get role;
  // enum roleEnum {  ADMIN,  COMPANY,  MERCHANT,  EMPLOYEE,  FAMILY_MEMBER,  };

  @BuiltValueField(wireName: r'subRole')
  SubRole? get subRole;
  // enum subRoleEnum {  SUPER_ADMIN,  FINANCE,  SUPPORT,  COMPLIANCE,  OWNER,  MANAGER,  ACCOUNTANT,  READ_ONLY,  CASHIER,  };

  @BuiltValueField(wireName: r'permissions')
  BuiltSet<String> get permissions;

  /// Tenant unique du compte (RG-2.5), fixé à la connexion : entreprise ou commerçant. `null` pour un administrateur. 
  @BuiltValueField(wireName: r'tenant')
  TenantSummary? get tenant;

  @BuiltValueField(wireName: r'mfa')
  MeMfa get mfa;

  /// Visite guidée de première connexion déjà vue ou passée (Commerçant, Entreprise, Bénéficiaire). `false` : le client l'affiche à l'arrivée dans l'espace. 
  @BuiltValueField(wireName: r'onboardingTourDone')
  bool get onboardingTourDone;

  Me._();

  factory Me([void updates(MeBuilder b)]) = _$Me;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Me> get serializer => _$MeSerializer();
}

class _$MeSerializer implements PrimitiveSerializer<Me> {
  @override
  final Iterable<Type> types = const [Me, _$Me];

  @override
  final String wireName = r'Me';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Me object, {
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
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltSet, [FullType(String)]),
    );
    yield r'tenant';
    yield object.tenant == null ? null : serializers.serialize(
      object.tenant,
      specifiedType: const FullType.nullable(TenantSummary),
    );
    yield r'mfa';
    yield serializers.serialize(
      object.mfa,
      specifiedType: const FullType(MeMfa),
    );
    yield r'onboardingTourDone';
    yield serializers.serialize(
      object.onboardingTourDone,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Me object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MeBuilder result,
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
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(String)]),
          ) as BuiltSet<String>;
          result.permissions.replace(valueDes);
          break;
        case r'tenant':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TenantSummary),
          ) as TenantSummary?;
          if (valueDes == null) continue;
          result.tenant.replace(valueDes);
          break;
        case r'mfa':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MeMfa),
          ) as MeMfa;
          result.mfa.replace(valueDes);
          break;
        case r'onboardingTourDone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.onboardingTourDone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Me deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MeBuilder();
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


