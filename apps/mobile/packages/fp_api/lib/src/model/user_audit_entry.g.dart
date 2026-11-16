// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_audit_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserAuditEntry extends UserAuditEntry {
  @override
  final DateTime occurredAt;
  @override
  final String actorName;
  @override
  final String action;
  @override
  final String? reason;

  factory _$UserAuditEntry([void Function(UserAuditEntryBuilder)? updates]) =>
      (UserAuditEntryBuilder()..update(updates))._build();

  _$UserAuditEntry._({
    required this.occurredAt,
    required this.actorName,
    required this.action,
    this.reason,
  }) : super._();
  @override
  UserAuditEntry rebuild(void Function(UserAuditEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserAuditEntryBuilder toBuilder() => UserAuditEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserAuditEntry &&
        occurredAt == other.occurredAt &&
        actorName == other.actorName &&
        action == other.action &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserAuditEntry')
          ..add('occurredAt', occurredAt)
          ..add('actorName', actorName)
          ..add('action', action)
          ..add('reason', reason))
        .toString();
  }
}

class UserAuditEntryBuilder
    implements Builder<UserAuditEntry, UserAuditEntryBuilder> {
  _$UserAuditEntry? _$v;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  UserAuditEntryBuilder() {
    UserAuditEntry._defaults(this);
  }

  UserAuditEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _occurredAt = $v.occurredAt;
      _actorName = $v.actorName;
      _action = $v.action;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserAuditEntry other) {
    _$v = other as _$UserAuditEntry;
  }

  @override
  void update(void Function(UserAuditEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserAuditEntry build() => _build();

  _$UserAuditEntry _build() {
    final _$result =
        _$v ??
        _$UserAuditEntry._(
          occurredAt: BuiltValueNullFieldError.checkNotNull(
            occurredAt,
            r'UserAuditEntry',
            'occurredAt',
          ),
          actorName: BuiltValueNullFieldError.checkNotNull(
            actorName,
            r'UserAuditEntry',
            'actorName',
          ),
          action: BuiltValueNullFieldError.checkNotNull(
            action,
            r'UserAuditEntry',
            'action',
          ),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
