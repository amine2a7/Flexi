//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'password_policy_rule_code.g.dart';

/// Règle de la politique de mot de passe. Liste extensible (règle inconnue : ne pas l'afficher). Règles en vigueur (SEC-A1, DP n° 9) : `MIN_LENGTH {min: 12}`, `MAX_LENGTH {max: 128}`, `NOT_COMPROMISED` (absent d'une liste locale de mots de passe compromis), `NOT_IDENTIFIER` (différent de l'identifiant), `DIFFERENT_FROM_CURRENT`. 
class PasswordPolicyRuleCode extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MIN_LENGTH')
  static const PasswordPolicyRuleCode MIN_LENGTH = _$MIN_LENGTH;
  @BuiltValueEnumConst(wireName: r'MAX_LENGTH')
  static const PasswordPolicyRuleCode MAX_LENGTH = _$MAX_LENGTH;
  @BuiltValueEnumConst(wireName: r'NOT_COMPROMISED')
  static const PasswordPolicyRuleCode NOT_COMPROMISED = _$NOT_COMPROMISED;
  @BuiltValueEnumConst(wireName: r'NOT_IDENTIFIER')
  static const PasswordPolicyRuleCode NOT_IDENTIFIER = _$NOT_IDENTIFIER;
  @BuiltValueEnumConst(wireName: r'DIFFERENT_FROM_CURRENT')
  static const PasswordPolicyRuleCode DIFFERENT_FROM_CURRENT = _$DIFFERENT_FROM_CURRENT;

  static Serializer<PasswordPolicyRuleCode> get serializer => _$passwordPolicyRuleCodeSerializer;

  const PasswordPolicyRuleCode._(String name): super(name);

  static BuiltSet<PasswordPolicyRuleCode> get values => _$values;
  static PasswordPolicyRuleCode valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PasswordPolicyRuleCodeMixin = Object with _$PasswordPolicyRuleCodeMixin;

