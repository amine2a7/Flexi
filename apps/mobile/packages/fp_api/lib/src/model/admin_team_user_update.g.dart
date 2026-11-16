// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_team_user_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTeamUserUpdate extends AdminTeamUserUpdate {
  @override
  final String? displayName;
  @override
  final TeamSubRole? subRole;
  @override
  final String reason;

  factory _$AdminTeamUserUpdate([
    void Function(AdminTeamUserUpdateBuilder)? updates,
  ]) => (AdminTeamUserUpdateBuilder()..update(updates))._build();

  _$AdminTeamUserUpdate._({
    this.displayName,
    this.subRole,
    required this.reason,
  }) : super._();
  @override
  AdminTeamUserUpdate rebuild(
    void Function(AdminTeamUserUpdateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTeamUserUpdateBuilder toBuilder() =>
      AdminTeamUserUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTeamUserUpdate &&
        displayName == other.displayName &&
        subRole == other.subRole &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, subRole.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTeamUserUpdate')
          ..add('displayName', displayName)
          ..add('subRole', subRole)
          ..add('reason', reason))
        .toString();
  }
}

class AdminTeamUserUpdateBuilder
    implements Builder<AdminTeamUserUpdate, AdminTeamUserUpdateBuilder> {
  _$AdminTeamUserUpdate? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  TeamSubRole? _subRole;
  TeamSubRole? get subRole => _$this._subRole;
  set subRole(TeamSubRole? subRole) => _$this._subRole = subRole;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminTeamUserUpdateBuilder() {
    AdminTeamUserUpdate._defaults(this);
  }

  AdminTeamUserUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _subRole = $v.subRole;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTeamUserUpdate other) {
    _$v = other as _$AdminTeamUserUpdate;
  }

  @override
  void update(void Function(AdminTeamUserUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTeamUserUpdate build() => _build();

  _$AdminTeamUserUpdate _build() {
    final _$result =
        _$v ??
        _$AdminTeamUserUpdate._(
          displayName: displayName,
          subRole: subRole,
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminTeamUserUpdate',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
