// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_quote_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutQuoteRequest extends PayoutQuoteRequest {
  @override
  final CreditType creditType;
  @override
  final int grossMillimes;

  factory _$PayoutQuoteRequest([
    void Function(PayoutQuoteRequestBuilder)? updates,
  ]) => (PayoutQuoteRequestBuilder()..update(updates))._build();

  _$PayoutQuoteRequest._({
    required this.creditType,
    required this.grossMillimes,
  }) : super._();
  @override
  PayoutQuoteRequest rebuild(
    void Function(PayoutQuoteRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PayoutQuoteRequestBuilder toBuilder() =>
      PayoutQuoteRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutQuoteRequest &&
        creditType == other.creditType &&
        grossMillimes == other.grossMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, grossMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PayoutQuoteRequest')
          ..add('creditType', creditType)
          ..add('grossMillimes', grossMillimes))
        .toString();
  }
}

class PayoutQuoteRequestBuilder
    implements Builder<PayoutQuoteRequest, PayoutQuoteRequestBuilder> {
  _$PayoutQuoteRequest? _$v;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  int? _grossMillimes;
  int? get grossMillimes => _$this._grossMillimes;
  set grossMillimes(int? grossMillimes) =>
      _$this._grossMillimes = grossMillimes;

  PayoutQuoteRequestBuilder() {
    PayoutQuoteRequest._defaults(this);
  }

  PayoutQuoteRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _creditType = $v.creditType;
      _grossMillimes = $v.grossMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutQuoteRequest other) {
    _$v = other as _$PayoutQuoteRequest;
  }

  @override
  void update(void Function(PayoutQuoteRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutQuoteRequest build() => _build();

  _$PayoutQuoteRequest _build() {
    final _$result =
        _$v ??
        _$PayoutQuoteRequest._(
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'PayoutQuoteRequest',
            'creditType',
          ),
          grossMillimes: BuiltValueNullFieldError.checkNotNull(
            grossMillimes,
            r'PayoutQuoteRequest',
            'grossMillimes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
