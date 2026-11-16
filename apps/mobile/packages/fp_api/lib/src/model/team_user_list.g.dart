// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_user_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TeamUserList extends TeamUserList {
  @override
  final BuiltList<TeamUser> data;

  factory _$TeamUserList([void Function(TeamUserListBuilder)? updates]) =>
      (TeamUserListBuilder()..update(updates))._build();

  _$TeamUserList._({required this.data}) : super._();
  @override
  TeamUserList rebuild(void Function(TeamUserListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TeamUserListBuilder toBuilder() => TeamUserListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeamUserList && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'TeamUserList',
    )..add('data', data)).toString();
  }
}

class TeamUserListBuilder
    implements Builder<TeamUserList, TeamUserListBuilder> {
  _$TeamUserList? _$v;

  ListBuilder<TeamUser>? _data;
  ListBuilder<TeamUser> get data => _$this._data ??= ListBuilder<TeamUser>();
  set data(ListBuilder<TeamUser>? data) => _$this._data = data;

  TeamUserListBuilder() {
    TeamUserList._defaults(this);
  }

  TeamUserListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeamUserList other) {
    _$v = other as _$TeamUserList;
  }

  @override
  void update(void Function(TeamUserListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TeamUserList build() => _build();

  _$TeamUserList _build() {
    _$TeamUserList _$result;
    try {
      _$result = _$v ?? _$TeamUserList._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'TeamUserList',
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
