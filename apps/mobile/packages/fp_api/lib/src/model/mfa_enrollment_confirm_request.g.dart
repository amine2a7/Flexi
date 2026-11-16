// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_enrollment_confirm_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaEnrollmentConfirmRequest extends MfaEnrollmentConfirmRequest {
  @override
  final String code;

  factory _$MfaEnrollmentConfirmRequest([
    void Function(MfaEnrollmentConfirmRequestBuilder)? updates,
  ]) => (MfaEnrollmentConfirmRequestBuilder()..update(updates))._build();

  _$MfaEnrollmentConfirmRequest._({required this.code}) : super._();
  @override
  MfaEnrollmentConfirmRequest rebuild(
    void Function(MfaEnrollmentConfirmRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MfaEnrollmentConfirmRequestBuilder toBuilder() =>
      MfaEnrollmentConfirmRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaEnrollmentConfirmRequest && code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MfaEnrollmentConfirmRequest',
    )..add('code', code)).toString();
  }
}

class MfaEnrollmentConfirmRequestBuilder
    implements
        Builder<
          MfaEnrollmentConfirmRequest,
          MfaEnrollmentConfirmRequestBuilder
        > {
  _$MfaEnrollmentConfirmRequest? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  MfaEnrollmentConfirmRequestBuilder() {
    MfaEnrollmentConfirmRequest._defaults(this);
  }

  MfaEnrollmentConfirmRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaEnrollmentConfirmRequest other) {
    _$v = other as _$MfaEnrollmentConfirmRequest;
  }

  @override
  void update(void Function(MfaEnrollmentConfirmRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaEnrollmentConfirmRequest build() => _build();

  _$MfaEnrollmentConfirmRequest _build() {
    final _$result =
        _$v ??
        _$MfaEnrollmentConfirmRequest._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'MfaEnrollmentConfirmRequest',
            'code',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
