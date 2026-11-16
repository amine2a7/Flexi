// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_proof.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TransferProofContentTypeEnum
_$transferProofContentTypeEnum_imageSlashJpeg =
    const TransferProofContentTypeEnum._('imageSlashJpeg');
const TransferProofContentTypeEnum
_$transferProofContentTypeEnum_imageSlashPng =
    const TransferProofContentTypeEnum._('imageSlashPng');
const TransferProofContentTypeEnum
_$transferProofContentTypeEnum_applicationSlashPdf =
    const TransferProofContentTypeEnum._('applicationSlashPdf');

TransferProofContentTypeEnum _$transferProofContentTypeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'imageSlashJpeg':
      return _$transferProofContentTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$transferProofContentTypeEnum_imageSlashPng;
    case 'applicationSlashPdf':
      return _$transferProofContentTypeEnum_applicationSlashPdf;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TransferProofContentTypeEnum>
_$transferProofContentTypeEnumValues = BuiltSet<TransferProofContentTypeEnum>(
  const <TransferProofContentTypeEnum>[
    _$transferProofContentTypeEnum_imageSlashJpeg,
    _$transferProofContentTypeEnum_imageSlashPng,
    _$transferProofContentTypeEnum_applicationSlashPdf,
  ],
);

Serializer<TransferProofContentTypeEnum>
_$transferProofContentTypeEnumSerializer =
    _$TransferProofContentTypeEnumSerializer();

class _$TransferProofContentTypeEnumSerializer
    implements PrimitiveSerializer<TransferProofContentTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'imageSlashJpeg': 'image/jpeg',
    'imageSlashPng': 'image/png',
    'applicationSlashPdf': 'application/pdf',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'image/jpeg': 'imageSlashJpeg',
    'image/png': 'imageSlashPng',
    'application/pdf': 'applicationSlashPdf',
  };

  @override
  final Iterable<Type> types = const <Type>[TransferProofContentTypeEnum];
  @override
  final String wireName = 'TransferProofContentTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    TransferProofContentTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  TransferProofContentTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => TransferProofContentTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$TransferProof extends TransferProof {
  @override
  final String fileName;
  @override
  final TransferProofContentTypeEnum contentType;
  @override
  final int sizeBytes;

  factory _$TransferProof([void Function(TransferProofBuilder)? updates]) =>
      (TransferProofBuilder()..update(updates))._build();

  _$TransferProof._({
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
  }) : super._();
  @override
  TransferProof rebuild(void Function(TransferProofBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TransferProofBuilder toBuilder() => TransferProofBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TransferProof &&
        fileName == other.fileName &&
        contentType == other.contentType &&
        sizeBytes == other.sizeBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TransferProof')
          ..add('fileName', fileName)
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class TransferProofBuilder
    implements Builder<TransferProof, TransferProofBuilder> {
  _$TransferProof? _$v;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  TransferProofContentTypeEnum? _contentType;
  TransferProofContentTypeEnum? get contentType => _$this._contentType;
  set contentType(TransferProofContentTypeEnum? contentType) =>
      _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  TransferProofBuilder() {
    TransferProof._defaults(this);
  }

  TransferProofBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fileName = $v.fileName;
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TransferProof other) {
    _$v = other as _$TransferProof;
  }

  @override
  void update(void Function(TransferProofBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TransferProof build() => _build();

  _$TransferProof _build() {
    final _$result =
        _$v ??
        _$TransferProof._(
          fileName: BuiltValueNullFieldError.checkNotNull(
            fileName,
            r'TransferProof',
            'fileName',
          ),
          contentType: BuiltValueNullFieldError.checkNotNull(
            contentType,
            r'TransferProof',
            'contentType',
          ),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
            sizeBytes,
            r'TransferProof',
            'sizeBytes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
