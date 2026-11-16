// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_sub_role.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TeamSubRole _$OWNER = const TeamSubRole._('OWNER');
const TeamSubRole _$MANAGER = const TeamSubRole._('MANAGER');
const TeamSubRole _$FINANCE = const TeamSubRole._('FINANCE');
const TeamSubRole _$CASHIER = const TeamSubRole._('CASHIER');

TeamSubRole _$valueOf(String name) {
  switch (name) {
    case 'OWNER':
      return _$OWNER;
    case 'MANAGER':
      return _$MANAGER;
    case 'FINANCE':
      return _$FINANCE;
    case 'CASHIER':
      return _$CASHIER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TeamSubRole> _$values = BuiltSet<TeamSubRole>(
  const <TeamSubRole>[_$OWNER, _$MANAGER, _$FINANCE, _$CASHIER],
);

class _$TeamSubRoleMeta {
  const _$TeamSubRoleMeta();
  TeamSubRole get OWNER => _$OWNER;
  TeamSubRole get MANAGER => _$MANAGER;
  TeamSubRole get FINANCE => _$FINANCE;
  TeamSubRole get CASHIER => _$CASHIER;
  TeamSubRole valueOf(String name) => _$valueOf(name);
  BuiltSet<TeamSubRole> get values => _$values;
}

mixin _$TeamSubRoleMixin {
  // ignore: non_constant_identifier_names
  _$TeamSubRoleMeta get TeamSubRole => const _$TeamSubRoleMeta();
}

Serializer<TeamSubRole> _$teamSubRoleSerializer = _$TeamSubRoleSerializer();

class _$TeamSubRoleSerializer implements PrimitiveSerializer<TeamSubRole> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OWNER': 'OWNER',
    'MANAGER': 'MANAGER',
    'FINANCE': 'FINANCE',
    'CASHIER': 'CASHIER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OWNER': 'OWNER',
    'MANAGER': 'MANAGER',
    'FINANCE': 'FINANCE',
    'CASHIER': 'CASHIER',
  };

  @override
  final Iterable<Type> types = const <Type>[TeamSubRole];
  @override
  final String wireName = 'TeamSubRole';

  @override
  Object serialize(
    Serializers serializers,
    TeamSubRole object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  TeamSubRole deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => TeamSubRole.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
