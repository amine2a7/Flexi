// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_batch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettlementBatch extends SettlementBatch {
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

  factory _$SettlementBatch([void Function(SettlementBatchBuilder)? updates]) =>
      (SettlementBatchBuilder()..update(updates))._build();

  _$SettlementBatch._({
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
  }) : super._();
  @override
  SettlementBatch rebuild(void Function(SettlementBatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettlementBatchBuilder toBuilder() => SettlementBatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettlementBatch &&
        id == other.id &&
        reference == other.reference &&
        settlementDate == other.settlementDate &&
        merchantsCount == other.merchantsCount &&
        grossMillimes == other.grossMillimes &&
        commissionMillimes == other.commissionMillimes &&
        vatMillimes == other.vatMillimes &&
        stampDutyMillimes == other.stampDutyMillimes &&
        netMillimes == other.netMillimes &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SettlementBatch')
          ..add('id', id)
          ..add('reference', reference)
          ..add('settlementDate', settlementDate)
          ..add('merchantsCount', merchantsCount)
          ..add('grossMillimes', grossMillimes)
          ..add('commissionMillimes', commissionMillimes)
          ..add('vatMillimes', vatMillimes)
          ..add('stampDutyMillimes', stampDutyMillimes)
          ..add('netMillimes', netMillimes)
          ..add('status', status))
        .toString();
  }
}

class SettlementBatchBuilder
    implements Builder<SettlementBatch, SettlementBatchBuilder> {
  _$SettlementBatch? _$v;

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

  SettlementBatchBuilder() {
    SettlementBatch._defaults(this);
  }

  SettlementBatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettlementBatch other) {
    _$v = other as _$SettlementBatch;
  }

  @override
  void update(void Function(SettlementBatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettlementBatch build() => _build();

  _$SettlementBatch _build() {
    final _$result =
        _$v ??
        _$SettlementBatch._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'SettlementBatch',
            'id',
          ),
          reference: BuiltValueNullFieldError.checkNotNull(
            reference,
            r'SettlementBatch',
            'reference',
          ),
          settlementDate: BuiltValueNullFieldError.checkNotNull(
            settlementDate,
            r'SettlementBatch',
            'settlementDate',
          ),
          merchantsCount: BuiltValueNullFieldError.checkNotNull(
            merchantsCount,
            r'SettlementBatch',
            'merchantsCount',
          ),
          grossMillimes: BuiltValueNullFieldError.checkNotNull(
            grossMillimes,
            r'SettlementBatch',
            'grossMillimes',
          ),
          commissionMillimes: BuiltValueNullFieldError.checkNotNull(
            commissionMillimes,
            r'SettlementBatch',
            'commissionMillimes',
          ),
          vatMillimes: BuiltValueNullFieldError.checkNotNull(
            vatMillimes,
            r'SettlementBatch',
            'vatMillimes',
          ),
          stampDutyMillimes: BuiltValueNullFieldError.checkNotNull(
            stampDutyMillimes,
            r'SettlementBatch',
            'stampDutyMillimes',
          ),
          netMillimes: BuiltValueNullFieldError.checkNotNull(
            netMillimes,
            r'SettlementBatch',
            'netMillimes',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'SettlementBatch',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
