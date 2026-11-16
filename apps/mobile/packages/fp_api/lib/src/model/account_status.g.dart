// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AccountStatus _$PENDING_KYC = const AccountStatus._('PENDING_KYC');
const AccountStatus _$APPROVED = const AccountStatus._('APPROVED');
const AccountStatus _$REJECTED = const AccountStatus._('REJECTED');
const AccountStatus _$SUSPENDED = const AccountStatus._('SUSPENDED');

AccountStatus _$valueOf(String name) {
  switch (name) {
    case 'PENDING_KYC':
      return _$PENDING_KYC;
    case 'APPROVED':
      return _$APPROVED;
    case 'REJECTED':
      return _$REJECTED;
    case 'SUSPENDED':
      return _$SUSPENDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AccountStatus> _$values = BuiltSet<AccountStatus>(
  const <AccountStatus>[_$PENDING_KYC, _$APPROVED, _$REJECTED, _$SUSPENDED],
);

class _$AccountStatusMeta {
  const _$AccountStatusMeta();
  AccountStatus get PENDING_KYC => _$PENDING_KYC;
  AccountStatus get APPROVED => _$APPROVED;
  AccountStatus get REJECTED => _$REJECTED;
  AccountStatus get SUSPENDED => _$SUSPENDED;
  AccountStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<AccountStatus> get values => _$values;
}

mixin _$AccountStatusMixin {
  // ignore: non_constant_identifier_names
  _$AccountStatusMeta get AccountStatus => const _$AccountStatusMeta();
}

Serializer<AccountStatus> _$accountStatusSerializer =
    _$AccountStatusSerializer();

class _$AccountStatusSerializer implements PrimitiveSerializer<AccountStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING_KYC': 'PENDING_KYC',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'SUSPENDED': 'SUSPENDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING_KYC': 'PENDING_KYC',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'SUSPENDED': 'SUSPENDED',
  };

  @override
  final Iterable<Type> types = const <Type>[AccountStatus];
  @override
  final String wireName = 'AccountStatus';

  @override
  Object serialize(
    Serializers serializers,
    AccountStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AccountStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AccountStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
