// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_order_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreditOrderLine extends CreditOrderLine {
  @override
  final CreditType creditType;
  @override
  final int amountMillimes;

  factory _$CreditOrderLine([void Function(CreditOrderLineBuilder)? updates]) =>
      (CreditOrderLineBuilder()..update(updates))._build();

  _$CreditOrderLine._({required this.creditType, required this.amountMillimes})
    : super._();
  @override
  CreditOrderLine rebuild(void Function(CreditOrderLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreditOrderLineBuilder toBuilder() => CreditOrderLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreditOrderLine &&
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
    return (newBuiltValueToStringHelper(r'CreditOrderLine')
          ..add('creditType', creditType)
          ..add('amountMillimes', amountMillimes))
        .toString();
  }
}

class CreditOrderLineBuilder
    implements Builder<CreditOrderLine, CreditOrderLineBuilder> {
  _$CreditOrderLine? _$v;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  CreditOrderLineBuilder() {
    CreditOrderLine._defaults(this);
  }

  CreditOrderLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _creditType = $v.creditType;
      _amountMillimes = $v.amountMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreditOrderLine other) {
    _$v = other as _$CreditOrderLine;
  }

  @override
  void update(void Function(CreditOrderLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreditOrderLine build() => _build();

  _$CreditOrderLine _build() {
    final _$result =
        _$v ??
        _$CreditOrderLine._(
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'CreditOrderLine',
            'creditType',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'CreditOrderLine',
            'amountMillimes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
