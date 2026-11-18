// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_file.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$KycFile extends KycFile {
  @override
  final KycIdentifiers? maskedIdentifiers;
  @override
  final KycIdentifiers? identifiers;
  @override
  final BuiltList<KycPiece>? pieces;
  @override
  final String id;
  @override
  final KycAccountType accountType;
  @override
  final String accountId;
  @override
  final String accountName;
  @override
  final String city;
  @override
  final KycStatus status;
  @override
  final DateTime submittedAt;
  @override
  final int documentsCount;
  @override
  final BuiltList<KycDocument> documents;
  @override
  final String? rejectionReason;
  @override
  final BuiltList<KycEvent> history;

  factory _$KycFile([void Function(KycFileBuilder)? updates]) =>
      (KycFileBuilder()..update(updates))._build();

  _$KycFile._({
    this.maskedIdentifiers,
    this.identifiers,
    this.pieces,
    required this.id,
    required this.accountType,
    required this.accountId,
    required this.accountName,
    required this.city,
    required this.status,
    required this.submittedAt,
    required this.documentsCount,
    required this.documents,
    this.rejectionReason,
    required this.history,
  }) : super._();
  @override
  KycFile rebuild(void Function(KycFileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KycFileBuilder toBuilder() => KycFileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KycFile &&
        maskedIdentifiers == other.maskedIdentifiers &&
        identifiers == other.identifiers &&
        pieces == other.pieces &&
        id == other.id &&
        accountType == other.accountType &&
        accountId == other.accountId &&
        accountName == other.accountName &&
        city == other.city &&
        status == other.status &&
        submittedAt == other.submittedAt &&
        documentsCount == other.documentsCount &&
        documents == other.documents &&
        rejectionReason == other.rejectionReason &&
        history == other.history;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, maskedIdentifiers.hashCode);
    _$hash = $jc(_$hash, identifiers.hashCode);
    _$hash = $jc(_$hash, pieces.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, accountType.hashCode);
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, accountName.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, documentsCount.hashCode);
    _$hash = $jc(_$hash, documents.hashCode);
    _$hash = $jc(_$hash, rejectionReason.hashCode);
    _$hash = $jc(_$hash, history.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'KycFile')
          ..add('maskedIdentifiers', maskedIdentifiers)
          ..add('identifiers', identifiers)
          ..add('pieces', pieces)
          ..add('id', id)
          ..add('accountType', accountType)
          ..add('accountId', accountId)
          ..add('accountName', accountName)
          ..add('city', city)
          ..add('status', status)
          ..add('submittedAt', submittedAt)
          ..add('documentsCount', documentsCount)
          ..add('documents', documents)
          ..add('rejectionReason', rejectionReason)
          ..add('history', history))
        .toString();
  }
}

class KycFileBuilder implements Builder<KycFile, KycFileBuilder> {
  _$KycFile? _$v;

  KycIdentifiersBuilder? _maskedIdentifiers;
  KycIdentifiersBuilder get maskedIdentifiers =>
      _$this._maskedIdentifiers ??= KycIdentifiersBuilder();
  set maskedIdentifiers(KycIdentifiersBuilder? maskedIdentifiers) =>
      _$this._maskedIdentifiers = maskedIdentifiers;

  KycIdentifiersBuilder? _identifiers;
  KycIdentifiersBuilder get identifiers =>
      _$this._identifiers ??= KycIdentifiersBuilder();
  set identifiers(KycIdentifiersBuilder? identifiers) =>
      _$this._identifiers = identifiers;

  ListBuilder<KycPiece>? _pieces;
  ListBuilder<KycPiece> get pieces =>
      _$this._pieces ??= ListBuilder<KycPiece>();
  set pieces(ListBuilder<KycPiece>? pieces) => _$this._pieces = pieces;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  KycAccountType? _accountType;
  KycAccountType? get accountType => _$this._accountType;
  set accountType(KycAccountType? accountType) =>
      _$this._accountType = accountType;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  String? _accountName;
  String? get accountName => _$this._accountName;
  set accountName(String? accountName) => _$this._accountName = accountName;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  KycStatus? _status;
  KycStatus? get status => _$this._status;
  set status(KycStatus? status) => _$this._status = status;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  int? _documentsCount;
  int? get documentsCount => _$this._documentsCount;
  set documentsCount(int? documentsCount) =>
      _$this._documentsCount = documentsCount;

  ListBuilder<KycDocument>? _documents;
  ListBuilder<KycDocument> get documents =>
      _$this._documents ??= ListBuilder<KycDocument>();
  set documents(ListBuilder<KycDocument>? documents) =>
      _$this._documents = documents;

  String? _rejectionReason;
  String? get rejectionReason => _$this._rejectionReason;
  set rejectionReason(String? rejectionReason) =>
      _$this._rejectionReason = rejectionReason;

  ListBuilder<KycEvent>? _history;
  ListBuilder<KycEvent> get history =>
      _$this._history ??= ListBuilder<KycEvent>();
  set history(ListBuilder<KycEvent>? history) => _$this._history = history;

  KycFileBuilder() {
    KycFile._defaults(this);
  }

  KycFileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _maskedIdentifiers = $v.maskedIdentifiers?.toBuilder();
      _identifiers = $v.identifiers?.toBuilder();
      _pieces = $v.pieces?.toBuilder();
      _id = $v.id;
      _accountType = $v.accountType;
      _accountId = $v.accountId;
      _accountName = $v.accountName;
      _city = $v.city;
      _status = $v.status;
      _submittedAt = $v.submittedAt;
      _documentsCount = $v.documentsCount;
      _documents = $v.documents.toBuilder();
      _rejectionReason = $v.rejectionReason;
      _history = $v.history.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KycFile other) {
    _$v = other as _$KycFile;
  }

  @override
  void update(void Function(KycFileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KycFile build() => _build();

  _$KycFile _build() {
    _$KycFile _$result;
    try {
      _$result =
          _$v ??
          _$KycFile._(
            maskedIdentifiers: _maskedIdentifiers?.build(),
            identifiers: _identifiers?.build(),
            pieces: _pieces?.build(),
            id: BuiltValueNullFieldError.checkNotNull(id, r'KycFile', 'id'),
            accountType: BuiltValueNullFieldError.checkNotNull(
              accountType,
              r'KycFile',
              'accountType',
            ),
            accountId: BuiltValueNullFieldError.checkNotNull(
              accountId,
              r'KycFile',
              'accountId',
            ),
            accountName: BuiltValueNullFieldError.checkNotNull(
              accountName,
              r'KycFile',
              'accountName',
            ),
            city: BuiltValueNullFieldError.checkNotNull(
              city,
              r'KycFile',
              'city',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'KycFile',
              'status',
            ),
            submittedAt: BuiltValueNullFieldError.checkNotNull(
              submittedAt,
              r'KycFile',
              'submittedAt',
            ),
            documentsCount: BuiltValueNullFieldError.checkNotNull(
              documentsCount,
              r'KycFile',
              'documentsCount',
            ),
            documents: documents.build(),
            rejectionReason: rejectionReason,
            history: history.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'maskedIdentifiers';
        _maskedIdentifiers?.build();
        _$failedField = 'identifiers';
        _identifiers?.build();
        _$failedField = 'pieces';
        _pieces?.build();

        _$failedField = 'documents';
        documents.build();

        _$failedField = 'history';
        history.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'KycFile',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
