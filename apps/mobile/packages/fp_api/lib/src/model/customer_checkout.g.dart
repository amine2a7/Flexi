// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_checkout.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerCheckout extends CustomerCheckout {
  @override
  final String id;
  @override
  final String merchantName;
  @override
  final String registerName;
  @override
  final String? city;
  @override
  final int amountMillimes;
  @override
  final CreditType creditType;
  @override
  final DateTime expiresAt;

  factory _$CustomerCheckout([
    void Function(CustomerCheckoutBuilder)? updates,
  ]) => (CustomerCheckoutBuilder()..update(updates))._build();

  _$CustomerCheckout._({
    required this.id,
    required this.merchantName,
    required this.registerName,
    this.city,
    required this.amountMillimes,
    required this.creditType,
    required this.expiresAt,
  }) : super._();
  @override
  CustomerCheckout rebuild(void Function(CustomerCheckoutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustomerCheckoutBuilder toBuilder() =>
      CustomerCheckoutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerCheckout &&
        id == other.id &&
        merchantName == other.merchantName &&
        registerName == other.registerName &&
        city == other.city &&
        amountMillimes == other.amountMillimes &&
        creditType == other.creditType &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, merchantName.hashCode);
    _$hash = $jc(_$hash, registerName.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerCheckout')
          ..add('id', id)
          ..add('merchantName', merchantName)
          ..add('registerName', registerName)
          ..add('city', city)
          ..add('amountMillimes', amountMillimes)
          ..add('creditType', creditType)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class CustomerCheckoutBuilder
    implements Builder<CustomerCheckout, CustomerCheckoutBuilder> {
  _$CustomerCheckout? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _merchantName;
  String? get merchantName => _$this._merchantName;
  set merchantName(String? merchantName) => _$this._merchantName = merchantName;

  String? _registerName;
  String? get registerName => _$this._registerName;
  set registerName(String? registerName) => _$this._registerName = registerName;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  CustomerCheckoutBuilder() {
    CustomerCheckout._defaults(this);
  }

  CustomerCheckoutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _merchantName = $v.merchantName;
      _registerName = $v.registerName;
      _city = $v.city;
      _amountMillimes = $v.amountMillimes;
      _creditType = $v.creditType;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerCheckout other) {
    _$v = other as _$CustomerCheckout;
  }

  @override
  void update(void Function(CustomerCheckoutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerCheckout build() => _build();

  _$CustomerCheckout _build() {
    final _$result =
        _$v ??
        _$CustomerCheckout._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'CustomerCheckout',
            'id',
          ),
          merchantName: BuiltValueNullFieldError.checkNotNull(
            merchantName,
            r'CustomerCheckout',
            'merchantName',
          ),
          registerName: BuiltValueNullFieldError.checkNotNull(
            registerName,
            r'CustomerCheckout',
            'registerName',
          ),
          city: city,
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'CustomerCheckout',
            'amountMillimes',
          ),
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'CustomerCheckout',
            'creditType',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'CustomerCheckout',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
