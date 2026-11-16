// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_kyc_file.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MyKycFile extends MyKycFile {
  @override
  final String id;
  @override
  final KycStatus status;
  @override
  final String? rejectionReason;
  @override
  final BuiltList<KycPiece> documents;

  factory _$MyKycFile([void Function(MyKycFileBuilder)? updates]) =>
      (MyKycFileBuilder()..update(updates))._build();

  _$MyKycFile._({
    required this.id,
    required this.status,
    this.rejectionReason,
    required this.documents,
  }) : super._();
  @override
  MyKycFile rebuild(void Function(MyKycFileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MyKycFileBuilder toBuilder() => MyKycFileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MyKycFile &&
        id == other.id &&
        status == other.status &&
        rejectionReason == other.rejectionReason &&
        documents == other.documents;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, rejectionReason.hashCode);
    _$hash = $jc(_$hash, documents.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MyKycFile')
          ..add('id', id)
          ..add('status', status)
          ..add('rejectionReason', rejectionReason)
          ..add('documents', documents))
        .toString();
  }
}

class MyKycFileBuilder implements Builder<MyKycFile, MyKycFileBuilder> {
  _$MyKycFile? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  KycStatus? _status;
  KycStatus? get status => _$this._status;
  set status(KycStatus? status) => _$this._status = status;

  String? _rejectionReason;
  String? get rejectionReason => _$this._rejectionReason;
  set rejectionReason(String? rejectionReason) =>
      _$this._rejectionReason = rejectionReason;

  ListBuilder<KycPiece>? _documents;
  ListBuilder<KycPiece> get documents =>
      _$this._documents ??= ListBuilder<KycPiece>();
  set documents(ListBuilder<KycPiece>? documents) =>
      _$this._documents = documents;

  MyKycFileBuilder() {
    MyKycFile._defaults(this);
  }

  MyKycFileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _rejectionReason = $v.rejectionReason;
      _documents = $v.documents.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MyKycFile other) {
    _$v = other as _$MyKycFile;
  }

  @override
  void update(void Function(MyKycFileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MyKycFile build() => _build();

  _$MyKycFile _build() {
    _$MyKycFile _$result;
    try {
      _$result =
          _$v ??
          _$MyKycFile._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'MyKycFile', 'id'),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'MyKycFile',
              'status',
            ),
            rejectionReason: rejectionReason,
            documents: documents.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'documents';
        documents.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MyKycFile',
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
