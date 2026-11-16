// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutEvent extends PayoutEvent {
  @override
  final PayoutRequestStatus status;
  @override
  final DateTime occurredAt;
  @override
  final String? reasonKey;
  @override
  final String? reason;

  factory _$PayoutEvent([void Function(PayoutEventBuilder)? updates]) =>
      (PayoutEventBuilder()..update(updates))._build();

  _$PayoutEvent._({
    required this.status,
    required this.occurredAt,
    this.reasonKey,
    this.reason,
  }) : super._();
  @override
  PayoutEvent rebuild(void Function(PayoutEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PayoutEventBuilder toBuilder() => PayoutEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutEvent &&
        status == other.status &&
        occurredAt == other.occurredAt &&
        reasonKey == other.reasonKey &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, reasonKey.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PayoutEvent')
          ..add('status', status)
          ..add('occurredAt', occurredAt)
          ..add('reasonKey', reasonKey)
          ..add('reason', reason))
        .toString();
  }
}

class PayoutEventBuilder implements Builder<PayoutEvent, PayoutEventBuilder> {
  _$PayoutEvent? _$v;

  PayoutRequestStatus? _status;
  PayoutRequestStatus? get status => _$this._status;
  set status(PayoutRequestStatus? status) => _$this._status = status;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  String? _reasonKey;
  String? get reasonKey => _$this._reasonKey;
  set reasonKey(String? reasonKey) => _$this._reasonKey = reasonKey;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  PayoutEventBuilder() {
    PayoutEvent._defaults(this);
  }

  PayoutEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _occurredAt = $v.occurredAt;
      _reasonKey = $v.reasonKey;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutEvent other) {
    _$v = other as _$PayoutEvent;
  }

  @override
  void update(void Function(PayoutEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutEvent build() => _build();

  _$PayoutEvent _build() {
    final _$result =
        _$v ??
        _$PayoutEvent._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'PayoutEvent',
            'status',
          ),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
            occurredAt,
            r'PayoutEvent',
            'occurredAt',
          ),
          reasonKey: reasonKey,
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
