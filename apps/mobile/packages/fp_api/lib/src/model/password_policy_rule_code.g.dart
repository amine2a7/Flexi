// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_policy_rule_code.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PasswordPolicyRuleCode _$MIN_LENGTH = const PasswordPolicyRuleCode._(
  'MIN_LENGTH',
);
const PasswordPolicyRuleCode _$MAX_LENGTH = const PasswordPolicyRuleCode._(
  'MAX_LENGTH',
);
const PasswordPolicyRuleCode _$NOT_COMPROMISED = const PasswordPolicyRuleCode._(
  'NOT_COMPROMISED',
);
const PasswordPolicyRuleCode _$NOT_IDENTIFIER = const PasswordPolicyRuleCode._(
  'NOT_IDENTIFIER',
);
const PasswordPolicyRuleCode _$DIFFERENT_FROM_CURRENT =
    const PasswordPolicyRuleCode._('DIFFERENT_FROM_CURRENT');

PasswordPolicyRuleCode _$valueOf(String name) {
  switch (name) {
    case 'MIN_LENGTH':
      return _$MIN_LENGTH;
    case 'MAX_LENGTH':
      return _$MAX_LENGTH;
    case 'NOT_COMPROMISED':
      return _$NOT_COMPROMISED;
    case 'NOT_IDENTIFIER':
      return _$NOT_IDENTIFIER;
    case 'DIFFERENT_FROM_CURRENT':
      return _$DIFFERENT_FROM_CURRENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PasswordPolicyRuleCode> _$values =
    BuiltSet<PasswordPolicyRuleCode>(const <PasswordPolicyRuleCode>[
      _$MIN_LENGTH,
      _$MAX_LENGTH,
      _$NOT_COMPROMISED,
      _$NOT_IDENTIFIER,
      _$DIFFERENT_FROM_CURRENT,
    ]);

class _$PasswordPolicyRuleCodeMeta {
  const _$PasswordPolicyRuleCodeMeta();
  PasswordPolicyRuleCode get MIN_LENGTH => _$MIN_LENGTH;
  PasswordPolicyRuleCode get MAX_LENGTH => _$MAX_LENGTH;
  PasswordPolicyRuleCode get NOT_COMPROMISED => _$NOT_COMPROMISED;
  PasswordPolicyRuleCode get NOT_IDENTIFIER => _$NOT_IDENTIFIER;
  PasswordPolicyRuleCode get DIFFERENT_FROM_CURRENT => _$DIFFERENT_FROM_CURRENT;
  PasswordPolicyRuleCode valueOf(String name) => _$valueOf(name);
  BuiltSet<PasswordPolicyRuleCode> get values => _$values;
}

mixin _$PasswordPolicyRuleCodeMixin {
  // ignore: non_constant_identifier_names
  _$PasswordPolicyRuleCodeMeta get PasswordPolicyRuleCode =>
      const _$PasswordPolicyRuleCodeMeta();
}

Serializer<PasswordPolicyRuleCode> _$passwordPolicyRuleCodeSerializer =
    _$PasswordPolicyRuleCodeSerializer();

class _$PasswordPolicyRuleCodeSerializer
    implements PrimitiveSerializer<PasswordPolicyRuleCode> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MIN_LENGTH': 'MIN_LENGTH',
    'MAX_LENGTH': 'MAX_LENGTH',
    'NOT_COMPROMISED': 'NOT_COMPROMISED',
    'NOT_IDENTIFIER': 'NOT_IDENTIFIER',
    'DIFFERENT_FROM_CURRENT': 'DIFFERENT_FROM_CURRENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MIN_LENGTH': 'MIN_LENGTH',
    'MAX_LENGTH': 'MAX_LENGTH',
    'NOT_COMPROMISED': 'NOT_COMPROMISED',
    'NOT_IDENTIFIER': 'NOT_IDENTIFIER',
    'DIFFERENT_FROM_CURRENT': 'DIFFERENT_FROM_CURRENT',
  };

  @override
  final Iterable<Type> types = const <Type>[PasswordPolicyRuleCode];
  @override
  final String wireName = 'PasswordPolicyRuleCode';

  @override
  Object serialize(
    Serializers serializers,
    PasswordPolicyRuleCode object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  PasswordPolicyRuleCode deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => PasswordPolicyRuleCode.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
