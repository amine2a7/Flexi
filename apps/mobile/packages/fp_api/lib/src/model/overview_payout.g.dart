// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_payout.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OverviewPayout extends OverviewPayout {
  @override
  final String id;
  @override
  final String reference;
  @override
  final CreditType creditType;
  @override
  final PayoutRequestStatus status;
  @override
  final int grossMillimes;
  @override
  final int netMillimes;
  @override
  final String? bankReference;
  @override
  final DateTime requestedAt;

  factory _$OverviewPayout([void Function(OverviewPayoutBuilder)? updates]) =>
      (OverviewPayoutBuilder()..update(updates))._build();

  _$OverviewPayout._({
    required this.id,
    required this.reference,
    required this.creditType,
    required this.status,
    required this.grossMillimes,
    required this.netMillimes,
    this.bankReference,
    required this.requestedAt,
  }) : super._();
  @override
  OverviewPayout rebuild(void Function(OverviewPayoutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OverviewPayoutBuilder toBuilder() => OverviewPayoutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OverviewPayout &&
        id == other.id &&
        reference == other.reference &&
        creditType == other.creditType &&
        status == other.status &&
        grossMillimes == other.grossMillimes &&
        netMillimes == other.netMillimes &&
        bankReference == other.bankReference &&
        requestedAt == other.requestedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, grossMillimes.hashCode);
    _$hash = $jc(_$hash, netMillimes.hashCode);
    _$hash = $jc(_$hash, bankReference.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OverviewPayout')
          ..add('id', id)
          ..add('reference', reference)
          ..add('creditType', creditType)
          ..add('status', status)
          ..add('grossMillimes', grossMillimes)
          ..add('netMillimes', netMillimes)
          ..add('bankReference', bankReference)
          ..add('requestedAt', requestedAt))
        .toString();
  }
}

class OverviewPayoutBuilder
    implements Builder<OverviewPayout, OverviewPayoutBuilder> {
  _$OverviewPayout? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  PayoutRequestStatus? _status;
  PayoutRequestStatus? get status => _$this._status;
  set status(PayoutRequestStatus? status) => _$this._status = status;

  int? _grossMillimes;
  int? get grossMillimes => _$this._grossMillimes;
  set grossMillimes(int? grossMillimes) =>
      _$this._grossMillimes = grossMillimes;

  int? _netMillimes;
  int? get netMillimes => _$this._netMillimes;
  set netMillimes(int? netMillimes) => _$this._netMillimes = netMillimes;

  String? _bankReference;
  String? get bankReference => _$this._bankReference;
  set bankReference(String? bankReference) =>
      _$this._bankReference = bankReference;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  OverviewPayoutBuilder() {
    OverviewPayout._defaults(this);
  }

  OverviewPayoutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _creditType = $v.creditType;
      _status = $v.status;
      _grossMillimes = $v.grossMillimes;
      _netMillimes = $v.netMillimes;
      _bankReference = $v.bankReference;
      _requestedAt = $v.requestedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OverviewPayout other) {
    _$v = other as _$OverviewPayout;
  }

  @override
  void update(void Function(OverviewPayoutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OverviewPayout build() => _build();

  _$OverviewPayout _build() {
    final _$result =
        _$v ??
        _$OverviewPayout._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'OverviewPayout',
            'id',
          ),
          reference: BuiltValueNullFieldError.checkNotNull(
            reference,
            r'OverviewPayout',
            'reference',
          ),
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'OverviewPayout',
            'creditType',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'OverviewPayout',
            'status',
          ),
          grossMillimes: BuiltValueNullFieldError.checkNotNull(
            grossMillimes,
            r'OverviewPayout',
            'grossMillimes',
          ),
          netMillimes: BuiltValueNullFieldError.checkNotNull(
            netMillimes,
            r'OverviewPayout',
            'netMillimes',
          ),
          bankReference: bankReference,
          requestedAt: BuiltValueNullFieldError.checkNotNull(
            requestedAt,
            r'OverviewPayout',
            'requestedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
