// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_document_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantDocumentType _$COMMISSION_INVOICE = const MerchantDocumentType._(
  'COMMISSION_INVOICE',
);
const MerchantDocumentType _$STATEMENT = const MerchantDocumentType._(
  'STATEMENT',
);
const MerchantDocumentType _$CERTIFICATE = const MerchantDocumentType._(
  'CERTIFICATE',
);

MerchantDocumentType _$valueOf(String name) {
  switch (name) {
    case 'COMMISSION_INVOICE':
      return _$COMMISSION_INVOICE;
    case 'STATEMENT':
      return _$STATEMENT;
    case 'CERTIFICATE':
      return _$CERTIFICATE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantDocumentType> _$values = BuiltSet<MerchantDocumentType>(
  const <MerchantDocumentType>[
    _$COMMISSION_INVOICE,
    _$STATEMENT,
    _$CERTIFICATE,
  ],
);

class _$MerchantDocumentTypeMeta {
  const _$MerchantDocumentTypeMeta();
  MerchantDocumentType get COMMISSION_INVOICE => _$COMMISSION_INVOICE;
  MerchantDocumentType get STATEMENT => _$STATEMENT;
  MerchantDocumentType get CERTIFICATE => _$CERTIFICATE;
  MerchantDocumentType valueOf(String name) => _$valueOf(name);
  BuiltSet<MerchantDocumentType> get values => _$values;
}

mixin _$MerchantDocumentTypeMixin {
  // ignore: non_constant_identifier_names
  _$MerchantDocumentTypeMeta get MerchantDocumentType =>
      const _$MerchantDocumentTypeMeta();
}

Serializer<MerchantDocumentType> _$merchantDocumentTypeSerializer =
    _$MerchantDocumentTypeSerializer();

class _$MerchantDocumentTypeSerializer
    implements PrimitiveSerializer<MerchantDocumentType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COMMISSION_INVOICE': 'COMMISSION_INVOICE',
    'STATEMENT': 'STATEMENT',
    'CERTIFICATE': 'CERTIFICATE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COMMISSION_INVOICE': 'COMMISSION_INVOICE',
    'STATEMENT': 'STATEMENT',
    'CERTIFICATE': 'CERTIFICATE',
  };

  @override
  final Iterable<Type> types = const <Type>[MerchantDocumentType];
  @override
  final String wireName = 'MerchantDocumentType';

  @override
  Object serialize(
    Serializers serializers,
    MerchantDocumentType object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantDocumentType deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantDocumentType.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
