// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Settlement extends Settlement {
  @override
  final String id;
  @override
  final String reference;
  @override
  final Date settlementDate;
  @override
  final int paymentsCount;
  @override
  final int grossMillimes;
  @override
  final int commissionMillimes;
  @override
  final int netMillimes;
  @override
  final SettlementStatus status;

  factory _$Settlement([void Function(SettlementBuilder)? updates]) =>
      (SettlementBuilder()..update(updates))._build();

  _$Settlement._({
    required this.id,
    required this.reference,
    required this.settlementDate,
    required this.paymentsCount,
    required this.grossMillimes,
    required this.commissionMillimes,
    required this.netMillimes,
    required this.status,
  }) : super._();
  @override
  Settlement rebuild(void Function(SettlementBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettlementBuilder toBuilder() => SettlementBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Settlement &&
        id == other.id &&
        reference == other.reference &&
        settlementDate == other.settlementDate &&
        paymentsCount == other.paymentsCount &&
        grossMillimes == other.grossMillimes &&
        commissionMillimes == other.commissionMillimes &&
        netMillimes == other.netMillimes &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, settlementDate.hashCode);
    _$hash = $jc(_$hash, paymentsCount.hashCode);
    _$hash = $jc(_$hash, grossMillimes.hashCode);
    _$hash = $jc(_$hash, commissionMillimes.hashCode);
    _$hash = $jc(_$hash, netMillimes.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Settlement')
          ..add('id', id)
          ..add('reference', reference)
          ..add('settlementDate', settlementDate)
          ..add('paymentsCount', paymentsCount)
          ..add('grossMillimes', grossMillimes)
          ..add('commissionMillimes', commissionMillimes)
          ..add('netMillimes', netMillimes)
          ..add('status', status))
        .toString();
  }
}

class SettlementBuilder implements Builder<Settlement, SettlementBuilder> {
  _$Settlement? _$v;

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

  int? _paymentsCount;
  int? get paymentsCount => _$this._paymentsCount;
  set paymentsCount(int? paymentsCount) =>
      _$this._paymentsCount = paymentsCount;

  int? _grossMillimes;
  int? get grossMillimes => _$this._grossMillimes;
  set grossMillimes(int? grossMillimes) =>
      _$this._grossMillimes = grossMillimes;

  int? _commissionMillimes;
  int? get commissionMillimes => _$this._commissionMillimes;
  set commissionMillimes(int? commissionMillimes) =>
      _$this._commissionMillimes = commissionMillimes;

  int? _netMillimes;
  int? get netMillimes => _$this._netMillimes;
  set netMillimes(int? netMillimes) => _$this._netMillimes = netMillimes;

  SettlementStatus? _status;
  SettlementStatus? get status => _$this._status;
  set status(SettlementStatus? status) => _$this._status = status;

  SettlementBuilder() {
    Settlement._defaults(this);
  }

  SettlementBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _settlementDate = $v.settlementDate;
      _paymentsCount = $v.paymentsCount;
      _grossMillimes = $v.grossMillimes;
      _commissionMillimes = $v.commissionMillimes;
      _netMillimes = $v.netMillimes;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Settlement other) {
    _$v = other as _$Settlement;
  }

  @override
  void update(void Function(SettlementBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Settlement build() => _build();

  _$Settlement _build() {
    final _$result =
        _$v ??
        _$Settlement._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Settlement', 'id'),
          reference: BuiltValueNullFieldError.checkNotNull(
            reference,
            r'Settlement',
            'reference',
          ),
          settlementDate: BuiltValueNullFieldError.checkNotNull(
            settlementDate,
            r'Settlement',
            'settlementDate',
          ),
          paymentsCount: BuiltValueNullFieldError.checkNotNull(
            paymentsCount,
            r'Settlement',
            'paymentsCount',
          ),
          grossMillimes: BuiltValueNullFieldError.checkNotNull(
            grossMillimes,
            r'Settlement',
            'grossMillimes',
          ),
          commissionMillimes: BuiltValueNullFieldError.checkNotNull(
            commissionMillimes,
            r'Settlement',
            'commissionMillimes',
          ),
          netMillimes: BuiltValueNullFieldError.checkNotNull(
            netMillimes,
            r'Settlement',
            'netMillimes',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'Settlement',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
