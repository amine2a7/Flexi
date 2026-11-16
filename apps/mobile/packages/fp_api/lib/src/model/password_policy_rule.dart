//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/password_policy_rule_code.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'password_policy_rule.g.dart';

/// PasswordPolicyRule
///
/// Properties:
/// * [code] 
/// * [params] 
@BuiltValue()
abstract class PasswordPolicyRule implements Built<PasswordPolicyRule, PasswordPolicyRuleBuilder> {
  @BuiltValueField(wireName: r'code')
  PasswordPolicyRuleCode get code;
  // enum codeEnum {  MIN_LENGTH,  MAX_LENGTH,  NOT_COMPROMISED,  NOT_IDENTIFIER,  DIFFERENT_FROM_CURRENT,  };

  @BuiltValueField(wireName: r'params')
  BuiltMap<String, int>? get params;

  PasswordPolicyRule._();

  factory PasswordPolicyRule([void updates(PasswordPolicyRuleBuilder b)]) = _$PasswordPolicyRule;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PasswordPolicyRuleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PasswordPolicyRule> get serializer => _$PasswordPolicyRuleSerializer();
}

class _$PasswordPolicyRuleSerializer implements PrimitiveSerializer<PasswordPolicyRule> {
  @override
  final Iterable<Type> types = const [PasswordPolicyRule, _$PasswordPolicyRule];

  @override
  final String wireName = r'PasswordPolicyRule';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PasswordPolicyRule object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(PasswordPolicyRuleCode),
    );
    if (object.params != null) {
      yield r'params';
      yield serializers.serialize(
        object.params,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PasswordPolicyRule object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PasswordPolicyRuleBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PasswordPolicyRuleCode),
          ) as PasswordPolicyRuleCode;
          result.code = valueDes;
          break;
        case r'params':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>?;
          if (valueDes == null) continue;
          result.params.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PasswordPolicyRule deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PasswordPolicyRuleBuilder();
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


