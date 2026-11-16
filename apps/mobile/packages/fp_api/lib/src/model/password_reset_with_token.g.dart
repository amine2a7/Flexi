// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_reset_with_token.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PasswordResetWithToken extends PasswordResetWithToken {
  @override
  final String token;
  @override
  final String newPassword;

  factory _$PasswordResetWithToken([
    void Function(PasswordResetWithTokenBuilder)? updates,
  ]) => (PasswordResetWithTokenBuilder()..update(updates))._build();

  _$PasswordResetWithToken._({required this.token, required this.newPassword})
    : super._();
  @override
  PasswordResetWithToken rebuild(
    void Function(PasswordResetWithTokenBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PasswordResetWithTokenBuilder toBuilder() =>
      PasswordResetWithTokenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PasswordResetWithToken &&
        token == other.token &&
        newPassword == other.newPassword;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, newPassword.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PasswordResetWithToken')
          ..add('token', token)
          ..add('newPassword', newPassword))
        .toString();
  }
}

class PasswordResetWithTokenBuilder
    implements Builder<PasswordResetWithToken, PasswordResetWithTokenBuilder> {
  _$PasswordResetWithToken? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _newPassword;
  String? get newPassword => _$this._newPassword;
  set newPassword(String? newPassword) => _$this._newPassword = newPassword;

  PasswordResetWithTokenBuilder() {
    PasswordResetWithToken._defaults(this);
  }

  PasswordResetWithTokenBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _newPassword = $v.newPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PasswordResetWithToken other) {
    _$v = other as _$PasswordResetWithToken;
  }

  @override
  void update(void Function(PasswordResetWithTokenBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PasswordResetWithToken build() => _build();

  _$PasswordResetWithToken _build() {
    final _$result =
        _$v ??
        _$PasswordResetWithToken._(
          token: BuiltValueNullFieldError.checkNotNull(
            token,
            r'PasswordResetWithToken',
            'token',
          ),
          newPassword: BuiltValueNullFieldError.checkNotNull(
            newPassword,
            r'PasswordResetWithToken',
            'newPassword',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
