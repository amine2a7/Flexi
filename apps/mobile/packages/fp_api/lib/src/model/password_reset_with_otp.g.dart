// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_reset_with_otp.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PasswordResetWithOtp extends PasswordResetWithOtp {
  @override
  final String identifier;
  @override
  final String otp;
  @override
  final String newPassword;

  factory _$PasswordResetWithOtp([
    void Function(PasswordResetWithOtpBuilder)? updates,
  ]) => (PasswordResetWithOtpBuilder()..update(updates))._build();

  _$PasswordResetWithOtp._({
    required this.identifier,
    required this.otp,
    required this.newPassword,
  }) : super._();
  @override
  PasswordResetWithOtp rebuild(
    void Function(PasswordResetWithOtpBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PasswordResetWithOtpBuilder toBuilder() =>
      PasswordResetWithOtpBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PasswordResetWithOtp &&
        identifier == other.identifier &&
        otp == other.otp &&
        newPassword == other.newPassword;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, identifier.hashCode);
    _$hash = $jc(_$hash, otp.hashCode);
    _$hash = $jc(_$hash, newPassword.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PasswordResetWithOtp')
          ..add('identifier', identifier)
          ..add('otp', otp)
          ..add('newPassword', newPassword))
        .toString();
  }
}

class PasswordResetWithOtpBuilder
    implements Builder<PasswordResetWithOtp, PasswordResetWithOtpBuilder> {
  _$PasswordResetWithOtp? _$v;

  String? _identifier;
  String? get identifier => _$this._identifier;
  set identifier(String? identifier) => _$this._identifier = identifier;

  String? _otp;
  String? get otp => _$this._otp;
  set otp(String? otp) => _$this._otp = otp;

  String? _newPassword;
  String? get newPassword => _$this._newPassword;
  set newPassword(String? newPassword) => _$this._newPassword = newPassword;

  PasswordResetWithOtpBuilder() {
    PasswordResetWithOtp._defaults(this);
  }

  PasswordResetWithOtpBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _identifier = $v.identifier;
      _otp = $v.otp;
      _newPassword = $v.newPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PasswordResetWithOtp other) {
    _$v = other as _$PasswordResetWithOtp;
  }

  @override
  void update(void Function(PasswordResetWithOtpBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PasswordResetWithOtp build() => _build();

  _$PasswordResetWithOtp _build() {
    final _$result =
        _$v ??
        _$PasswordResetWithOtp._(
          identifier: BuiltValueNullFieldError.checkNotNull(
            identifier,
            r'PasswordResetWithOtp',
            'identifier',
          ),
          otp: BuiltValueNullFieldError.checkNotNull(
            otp,
            r'PasswordResetWithOtp',
            'otp',
          ),
          newPassword: BuiltValueNullFieldError.checkNotNull(
            newPassword,
            r'PasswordResetWithOtp',
            'newPassword',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
