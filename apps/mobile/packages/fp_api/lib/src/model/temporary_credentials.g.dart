// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temporary_credentials.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TemporaryCredentials extends TemporaryCredentials {
  @override
  final String email;
  @override
  final String temporaryPassword;

  factory _$TemporaryCredentials([
    void Function(TemporaryCredentialsBuilder)? updates,
  ]) => (TemporaryCredentialsBuilder()..update(updates))._build();

  _$TemporaryCredentials._({
    required this.email,
    required this.temporaryPassword,
  }) : super._();
  @override
  TemporaryCredentials rebuild(
    void Function(TemporaryCredentialsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  TemporaryCredentialsBuilder toBuilder() =>
      TemporaryCredentialsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TemporaryCredentials &&
        email == other.email &&
        temporaryPassword == other.temporaryPassword;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, temporaryPassword.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TemporaryCredentials')
          ..add('email', email)
          ..add('temporaryPassword', temporaryPassword))
        .toString();
  }
}

class TemporaryCredentialsBuilder
    implements Builder<TemporaryCredentials, TemporaryCredentialsBuilder> {
  _$TemporaryCredentials? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _temporaryPassword;
  String? get temporaryPassword => _$this._temporaryPassword;
  set temporaryPassword(String? temporaryPassword) =>
      _$this._temporaryPassword = temporaryPassword;

  TemporaryCredentialsBuilder() {
    TemporaryCredentials._defaults(this);
  }

  TemporaryCredentialsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _temporaryPassword = $v.temporaryPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TemporaryCredentials other) {
    _$v = other as _$TemporaryCredentials;
  }

  @override
  void update(void Function(TemporaryCredentialsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TemporaryCredentials build() => _build();

  _$TemporaryCredentials _build() {
    final _$result =
        _$v ??
        _$TemporaryCredentials._(
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'TemporaryCredentials',
            'email',
          ),
          temporaryPassword: BuiltValueNullFieldError.checkNotNull(
            temporaryPassword,
            r'TemporaryCredentials',
            'temporaryPassword',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
