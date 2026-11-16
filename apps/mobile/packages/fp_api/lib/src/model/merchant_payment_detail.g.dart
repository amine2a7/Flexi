// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_payment_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPaymentDetail extends MerchantPaymentDetail {
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
  @override
  final CreditType creditType;
  @override
  final int commissionRateBps;
  @override
  final int commissionMillimes;
  @override
  final int netMillimes;
  @override
  final Date? settlementDate;
  @override
  final BuiltList<PaymentEvent> history;

  factory _$MerchantPaymentDetail([
    void Function(MerchantPaymentDetailBuilder)? updates,
  ]) => (MerchantPaymentDetailBuilder()..update(updates))._build();

  _$MerchantPaymentDetail._({
    required this.id,
    required this.reference,
    required this.status,
    required this.amountMillimes,
    required this.customer,
    required this.createdAt,
    this.expiresAt,
    required this.creditType,
    required this.commissionRateBps,
    required this.commissionMillimes,
    required this.netMillimes,
    this.settlementDate,
    required this.history,
  }) : super._();
  @override
  MerchantPaymentDetail rebuild(
    void Function(MerchantPaymentDetailBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPaymentDetailBuilder toBuilder() =>
      MerchantPaymentDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPaymentDetail &&
        id == other.id &&
        reference == other.reference &&
        status == other.status &&
        amountMillimes == other.amountMillimes &&
        customer == other.customer &&
        createdAt == other.createdAt &&
        expiresAt == other.expiresAt &&
        creditType == other.creditType &&
        commissionRateBps == other.commissionRateBps &&
        commissionMillimes == other.commissionMillimes &&
        netMillimes == other.netMillimes &&
        settlementDate == other.settlementDate &&
        history == other.history;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, customer.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, commissionRateBps.hashCode);
    _$hash = $jc(_$hash, commissionMillimes.hashCode);
    _$hash = $jc(_$hash, netMillimes.hashCode);
    _$hash = $jc(_$hash, settlementDate.hashCode);
    _$hash = $jc(_$hash, history.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantPaymentDetail')
          ..add('id', id)
          ..add('reference', reference)
          ..add('status', status)
          ..add('amountMillimes', amountMillimes)
          ..add('customer', customer)
          ..add('createdAt', createdAt)
          ..add('expiresAt', expiresAt)
          ..add('creditType', creditType)
          ..add('commissionRateBps', commissionRateBps)
          ..add('commissionMillimes', commissionMillimes)
          ..add('netMillimes', netMillimes)
          ..add('settlementDate', settlementDate)
          ..add('history', history))
        .toString();
  }
}

class MerchantPaymentDetailBuilder
    implements Builder<MerchantPaymentDetail, MerchantPaymentDetailBuilder> {
  _$MerchantPaymentDetail? _$v;

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

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  int? _commissionRateBps;
  int? get commissionRateBps => _$this._commissionRateBps;
  set commissionRateBps(int? commissionRateBps) =>
      _$this._commissionRateBps = commissionRateBps;

  int? _commissionMillimes;
  int? get commissionMillimes => _$this._commissionMillimes;
  set commissionMillimes(int? commissionMillimes) =>
      _$this._commissionMillimes = commissionMillimes;

  int? _netMillimes;
  int? get netMillimes => _$this._netMillimes;
  set netMillimes(int? netMillimes) => _$this._netMillimes = netMillimes;

  Date? _settlementDate;
  Date? get settlementDate => _$this._settlementDate;
  set settlementDate(Date? settlementDate) =>
      _$this._settlementDate = settlementDate;

  ListBuilder<PaymentEvent>? _history;
  ListBuilder<PaymentEvent> get history =>
      _$this._history ??= ListBuilder<PaymentEvent>();
  set history(ListBuilder<PaymentEvent>? history) => _$this._history = history;

  MerchantPaymentDetailBuilder() {
    MerchantPaymentDetail._defaults(this);
  }

  MerchantPaymentDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _status = $v.status;
      _amountMillimes = $v.amountMillimes;
      _customer = $v.customer.toBuilder();
      _createdAt = $v.createdAt;
      _expiresAt = $v.expiresAt;
      _creditType = $v.creditType;
      _commissionRateBps = $v.commissionRateBps;
      _commissionMillimes = $v.commissionMillimes;
      _netMillimes = $v.netMillimes;
      _settlementDate = $v.settlementDate;
      _history = $v.history.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPaymentDetail other) {
    _$v = other as _$MerchantPaymentDetail;
  }

  @override
  void update(void Function(MerchantPaymentDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPaymentDetail build() => _build();

  _$MerchantPaymentDetail _build() {
    _$MerchantPaymentDetail _$result;
    try {
      _$result =
          _$v ??
          _$MerchantPaymentDetail._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantPaymentDetail',
              'id',
            ),
            reference: BuiltValueNullFieldError.checkNotNull(
              reference,
              r'MerchantPaymentDetail',
              'reference',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'MerchantPaymentDetail',
              'status',
            ),
            amountMillimes: BuiltValueNullFieldError.checkNotNull(
              amountMillimes,
              r'MerchantPaymentDetail',
              'amountMillimes',
            ),
            customer: customer.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'MerchantPaymentDetail',
              'createdAt',
            ),
            expiresAt: expiresAt,
            creditType: BuiltValueNullFieldError.checkNotNull(
              creditType,
              r'MerchantPaymentDetail',
              'creditType',
            ),
            commissionRateBps: BuiltValueNullFieldError.checkNotNull(
              commissionRateBps,
              r'MerchantPaymentDetail',
              'commissionRateBps',
            ),
            commissionMillimes: BuiltValueNullFieldError.checkNotNull(
              commissionMillimes,
              r'MerchantPaymentDetail',
              'commissionMillimes',
            ),
            netMillimes: BuiltValueNullFieldError.checkNotNull(
              netMillimes,
              r'MerchantPaymentDetail',
              'netMillimes',
            ),
            settlementDate: settlementDate,
            history: history.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'customer';
        customer.build();

        _$failedField = 'history';
        history.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantPaymentDetail',
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
