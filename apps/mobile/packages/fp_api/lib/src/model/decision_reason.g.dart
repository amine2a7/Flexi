// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision_reason.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DecisionReason extends DecisionReason {
  @override
  final String reason;

  factory _$DecisionReason([void Function(DecisionReasonBuilder)? updates]) =>
      (DecisionReasonBuilder()..update(updates))._build();

  _$DecisionReason._({required this.reason}) : super._();
  @override
  DecisionReason rebuild(void Function(DecisionReasonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DecisionReasonBuilder toBuilder() => DecisionReasonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DecisionReason && reason == other.reason;
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
      r'DecisionReason',
    )..add('reason', reason)).toString();
  }
}

class DecisionReasonBuilder
    implements Builder<DecisionReason, DecisionReasonBuilder> {
  _$DecisionReason? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DecisionReasonBuilder() {
    DecisionReason._defaults(this);
  }

  DecisionReasonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DecisionReason other) {
    _$v = other as _$DecisionReason;
  }

  @override
  void update(void Function(DecisionReasonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DecisionReason build() => _build();

  _$DecisionReason _build() {
    final _$result =
        _$v ??
        _$DecisionReason._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'DecisionReason',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
