//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/sub_role.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'staff_member.g.dart';

/// StaffMember
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [displayName] 
/// * [subRole] 
@BuiltValue()
abstract class StaffMember implements Built<StaffMember, StaffMemberBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'subRole')
  SubRole get subRole;
  // enum subRoleEnum {  SUPER_ADMIN,  FINANCE,  SUPPORT,  COMPLIANCE,  OWNER,  MANAGER,  ACCOUNTANT,  READ_ONLY,  CASHIER,  };

  StaffMember._();

  factory StaffMember([void updates(StaffMemberBuilder b)]) = _$StaffMember;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StaffMemberBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StaffMember> get serializer => _$StaffMemberSerializer();
}

class _$StaffMemberSerializer implements PrimitiveSerializer<StaffMember> {
  @override
  final Iterable<Type> types = const [StaffMember, _$StaffMember];

  @override
  final String wireName = r'StaffMember';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StaffMember object, {
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
    yield r'subRole';
    yield serializers.serialize(
      object.subRole,
      specifiedType: const FullType(SubRole),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StaffMember object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StaffMemberBuilder result,
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
        case r'subRole':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubRole),
          ) as SubRole;
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
  StaffMember deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StaffMemberBuilder();
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


