// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_order_decision_reason.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreditOrderDecisionReason extends CreditOrderDecisionReason {
  @override
  final String reason;

  factory _$CreditOrderDecisionReason([
    void Function(CreditOrderDecisionReasonBuilder)? updates,
  ]) => (CreditOrderDecisionReasonBuilder()..update(updates))._build();

  _$CreditOrderDecisionReason._({required this.reason}) : super._();
  @override
  CreditOrderDecisionReason rebuild(
    void Function(CreditOrderDecisionReasonBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CreditOrderDecisionReasonBuilder toBuilder() =>
      CreditOrderDecisionReasonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreditOrderDecisionReason && reason == other.reason;
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
      r'CreditOrderDecisionReason',
    )..add('reason', reason)).toString();
  }
}

class CreditOrderDecisionReasonBuilder
    implements
        Builder<CreditOrderDecisionReason, CreditOrderDecisionReasonBuilder> {
  _$CreditOrderDecisionReason? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CreditOrderDecisionReasonBuilder() {
    CreditOrderDecisionReason._defaults(this);
  }

  CreditOrderDecisionReasonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreditOrderDecisionReason other) {
    _$v = other as _$CreditOrderDecisionReason;
  }

  @override
  void update(void Function(CreditOrderDecisionReasonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreditOrderDecisionReason build() => _build();

  _$CreditOrderDecisionReason _build() {
    final _$result =
        _$v ??
        _$CreditOrderDecisionReason._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CreditOrderDecisionReason',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
