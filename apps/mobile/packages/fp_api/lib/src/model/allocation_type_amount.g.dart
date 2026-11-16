// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_type_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AllocationTypeAmount extends AllocationTypeAmount {
  @override
  final CreditType creditType;
  @override
  final int amountMillimes;

  factory _$AllocationTypeAmount([
    void Function(AllocationTypeAmountBuilder)? updates,
  ]) => (AllocationTypeAmountBuilder()..update(updates))._build();

  _$AllocationTypeAmount._({
    required this.creditType,
    required this.amountMillimes,
  }) : super._();
  @override
  AllocationTypeAmount rebuild(
    void Function(AllocationTypeAmountBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AllocationTypeAmountBuilder toBuilder() =>
      AllocationTypeAmountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocationTypeAmount &&
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
    return (newBuiltValueToStringHelper(r'AllocationTypeAmount')
          ..add('creditType', creditType)
          ..add('amountMillimes', amountMillimes))
        .toString();
  }
}

class AllocationTypeAmountBuilder
    implements Builder<AllocationTypeAmount, AllocationTypeAmountBuilder> {
  _$AllocationTypeAmount? _$v;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  AllocationTypeAmountBuilder() {
    AllocationTypeAmount._defaults(this);
  }

  AllocationTypeAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _creditType = $v.creditType;
      _amountMillimes = $v.amountMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocationTypeAmount other) {
    _$v = other as _$AllocationTypeAmount;
  }

  @override
  void update(void Function(AllocationTypeAmountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AllocationTypeAmount build() => _build();

  _$AllocationTypeAmount _build() {
    final _$result =
        _$v ??
        _$AllocationTypeAmount._(
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'AllocationTypeAmount',
            'creditType',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'AllocationTypeAmount',
            'amountMillimes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
