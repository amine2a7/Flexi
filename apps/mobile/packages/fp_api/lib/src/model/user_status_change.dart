//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_status_change.g.dart';

/// Motif obligatoire d'un changement d'accès (bornes provisoires 10 à 500, à confirmer).
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class UserStatusChange implements Built<UserStatusChange, UserStatusChangeBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  UserStatusChange._();

  factory UserStatusChange([void updates(UserStatusChangeBuilder b)]) = _$UserStatusChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserStatusChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserStatusChange> get serializer => _$UserStatusChangeSerializer();
}

class _$UserStatusChangeSerializer implements PrimitiveSerializer<UserStatusChange> {
  @override
  final Iterable<Type> types = const [UserStatusChange, _$UserStatusChange];

  @override
  final String wireName = r'UserStatusChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserStatusChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserStatusChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserStatusChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  UserStatusChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserStatusChangeBuilder();
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


