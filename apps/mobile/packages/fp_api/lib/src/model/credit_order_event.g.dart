// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_order_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreditOrderEvent extends CreditOrderEvent {
  @override
  final CreditOrderEventAction action;
  @override
  final DateTime occurredAt;
  @override
  final String actorName;
  @override
  final Role actorRole;
  @override
  final String? reason;

  factory _$CreditOrderEvent([
    void Function(CreditOrderEventBuilder)? updates,
  ]) => (CreditOrderEventBuilder()..update(updates))._build();

  _$CreditOrderEvent._({
    required this.action,
    required this.occurredAt,
    required this.actorName,
    required this.actorRole,
    this.reason,
  }) : super._();
  @override
  CreditOrderEvent rebuild(void Function(CreditOrderEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreditOrderEventBuilder toBuilder() =>
      CreditOrderEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreditOrderEvent &&
        action == other.action &&
        occurredAt == other.occurredAt &&
        actorName == other.actorName &&
        actorRole == other.actorRole &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreditOrderEvent')
          ..add('action', action)
          ..add('occurredAt', occurredAt)
          ..add('actorName', actorName)
          ..add('actorRole', actorRole)
          ..add('reason', reason))
        .toString();
  }
}

class CreditOrderEventBuilder
    implements Builder<CreditOrderEvent, CreditOrderEventBuilder> {
  _$CreditOrderEvent? _$v;

  CreditOrderEventAction? _action;
  CreditOrderEventAction? get action => _$this._action;
  set action(CreditOrderEventAction? action) => _$this._action = action;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  Role? _actorRole;
  Role? get actorRole => _$this._actorRole;
  set actorRole(Role? actorRole) => _$this._actorRole = actorRole;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CreditOrderEventBuilder() {
    CreditOrderEvent._defaults(this);
  }

  CreditOrderEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _occurredAt = $v.occurredAt;
      _actorName = $v.actorName;
      _actorRole = $v.actorRole;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreditOrderEvent other) {
    _$v = other as _$CreditOrderEvent;
  }

  @override
  void update(void Function(CreditOrderEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreditOrderEvent build() => _build();

  _$CreditOrderEvent _build() {
    final _$result =
        _$v ??
        _$CreditOrderEvent._(
          action: BuiltValueNullFieldError.checkNotNull(
            action,
            r'CreditOrderEvent',
            'action',
          ),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
            occurredAt,
            r'CreditOrderEvent',
            'occurredAt',
          ),
          actorName: BuiltValueNullFieldError.checkNotNull(
            actorName,
            r'CreditOrderEvent',
            'actorName',
          ),
          actorRole: BuiltValueNullFieldError.checkNotNull(
            actorRole,
            r'CreditOrderEvent',
            'actorRole',
          ),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
