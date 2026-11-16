// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_batch_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettlementBatchDetail extends SettlementBatchDetail {
  @override
  final Date? paidOn;
  @override
  final String id;
  @override
  final String reference;
  @override
  final Date settlementDate;
  @override
  final int merchantsCount;
  @override
  final int grossMillimes;
  @override
  final int commissionMillimes;
  @override
  final int vatMillimes;
  @override
  final int stampDutyMillimes;
  @override
  final int netMillimes;
  @override
  final SettlementBatchStatus status;
  @override
  final DateTime? releasedAt;
  @override
  final DateTime? sentAt;
  @override
  final String? bankReference;
  @override
  final BuiltList<AdminPayoutRequest> payouts;

  factory _$SettlementBatchDetail([
    void Function(SettlementBatchDetailBuilder)? updates,
  ]) => (SettlementBatchDetailBuilder()..update(updates))._build();

  _$SettlementBatchDetail._({
    this.paidOn,
    required this.id,
    required this.reference,
    required this.settlementDate,
    required this.merchantsCount,
    required this.grossMillimes,
    required this.commissionMillimes,
    required this.vatMillimes,
    required this.stampDutyMillimes,
    required this.netMillimes,
    required this.status,
    this.releasedAt,
    this.sentAt,
    this.bankReference,
    required this.payouts,
  }) : super._();
  @override
  SettlementBatchDetail rebuild(
    void Function(SettlementBatchDetailBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SettlementBatchDetailBuilder toBuilder() =>
      SettlementBatchDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettlementBatchDetail &&
        paidOn == other.paidOn &&
        id == other.id &&
        reference == other.reference &&
        settlementDate == other.settlementDate &&
        merchantsCount == other.merchantsCount &&
        grossMillimes == other.grossMillimes &&
        commissionMillimes == other.commissionMillimes &&
        vatMillimes == other.vatMillimes &&
        stampDutyMillimes == other.stampDutyMillimes &&
        netMillimes == other.netMillimes &&
        status == other.status &&
        releasedAt == other.releasedAt &&
        sentAt == other.sentAt &&
        bankReference == other.bankReference &&
        payouts == other.payouts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paidOn.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, settlementDate.hashCode);
    _$hash = $jc(_$hash, merchantsCount.hashCode);
    _$hash = $jc(_$hash, grossMillimes.hashCode);
    _$hash = $jc(_$hash, commissionMillimes.hashCode);
    _$hash = $jc(_$hash, vatMillimes.hashCode);
    _$hash = $jc(_$hash, stampDutyMillimes.hashCode);
    _$hash = $jc(_$hash, netMillimes.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, releasedAt.hashCode);
    _$hash = $jc(_$hash, sentAt.hashCode);
    _$hash = $jc(_$hash, bankReference.hashCode);
    _$hash = $jc(_$hash, payouts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SettlementBatchDetail')
          ..add('paidOn', paidOn)
          ..add('id', id)
          ..add('reference', reference)
          ..add('settlementDate', settlementDate)
          ..add('merchantsCount', merchantsCount)
          ..add('grossMillimes', grossMillimes)
          ..add('commissionMillimes', commissionMillimes)
          ..add('vatMillimes', vatMillimes)
          ..add('stampDutyMillimes', stampDutyMillimes)
          ..add('netMillimes', netMillimes)
          ..add('status', status)
          ..add('releasedAt', releasedAt)
          ..add('sentAt', sentAt)
          ..add('bankReference', bankReference)
          ..add('payouts', payouts))
        .toString();
  }
}

