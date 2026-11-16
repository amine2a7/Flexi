//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/password_policy_rule.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'password_policy.g.dart';

/// PasswordPolicy
///
/// Properties:
/// * [rules] 
@BuiltValue()
abstract class PasswordPolicy implements Built<PasswordPolicy, PasswordPolicyBuilder> {
  @BuiltValueField(wireName: r'rules')
  BuiltList<PasswordPolicyRule> get rules;

  PasswordPolicy._();

  factory PasswordPolicy([void updates(PasswordPolicyBuilder b)]) = _$PasswordPolicy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PasswordPolicyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PasswordPolicy> get serializer => _$PasswordPolicySerializer();
}

class _$PasswordPolicySerializer implements PrimitiveSerializer<PasswordPolicy> {
  @override
  final Iterable<Type> types = const [PasswordPolicy, _$PasswordPolicy];

  @override
  final String wireName = r'PasswordPolicy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PasswordPolicy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rules';
    yield serializers.serialize(
      object.rules,
      specifiedType: const FullType(BuiltList, [FullType(PasswordPolicyRule)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PasswordPolicy object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PasswordPolicyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PasswordPolicyRule)]),
          ) as BuiltList<PasswordPolicyRule>;
          result.rules.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PasswordPolicy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PasswordPolicyBuilder();
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


