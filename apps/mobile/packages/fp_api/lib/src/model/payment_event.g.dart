// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentEvent extends PaymentEvent {
  @override
  final PaymentStatus status;
  @override
  final DateTime occurredAt;

  factory _$PaymentEvent([void Function(PaymentEventBuilder)? updates]) =>
      (PaymentEventBuilder()..update(updates))._build();

  _$PaymentEvent._({required this.status, required this.occurredAt})
    : super._();
  @override
  PaymentEvent rebuild(void Function(PaymentEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentEventBuilder toBuilder() => PaymentEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentEvent &&
        status == other.status &&
        occurredAt == other.occurredAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentEvent')
          ..add('status', status)
          ..add('occurredAt', occurredAt))
        .toString();
  }
}

class PaymentEventBuilder
    implements Builder<PaymentEvent, PaymentEventBuilder> {
  _$PaymentEvent? _$v;

  PaymentStatus? _status;
  PaymentStatus? get status => _$this._status;
  set status(PaymentStatus? status) => _$this._status = status;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  PaymentEventBuilder() {
    PaymentEvent._defaults(this);
  }

  PaymentEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _occurredAt = $v.occurredAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentEvent other) {
    _$v = other as _$PaymentEvent;
  }

  @override
  void update(void Function(PaymentEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentEvent build() => _build();

  _$PaymentEvent _build() {
    final _$result =
        _$v ??
        _$PaymentEvent._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'PaymentEvent',
            'status',
          ),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
            occurredAt,
            r'PaymentEvent',
            'occurredAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
