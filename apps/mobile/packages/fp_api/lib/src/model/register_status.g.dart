// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RegisterStatus _$ACTIVE = const RegisterStatus._('ACTIVE');
const RegisterStatus _$DISABLED = const RegisterStatus._('DISABLED');

RegisterStatus _$valueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$ACTIVE;
    case 'DISABLED':
      return _$DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RegisterStatus> _$values = BuiltSet<RegisterStatus>(
  const <RegisterStatus>[_$ACTIVE, _$DISABLED],
);

class _$RegisterStatusMeta {
  const _$RegisterStatusMeta();
  RegisterStatus get ACTIVE => _$ACTIVE;
  RegisterStatus get DISABLED => _$DISABLED;
  RegisterStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<RegisterStatus> get values => _$values;
}

mixin _$RegisterStatusMixin {
  // ignore: non_constant_identifier_names
  _$RegisterStatusMeta get RegisterStatus => const _$RegisterStatusMeta();
}

Serializer<RegisterStatus> _$registerStatusSerializer =
    _$RegisterStatusSerializer();

class _$RegisterStatusSerializer
    implements PrimitiveSerializer<RegisterStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'DISABLED': 'DISABLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'DISABLED': 'DISABLED',
  };

  @override
  final Iterable<Type> types = const <Type>[RegisterStatus];
  @override
  final String wireName = 'RegisterStatus';

  @override
  Object serialize(
    Serializers serializers,
    RegisterStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  RegisterStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => RegisterStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
