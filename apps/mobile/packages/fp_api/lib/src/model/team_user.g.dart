// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TeamUser extends TeamUser {
  @override
  final String id;
  @override
  final String displayName;
  @override
  final String email;
  @override
  final SubRole? subRole;
  @override
  final UserStatus status;
  @override
  final DateTime createdAt;

  factory _$TeamUser([void Function(TeamUserBuilder)? updates]) =>
      (TeamUserBuilder()..update(updates))._build();

  _$TeamUser._({
    required this.id,
    required this.displayName,
    required this.email,
    this.subRole,
    required this.status,
    required this.createdAt,
  }) : super._();
  @override
  TeamUser rebuild(void Function(TeamUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TeamUserBuilder toBuilder() => TeamUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeamUser &&
        id == other.id &&
        displayName == other.displayName &&
        email == other.email &&
        subRole == other.subRole &&
        status == other.status &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, subRole.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TeamUser')
          ..add('id', id)
          ..add('displayName', displayName)
          ..add('email', email)
          ..add('subRole', subRole)
          ..add('status', status)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class TeamUserBuilder implements Builder<TeamUser, TeamUserBuilder> {
  _$TeamUser? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  SubRole? _subRole;
  SubRole? get subRole => _$this._subRole;
  set subRole(SubRole? subRole) => _$this._subRole = subRole;

  UserStatus? _status;
  UserStatus? get status => _$this._status;
  set status(UserStatus? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  TeamUserBuilder() {
    TeamUser._defaults(this);
  }

  TeamUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _displayName = $v.displayName;
      _email = $v.email;
      _subRole = $v.subRole;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeamUser other) {
    _$v = other as _$TeamUser;
  }

  @override
  void update(void Function(TeamUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TeamUser build() => _build();

  _$TeamUser _build() {
    final _$result =
        _$v ??
        _$TeamUser._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'TeamUser', 'id'),
          displayName: BuiltValueNullFieldError.checkNotNull(
            displayName,
            r'TeamUser',
            'displayName',
          ),
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'TeamUser',
            'email',
          ),
          subRole: subRole,
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'TeamUser',
            'status',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'TeamUser',
            'createdAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
