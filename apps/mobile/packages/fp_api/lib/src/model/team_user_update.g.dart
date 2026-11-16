// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_user_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TeamUserUpdate extends TeamUserUpdate {
  @override
  final String? displayName;
  @override
  final TeamSubRole? subRole;

  factory _$TeamUserUpdate([void Function(TeamUserUpdateBuilder)? updates]) =>
      (TeamUserUpdateBuilder()..update(updates))._build();

  _$TeamUserUpdate._({this.displayName, this.subRole}) : super._();
  @override
  TeamUserUpdate rebuild(void Function(TeamUserUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TeamUserUpdateBuilder toBuilder() => TeamUserUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeamUserUpdate &&
        displayName == other.displayName &&
        subRole == other.subRole;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, subRole.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TeamUserUpdate')
          ..add('displayName', displayName)
          ..add('subRole', subRole))
        .toString();
  }
}

class TeamUserUpdateBuilder
    implements Builder<TeamUserUpdate, TeamUserUpdateBuilder> {
  _$TeamUserUpdate? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  TeamSubRole? _subRole;
  TeamSubRole? get subRole => _$this._subRole;
  set subRole(TeamSubRole? subRole) => _$this._subRole = subRole;

  TeamUserUpdateBuilder() {
    TeamUserUpdate._defaults(this);
  }

  TeamUserUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _subRole = $v.subRole;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeamUserUpdate other) {
    _$v = other as _$TeamUserUpdate;
  }

  @override
  void update(void Function(TeamUserUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TeamUserUpdate build() => _build();

  _$TeamUserUpdate _build() {
    final _$result =
        _$v ?? _$TeamUserUpdate._(displayName: displayName, subRole: subRole);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
