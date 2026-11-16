// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payout_request_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPayoutRequestDetail extends AdminPayoutRequestDetail {
  @override
  final CreditType creditType;
  @override
  final String id;
  @override
  final String reference;
  @override
  final PayoutRequestStatus status;
  @override
  final String merchantId;
  @override
  final String merchantName;
  @override
  final int grossMillimes;
  @override
  final int commissionRateBps;
  @override
  final int commissionMillimes;
  @override
  final int vatRateBps;
  @override
  final int vatMillimes;
  @override
  final int stampDutyMillimes;
  @override
  final int withholdingRateBps;
  @override
  final int withholdingMillimes;
  @override
  final int transferFeeMillimes;
  @override
  final int netMillimes;
  @override
  final DateTime requestedAt;
  @override
  final PayoutPayment? payment;
  @override
  final String iban;
  @override
  final String? batchId;
  @override
  final String? batchReference;
  @override
  final BuiltList<PayoutEvent> history;

  factory _$AdminPayoutRequestDetail([
    void Function(AdminPayoutRequestDetailBuilder)? updates,
  ]) => (AdminPayoutRequestDetailBuilder()..update(updates))._build();

  _$AdminPayoutRequestDetail._({
    required this.creditType,
    required this.id,
    required this.reference,
    required this.status,
    required this.merchantId,
    required this.merchantName,
    required this.grossMillimes,
    required this.commissionRateBps,
    required this.commissionMillimes,
    required this.vatRateBps,
    required this.vatMillimes,
    required this.stampDutyMillimes,
    required this.withholdingRateBps,
    required this.withholdingMillimes,
    required this.transferFeeMillimes,
    required this.netMillimes,
    required this.requestedAt,
    this.payment,
    required this.iban,
    this.batchId,
    this.batchReference,
    required this.history,
  }) : super._();
  @override
  AdminPayoutRequestDetail rebuild(
    void Function(AdminPayoutRequestDetailBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPayoutRequestDetailBuilder toBuilder() =>
      AdminPayoutRequestDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPayoutRequestDetail &&
        creditType == other.creditType &&
        id == other.id &&
        reference == other.reference &&
        status == other.status &&
        merchantId == other.merchantId &&
        merchantName == other.merchantName &&
        grossMillimes == other.grossMillimes &&
        commissionRateBps == other.commissionRateBps &&
        commissionMillimes == other.commissionMillimes &&
        vatRateBps == other.vatRateBps &&
        vatMillimes == other.vatMillimes &&
        stampDutyMillimes == other.stampDutyMillimes &&
        withholdingRateBps == other.withholdingRateBps &&
        withholdingMillimes == other.withholdingMillimes &&
        transferFeeMillimes == other.transferFeeMillimes &&
        netMillimes == other.netMillimes &&
        requestedAt == other.requestedAt &&
        payment == other.payment &&
        iban == other.iban &&
        batchId == other.batchId &&
        batchReference == other.batchReference &&
        history == other.history;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, merchantId.hashCode);
    _$hash = $jc(_$hash, merchantName.hashCode);
    _$hash = $jc(_$hash, grossMillimes.hashCode);
    _$hash = $jc(_$hash, commissionRateBps.hashCode);
    _$hash = $jc(_$hash, commissionMillimes.hashCode);
    _$hash = $jc(_$hash, vatRateBps.hashCode);
    _$hash = $jc(_$hash, vatMillimes.hashCode);
    _$hash = $jc(_$hash, stampDutyMillimes.hashCode);
    _$hash = $jc(_$hash, withholdingRateBps.hashCode);
    _$hash = $jc(_$hash, withholdingMillimes.hashCode);
    _$hash = $jc(_$hash, transferFeeMillimes.hashCode);
    _$hash = $jc(_$hash, netMillimes.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, payment.hashCode);
    _$hash = $jc(_$hash, iban.hashCode);
    _$hash = $jc(_$hash, batchId.hashCode);
    _$hash = $jc(_$hash, batchReference.hashCode);
    _$hash = $jc(_$hash, history.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPayoutRequestDetail')
          ..add('creditType', creditType)
          ..add('id', id)
          ..add('reference', reference)
          ..add('status', status)
          ..add('merchantId', merchantId)
          ..add('merchantName', merchantName)
          ..add('grossMillimes', grossMillimes)
          ..add('commissionRateBps', commissionRateBps)
          ..add('commissionMillimes', commissionMillimes)
          ..add('vatRateBps', vatRateBps)
          ..add('vatMillimes', vatMillimes)
          ..add('stampDutyMillimes', stampDutyMillimes)
          ..add('withholdingRateBps', withholdingRateBps)
          ..add('withholdingMillimes', withholdingMillimes)
          ..add('transferFeeMillimes', transferFeeMillimes)
          ..add('netMillimes', netMillimes)
          ..add('requestedAt', requestedAt)
          ..add('payment', payment)
          ..add('iban', iban)
          ..add('batchId', batchId)
          ..add('batchReference', batchReference)
          ..add('history', history))
        .toString();
  }
}

