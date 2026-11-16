// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_account_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const KycAccountType _$MERCHANT = const KycAccountType._('MERCHANT');
const KycAccountType _$COMPANY = const KycAccountType._('COMPANY');

KycAccountType _$valueOf(String name) {
  switch (name) {
    case 'MERCHANT':
      return _$MERCHANT;
    case 'COMPANY':
      return _$COMPANY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<KycAccountType> _$values = BuiltSet<KycAccountType>(
  const <KycAccountType>[_$MERCHANT, _$COMPANY],
);

class _$KycAccountTypeMeta {
  const _$KycAccountTypeMeta();
  KycAccountType get MERCHANT => _$MERCHANT;
  KycAccountType get COMPANY => _$COMPANY;
  KycAccountType valueOf(String name) => _$valueOf(name);
  BuiltSet<KycAccountType> get values => _$values;
}

mixin _$KycAccountTypeMixin {
  // ignore: non_constant_identifier_names
  _$KycAccountTypeMeta get KycAccountType => const _$KycAccountTypeMeta();
}

Serializer<KycAccountType> _$kycAccountTypeSerializer =
    _$KycAccountTypeSerializer();

class _$KycAccountTypeSerializer
    implements PrimitiveSerializer<KycAccountType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MERCHANT': 'MERCHANT',
    'COMPANY': 'COMPANY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MERCHANT': 'MERCHANT',
    'COMPANY': 'COMPANY',
  };

  @override
  final Iterable<Type> types = const <Type>[KycAccountType];
  @override
  final String wireName = 'KycAccountType';

  @override
  Object serialize(
    Serializers serializers,
    KycAccountType object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  KycAccountType deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => KycAccountType.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
