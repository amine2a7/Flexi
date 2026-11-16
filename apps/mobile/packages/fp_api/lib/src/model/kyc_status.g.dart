// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const KycStatus _$PENDING = const KycStatus._('PENDING');
const KycStatus _$APPROVED = const KycStatus._('APPROVED');
const KycStatus _$REJECTED = const KycStatus._('REJECTED');

KycStatus _$valueOf(String name) {
  switch (name) {
    case 'PENDING':
      return _$PENDING;
    case 'APPROVED':
      return _$APPROVED;
    case 'REJECTED':
      return _$REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<KycStatus> _$values = BuiltSet<KycStatus>(const <KycStatus>[
  _$PENDING,
  _$APPROVED,
  _$REJECTED,
]);

class _$KycStatusMeta {
  const _$KycStatusMeta();
  KycStatus get PENDING => _$PENDING;
  KycStatus get APPROVED => _$APPROVED;
  KycStatus get REJECTED => _$REJECTED;
  KycStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<KycStatus> get values => _$values;
}

mixin _$KycStatusMixin {
  // ignore: non_constant_identifier_names
  _$KycStatusMeta get KycStatus => const _$KycStatusMeta();
}

Serializer<KycStatus> _$kycStatusSerializer = _$KycStatusSerializer();

class _$KycStatusSerializer implements PrimitiveSerializer<KycStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[KycStatus];
  @override
  final String wireName = 'KycStatus';

  @override
  Object serialize(
    Serializers serializers,
    KycStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  KycStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => KycStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
