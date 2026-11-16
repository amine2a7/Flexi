// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_kyc.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OverviewKyc extends OverviewKyc {
  @override
  final String fileId;
  @override
  final KycStatus status;

  factory _$OverviewKyc([void Function(OverviewKycBuilder)? updates]) =>
      (OverviewKycBuilder()..update(updates))._build();

  _$OverviewKyc._({required this.fileId, required this.status}) : super._();
  @override
  OverviewKyc rebuild(void Function(OverviewKycBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OverviewKycBuilder toBuilder() => OverviewKycBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OverviewKyc &&
        fileId == other.fileId &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fileId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OverviewKyc')
          ..add('fileId', fileId)
          ..add('status', status))
        .toString();
  }
}

class OverviewKycBuilder implements Builder<OverviewKyc, OverviewKycBuilder> {
  _$OverviewKyc? _$v;

  String? _fileId;
  String? get fileId => _$this._fileId;
  set fileId(String? fileId) => _$this._fileId = fileId;

  KycStatus? _status;
  KycStatus? get status => _$this._status;
  set status(KycStatus? status) => _$this._status = status;

  OverviewKycBuilder() {
    OverviewKyc._defaults(this);
  }

  OverviewKycBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fileId = $v.fileId;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OverviewKyc other) {
    _$v = other as _$OverviewKyc;
  }

  @override
  void update(void Function(OverviewKycBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OverviewKyc build() => _build();

  _$OverviewKyc _build() {
    final _$result =
        _$v ??
        _$OverviewKyc._(
          fileId: BuiltValueNullFieldError.checkNotNull(
            fileId,
            r'OverviewKyc',
            'fileId',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'OverviewKyc',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