class AdminPayoutRequestDetailBuilder
    implements
        Builder<AdminPayoutRequestDetail, AdminPayoutRequestDetailBuilder> {
  _$AdminPayoutRequestDetail? _$v;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  PayoutRequestStatus? _status;
  PayoutRequestStatus? get status => _$this._status;
  set status(PayoutRequestStatus? status) => _$this._status = status;

  String? _merchantId;
  String? get merchantId => _$this._merchantId;
  set merchantId(String? merchantId) => _$this._merchantId = merchantId;

  String? _merchantName;
  String? get merchantName => _$this._merchantName;
  set merchantName(String? merchantName) => _$this._merchantName = merchantName;

  int? _grossMillimes;
  int? get grossMillimes => _$this._grossMillimes;
  set grossMillimes(int? grossMillimes) =>
      _$this._grossMillimes = grossMillimes;

  int? _commissionRateBps;
  int? get commissionRateBps => _$this._commissionRateBps;
  set commissionRateBps(int? commissionRateBps) =>
      _$this._commissionRateBps = commissionRateBps;

  int? _commissionMillimes;
  int? get commissionMillimes => _$this._commissionMillimes;
  set commissionMillimes(int? commissionMillimes) =>
      _$this._commissionMillimes = commissionMillimes;

  int? _vatRateBps;
  int? get vatRateBps => _$this._vatRateBps;
  set vatRateBps(int? vatRateBps) => _$this._vatRateBps = vatRateBps;

  int? _vatMillimes;
  int? get vatMillimes => _$this._vatMillimes;
  set vatMillimes(int? vatMillimes) => _$this._vatMillimes = vatMillimes;

  int? _stampDutyMillimes;
  int? get stampDutyMillimes => _$this._stampDutyMillimes;
  set stampDutyMillimes(int? stampDutyMillimes) =>
      _$this._stampDutyMillimes = stampDutyMillimes;

  int? _withholdingRateBps;
  int? get withholdingRateBps => _$this._withholdingRateBps;
  set withholdingRateBps(int? withholdingRateBps) =>
      _$this._withholdingRateBps = withholdingRateBps;

  int? _withholdingMillimes;
  int? get withholdingMillimes => _$this._withholdingMillimes;
  set withholdingMillimes(int? withholdingMillimes) =>
      _$this._withholdingMillimes = withholdingMillimes;

  int? _transferFeeMillimes;
  int? get transferFeeMillimes => _$this._transferFeeMillimes;
  set transferFeeMillimes(int? transferFeeMillimes) =>
      _$this._transferFeeMillimes = transferFeeMillimes;

  int? _netMillimes;
  int? get netMillimes => _$this._netMillimes;
  set netMillimes(int? netMillimes) => _$this._netMillimes = netMillimes;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  PayoutPaymentBuilder? _payment;
  PayoutPaymentBuilder get payment =>
      _$this._payment ??= PayoutPaymentBuilder();
  set payment(PayoutPaymentBuilder? payment) => _$this._payment = payment;

  String? _iban;
  String? get iban => _$this._iban;
  set iban(String? iban) => _$this._iban = iban;

  String? _batchId;
  String? get batchId => _$this._batchId;
  set batchId(String? batchId) => _$this._batchId = batchId;

  String? _batchReference;
  String? get batchReference => _$this._batchReference;
  set batchReference(String? batchReference) =>
      _$this._batchReference = batchReference;

  ListBuilder<PayoutEvent>? _history;
  ListBuilder<PayoutEvent> get history =>
      _$this._history ??= ListBuilder<PayoutEvent>();
  set history(ListBuilder<PayoutEvent>? history) => _$this._history = history;

  AdminPayoutRequestDetailBuilder() {
    AdminPayoutRequestDetail._defaults(this);
  }

  AdminPayoutRequestDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _creditType = $v.creditType;
      _id = $v.id;
      _reference = $v.reference;
      _status = $v.status;
      _merchantId = $v.merchantId;
      _merchantName = $v.merchantName;
      _grossMillimes = $v.grossMillimes;
      _commissionRateBps = $v.commissionRateBps;
      _commissionMillimes = $v.commissionMillimes;
      _vatRateBps = $v.vatRateBps;
      _vatMillimes = $v.vatMillimes;
      _stampDutyMillimes = $v.stampDutyMillimes;
      _withholdingRateBps = $v.withholdingRateBps;
      _withholdingMillimes = $v.withholdingMillimes;
      _transferFeeMillimes = $v.transferFeeMillimes;
      _netMillimes = $v.netMillimes;
      _requestedAt = $v.requestedAt;
      _payment = $v.payment?.toBuilder();
      _iban = $v.iban;
      _batchId = $v.batchId;
      _batchReference = $v.batchReference;
      _history = $v.history.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPayoutRequestDetail other) {
    _$v = other as _$AdminPayoutRequestDetail;
  }

  @override
  void update(void Function(AdminPayoutRequestDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPayoutRequestDetail build() => _build();

  _$AdminPayoutRequestDetail _build() {
    _$AdminPayoutRequestDetail _$result;
    try {
      _$result =
          _$v ??
          _$AdminPayoutRequestDetail._(
            creditType: BuiltValueNullFieldError.checkNotNull(
              creditType,
              r'AdminPayoutRequestDetail',
              'creditType',
            ),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminPayoutRequestDetail',
              'id',
            ),
            reference: BuiltValueNullFieldError.checkNotNull(
              reference,
              r'AdminPayoutRequestDetail',
              'reference',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminPayoutRequestDetail',
              'status',
            ),
            merchantId: BuiltValueNullFieldError.checkNotNull(
              merchantId,
              r'AdminPayoutRequestDetail',
              'merchantId',
            ),
            merchantName: BuiltValueNullFieldError.checkNotNull(
              merchantName,
              r'AdminPayoutRequestDetail',
              'merchantName',
            ),
            grossMillimes: BuiltValueNullFieldError.checkNotNull(
              grossMillimes,
              r'AdminPayoutRequestDetail',
              'grossMillimes',
            ),
            commissionRateBps: BuiltValueNullFieldError.checkNotNull(
              commissionRateBps,
              r'AdminPayoutRequestDetail',
              'commissionRateBps',
            ),
            commissionMillimes: BuiltValueNullFieldError.checkNotNull(
              commissionMillimes,
              r'AdminPayoutRequestDetail',
              'commissionMillimes',
            ),
            vatRateBps: BuiltValueNullFieldError.checkNotNull(
              vatRateBps,
              r'AdminPayoutRequestDetail',
              'vatRateBps',
            ),
            vatMillimes: BuiltValueNullFieldError.checkNotNull(
              vatMillimes,
              r'AdminPayoutRequestDetail',
              'vatMillimes',
            ),
            stampDutyMillimes: BuiltValueNullFieldError.checkNotNull(
              stampDutyMillimes,
              r'AdminPayoutRequestDetail',
              'stampDutyMillimes',
            ),
            withholdingRateBps: BuiltValueNullFieldError.checkNotNull(
              withholdingRateBps,
              r'AdminPayoutRequestDetail',
              'withholdingRateBps',
            ),
            withholdingMillimes: BuiltValueNullFieldError.checkNotNull(
              withholdingMillimes,
              r'AdminPayoutRequestDetail',
              'withholdingMillimes',
            ),
            transferFeeMillimes: BuiltValueNullFieldError.checkNotNull(
              transferFeeMillimes,
              r'AdminPayoutRequestDetail',
              'transferFeeMillimes',
            ),
            netMillimes: BuiltValueNullFieldError.checkNotNull(
              netMillimes,
              r'AdminPayoutRequestDetail',
              'netMillimes',
            ),
            requestedAt: BuiltValueNullFieldError.checkNotNull(
              requestedAt,
              r'AdminPayoutRequestDetail',
              'requestedAt',
            ),
            payment: _payment?.build(),
            iban: BuiltValueNullFieldError.checkNotNull(
              iban,
              r'AdminPayoutRequestDetail',
              'iban',
            ),
            batchId: batchId,
            batchReference: batchReference,
            history: history.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'payment';
        _payment?.build();

        _$failedField = 'history';
        history.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminPayoutRequestDetail',
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
