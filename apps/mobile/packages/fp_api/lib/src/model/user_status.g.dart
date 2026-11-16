// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UserStatus _$INVITED = const UserStatus._('INVITED');
const UserStatus _$ACTIVE = const UserStatus._('ACTIVE');
const UserStatus _$SUSPENDED = const UserStatus._('SUSPENDED');
const UserStatus _$DEACTIVATED = const UserStatus._('DEACTIVATED');

UserStatus _$valueOf(String name) {
  switch (name) {
    case 'INVITED':
      return _$INVITED;
    case 'ACTIVE':
      return _$ACTIVE;
    case 'SUSPENDED':
      return _$SUSPENDED;
    case 'DEACTIVATED':
      return _$DEACTIVATED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UserStatus> _$values = BuiltSet<UserStatus>(const <UserStatus>[
  _$INVITED,
  _$ACTIVE,
  _$SUSPENDED,
  _$DEACTIVATED,
]);

class _$UserStatusMeta {
  const _$UserStatusMeta();
  UserStatus get INVITED => _$INVITED;
  UserStatus get ACTIVE => _$ACTIVE;
  UserStatus get SUSPENDED => _$SUSPENDED;
  UserStatus get DEACTIVATED => _$DEACTIVATED;
  UserStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<UserStatus> get values => _$values;
}

mixin _$UserStatusMixin {
  // ignore: non_constant_identifier_names
  _$UserStatusMeta get UserStatus => const _$UserStatusMeta();
}

Serializer<UserStatus> _$userStatusSerializer = _$UserStatusSerializer();

class _$UserStatusSerializer implements PrimitiveSerializer<UserStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INVITED': 'INVITED',
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
    'DEACTIVATED': 'DEACTIVATED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INVITED': 'INVITED',
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
    'DEACTIVATED': 'DEACTIVATED',
  };

  @override
  final Iterable<Type> types = const <Type>[UserStatus];
  @override
  final String wireName = 'UserStatus';

  @override
  Object serialize(
    Serializers serializers,
    UserStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  UserStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => UserStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
