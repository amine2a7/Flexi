// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_document.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const KycDocumentContentTypeEnum _$kycDocumentContentTypeEnum_imageSlashJpeg =
    const KycDocumentContentTypeEnum._('imageSlashJpeg');
const KycDocumentContentTypeEnum _$kycDocumentContentTypeEnum_imageSlashPng =
    const KycDocumentContentTypeEnum._('imageSlashPng');
const KycDocumentContentTypeEnum
_$kycDocumentContentTypeEnum_applicationSlashPdf =
    const KycDocumentContentTypeEnum._('applicationSlashPdf');

KycDocumentContentTypeEnum _$kycDocumentContentTypeEnumValueOf(String name) {
  switch (name) {
    case 'imageSlashJpeg':
      return _$kycDocumentContentTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$kycDocumentContentTypeEnum_imageSlashPng;
    case 'applicationSlashPdf':
      return _$kycDocumentContentTypeEnum_applicationSlashPdf;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<KycDocumentContentTypeEnum> _$kycDocumentContentTypeEnumValues =
    BuiltSet<KycDocumentContentTypeEnum>(const <KycDocumentContentTypeEnum>[
      _$kycDocumentContentTypeEnum_imageSlashJpeg,
      _$kycDocumentContentTypeEnum_imageSlashPng,
      _$kycDocumentContentTypeEnum_applicationSlashPdf,
    ]);

Serializer<KycDocumentContentTypeEnum> _$kycDocumentContentTypeEnumSerializer =
    _$KycDocumentContentTypeEnumSerializer();

class _$KycDocumentContentTypeEnumSerializer
    implements PrimitiveSerializer<KycDocumentContentTypeEnum> {
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
  final Iterable<Type> types = const <Type>[KycDocumentContentTypeEnum];
  @override
  final String wireName = 'KycDocumentContentTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    KycDocumentContentTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  KycDocumentContentTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => KycDocumentContentTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$KycDocument extends KycDocument {
  @override
  final String id;
  @override
  final KycDocumentType type;
  @override
  final String fileName;
  @override
  final KycDocumentContentTypeEnum contentType;
  @override
  final int sizeBytes;
  @override
  final DateTime uploadedAt;
  @override
  final KycDocumentStatus? status;
  @override
  final String? correctionReason;

  factory _$KycDocument([void Function(KycDocumentBuilder)? updates]) =>
      (KycDocumentBuilder()..update(updates))._build();

  _$KycDocument._({
    required this.id,
    required this.type,
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
    required this.uploadedAt,
    this.status,
    this.correctionReason,
  }) : super._();
  @override
  KycDocument rebuild(void Function(KycDocumentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KycDocumentBuilder toBuilder() => KycDocumentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KycDocument &&
        id == other.id &&
        type == other.type &&
        fileName == other.fileName &&
        contentType == other.contentType &&
        sizeBytes == other.sizeBytes &&
        uploadedAt == other.uploadedAt &&
        status == other.status &&
        correctionReason == other.correctionReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, uploadedAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, correctionReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'KycDocument')
          ..add('id', id)
          ..add('type', type)
          ..add('fileName', fileName)
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes)
          ..add('uploadedAt', uploadedAt)
          ..add('status', status)
          ..add('correctionReason', correctionReason))
        .toString();
  }
}

class KycDocumentBuilder implements Builder<KycDocument, KycDocumentBuilder> {
  _$KycDocument? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  KycDocumentType? _type;
  KycDocumentType? get type => _$this._type;
  set type(KycDocumentType? type) => _$this._type = type;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  KycDocumentContentTypeEnum? _contentType;
  KycDocumentContentTypeEnum? get contentType => _$this._contentType;
  set contentType(KycDocumentContentTypeEnum? contentType) =>
      _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  DateTime? _uploadedAt;
  DateTime? get uploadedAt => _$this._uploadedAt;
  set uploadedAt(DateTime? uploadedAt) => _$this._uploadedAt = uploadedAt;

  KycDocumentStatus? _status;
  KycDocumentStatus? get status => _$this._status;
  set status(KycDocumentStatus? status) => _$this._status = status;

  String? _correctionReason;
  String? get correctionReason => _$this._correctionReason;
  set correctionReason(String? correctionReason) =>
      _$this._correctionReason = correctionReason;

  KycDocumentBuilder() {
    KycDocument._defaults(this);
  }

  KycDocumentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _fileName = $v.fileName;
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _uploadedAt = $v.uploadedAt;
      _status = $v.status;
      _correctionReason = $v.correctionReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KycDocument other) {
    _$v = other as _$KycDocument;
  }

  @override
  void update(void Function(KycDocumentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KycDocument build() => _build();

  _$KycDocument _build() {
    final _$result =
        _$v ??
        _$KycDocument._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'KycDocument', 'id'),
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'KycDocument',
            'type',
          ),
          fileName: BuiltValueNullFieldError.checkNotNull(
            fileName,
            r'KycDocument',
            'fileName',
          ),
          contentType: BuiltValueNullFieldError.checkNotNull(
            contentType,
            r'KycDocument',
            'contentType',
          ),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
            sizeBytes,
            r'KycDocument',
            'sizeBytes',
          ),
          uploadedAt: BuiltValueNullFieldError.checkNotNull(
            uploadedAt,
            r'KycDocument',
            'uploadedAt',
          ),
          status: status,
          correctionReason: correctionReason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
