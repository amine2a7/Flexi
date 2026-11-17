// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_refused_problem_all_of_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckoutRefusedProblemAllOfDetails
    extends CheckoutRefusedProblemAllOfDetails {
  @override
  final CheckoutRefusalReason reason;

  factory _$CheckoutRefusedProblemAllOfDetails([
    void Function(CheckoutRefusedProblemAllOfDetailsBuilder)? updates,
  ]) => (CheckoutRefusedProblemAllOfDetailsBuilder()..update(updates))._build();

  _$CheckoutRefusedProblemAllOfDetails._({required this.reason}) : super._();
  @override
  CheckoutRefusedProblemAllOfDetails rebuild(
    void Function(CheckoutRefusedProblemAllOfDetailsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CheckoutRefusedProblemAllOfDetailsBuilder toBuilder() =>
      CheckoutRefusedProblemAllOfDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutRefusedProblemAllOfDetails &&
        reason == other.reason;
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
      r'CheckoutRefusedProblemAllOfDetails',
    )..add('reason', reason)).toString();
  }
}

class CheckoutRefusedProblemAllOfDetailsBuilder
    implements
        Builder<
          CheckoutRefusedProblemAllOfDetails,
          CheckoutRefusedProblemAllOfDetailsBuilder
        > {
  _$CheckoutRefusedProblemAllOfDetails? _$v;

  CheckoutRefusalReason? _reason;
  CheckoutRefusalReason? get reason => _$this._reason;
  set reason(CheckoutRefusalReason? reason) => _$this._reason = reason;

  CheckoutRefusedProblemAllOfDetailsBuilder() {
    CheckoutRefusedProblemAllOfDetails._defaults(this);
  }

  CheckoutRefusedProblemAllOfDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutRefusedProblemAllOfDetails other) {
    _$v = other as _$CheckoutRefusedProblemAllOfDetails;
  }

  @override
  void update(
    void Function(CheckoutRefusedProblemAllOfDetailsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutRefusedProblemAllOfDetails build() => _build();

  _$CheckoutRefusedProblemAllOfDetails _build() {
    final _$result =
        _$v ??
        _$CheckoutRefusedProblemAllOfDetails._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CheckoutRefusedProblemAllOfDetails',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
