// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_status_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserStatusChange extends UserStatusChange {
  @override
  final String reason;

  factory _$UserStatusChange([
    void Function(UserStatusChangeBuilder)? updates,
  ]) => (UserStatusChangeBuilder()..update(updates))._build();

  _$UserStatusChange._({required this.reason}) : super._();
  @override
  UserStatusChange rebuild(void Function(UserStatusChangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStatusChangeBuilder toBuilder() =>
      UserStatusChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserStatusChange && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'UserStatusChange',
    )..add('reason', reason)).toString();
  }
}

class UserStatusChangeBuilder
    implements Builder<UserStatusChange, UserStatusChangeBuilder> {
  _$UserStatusChange? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  UserStatusChangeBuilder() {
    UserStatusChange._defaults(this);
  }

  UserStatusChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserStatusChange other) {
    _$v = other as _$UserStatusChange;
  }

  @override
  void update(void Function(UserStatusChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserStatusChange build() => _build();

  _$UserStatusChange _build() {
    final _$result =
        _$v ??
        _$UserStatusChange._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'UserStatusChange',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
