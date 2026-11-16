//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_user_create.g.dart';

/// AdminUserCreate
///
/// Properties:
/// * [displayName] 
/// * [email] 
/// * [subRole] 
/// * [reason] 
@BuiltValue()
abstract class AdminUserCreate implements Built<AdminUserCreate, AdminUserCreateBuilder> {
  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'subRole')
  AdminUserCreateSubRoleEnum get subRole;
  // enum subRoleEnum {  SUPER_ADMIN,  COMPLIANCE,  FINANCE,  SUPPORT,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminUserCreate._();

  factory AdminUserCreate([void updates(AdminUserCreateBuilder b)]) = _$AdminUserCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUserCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUserCreate> get serializer => _$AdminUserCreateSerializer();
}

class _$AdminUserCreateSerializer implements PrimitiveSerializer<AdminUserCreate> {
  @override
  final Iterable<Type> types = const [AdminUserCreate, _$AdminUserCreate];

  @override
  final String wireName = r'AdminUserCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUserCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield serializers.serialize(
      object.subRole,
      specifiedType: const FullType(AdminUserCreateSubRoleEnum),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminUserCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminUserCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(AdminUserCreateSubRoleEnum),
          ) as AdminUserCreateSubRoleEnum;
          result.subRole = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminUserCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUserCreateBuilder();
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


class AdminUserCreateSubRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SUPER_ADMIN')
  static const AdminUserCreateSubRoleEnum SUPER_ADMIN = _$adminUserCreateSubRoleEnum_SUPER_ADMIN;
  @BuiltValueEnumConst(wireName: r'COMPLIANCE')
  static const AdminUserCreateSubRoleEnum COMPLIANCE = _$adminUserCreateSubRoleEnum_COMPLIANCE;
  @BuiltValueEnumConst(wireName: r'FINANCE')
  static const AdminUserCreateSubRoleEnum FINANCE = _$adminUserCreateSubRoleEnum_FINANCE;
  @BuiltValueEnumConst(wireName: r'SUPPORT')
  static const AdminUserCreateSubRoleEnum SUPPORT = _$adminUserCreateSubRoleEnum_SUPPORT;

  static Serializer<AdminUserCreateSubRoleEnum> get serializer => _$adminUserCreateSubRoleEnumSerializer;

  const AdminUserCreateSubRoleEnum._(String name): super(name);

  static BuiltSet<AdminUserCreateSubRoleEnum> get values => _$adminUserCreateSubRoleEnumValues;
  static AdminUserCreateSubRoleEnum valueOf(String name) => _$adminUserCreateSubRoleEnumValueOf(name);
}

