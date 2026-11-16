// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutRequest extends PayoutRequest {
  @override
  final CreditType creditType;
  @override
  final String id;
  @override
  final String reference;
  @override
  final PayoutRequestStatus status;
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
  final int? deductedMillimes;
  @override
  final int netMillimes;
  @override
  final DateTime requestedAt;
  @override
  final PayoutPayment? payment;
  @override
  final String maskedIban;

  factory _$PayoutRequest([void Function(PayoutRequestBuilder)? updates]) =>
      (PayoutRequestBuilder()..update(updates))._build();

  _$PayoutRequest._({
    required this.creditType,
    required this.id,
    required this.reference,
    required this.status,
    required this.grossMillimes,
    required this.commissionRateBps,
    required this.commissionMillimes,
    required this.vatRateBps,
    required this.vatMillimes,
    required this.stampDutyMillimes,
    required this.withholdingRateBps,
    required this.withholdingMillimes,
    required this.transferFeeMillimes,
    this.deductedMillimes,
    required this.netMillimes,
    required this.requestedAt,
    this.payment,
    required this.maskedIban,
  }) : super._();
  @override
  PayoutRequest rebuild(void Function(PayoutRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PayoutRequestBuilder toBuilder() => PayoutRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutRequest &&
        creditType == other.creditType &&
        id == other.id &&
        reference == other.reference &&
        status == other.status &&
        grossMillimes == other.grossMillimes &&
        commissionRateBps == other.commissionRateBps &&
        commissionMillimes == other.commissionMillimes &&
        vatRateBps == other.vatRateBps &&
        vatMillimes == other.vatMillimes &&
        stampDutyMillimes == other.stampDutyMillimes &&
        withholdingRateBps == other.withholdingRateBps &&
        withholdingMillimes == other.withholdingMillimes &&
        transferFeeMillimes == other.transferFeeMillimes &&
        deductedMillimes == other.deductedMillimes &&
        netMillimes == other.netMillimes &&
        requestedAt == other.requestedAt &&
        payment == other.payment &&
        maskedIban == other.maskedIban;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, grossMillimes.hashCode);
    _$hash = $jc(_$hash, commissionRateBps.hashCode);
    _$hash = $jc(_$hash, commissionMillimes.hashCode);
    _$hash = $jc(_$hash, vatRateBps.hashCode);
    _$hash = $jc(_$hash, vatMillimes.hashCode);
    _$hash = $jc(_$hash, stampDutyMillimes.hashCode);
    _$hash = $jc(_$hash, withholdingRateBps.hashCode);
    _$hash = $jc(_$hash, withholdingMillimes.hashCode);
    _$hash = $jc(_$hash, transferFeeMillimes.hashCode);
    _$hash = $jc(_$hash, deductedMillimes.hashCode);
    _$hash = $jc(_$hash, netMillimes.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, payment.hashCode);
    _$hash = $jc(_$hash, maskedIban.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PayoutRequest')
          ..add('creditType', creditType)
          ..add('id', id)
          ..add('reference', reference)
          ..add('status', status)
          ..add('grossMillimes', grossMillimes)
          ..add('commissionRateBps', commissionRateBps)
          ..add('commissionMillimes', commissionMillimes)
          ..add('vatRateBps', vatRateBps)
          ..add('vatMillimes', vatMillimes)
          ..add('stampDutyMillimes', stampDutyMillimes)
          ..add('withholdingRateBps', withholdingRateBps)
          ..add('withholdingMillimes', withholdingMillimes)
          ..add('transferFeeMillimes', transferFeeMillimes)
          ..add('deductedMillimes', deductedMillimes)
          ..add('netMillimes', netMillimes)
          ..add('requestedAt', requestedAt)
          ..add('payment', payment)
          ..add('maskedIban', maskedIban))
        .toString();
  }
}

