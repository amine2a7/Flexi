// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_document_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const KycDocumentType _$REGISTRY_EXTRACT = const KycDocumentType._(
  'REGISTRY_EXTRACT',
);
const KycDocumentType _$TAX_CERTIFICATE = const KycDocumentType._(
  'TAX_CERTIFICATE',
);
const KycDocumentType _$MANAGER_ID = const KycDocumentType._('MANAGER_ID');
const KycDocumentType _$MANAGER_ID_FRONT = const KycDocumentType._(
  'MANAGER_ID_FRONT',
);
const KycDocumentType _$MANAGER_ID_BACK = const KycDocumentType._(
  'MANAGER_ID_BACK',
);
const KycDocumentType _$BANK_DETAILS = const KycDocumentType._('BANK_DETAILS');
const KycDocumentType _$COMPANY_STATUTES = const KycDocumentType._(
  'COMPANY_STATUTES',
);
const KycDocumentType _$PROOF_OF_ADDRESS = const KycDocumentType._(
  'PROOF_OF_ADDRESS',
);

KycDocumentType _$valueOf(String name) {
  switch (name) {
    case 'REGISTRY_EXTRACT':
      return _$REGISTRY_EXTRACT;
    case 'TAX_CERTIFICATE':
      return _$TAX_CERTIFICATE;
    case 'MANAGER_ID':
      return _$MANAGER_ID;
    case 'MANAGER_ID_FRONT':
      return _$MANAGER_ID_FRONT;
    case 'MANAGER_ID_BACK':
      return _$MANAGER_ID_BACK;
    case 'BANK_DETAILS':
      return _$BANK_DETAILS;
    case 'COMPANY_STATUTES':
      return _$COMPANY_STATUTES;
    case 'PROOF_OF_ADDRESS':
      return _$PROOF_OF_ADDRESS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<KycDocumentType> _$values = BuiltSet<KycDocumentType>(
  const <KycDocumentType>[
    _$REGISTRY_EXTRACT,
    _$TAX_CERTIFICATE,
    _$MANAGER_ID,
    _$MANAGER_ID_FRONT,
    _$MANAGER_ID_BACK,
    _$BANK_DETAILS,
    _$COMPANY_STATUTES,
    _$PROOF_OF_ADDRESS,
  ],
);

class _$KycDocumentTypeMeta {
  const _$KycDocumentTypeMeta();
  KycDocumentType get REGISTRY_EXTRACT => _$REGISTRY_EXTRACT;
  KycDocumentType get TAX_CERTIFICATE => _$TAX_CERTIFICATE;
  KycDocumentType get MANAGER_ID => _$MANAGER_ID;
  KycDocumentType get MANAGER_ID_FRONT => _$MANAGER_ID_FRONT;
  KycDocumentType get MANAGER_ID_BACK => _$MANAGER_ID_BACK;
  KycDocumentType get BANK_DETAILS => _$BANK_DETAILS;
  KycDocumentType get COMPANY_STATUTES => _$COMPANY_STATUTES;
  KycDocumentType get PROOF_OF_ADDRESS => _$PROOF_OF_ADDRESS;
  KycDocumentType valueOf(String name) => _$valueOf(name);
  BuiltSet<KycDocumentType> get values => _$values;
}

mixin _$KycDocumentTypeMixin {
  // ignore: non_constant_identifier_names
  _$KycDocumentTypeMeta get KycDocumentType => const _$KycDocumentTypeMeta();
}

Serializer<KycDocumentType> _$kycDocumentTypeSerializer =
    _$KycDocumentTypeSerializer();

class _$KycDocumentTypeSerializer
    implements PrimitiveSerializer<KycDocumentType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REGISTRY_EXTRACT': 'REGISTRY_EXTRACT',
    'TAX_CERTIFICATE': 'TAX_CERTIFICATE',
    'MANAGER_ID': 'MANAGER_ID',
    'MANAGER_ID_FRONT': 'MANAGER_ID_FRONT',
    'MANAGER_ID_BACK': 'MANAGER_ID_BACK',
    'BANK_DETAILS': 'BANK_DETAILS',
    'COMPANY_STATUTES': 'COMPANY_STATUTES',
    'PROOF_OF_ADDRESS': 'PROOF_OF_ADDRESS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REGISTRY_EXTRACT': 'REGISTRY_EXTRACT',
    'TAX_CERTIFICATE': 'TAX_CERTIFICATE',
    'MANAGER_ID': 'MANAGER_ID',
    'MANAGER_ID_FRONT': 'MANAGER_ID_FRONT',
    'MANAGER_ID_BACK': 'MANAGER_ID_BACK',
    'BANK_DETAILS': 'BANK_DETAILS',
    'COMPANY_STATUTES': 'COMPANY_STATUTES',
    'PROOF_OF_ADDRESS': 'PROOF_OF_ADDRESS',
  };

  @override
  final Iterable<Type> types = const <Type>[KycDocumentType];
  @override
  final String wireName = 'KycDocumentType';

  @override
  Object serialize(
    Serializers serializers,
    KycDocumentType object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  KycDocumentType deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => KycDocumentType.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
