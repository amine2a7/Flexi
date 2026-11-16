// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OverviewUser extends OverviewUser {
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

  factory _$OverviewUser([void Function(OverviewUserBuilder)? updates]) =>
      (OverviewUserBuilder()..update(updates))._build();

  _$OverviewUser._({
    required this.id,
    required this.displayName,
    required this.email,
    this.subRole,
    required this.status,
    required this.createdAt,
  }) : super._();
  @override
  OverviewUser rebuild(void Function(OverviewUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OverviewUserBuilder toBuilder() => OverviewUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OverviewUser &&
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
    return (newBuiltValueToStringHelper(r'OverviewUser')
          ..add('id', id)
          ..add('displayName', displayName)
          ..add('email', email)
          ..add('subRole', subRole)
          ..add('status', status)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class OverviewUserBuilder
    implements Builder<OverviewUser, OverviewUserBuilder> {
  _$OverviewUser? _$v;

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

  OverviewUserBuilder() {
    OverviewUser._defaults(this);
  }

  OverviewUserBuilder get _$this {
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
  void replace(OverviewUser other) {
    _$v = other as _$OverviewUser;
  }

  @override
  void update(void Function(OverviewUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OverviewUser build() => _build();

  _$OverviewUser _build() {
    final _$result =
        _$v ??
        _$OverviewUser._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'OverviewUser', 'id'),
          displayName: BuiltValueNullFieldError.checkNotNull(
            displayName,
            r'OverviewUser',
            'displayName',
          ),
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'OverviewUser',
            'email',
          ),
          subRole: subRole,
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'OverviewUser',
            'status',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'OverviewUser',
            'createdAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
