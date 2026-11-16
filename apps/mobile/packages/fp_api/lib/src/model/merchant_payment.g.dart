// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_payment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPayment extends MerchantPayment {
  @override
  final CreditType creditType;
  @override
  final String id;
  @override
  final String reference;
  @override
  final PaymentStatus status;
  @override
  final int amountMillimes;
  @override
  final CustomerSummary customer;
  @override
  final DateTime createdAt;
  @override
  final DateTime? expiresAt;

  factory _$MerchantPayment([void Function(MerchantPaymentBuilder)? updates]) =>
      (MerchantPaymentBuilder()..update(updates))._build();

  _$MerchantPayment._({
    required this.creditType,
    required this.id,
    required this.reference,
    required this.status,
    required this.amountMillimes,
    required this.customer,
    required this.createdAt,
    this.expiresAt,
  }) : super._();
  @override
  MerchantPayment rebuild(void Function(MerchantPaymentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MerchantPaymentBuilder toBuilder() => MerchantPaymentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPayment &&
        creditType == other.creditType &&
        id == other.id &&
        reference == other.reference &&
        status == other.status &&
        amountMillimes == other.amountMillimes &&
        customer == other.customer &&
        createdAt == other.createdAt &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, customer.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantPayment')
          ..add('creditType', creditType)
          ..add('id', id)
          ..add('reference', reference)
          ..add('status', status)
          ..add('amountMillimes', amountMillimes)
          ..add('customer', customer)
          ..add('createdAt', createdAt)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class MerchantPaymentBuilder
    implements Builder<MerchantPayment, MerchantPaymentBuilder> {
  _$MerchantPayment? _$v;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  PaymentStatus? _status;
  PaymentStatus? get status => _$this._status;
  set status(PaymentStatus? status) => _$this._status = status;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  CustomerSummaryBuilder? _customer;
  CustomerSummaryBuilder get customer =>
      _$this._customer ??= CustomerSummaryBuilder();
  set customer(CustomerSummaryBuilder? customer) => _$this._customer = customer;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  MerchantPaymentBuilder() {
    MerchantPayment._defaults(this);
  }

  MerchantPaymentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _creditType = $v.creditType;
      _id = $v.id;
      _reference = $v.reference;
      _status = $v.status;
      _amountMillimes = $v.amountMillimes;
      _customer = $v.customer.toBuilder();
      _createdAt = $v.createdAt;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPayment other) {
    _$v = other as _$MerchantPayment;
  }

  @override
  void update(void Function(MerchantPaymentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPayment build() => _build();

  _$MerchantPayment _build() {
    _$MerchantPayment _$result;
    try {
      _$result =
          _$v ??
          _$MerchantPayment._(
            creditType: BuiltValueNullFieldError.checkNotNull(
              creditType,
              r'MerchantPayment',
              'creditType',
            ),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantPayment',
              'id',
            ),
            reference: BuiltValueNullFieldError.checkNotNull(
              reference,
              r'MerchantPayment',
              'reference',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'MerchantPayment',
              'status',
            ),
            amountMillimes: BuiltValueNullFieldError.checkNotNull(
              amountMillimes,
              r'MerchantPayment',
              'amountMillimes',
            ),
            customer: customer.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'MerchantPayment',
              'createdAt',
            ),
            expiresAt: expiresAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'customer';
        customer.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantPayment',
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
