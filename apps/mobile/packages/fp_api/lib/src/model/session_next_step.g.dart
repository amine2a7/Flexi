// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_next_step.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SessionNextStep _$NONE = const SessionNextStep._('NONE');
const SessionNextStep _$PASSWORD_CHANGE = const SessionNextStep._(
  'PASSWORD_CHANGE',
);
const SessionNextStep _$MFA_ENROLL = const SessionNextStep._('MFA_ENROLL');

SessionNextStep _$valueOf(String name) {
  switch (name) {
    case 'NONE':
      return _$NONE;
    case 'PASSWORD_CHANGE':
      return _$PASSWORD_CHANGE;
    case 'MFA_ENROLL':
      return _$MFA_ENROLL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SessionNextStep> _$values = BuiltSet<SessionNextStep>(
  const <SessionNextStep>[_$NONE, _$PASSWORD_CHANGE, _$MFA_ENROLL],
);

class _$SessionNextStepMeta {
  const _$SessionNextStepMeta();
  SessionNextStep get NONE => _$NONE;
  SessionNextStep get PASSWORD_CHANGE => _$PASSWORD_CHANGE;
  SessionNextStep get MFA_ENROLL => _$MFA_ENROLL;
  SessionNextStep valueOf(String name) => _$valueOf(name);
  BuiltSet<SessionNextStep> get values => _$values;
}

mixin _$SessionNextStepMixin {
  // ignore: non_constant_identifier_names
  _$SessionNextStepMeta get SessionNextStep => const _$SessionNextStepMeta();
}

Serializer<SessionNextStep> _$sessionNextStepSerializer =
    _$SessionNextStepSerializer();

class _$SessionNextStepSerializer
    implements PrimitiveSerializer<SessionNextStep> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NONE': 'NONE',
    'PASSWORD_CHANGE': 'PASSWORD_CHANGE',
    'MFA_ENROLL': 'MFA_ENROLL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NONE': 'NONE',
    'PASSWORD_CHANGE': 'PASSWORD_CHANGE',
    'MFA_ENROLL': 'MFA_ENROLL',
  };

  @override
  final Iterable<Type> types = const <Type>[SessionNextStep];
  @override
  final String wireName = 'SessionNextStep';

  @override
  Object serialize(
    Serializers serializers,
    SessionNextStep object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SessionNextStep deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SessionNextStep.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
