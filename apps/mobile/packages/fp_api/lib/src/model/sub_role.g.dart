// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_role.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SubRole _$SUPER_ADMIN = const SubRole._('SUPER_ADMIN');
const SubRole _$FINANCE = const SubRole._('FINANCE');
const SubRole _$SUPPORT = const SubRole._('SUPPORT');
const SubRole _$COMPLIANCE = const SubRole._('COMPLIANCE');
const SubRole _$OWNER = const SubRole._('OWNER');
const SubRole _$MANAGER = const SubRole._('MANAGER');
const SubRole _$ACCOUNTANT = const SubRole._('ACCOUNTANT');
const SubRole _$READ_ONLY = const SubRole._('READ_ONLY');
const SubRole _$CASHIER = const SubRole._('CASHIER');

SubRole _$valueOf(String name) {
  switch (name) {
    case 'SUPER_ADMIN':
      return _$SUPER_ADMIN;
    case 'FINANCE':
      return _$FINANCE;
    case 'SUPPORT':
      return _$SUPPORT;
    case 'COMPLIANCE':
      return _$COMPLIANCE;
    case 'OWNER':
      return _$OWNER;
    case 'MANAGER':
      return _$MANAGER;
    case 'ACCOUNTANT':
      return _$ACCOUNTANT;
    case 'READ_ONLY':
      return _$READ_ONLY;
    case 'CASHIER':
      return _$CASHIER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SubRole> _$values = BuiltSet<SubRole>(const <SubRole>[
  _$SUPER_ADMIN,
  _$FINANCE,
  _$SUPPORT,
  _$COMPLIANCE,
  _$OWNER,
  _$MANAGER,
  _$ACCOUNTANT,
  _$READ_ONLY,
  _$CASHIER,
]);

class _$SubRoleMeta {
  const _$SubRoleMeta();
  SubRole get SUPER_ADMIN => _$SUPER_ADMIN;
  SubRole get FINANCE => _$FINANCE;
  SubRole get SUPPORT => _$SUPPORT;
  SubRole get COMPLIANCE => _$COMPLIANCE;
  SubRole get OWNER => _$OWNER;
  SubRole get MANAGER => _$MANAGER;
  SubRole get ACCOUNTANT => _$ACCOUNTANT;
  SubRole get READ_ONLY => _$READ_ONLY;
  SubRole get CASHIER => _$CASHIER;
  SubRole valueOf(String name) => _$valueOf(name);
  BuiltSet<SubRole> get values => _$values;
}

mixin _$SubRoleMixin {
  // ignore: non_constant_identifier_names
  _$SubRoleMeta get SubRole => const _$SubRoleMeta();
}

Serializer<SubRole> _$subRoleSerializer = _$SubRoleSerializer();

class _$SubRoleSerializer implements PrimitiveSerializer<SubRole> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SUPER_ADMIN': 'SUPER_ADMIN',
    'FINANCE': 'FINANCE',
    'SUPPORT': 'SUPPORT',
    'COMPLIANCE': 'COMPLIANCE',
    'OWNER': 'OWNER',
    'MANAGER': 'MANAGER',
    'ACCOUNTANT': 'ACCOUNTANT',
    'READ_ONLY': 'READ_ONLY',
    'CASHIER': 'CASHIER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SUPER_ADMIN': 'SUPER_ADMIN',
    'FINANCE': 'FINANCE',
    'SUPPORT': 'SUPPORT',
    'COMPLIANCE': 'COMPLIANCE',
    'OWNER': 'OWNER',
    'MANAGER': 'MANAGER',
    'ACCOUNTANT': 'ACCOUNTANT',
    'READ_ONLY': 'READ_ONLY',
    'CASHIER': 'CASHIER',
  };

  @override
  final Iterable<Type> types = const <Type>[SubRole];
  @override
  final String wireName = 'SubRole';

  @override
  Object serialize(
    Serializers serializers,
    SubRole object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SubRole deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SubRole.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
