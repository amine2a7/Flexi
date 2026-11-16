//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/sub_role.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_role_change.g.dart';

/// UserRoleChange
///
/// Properties:
/// * [subRole] 
/// * [reason] 
@BuiltValue()
abstract class UserRoleChange implements Built<UserRoleChange, UserRoleChangeBuilder> {
  @BuiltValueField(wireName: r'subRole')
  SubRole get subRole;
  // enum subRoleEnum {  SUPER_ADMIN,  FINANCE,  SUPPORT,  COMPLIANCE,  OWNER,  MANAGER,  ACCOUNTANT,  READ_ONLY,  CASHIER,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  UserRoleChange._();

  factory UserRoleChange([void updates(UserRoleChangeBuilder b)]) = _$UserRoleChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserRoleChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserRoleChange> get serializer => _$UserRoleChangeSerializer();
}

class _$UserRoleChangeSerializer implements PrimitiveSerializer<UserRoleChange> {
  @override
  final Iterable<Type> types = const [UserRoleChange, _$UserRoleChange];

  @override
  final String wireName = r'UserRoleChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserRoleChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'subRole';
    yield serializers.serialize(
      object.subRole,
      specifiedType: const FullType(SubRole),
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
    UserRoleChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserRoleChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'subRole':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubRole),
          ) as SubRole;
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
  UserRoleChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserRoleChangeBuilder();
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


