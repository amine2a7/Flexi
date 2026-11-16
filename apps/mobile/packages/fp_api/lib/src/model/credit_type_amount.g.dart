// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_type_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreditTypeAmount extends CreditTypeAmount {
  @override
  final CreditType creditType;
  @override
  final int amountMillimes;

  factory _$CreditTypeAmount([
    void Function(CreditTypeAmountBuilder)? updates,
  ]) => (CreditTypeAmountBuilder()..update(updates))._build();

  _$CreditTypeAmount._({required this.creditType, required this.amountMillimes})
    : super._();
  @override
  CreditTypeAmount rebuild(void Function(CreditTypeAmountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreditTypeAmountBuilder toBuilder() =>
      CreditTypeAmountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreditTypeAmount &&
        creditType == other.creditType &&
        amountMillimes == other.amountMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreditTypeAmount')
          ..add('creditType', creditType)
          ..add('amountMillimes', amountMillimes))
        .toString();
  }
}

class CreditTypeAmountBuilder
    implements Builder<CreditTypeAmount, CreditTypeAmountBuilder> {
  _$CreditTypeAmount? _$v;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  CreditTypeAmountBuilder() {
    CreditTypeAmount._defaults(this);
  }

  CreditTypeAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _creditType = $v.creditType;
      _amountMillimes = $v.amountMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreditTypeAmount other) {
    _$v = other as _$CreditTypeAmount;
  }

  @override
  void update(void Function(CreditTypeAmountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreditTypeAmount build() => _build();

  _$CreditTypeAmount _build() {
    final _$result =
        _$v ??
        _$CreditTypeAmount._(
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'CreditTypeAmount',
            'creditType',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'CreditTypeAmount',
            'amountMillimes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