class SettlementBatchDetailBuilder
    implements Builder<SettlementBatchDetail, SettlementBatchDetailBuilder> {
  _$SettlementBatchDetail? _$v;

  Date? _paidOn;
  Date? get paidOn => _$this._paidOn;
  set paidOn(Date? paidOn) => _$this._paidOn = paidOn;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  Date? _settlementDate;
  Date? get settlementDate => _$this._settlementDate;
  set settlementDate(Date? settlementDate) =>
      _$this._settlementDate = settlementDate;

  int? _merchantsCount;
  int? get merchantsCount => _$this._merchantsCount;
  set merchantsCount(int? merchantsCount) =>
      _$this._merchantsCount = merchantsCount;

  int? _grossMillimes;
  int? get grossMillimes => _$this._grossMillimes;
  set grossMillimes(int? grossMillimes) =>
      _$this._grossMillimes = grossMillimes;

  int? _commissionMillimes;
  int? get commissionMillimes => _$this._commissionMillimes;
  set commissionMillimes(int? commissionMillimes) =>
      _$this._commissionMillimes = commissionMillimes;

  int? _vatMillimes;
  int? get vatMillimes => _$this._vatMillimes;
  set vatMillimes(int? vatMillimes) => _$this._vatMillimes = vatMillimes;

  int? _stampDutyMillimes;
  int? get stampDutyMillimes => _$this._stampDutyMillimes;
  set stampDutyMillimes(int? stampDutyMillimes) =>
      _$this._stampDutyMillimes = stampDutyMillimes;

  int? _netMillimes;
  int? get netMillimes => _$this._netMillimes;
  set netMillimes(int? netMillimes) => _$this._netMillimes = netMillimes;

  SettlementBatchStatus? _status;
  SettlementBatchStatus? get status => _$this._status;
  set status(SettlementBatchStatus? status) => _$this._status = status;

  DateTime? _releasedAt;
  DateTime? get releasedAt => _$this._releasedAt;
  set releasedAt(DateTime? releasedAt) => _$this._releasedAt = releasedAt;

  DateTime? _sentAt;
  DateTime? get sentAt => _$this._sentAt;
  set sentAt(DateTime? sentAt) => _$this._sentAt = sentAt;

  String? _bankReference;
  String? get bankReference => _$this._bankReference;
  set bankReference(String? bankReference) =>
      _$this._bankReference = bankReference;

  ListBuilder<AdminPayoutRequest>? _payouts;
  ListBuilder<AdminPayoutRequest> get payouts =>
      _$this._payouts ??= ListBuilder<AdminPayoutRequest>();
  set payouts(ListBuilder<AdminPayoutRequest>? payouts) =>
      _$this._payouts = payouts;

  SettlementBatchDetailBuilder() {
    SettlementBatchDetail._defaults(this);
  }

  SettlementBatchDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paidOn = $v.paidOn;
      _id = $v.id;
      _reference = $v.reference;
      _settlementDate = $v.settlementDate;
      _merchantsCount = $v.merchantsCount;
      _grossMillimes = $v.grossMillimes;
      _commissionMillimes = $v.commissionMillimes;
      _vatMillimes = $v.vatMillimes;
      _stampDutyMillimes = $v.stampDutyMillimes;
      _netMillimes = $v.netMillimes;
      _status = $v.status;
      _releasedAt = $v.releasedAt;
      _sentAt = $v.sentAt;
      _bankReference = $v.bankReference;
      _payouts = $v.payouts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettlementBatchDetail other) {
    _$v = other as _$SettlementBatchDetail;
  }

  @override
  void update(void Function(SettlementBatchDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettlementBatchDetail build() => _build();

  _$SettlementBatchDetail _build() {
    _$SettlementBatchDetail _$result;
    try {
      _$result =
          _$v ??
          _$SettlementBatchDetail._(
            paidOn: paidOn,
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'SettlementBatchDetail',
              'id',
            ),
            reference: BuiltValueNullFieldError.checkNotNull(
              reference,
              r'SettlementBatchDetail',
              'reference',
            ),
            settlementDate: BuiltValueNullFieldError.checkNotNull(
              settlementDate,
              r'SettlementBatchDetail',
              'settlementDate',
            ),
            merchantsCount: BuiltValueNullFieldError.checkNotNull(
              merchantsCount,
              r'SettlementBatchDetail',
              'merchantsCount',
            ),
            grossMillimes: BuiltValueNullFieldError.checkNotNull(
              grossMillimes,
              r'SettlementBatchDetail',
              'grossMillimes',
            ),
            commissionMillimes: BuiltValueNullFieldError.checkNotNull(
              commissionMillimes,
              r'SettlementBatchDetail',
              'commissionMillimes',
            ),
            vatMillimes: BuiltValueNullFieldError.checkNotNull(
              vatMillimes,
              r'SettlementBatchDetail',
              'vatMillimes',
            ),
            stampDutyMillimes: BuiltValueNullFieldError.checkNotNull(
              stampDutyMillimes,
              r'SettlementBatchDetail',
              'stampDutyMillimes',
            ),
            netMillimes: BuiltValueNullFieldError.checkNotNull(
              netMillimes,
              r'SettlementBatchDetail',
              'netMillimes',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'SettlementBatchDetail',
              'status',
            ),
            releasedAt: releasedAt,
            sentAt: sentAt,
            bankReference: bankReference,
            payouts: payouts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'payouts';
        payouts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SettlementBatchDetail',
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
