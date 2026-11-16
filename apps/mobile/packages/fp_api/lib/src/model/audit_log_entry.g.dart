// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuditLogEntry extends AuditLogEntry {
  @override
  final String id;
  @override
  final DateTime occurredAt;
  @override
  final String actorName;
  @override
  final String action;
  @override
  final String target;

  factory _$AuditLogEntry([void Function(AuditLogEntryBuilder)? updates]) =>
      (AuditLogEntryBuilder()..update(updates))._build();

  _$AuditLogEntry._({
    required this.id,
    required this.occurredAt,
    required this.actorName,
    required this.action,
    required this.target,
  }) : super._();
  @override
  AuditLogEntry rebuild(void Function(AuditLogEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuditLogEntryBuilder toBuilder() => AuditLogEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuditLogEntry &&
        id == other.id &&
        occurredAt == other.occurredAt &&
        actorName == other.actorName &&
        action == other.action &&
        target == other.target;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, target.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuditLogEntry')
          ..add('id', id)
          ..add('occurredAt', occurredAt)
          ..add('actorName', actorName)
          ..add('action', action)
          ..add('target', target))
        .toString();
  }
}

class AuditLogEntryBuilder
    implements Builder<AuditLogEntry, AuditLogEntryBuilder> {
  _$AuditLogEntry? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  String? _target;
  String? get target => _$this._target;
  set target(String? target) => _$this._target = target;

  AuditLogEntryBuilder() {
    AuditLogEntry._defaults(this);
  }

  AuditLogEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _occurredAt = $v.occurredAt;
      _actorName = $v.actorName;
      _action = $v.action;
      _target = $v.target;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuditLogEntry other) {
    _$v = other as _$AuditLogEntry;
  }

  @override
  void update(void Function(AuditLogEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuditLogEntry build() => _build();

  _$AuditLogEntry _build() {
    final _$result =
        _$v ??
        _$AuditLogEntry._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'AuditLogEntry', 'id'),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
            occurredAt,
            r'AuditLogEntry',
            'occurredAt',
          ),
          actorName: BuiltValueNullFieldError.checkNotNull(
            actorName,
            r'AuditLogEntry',
            'actorName',
          ),
          action: BuiltValueNullFieldError.checkNotNull(
            action,
            r'AuditLogEntry',
            'action',
          ),
          target: BuiltValueNullFieldError.checkNotNull(
            target,
            r'AuditLogEntry',
            'target',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
