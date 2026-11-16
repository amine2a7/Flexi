// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_re_enrollment_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaReEnrollmentRequest extends MfaReEnrollmentRequest {
  @override
  final String? currentPassword;
  @override
  final String? currentCode;

  factory _$MfaReEnrollmentRequest([
    void Function(MfaReEnrollmentRequestBuilder)? updates,
  ]) => (MfaReEnrollmentRequestBuilder()..update(updates))._build();

  _$MfaReEnrollmentRequest._({this.currentPassword, this.currentCode})
    : super._();
  @override
  MfaReEnrollmentRequest rebuild(
    void Function(MfaReEnrollmentRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MfaReEnrollmentRequestBuilder toBuilder() =>
      MfaReEnrollmentRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaReEnrollmentRequest &&
        currentPassword == other.currentPassword &&
        currentCode == other.currentCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPassword.hashCode);
    _$hash = $jc(_$hash, currentCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaReEnrollmentRequest')
          ..add('currentPassword', currentPassword)
          ..add('currentCode', currentCode))
        .toString();
  }
}

class MfaReEnrollmentRequestBuilder
    implements Builder<MfaReEnrollmentRequest, MfaReEnrollmentRequestBuilder> {
  _$MfaReEnrollmentRequest? _$v;

  String? _currentPassword;
  String? get currentPassword => _$this._currentPassword;
  set currentPassword(String? currentPassword) =>
      _$this._currentPassword = currentPassword;

  String? _currentCode;
  String? get currentCode => _$this._currentCode;
  set currentCode(String? currentCode) => _$this._currentCode = currentCode;

  MfaReEnrollmentRequestBuilder() {
    MfaReEnrollmentRequest._defaults(this);
  }

  MfaReEnrollmentRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPassword = $v.currentPassword;
      _currentCode = $v.currentCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaReEnrollmentRequest other) {
    _$v = other as _$MfaReEnrollmentRequest;
  }

  @override
  void update(void Function(MfaReEnrollmentRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaReEnrollmentRequest build() => _build();

  _$MfaReEnrollmentRequest _build() {
    final _$result =
        _$v ??
        _$MfaReEnrollmentRequest._(
          currentPassword: currentPassword,
          currentCode: currentCode,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
