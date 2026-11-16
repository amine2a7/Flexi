// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_open.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeOpen extends DisputeOpen {
  @override
  final String paymentId;
  @override
  final String reason;

  factory _$DisputeOpen([void Function(DisputeOpenBuilder)? updates]) =>
      (DisputeOpenBuilder()..update(updates))._build();

  _$DisputeOpen._({required this.paymentId, required this.reason}) : super._();
  @override
  DisputeOpen rebuild(void Function(DisputeOpenBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeOpenBuilder toBuilder() => DisputeOpenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeOpen &&
        paymentId == other.paymentId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeOpen')
          ..add('paymentId', paymentId)
          ..add('reason', reason))
        .toString();
  }
}

class DisputeOpenBuilder implements Builder<DisputeOpen, DisputeOpenBuilder> {
  _$DisputeOpen? _$v;

  String? _paymentId;
  String? get paymentId => _$this._paymentId;
  set paymentId(String? paymentId) => _$this._paymentId = paymentId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DisputeOpenBuilder() {
    DisputeOpen._defaults(this);
  }

  DisputeOpenBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentId = $v.paymentId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeOpen other) {
    _$v = other as _$DisputeOpen;
  }

  @override
  void update(void Function(DisputeOpenBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeOpen build() => _build();

  _$DisputeOpen _build() {
    final _$result =
        _$v ??
        _$DisputeOpen._(
          paymentId: BuiltValueNullFieldError.checkNotNull(
            paymentId,
            r'DisputeOpen',
            'paymentId',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'DisputeOpen',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
