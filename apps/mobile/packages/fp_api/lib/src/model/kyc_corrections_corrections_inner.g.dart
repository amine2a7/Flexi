// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_corrections_corrections_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$KycCorrectionsCorrectionsInner extends KycCorrectionsCorrectionsInner {
  @override
  final String documentId;
  @override
  final String reason;

  factory _$KycCorrectionsCorrectionsInner([
    void Function(KycCorrectionsCorrectionsInnerBuilder)? updates,
  ]) => (KycCorrectionsCorrectionsInnerBuilder()..update(updates))._build();

  _$KycCorrectionsCorrectionsInner._({
    required this.documentId,
    required this.reason,
  }) : super._();
  @override
  KycCorrectionsCorrectionsInner rebuild(
    void Function(KycCorrectionsCorrectionsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  KycCorrectionsCorrectionsInnerBuilder toBuilder() =>
      KycCorrectionsCorrectionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KycCorrectionsCorrectionsInner &&
        documentId == other.documentId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, documentId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'KycCorrectionsCorrectionsInner')
          ..add('documentId', documentId)
          ..add('reason', reason))
        .toString();
  }
}

class KycCorrectionsCorrectionsInnerBuilder
    implements
        Builder<
          KycCorrectionsCorrectionsInner,
          KycCorrectionsCorrectionsInnerBuilder
        > {
  _$KycCorrectionsCorrectionsInner? _$v;

  String? _documentId;
  String? get documentId => _$this._documentId;
  set documentId(String? documentId) => _$this._documentId = documentId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  KycCorrectionsCorrectionsInnerBuilder() {
    KycCorrectionsCorrectionsInner._defaults(this);
  }

  KycCorrectionsCorrectionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _documentId = $v.documentId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KycCorrectionsCorrectionsInner other) {
    _$v = other as _$KycCorrectionsCorrectionsInner;
  }

  @override
  void update(void Function(KycCorrectionsCorrectionsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KycCorrectionsCorrectionsInner build() => _build();

  _$KycCorrectionsCorrectionsInner _build() {
    final _$result =
        _$v ??
        _$KycCorrectionsCorrectionsInner._(
          documentId: BuiltValueNullFieldError.checkNotNull(
            documentId,
            r'KycCorrectionsCorrectionsInner',
            'documentId',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'KycCorrectionsCorrectionsInner',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