class PayoutRequestBuilder
    implements Builder<PayoutRequest, PayoutRequestBuilder> {
  _$PayoutRequest? _$v;

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

  int? _deductedMillimes;
  int? get deductedMillimes => _$this._deductedMillimes;
  set deductedMillimes(int? deductedMillimes) =>
      _$this._deductedMillimes = deductedMillimes;

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

  String? _maskedIban;
  String? get maskedIban => _$this._maskedIban;
  set maskedIban(String? maskedIban) => _$this._maskedIban = maskedIban;

  PayoutRequestBuilder() {
    PayoutRequest._defaults(this);
  }

  PayoutRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _creditType = $v.creditType;
      _id = $v.id;
      _reference = $v.reference;
      _status = $v.status;
      _grossMillimes = $v.grossMillimes;
      _commissionRateBps = $v.commissionRateBps;
      _commissionMillimes = $v.commissionMillimes;
      _vatRateBps = $v.vatRateBps;
      _vatMillimes = $v.vatMillimes;
      _stampDutyMillimes = $v.stampDutyMillimes;
      _withholdingRateBps = $v.withholdingRateBps;
      _withholdingMillimes = $v.withholdingMillimes;
      _transferFeeMillimes = $v.transferFeeMillimes;
      _deductedMillimes = $v.deductedMillimes;
      _netMillimes = $v.netMillimes;
      _requestedAt = $v.requestedAt;
      _payment = $v.payment?.toBuilder();
      _maskedIban = $v.maskedIban;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutRequest other) {
    _$v = other as _$PayoutRequest;
  }

  @override
  void update(void Function(PayoutRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutRequest build() => _build();

  _$PayoutRequest _build() {
    _$PayoutRequest _$result;
    try {
      _$result =
          _$v ??
          _$PayoutRequest._(
            creditType: BuiltValueNullFieldError.checkNotNull(
              creditType,
              r'PayoutRequest',
              'creditType',
            ),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'PayoutRequest',
              'id',
            ),
            reference: BuiltValueNullFieldError.checkNotNull(
              reference,
              r'PayoutRequest',
              'reference',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'PayoutRequest',
              'status',
            ),
            grossMillimes: BuiltValueNullFieldError.checkNotNull(
              grossMillimes,
              r'PayoutRequest',
              'grossMillimes',
            ),
            commissionRateBps: BuiltValueNullFieldError.checkNotNull(
              commissionRateBps,
              r'PayoutRequest',
              'commissionRateBps',
            ),
            commissionMillimes: BuiltValueNullFieldError.checkNotNull(
              commissionMillimes,
              r'PayoutRequest',
              'commissionMillimes',
            ),
            vatRateBps: BuiltValueNullFieldError.checkNotNull(
              vatRateBps,
              r'PayoutRequest',
              'vatRateBps',
            ),
            vatMillimes: BuiltValueNullFieldError.checkNotNull(
              vatMillimes,
              r'PayoutRequest',
              'vatMillimes',
            ),
            stampDutyMillimes: BuiltValueNullFieldError.checkNotNull(
              stampDutyMillimes,
              r'PayoutRequest',
              'stampDutyMillimes',
            ),
            withholdingRateBps: BuiltValueNullFieldError.checkNotNull(
              withholdingRateBps,
              r'PayoutRequest',
              'withholdingRateBps',
            ),
            withholdingMillimes: BuiltValueNullFieldError.checkNotNull(
              withholdingMillimes,
              r'PayoutRequest',
              'withholdingMillimes',
            ),
            transferFeeMillimes: BuiltValueNullFieldError.checkNotNull(
              transferFeeMillimes,
              r'PayoutRequest',
              'transferFeeMillimes',
            ),
            deductedMillimes: deductedMillimes,
            netMillimes: BuiltValueNullFieldError.checkNotNull(
              netMillimes,
              r'PayoutRequest',
              'netMillimes',
            ),
            requestedAt: BuiltValueNullFieldError.checkNotNull(
              requestedAt,
              r'PayoutRequest',
              'requestedAt',
            ),
            payment: _payment?.build(),
            maskedIban: BuiltValueNullFieldError.checkNotNull(
              maskedIban,
              r'PayoutRequest',
              'maskedIban',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'payment';
        _payment?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PayoutRequest',
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
