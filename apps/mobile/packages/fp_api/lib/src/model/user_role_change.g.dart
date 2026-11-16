// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserRoleChange extends UserRoleChange {
  @override
  final SubRole subRole;
  @override
  final String reason;

  factory _$UserRoleChange([void Function(UserRoleChangeBuilder)? updates]) =>
      (UserRoleChangeBuilder()..update(updates))._build();

  _$UserRoleChange._({required this.subRole, required this.reason}) : super._();
  @override
  UserRoleChange rebuild(void Function(UserRoleChangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserRoleChangeBuilder toBuilder() => UserRoleChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserRoleChange &&
        subRole == other.subRole &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subRole.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserRoleChange')
          ..add('subRole', subRole)
          ..add('reason', reason))
        .toString();
  }
}

class UserRoleChangeBuilder
    implements Builder<UserRoleChange, UserRoleChangeBuilder> {
  _$UserRoleChange? _$v;

  SubRole? _subRole;
  SubRole? get subRole => _$this._subRole;
  set subRole(SubRole? subRole) => _$this._subRole = subRole;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  UserRoleChangeBuilder() {
    UserRoleChange._defaults(this);
  }

  UserRoleChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subRole = $v.subRole;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserRoleChange other) {
    _$v = other as _$UserRoleChange;
  }

  @override
  void update(void Function(UserRoleChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserRoleChange build() => _build();

  _$UserRoleChange _build() {
    final _$result =
        _$v ??
        _$UserRoleChange._(
          subRole: BuiltValueNullFieldError.checkNotNull(
            subRole,
            r'UserRoleChange',
            'subRole',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'UserRoleChange',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
