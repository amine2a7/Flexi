// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_form_change_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LegalFormChangeRequest extends LegalFormChangeRequest {
  @override
  final LegalForm legalForm;
  @override
  final String reason;

  factory _$LegalFormChangeRequest([
    void Function(LegalFormChangeRequestBuilder)? updates,
  ]) => (LegalFormChangeRequestBuilder()..update(updates))._build();

  _$LegalFormChangeRequest._({required this.legalForm, required this.reason})
    : super._();
  @override
  LegalFormChangeRequest rebuild(
    void Function(LegalFormChangeRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  LegalFormChangeRequestBuilder toBuilder() =>
      LegalFormChangeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LegalFormChangeRequest &&
        legalForm == other.legalForm &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, legalForm.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LegalFormChangeRequest')
          ..add('legalForm', legalForm)
          ..add('reason', reason))
        .toString();
  }
}

class LegalFormChangeRequestBuilder
    implements Builder<LegalFormChangeRequest, LegalFormChangeRequestBuilder> {
  _$LegalFormChangeRequest? _$v;

  LegalForm? _legalForm;
  LegalForm? get legalForm => _$this._legalForm;
  set legalForm(LegalForm? legalForm) => _$this._legalForm = legalForm;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  LegalFormChangeRequestBuilder() {
    LegalFormChangeRequest._defaults(this);
  }

  LegalFormChangeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _legalForm = $v.legalForm;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LegalFormChangeRequest other) {
    _$v = other as _$LegalFormChangeRequest;
  }

  @override
  void update(void Function(LegalFormChangeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LegalFormChangeRequest build() => _build();

  _$LegalFormChangeRequest _build() {
    final _$result =
        _$v ??
        _$LegalFormChangeRequest._(
          legalForm: BuiltValueNullFieldError.checkNotNull(
            legalForm,
            r'LegalFormChangeRequest',
            'legalForm',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'LegalFormChangeRequest',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
