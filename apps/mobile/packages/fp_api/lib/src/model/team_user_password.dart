//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/team_user.dart';
import 'package:fp_api/src/model/temporary_credentials.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'team_user_password.g.dart';

/// TeamUserPassword
///
/// Properties:
/// * [user] 
/// * [credentials] 
@BuiltValue()
abstract class TeamUserPassword implements Built<TeamUserPassword, TeamUserPasswordBuilder> {
  @BuiltValueField(wireName: r'user')
  TeamUser get user;

  @BuiltValueField(wireName: r'credentials')
  TemporaryCredentials get credentials;

  TeamUserPassword._();

  factory TeamUserPassword([void updates(TeamUserPasswordBuilder b)]) = _$TeamUserPassword;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TeamUserPasswordBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TeamUserPassword> get serializer => _$TeamUserPasswordSerializer();
}

class _$TeamUserPasswordSerializer implements PrimitiveSerializer<TeamUserPassword> {
  @override
  final Iterable<Type> types = const [TeamUserPassword, _$TeamUserPassword];

  @override
  final String wireName = r'TeamUserPassword';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TeamUserPassword object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(TeamUser),
    );
    yield r'credentials';
    yield serializers.serialize(
      object.credentials,
      specifiedType: const FullType(TemporaryCredentials),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TeamUserPassword object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TeamUserPasswordBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TeamUser),
          ) as TeamUser;
          result.user.replace(valueDes);
          break;
        case r'credentials':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TemporaryCredentials),
          ) as TemporaryCredentials;
          result.credentials.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TeamUserPassword deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TeamUserPasswordBuilder();
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


