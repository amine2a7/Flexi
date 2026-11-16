// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_user_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TeamUserCreate extends TeamUserCreate {
  @override
  final String displayName;
  @override
  final String email;
  @override
  final TeamSubRole subRole;

  factory _$TeamUserCreate([void Function(TeamUserCreateBuilder)? updates]) =>
      (TeamUserCreateBuilder()..update(updates))._build();

  _$TeamUserCreate._({
    required this.displayName,
    required this.email,
    required this.subRole,
  }) : super._();
  @override
  TeamUserCreate rebuild(void Function(TeamUserCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TeamUserCreateBuilder toBuilder() => TeamUserCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeamUserCreate &&
        displayName == other.displayName &&
        email == other.email &&
        subRole == other.subRole;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, subRole.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TeamUserCreate')
          ..add('displayName', displayName)
          ..add('email', email)
          ..add('subRole', subRole))
        .toString();
  }
}

class TeamUserCreateBuilder
    implements Builder<TeamUserCreate, TeamUserCreateBuilder> {
  _$TeamUserCreate? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  TeamSubRole? _subRole;
  TeamSubRole? get subRole => _$this._subRole;
  set subRole(TeamSubRole? subRole) => _$this._subRole = subRole;

  TeamUserCreateBuilder() {
    TeamUserCreate._defaults(this);
  }

  TeamUserCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _email = $v.email;
      _subRole = $v.subRole;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeamUserCreate other) {
    _$v = other as _$TeamUserCreate;
  }

  @override
  void update(void Function(TeamUserCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TeamUserCreate build() => _build();

  _$TeamUserCreate _build() {
    final _$result =
        _$v ??
        _$TeamUserCreate._(
          displayName: BuiltValueNullFieldError.checkNotNull(
            displayName,
            r'TeamUserCreate',
            'displayName',
          ),
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'TeamUserCreate',
            'email',
          ),
          subRole: BuiltValueNullFieldError.checkNotNull(
            subRole,
            r'TeamUserCreate',
            'subRole',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
