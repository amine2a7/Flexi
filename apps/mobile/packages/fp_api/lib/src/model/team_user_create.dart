//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/team_sub_role.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'team_user_create.g.dart';

/// TeamUserCreate
///
/// Properties:
/// * [displayName] 
/// * [email] 
/// * [subRole] 
@BuiltValue()
abstract class TeamUserCreate implements Built<TeamUserCreate, TeamUserCreateBuilder> {
  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'subRole')
  TeamSubRole get subRole;
  // enum subRoleEnum {  OWNER,  MANAGER,  FINANCE,  CASHIER,  };

  TeamUserCreate._();

  factory TeamUserCreate([void updates(TeamUserCreateBuilder b)]) = _$TeamUserCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TeamUserCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TeamUserCreate> get serializer => _$TeamUserCreateSerializer();
}

class _$TeamUserCreateSerializer implements PrimitiveSerializer<TeamUserCreate> {
  @override
  final Iterable<Type> types = const [TeamUserCreate, _$TeamUserCreate];

  @override
  final String wireName = r'TeamUserCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TeamUserCreate object, {
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
      specifiedType: const FullType(TeamSubRole),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TeamUserCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TeamUserCreateBuilder result,
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
            specifiedType: const FullType(TeamSubRole),
          ) as TeamSubRole;
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
  TeamUserCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TeamUserCreateBuilder();
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


