// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_user_created.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TeamUserCreated extends TeamUserCreated {
  @override
  final TemporaryCredentials credentials;

  factory _$TeamUserCreated([void Function(TeamUserCreatedBuilder)? updates]) =>
      (TeamUserCreatedBuilder()..update(updates))._build();

  _$TeamUserCreated._({required this.credentials}) : super._();
  @override
  TeamUserCreated rebuild(void Function(TeamUserCreatedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TeamUserCreatedBuilder toBuilder() => TeamUserCreatedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeamUserCreated && credentials == other.credentials;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, credentials.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'TeamUserCreated',
    )..add('credentials', credentials)).toString();
  }
}

class TeamUserCreatedBuilder
    implements Builder<TeamUserCreated, TeamUserCreatedBuilder> {
  _$TeamUserCreated? _$v;

  TemporaryCredentialsBuilder? _credentials;
  TemporaryCredentialsBuilder get credentials =>
      _$this._credentials ??= TemporaryCredentialsBuilder();
  set credentials(TemporaryCredentialsBuilder? credentials) =>
      _$this._credentials = credentials;

  TeamUserCreatedBuilder() {
    TeamUserCreated._defaults(this);
  }

  TeamUserCreatedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _credentials = $v.credentials.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeamUserCreated other) {
    _$v = other as _$TeamUserCreated;
  }

  @override
  void update(void Function(TeamUserCreatedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TeamUserCreated build() => _build();

  _$TeamUserCreated _build() {
    _$TeamUserCreated _$result;
    try {
      _$result = _$v ?? _$TeamUserCreated._(credentials: credentials.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'credentials';
        credentials.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'TeamUserCreated',
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
