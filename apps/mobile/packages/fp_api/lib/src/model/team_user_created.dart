//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/temporary_credentials.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'team_user_created.g.dart';

/// TeamUserCreated
///
/// Properties:
/// * [credentials] 
@BuiltValue()
abstract class TeamUserCreated implements Built<TeamUserCreated, TeamUserCreatedBuilder> {
  @BuiltValueField(wireName: r'credentials')
  TemporaryCredentials get credentials;

  TeamUserCreated._();

  factory TeamUserCreated([void updates(TeamUserCreatedBuilder b)]) = _$TeamUserCreated;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TeamUserCreatedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TeamUserCreated> get serializer => _$TeamUserCreatedSerializer();
}

class _$TeamUserCreatedSerializer implements PrimitiveSerializer<TeamUserCreated> {
  @override
  final Iterable<Type> types = const [TeamUserCreated, _$TeamUserCreated];

  @override
  final String wireName = r'TeamUserCreated';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TeamUserCreated object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'credentials';
    yield serializers.serialize(
      object.credentials,
      specifiedType: const FullType(TemporaryCredentials),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TeamUserCreated object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TeamUserCreatedBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  TeamUserCreated deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TeamUserCreatedBuilder();
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


