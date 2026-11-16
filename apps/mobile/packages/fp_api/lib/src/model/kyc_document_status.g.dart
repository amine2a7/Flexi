// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_document_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const KycDocumentStatus _$SUBMITTED = const KycDocumentStatus._('SUBMITTED');
const KycDocumentStatus _$VALIDATED = const KycDocumentStatus._('VALIDATED');
const KycDocumentStatus _$TO_CORRECT = const KycDocumentStatus._('TO_CORRECT');

KycDocumentStatus _$valueOf(String name) {
  switch (name) {
    case 'SUBMITTED':
      return _$SUBMITTED;
    case 'VALIDATED':
      return _$VALIDATED;
    case 'TO_CORRECT':
      return _$TO_CORRECT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<KycDocumentStatus> _$values = BuiltSet<KycDocumentStatus>(
  const <KycDocumentStatus>[_$SUBMITTED, _$VALIDATED, _$TO_CORRECT],
);

class _$KycDocumentStatusMeta {
  const _$KycDocumentStatusMeta();
  KycDocumentStatus get SUBMITTED => _$SUBMITTED;
  KycDocumentStatus get VALIDATED => _$VALIDATED;
  KycDocumentStatus get TO_CORRECT => _$TO_CORRECT;
  KycDocumentStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<KycDocumentStatus> get values => _$values;
}

mixin _$KycDocumentStatusMixin {
  // ignore: non_constant_identifier_names
  _$KycDocumentStatusMeta get KycDocumentStatus =>
      const _$KycDocumentStatusMeta();
}

Serializer<KycDocumentStatus> _$kycDocumentStatusSerializer =
    _$KycDocumentStatusSerializer();

class _$KycDocumentStatusSerializer
    implements PrimitiveSerializer<KycDocumentStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SUBMITTED': 'SUBMITTED',
    'VALIDATED': 'VALIDATED',
    'TO_CORRECT': 'TO_CORRECT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SUBMITTED': 'SUBMITTED',
    'VALIDATED': 'VALIDATED',
    'TO_CORRECT': 'TO_CORRECT',
  };

  @override
  final Iterable<Type> types = const <Type>[KycDocumentStatus];
  @override
  final String wireName = 'KycDocumentStatus';

  @override
  Object serialize(
    Serializers serializers,
    KycDocumentStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  KycDocumentStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => KycDocumentStatus.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
