// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_payment_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeePaymentCreate extends EmployeePaymentCreate {
  @override
  final String merchantCode;
  @override
  final CreditType creditType;
  @override
  final int amountMillimes;
  @override
  final String pin;

  factory _$EmployeePaymentCreate([
    void Function(EmployeePaymentCreateBuilder)? updates,
  ]) => (EmployeePaymentCreateBuilder()..update(updates))._build();

  _$EmployeePaymentCreate._({
    required this.merchantCode,
    required this.creditType,
    required this.amountMillimes,
    required this.pin,
  }) : super._();
  @override
  EmployeePaymentCreate rebuild(
    void Function(EmployeePaymentCreateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeePaymentCreateBuilder toBuilder() =>
      EmployeePaymentCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeePaymentCreate &&
        merchantCode == other.merchantCode &&
        creditType == other.creditType &&
        amountMillimes == other.amountMillimes &&
        pin == other.pin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, merchantCode.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, pin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeePaymentCreate')
          ..add('merchantCode', merchantCode)
          ..add('creditType', creditType)
          ..add('amountMillimes', amountMillimes)
          ..add('pin', pin))
        .toString();
  }
}

class EmployeePaymentCreateBuilder
    implements Builder<EmployeePaymentCreate, EmployeePaymentCreateBuilder> {
  _$EmployeePaymentCreate? _$v;

  String? _merchantCode;
  String? get merchantCode => _$this._merchantCode;
  set merchantCode(String? merchantCode) => _$this._merchantCode = merchantCode;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  String? _pin;
  String? get pin => _$this._pin;
  set pin(String? pin) => _$this._pin = pin;

  EmployeePaymentCreateBuilder() {
    EmployeePaymentCreate._defaults(this);
  }

  EmployeePaymentCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _merchantCode = $v.merchantCode;
      _creditType = $v.creditType;
      _amountMillimes = $v.amountMillimes;
      _pin = $v.pin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeePaymentCreate other) {
    _$v = other as _$EmployeePaymentCreate;
  }

  @override
  void update(void Function(EmployeePaymentCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeePaymentCreate build() => _build();

  _$EmployeePaymentCreate _build() {
    final _$result =
        _$v ??
        _$EmployeePaymentCreate._(
          merchantCode: BuiltValueNullFieldError.checkNotNull(
            merchantCode,
            r'EmployeePaymentCreate',
            'merchantCode',
          ),
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'EmployeePaymentCreate',
            'creditType',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'EmployeePaymentCreate',
            'amountMillimes',
          ),
          pin: BuiltValueNullFieldError.checkNotNull(
            pin,
            r'EmployeePaymentCreate',
            'pin',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
