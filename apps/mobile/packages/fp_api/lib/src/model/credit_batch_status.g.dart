// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_batch_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreditBatchStatus _$ACTIVE = const CreditBatchStatus._('ACTIVE');
const CreditBatchStatus _$EXPIRED = const CreditBatchStatus._('EXPIRED');

CreditBatchStatus _$valueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$ACTIVE;
    case 'EXPIRED':
      return _$EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreditBatchStatus> _$values = BuiltSet<CreditBatchStatus>(
  const <CreditBatchStatus>[_$ACTIVE, _$EXPIRED],
);

class _$CreditBatchStatusMeta {
  const _$CreditBatchStatusMeta();
  CreditBatchStatus get ACTIVE => _$ACTIVE;
  CreditBatchStatus get EXPIRED => _$EXPIRED;
  CreditBatchStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<CreditBatchStatus> get values => _$values;
}

mixin _$CreditBatchStatusMixin {
  // ignore: non_constant_identifier_names
  _$CreditBatchStatusMeta get CreditBatchStatus =>
      const _$CreditBatchStatusMeta();
}

Serializer<CreditBatchStatus> _$creditBatchStatusSerializer =
    _$CreditBatchStatusSerializer();

class _$CreditBatchStatusSerializer
    implements PrimitiveSerializer<CreditBatchStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'EXPIRED': 'EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'EXPIRED': 'EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[CreditBatchStatus];
  @override
  final String wireName = 'CreditBatchStatus';

  @override
  Object serialize(
    Serializers serializers,
    CreditBatchStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CreditBatchStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CreditBatchStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
