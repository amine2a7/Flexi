//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/team_user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'team_user_list.g.dart';

/// TeamUserList
///
/// Properties:
/// * [data] 
@BuiltValue()
abstract class TeamUserList implements Built<TeamUserList, TeamUserListBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<TeamUser> get data;

  TeamUserList._();

  factory TeamUserList([void updates(TeamUserListBuilder b)]) = _$TeamUserList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TeamUserListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TeamUserList> get serializer => _$TeamUserListSerializer();
}

class _$TeamUserListSerializer implements PrimitiveSerializer<TeamUserList> {
  @override
  final Iterable<Type> types = const [TeamUserList, _$TeamUserList];

  @override
  final String wireName = r'TeamUserList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TeamUserList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(TeamUser)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TeamUserList object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TeamUserListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TeamUser)]),
          ) as BuiltList<TeamUser>;
          result.data.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TeamUserList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TeamUserListBuilder();
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


