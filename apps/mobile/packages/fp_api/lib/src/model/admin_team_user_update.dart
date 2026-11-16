//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/team_sub_role.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_team_user_update.g.dart';

/// AdminTeamUserUpdate
///
/// Properties:
/// * [displayName] 
/// * [subRole] 
/// * [reason] 
@BuiltValue()
abstract class AdminTeamUserUpdate implements Built<AdminTeamUserUpdate, AdminTeamUserUpdateBuilder> {
  @BuiltValueField(wireName: r'displayName')
  String? get displayName;

  @BuiltValueField(wireName: r'subRole')
  TeamSubRole? get subRole;
  // enum subRoleEnum {  OWNER,  MANAGER,  FINANCE,  CASHIER,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminTeamUserUpdate._();

  factory AdminTeamUserUpdate([void updates(AdminTeamUserUpdateBuilder b)]) = _$AdminTeamUserUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTeamUserUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTeamUserUpdate> get serializer => _$AdminTeamUserUpdateSerializer();
}

class _$AdminTeamUserUpdateSerializer implements PrimitiveSerializer<AdminTeamUserUpdate> {
  @override
  final Iterable<Type> types = const [AdminTeamUserUpdate, _$AdminTeamUserUpdate];

  @override
  final String wireName = r'AdminTeamUserUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTeamUserUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.displayName != null) {
      yield r'displayName';
      yield serializers.serialize(
        object.displayName,
        specifiedType: const FullType(String),
      );
    }
    if (object.subRole != null) {
      yield r'subRole';
      yield serializers.serialize(
        object.subRole,
        specifiedType: const FullType(TeamSubRole),
      );
    }
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTeamUserUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminTeamUserUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        case r'subRole':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TeamSubRole),
          ) as TeamSubRole?;
          if (valueDes == null) continue;
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
  AdminTeamUserUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTeamUserUpdateBuilder();
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


