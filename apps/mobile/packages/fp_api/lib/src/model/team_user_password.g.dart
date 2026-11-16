// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_user_password.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TeamUserPassword extends TeamUserPassword {
  @override
  final TeamUser user;
  @override
  final TemporaryCredentials credentials;

  factory _$TeamUserPassword([
    void Function(TeamUserPasswordBuilder)? updates,
  ]) => (TeamUserPasswordBuilder()..update(updates))._build();

  _$TeamUserPassword._({required this.user, required this.credentials})
    : super._();
  @override
  TeamUserPassword rebuild(void Function(TeamUserPasswordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TeamUserPasswordBuilder toBuilder() =>
      TeamUserPasswordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeamUserPassword &&
        user == other.user &&
        credentials == other.credentials;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, credentials.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TeamUserPassword')
          ..add('user', user)
          ..add('credentials', credentials))
        .toString();
  }
}

class TeamUserPasswordBuilder
    implements Builder<TeamUserPassword, TeamUserPasswordBuilder> {
  _$TeamUserPassword? _$v;

  TeamUserBuilder? _user;
  TeamUserBuilder get user => _$this._user ??= TeamUserBuilder();
  set user(TeamUserBuilder? user) => _$this._user = user;

  TemporaryCredentialsBuilder? _credentials;
  TemporaryCredentialsBuilder get credentials =>
      _$this._credentials ??= TemporaryCredentialsBuilder();
  set credentials(TemporaryCredentialsBuilder? credentials) =>
      _$this._credentials = credentials;

  TeamUserPasswordBuilder() {
    TeamUserPassword._defaults(this);
  }

  TeamUserPasswordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user.toBuilder();
      _credentials = $v.credentials.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeamUserPassword other) {
    _$v = other as _$TeamUserPassword;
  }

  @override
  void update(void Function(TeamUserPasswordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TeamUserPassword build() => _build();

  _$TeamUserPassword _build() {
    _$TeamUserPassword _$result;
    try {
      _$result =
          _$v ??
          _$TeamUserPassword._(
            user: user.build(),
            credentials: credentials.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
        _$failedField = 'credentials';
        credentials.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'TeamUserPassword',
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
