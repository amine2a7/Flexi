// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Checkout extends Checkout {
  @override
  final String id;
  @override
  final String registerId;
  @override
  final String shortCode;
  @override
  final int amountMillimes;
  @override
  final CreditType creditType;
  @override
  final CheckoutStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime expiresAt;
  @override
  final DateTime? paidAt;
  @override
  final String? customerFirstName;
  @override
  final String? paymentReference;
  @override
  final CheckoutRefusal? lastRefusal;

  factory _$Checkout([void Function(CheckoutBuilder)? updates]) =>
      (CheckoutBuilder()..update(updates))._build();

  _$Checkout._({
    required this.id,
    required this.registerId,
    required this.shortCode,
    required this.amountMillimes,
    required this.creditType,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    this.paidAt,
    this.customerFirstName,
    this.paymentReference,
    this.lastRefusal,
  }) : super._();
  @override
  Checkout rebuild(void Function(CheckoutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutBuilder toBuilder() => CheckoutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Checkout &&
        id == other.id &&
        registerId == other.registerId &&
        shortCode == other.shortCode &&
        amountMillimes == other.amountMillimes &&
        creditType == other.creditType &&
        status == other.status &&
        createdAt == other.createdAt &&
        expiresAt == other.expiresAt &&
        paidAt == other.paidAt &&
        customerFirstName == other.customerFirstName &&
        paymentReference == other.paymentReference &&
        lastRefusal == other.lastRefusal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, registerId.hashCode);
    _$hash = $jc(_$hash, shortCode.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, paidAt.hashCode);
    _$hash = $jc(_$hash, customerFirstName.hashCode);
    _$hash = $jc(_$hash, paymentReference.hashCode);
    _$hash = $jc(_$hash, lastRefusal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Checkout')
          ..add('id', id)
          ..add('registerId', registerId)
          ..add('shortCode', shortCode)
          ..add('amountMillimes', amountMillimes)
          ..add('creditType', creditType)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('expiresAt', expiresAt)
          ..add('paidAt', paidAt)
          ..add('customerFirstName', customerFirstName)
          ..add('paymentReference', paymentReference)
          ..add('lastRefusal', lastRefusal))
        .toString();
  }
}

class CheckoutBuilder implements Builder<Checkout, CheckoutBuilder> {
  _$Checkout? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _registerId;
  String? get registerId => _$this._registerId;
  set registerId(String? registerId) => _$this._registerId = registerId;

  String? _shortCode;
  String? get shortCode => _$this._shortCode;
  set shortCode(String? shortCode) => _$this._shortCode = shortCode;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  CheckoutStatus? _status;
  CheckoutStatus? get status => _$this._status;
  set status(CheckoutStatus? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DateTime? _paidAt;
  DateTime? get paidAt => _$this._paidAt;
  set paidAt(DateTime? paidAt) => _$this._paidAt = paidAt;

  String? _customerFirstName;
  String? get customerFirstName => _$this._customerFirstName;
  set customerFirstName(String? customerFirstName) =>
      _$this._customerFirstName = customerFirstName;

  String? _paymentReference;
  String? get paymentReference => _$this._paymentReference;
  set paymentReference(String? paymentReference) =>
      _$this._paymentReference = paymentReference;

  CheckoutRefusalBuilder? _lastRefusal;
  CheckoutRefusalBuilder get lastRefusal =>
      _$this._lastRefusal ??= CheckoutRefusalBuilder();
  set lastRefusal(CheckoutRefusalBuilder? lastRefusal) =>
      _$this._lastRefusal = lastRefusal;

  CheckoutBuilder() {
    Checkout._defaults(this);
  }

  CheckoutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _registerId = $v.registerId;
      _shortCode = $v.shortCode;
      _amountMillimes = $v.amountMillimes;
      _creditType = $v.creditType;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _expiresAt = $v.expiresAt;
      _paidAt = $v.paidAt;
      _customerFirstName = $v.customerFirstName;
      _paymentReference = $v.paymentReference;
      _lastRefusal = $v.lastRefusal?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Checkout other) {
    _$v = other as _$Checkout;
  }

  @override
  void update(void Function(CheckoutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Checkout build() => _build();

  _$Checkout _build() {
    _$Checkout _$result;
    try {
      _$result =
          _$v ??
          _$Checkout._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Checkout', 'id'),
            registerId: BuiltValueNullFieldError.checkNotNull(
              registerId,
              r'Checkout',
              'registerId',
            ),
            shortCode: BuiltValueNullFieldError.checkNotNull(
              shortCode,
              r'Checkout',
              'shortCode',
            ),
            amountMillimes: BuiltValueNullFieldError.checkNotNull(
              amountMillimes,
              r'Checkout',
              'amountMillimes',
            ),
            creditType: BuiltValueNullFieldError.checkNotNull(
              creditType,
              r'Checkout',
              'creditType',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'Checkout',
              'status',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'Checkout',
              'createdAt',
            ),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt,
              r'Checkout',
              'expiresAt',
            ),
            paidAt: paidAt,
            customerFirstName: customerFirstName,
            paymentReference: paymentReference,
            lastRefusal: _lastRefusal?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lastRefusal';
        _lastRefusal?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Checkout',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
