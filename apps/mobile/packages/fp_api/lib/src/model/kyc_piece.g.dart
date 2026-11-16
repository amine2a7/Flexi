// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_piece.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const KycPieceStatusEnum _$kycPieceStatusEnum_MISSING =
    const KycPieceStatusEnum._('MISSING');
const KycPieceStatusEnum _$kycPieceStatusEnum_SUBMITTED =
    const KycPieceStatusEnum._('SUBMITTED');
const KycPieceStatusEnum _$kycPieceStatusEnum_VALIDATED =
    const KycPieceStatusEnum._('VALIDATED');
const KycPieceStatusEnum _$kycPieceStatusEnum_TO_CORRECT =
    const KycPieceStatusEnum._('TO_CORRECT');

KycPieceStatusEnum _$kycPieceStatusEnumValueOf(String name) {
  switch (name) {
    case 'MISSING':
      return _$kycPieceStatusEnum_MISSING;
    case 'SUBMITTED':
      return _$kycPieceStatusEnum_SUBMITTED;
    case 'VALIDATED':
      return _$kycPieceStatusEnum_VALIDATED;
    case 'TO_CORRECT':
      return _$kycPieceStatusEnum_TO_CORRECT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<KycPieceStatusEnum> _$kycPieceStatusEnumValues =
    BuiltSet<KycPieceStatusEnum>(const <KycPieceStatusEnum>[
      _$kycPieceStatusEnum_MISSING,
      _$kycPieceStatusEnum_SUBMITTED,
      _$kycPieceStatusEnum_VALIDATED,
      _$kycPieceStatusEnum_TO_CORRECT,
    ]);

const KycPieceContentTypeEnum _$kycPieceContentTypeEnum_imageSlashJpeg =
    const KycPieceContentTypeEnum._('imageSlashJpeg');
const KycPieceContentTypeEnum _$kycPieceContentTypeEnum_imageSlashPng =
    const KycPieceContentTypeEnum._('imageSlashPng');
const KycPieceContentTypeEnum _$kycPieceContentTypeEnum_applicationSlashPdf =
    const KycPieceContentTypeEnum._('applicationSlashPdf');

KycPieceContentTypeEnum _$kycPieceContentTypeEnumValueOf(String name) {
  switch (name) {
    case 'imageSlashJpeg':
      return _$kycPieceContentTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$kycPieceContentTypeEnum_imageSlashPng;
    case 'applicationSlashPdf':
      return _$kycPieceContentTypeEnum_applicationSlashPdf;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<KycPieceContentTypeEnum> _$kycPieceContentTypeEnumValues =
    BuiltSet<KycPieceContentTypeEnum>(const <KycPieceContentTypeEnum>[
      _$kycPieceContentTypeEnum_imageSlashJpeg,
      _$kycPieceContentTypeEnum_imageSlashPng,
      _$kycPieceContentTypeEnum_applicationSlashPdf,
    ]);

Serializer<KycPieceStatusEnum> _$kycPieceStatusEnumSerializer =
    _$KycPieceStatusEnumSerializer();
Serializer<KycPieceContentTypeEnum> _$kycPieceContentTypeEnumSerializer =
    _$KycPieceContentTypeEnumSerializer();

class _$KycPieceStatusEnumSerializer
    implements PrimitiveSerializer<KycPieceStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MISSING': 'MISSING',
    'SUBMITTED': 'SUBMITTED',
    'VALIDATED': 'VALIDATED',
    'TO_CORRECT': 'TO_CORRECT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MISSING': 'MISSING',
    'SUBMITTED': 'SUBMITTED',
    'VALIDATED': 'VALIDATED',
    'TO_CORRECT': 'TO_CORRECT',
  };

  @override
  final Iterable<Type> types = const <Type>[KycPieceStatusEnum];
  @override
  final String wireName = 'KycPieceStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    KycPieceStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  KycPieceStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => KycPieceStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$KycPieceContentTypeEnumSerializer
    implements PrimitiveSerializer<KycPieceContentTypeEnum> {
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
  final Iterable<Type> types = const <Type>[KycPieceContentTypeEnum];
  @override
  final String wireName = 'KycPieceContentTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    KycPieceContentTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  KycPieceContentTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => KycPieceContentTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$KycPiece extends KycPiece {
  @override
  final KycDocumentType type;
  @override
  final KycPieceStatusEnum status;
  @override
  final String? documentId;
  @override
  final String? fileName;
  @override
  final KycPieceContentTypeEnum? contentType;
  @override
  final int? sizeBytes;
  @override
  final DateTime? uploadedAt;
  @override
  final String? correctionReason;

  factory _$KycPiece([void Function(KycPieceBuilder)? updates]) =>
      (KycPieceBuilder()..update(updates))._build();

  _$KycPiece._({
    required this.type,
    required this.status,
    this.documentId,
    this.fileName,
    this.contentType,
    this.sizeBytes,
    this.uploadedAt,
    this.correctionReason,
  }) : super._();
  @override
  KycPiece rebuild(void Function(KycPieceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KycPieceBuilder toBuilder() => KycPieceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KycPiece &&
        type == other.type &&
        status == other.status &&
        documentId == other.documentId &&
        fileName == other.fileName &&
        contentType == other.contentType &&
        sizeBytes == other.sizeBytes &&
        uploadedAt == other.uploadedAt &&
        correctionReason == other.correctionReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, documentId.hashCode);
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, uploadedAt.hashCode);
    _$hash = $jc(_$hash, correctionReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'KycPiece')
          ..add('type', type)
          ..add('status', status)
          ..add('documentId', documentId)
          ..add('fileName', fileName)
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes)
          ..add('uploadedAt', uploadedAt)
          ..add('correctionReason', correctionReason))
        .toString();
  }
}

class KycPieceBuilder implements Builder<KycPiece, KycPieceBuilder> {
  _$KycPiece? _$v;

  KycDocumentType? _type;
  KycDocumentType? get type => _$this._type;
  set type(KycDocumentType? type) => _$this._type = type;

  KycPieceStatusEnum? _status;
  KycPieceStatusEnum? get status => _$this._status;
  set status(KycPieceStatusEnum? status) => _$this._status = status;

  String? _documentId;
  String? get documentId => _$this._documentId;
  set documentId(String? documentId) => _$this._documentId = documentId;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  KycPieceContentTypeEnum? _contentType;
  KycPieceContentTypeEnum? get contentType => _$this._contentType;
  set contentType(KycPieceContentTypeEnum? contentType) =>
      _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  DateTime? _uploadedAt;
  DateTime? get uploadedAt => _$this._uploadedAt;
  set uploadedAt(DateTime? uploadedAt) => _$this._uploadedAt = uploadedAt;

  String? _correctionReason;
  String? get correctionReason => _$this._correctionReason;
  set correctionReason(String? correctionReason) =>
      _$this._correctionReason = correctionReason;

  KycPieceBuilder() {
    KycPiece._defaults(this);
  }

  KycPieceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _status = $v.status;
      _documentId = $v.documentId;
      _fileName = $v.fileName;
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _uploadedAt = $v.uploadedAt;
      _correctionReason = $v.correctionReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KycPiece other) {
    _$v = other as _$KycPiece;
  }

  @override
  void update(void Function(KycPieceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KycPiece build() => _build();

  _$KycPiece _build() {
    final _$result =
        _$v ??
        _$KycPiece._(
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'KycPiece',
            'type',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'KycPiece',
            'status',
          ),
          documentId: documentId,
          fileName: fileName,
          contentType: contentType,
          sizeBytes: sizeBytes,
          uploadedAt: uploadedAt,
          correctionReason: correctionReason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
