// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const Role _$ADMIN = const Role._('ADMIN');
const Role _$COMPANY = const Role._('COMPANY');
const Role _$MERCHANT = const Role._('MERCHANT');
const Role _$EMPLOYEE = const Role._('EMPLOYEE');
const Role _$FAMILY_MEMBER = const Role._('FAMILY_MEMBER');

Role _$valueOf(String name) {
  switch (name) {
    case 'ADMIN':
      return _$ADMIN;
    case 'COMPANY':
      return _$COMPANY;
    case 'MERCHANT':
      return _$MERCHANT;
    case 'EMPLOYEE':
      return _$EMPLOYEE;
    case 'FAMILY_MEMBER':
      return _$FAMILY_MEMBER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<Role> _$values = BuiltSet<Role>(const <Role>[
  _$ADMIN,
  _$COMPANY,
  _$MERCHANT,
  _$EMPLOYEE,
  _$FAMILY_MEMBER,
]);

class _$RoleMeta {
  const _$RoleMeta();
  Role get ADMIN => _$ADMIN;
  Role get COMPANY => _$COMPANY;
  Role get MERCHANT => _$MERCHANT;
  Role get EMPLOYEE => _$EMPLOYEE;
  Role get FAMILY_MEMBER => _$FAMILY_MEMBER;
  Role valueOf(String name) => _$valueOf(name);
  BuiltSet<Role> get values => _$values;
}

mixin _$RoleMixin {
  // ignore: non_constant_identifier_names
  _$RoleMeta get Role => const _$RoleMeta();
}

Serializer<Role> _$roleSerializer = _$RoleSerializer();

class _$RoleSerializer implements PrimitiveSerializer<Role> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ADMIN': 'ADMIN',
    'COMPANY': 'COMPANY',
    'MERCHANT': 'MERCHANT',
    'EMPLOYEE': 'EMPLOYEE',
    'FAMILY_MEMBER': 'FAMILY_MEMBER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ADMIN': 'ADMIN',
    'COMPANY': 'COMPANY',
    'MERCHANT': 'MERCHANT',
    'EMPLOYEE': 'EMPLOYEE',
    'FAMILY_MEMBER': 'FAMILY_MEMBER',
  };

  @override
  final Iterable<Type> types = const <Type>[Role];
  @override
  final String wireName = 'Role';

  @override
  Object serialize(
    Serializers serializers,
    Role object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  Role deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => Role.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
