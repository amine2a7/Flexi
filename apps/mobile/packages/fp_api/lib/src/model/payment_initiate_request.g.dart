// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_initiate_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentInitiateRequest extends PaymentInitiateRequest {
  @override
  final String customerCode;
  @override
  final CreditType creditType;
  @override
  final int amountMillimes;

  factory _$PaymentInitiateRequest([
    void Function(PaymentInitiateRequestBuilder)? updates,
  ]) => (PaymentInitiateRequestBuilder()..update(updates))._build();

  _$PaymentInitiateRequest._({
    required this.customerCode,
    required this.creditType,
    required this.amountMillimes,
  }) : super._();
  @override
  PaymentInitiateRequest rebuild(
    void Function(PaymentInitiateRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PaymentInitiateRequestBuilder toBuilder() =>
      PaymentInitiateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentInitiateRequest &&
        customerCode == other.customerCode &&
        creditType == other.creditType &&
        amountMillimes == other.amountMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, customerCode.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentInitiateRequest')
          ..add('customerCode', customerCode)
          ..add('creditType', creditType)
          ..add('amountMillimes', amountMillimes))
        .toString();
  }
}

class PaymentInitiateRequestBuilder
    implements Builder<PaymentInitiateRequest, PaymentInitiateRequestBuilder> {
  _$PaymentInitiateRequest? _$v;

  String? _customerCode;
  String? get customerCode => _$this._customerCode;
  set customerCode(String? customerCode) => _$this._customerCode = customerCode;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  PaymentInitiateRequestBuilder() {
    PaymentInitiateRequest._defaults(this);
  }

  PaymentInitiateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _customerCode = $v.customerCode;
      _creditType = $v.creditType;
      _amountMillimes = $v.amountMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentInitiateRequest other) {
    _$v = other as _$PaymentInitiateRequest;
  }

  @override
  void update(void Function(PaymentInitiateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentInitiateRequest build() => _build();

  _$PaymentInitiateRequest _build() {
    final _$result =
        _$v ??
        _$PaymentInitiateRequest._(
          customerCode: BuiltValueNullFieldError.checkNotNull(
            customerCode,
            r'PaymentInitiateRequest',
            'customerCode',
          ),
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'PaymentInitiateRequest',
            'creditType',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'PaymentInitiateRequest',
            'amountMillimes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
