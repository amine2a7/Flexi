//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/team_sub_role.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'team_user_update.g.dart';

/// TeamUserUpdate
///
/// Properties:
/// * [displayName] 
/// * [subRole] 
@BuiltValue()
abstract class TeamUserUpdate implements Built<TeamUserUpdate, TeamUserUpdateBuilder> {
  @BuiltValueField(wireName: r'displayName')
  String? get displayName;

  @BuiltValueField(wireName: r'subRole')
  TeamSubRole? get subRole;
  // enum subRoleEnum {  OWNER,  MANAGER,  FINANCE,  CASHIER,  };

  TeamUserUpdate._();

  factory TeamUserUpdate([void updates(TeamUserUpdateBuilder b)]) = _$TeamUserUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TeamUserUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TeamUserUpdate> get serializer => _$TeamUserUpdateSerializer();
}

class _$TeamUserUpdateSerializer implements PrimitiveSerializer<TeamUserUpdate> {
  @override
  final Iterable<Type> types = const [TeamUserUpdate, _$TeamUserUpdate];

  @override
  final String wireName = r'TeamUserUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TeamUserUpdate object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    TeamUserUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TeamUserUpdateBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TeamUserUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TeamUserUpdateBuilder();
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


