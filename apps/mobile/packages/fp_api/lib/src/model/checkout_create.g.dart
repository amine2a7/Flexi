// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckoutCreate extends CheckoutCreate {
  @override
  final int amountMillimes;
  @override
  final CreditType creditType;

  factory _$CheckoutCreate([void Function(CheckoutCreateBuilder)? updates]) =>
      (CheckoutCreateBuilder()..update(updates))._build();

  _$CheckoutCreate._({required this.amountMillimes, required this.creditType})
    : super._();
  @override
  CheckoutCreate rebuild(void Function(CheckoutCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutCreateBuilder toBuilder() => CheckoutCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutCreate &&
        amountMillimes == other.amountMillimes &&
        creditType == other.creditType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutCreate')
          ..add('amountMillimes', amountMillimes)
          ..add('creditType', creditType))
        .toString();
  }
}

class CheckoutCreateBuilder
    implements Builder<CheckoutCreate, CheckoutCreateBuilder> {
  _$CheckoutCreate? _$v;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  CheckoutCreateBuilder() {
    CheckoutCreate._defaults(this);
  }

  CheckoutCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amountMillimes = $v.amountMillimes;
      _creditType = $v.creditType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutCreate other) {
    _$v = other as _$CheckoutCreate;
  }

  @override
  void update(void Function(CheckoutCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutCreate build() => _build();

  _$CheckoutCreate _build() {
    final _$result =
        _$v ??
        _$CheckoutCreate._(
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'CheckoutCreate',
            'amountMillimes',
          ),
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'CheckoutCreate',
            'creditType',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
