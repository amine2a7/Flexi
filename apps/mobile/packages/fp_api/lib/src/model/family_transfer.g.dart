// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_transfer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FamilyTransfer extends FamilyTransfer {
  @override
  final String memberId;
  @override
  final CreditType creditType;
  @override
  final int amountMillimes;
  @override
  final int? dailyLimitMillimes;
  @override
  final Date? endsOn;

  factory _$FamilyTransfer([void Function(FamilyTransferBuilder)? updates]) =>
      (FamilyTransferBuilder()..update(updates))._build();

  _$FamilyTransfer._({
    required this.memberId,
    required this.creditType,
    required this.amountMillimes,
    this.dailyLimitMillimes,
    this.endsOn,
  }) : super._();
  @override
  FamilyTransfer rebuild(void Function(FamilyTransferBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FamilyTransferBuilder toBuilder() => FamilyTransferBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FamilyTransfer &&
        memberId == other.memberId &&
        creditType == other.creditType &&
        amountMillimes == other.amountMillimes &&
        dailyLimitMillimes == other.dailyLimitMillimes &&
        endsOn == other.endsOn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, dailyLimitMillimes.hashCode);
    _$hash = $jc(_$hash, endsOn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FamilyTransfer')
          ..add('memberId', memberId)
          ..add('creditType', creditType)
          ..add('amountMillimes', amountMillimes)
          ..add('dailyLimitMillimes', dailyLimitMillimes)
          ..add('endsOn', endsOn))
        .toString();
  }
}

class FamilyTransferBuilder
    implements Builder<FamilyTransfer, FamilyTransferBuilder> {
  _$FamilyTransfer? _$v;

  String? _memberId;
  String? get memberId => _$this._memberId;
  set memberId(String? memberId) => _$this._memberId = memberId;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  int? _dailyLimitMillimes;
  int? get dailyLimitMillimes => _$this._dailyLimitMillimes;
  set dailyLimitMillimes(int? dailyLimitMillimes) =>
      _$this._dailyLimitMillimes = dailyLimitMillimes;

  Date? _endsOn;
  Date? get endsOn => _$this._endsOn;
  set endsOn(Date? endsOn) => _$this._endsOn = endsOn;

  FamilyTransferBuilder() {
    FamilyTransfer._defaults(this);
  }

  FamilyTransferBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _memberId = $v.memberId;
      _creditType = $v.creditType;
      _amountMillimes = $v.amountMillimes;
      _dailyLimitMillimes = $v.dailyLimitMillimes;
      _endsOn = $v.endsOn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FamilyTransfer other) {
    _$v = other as _$FamilyTransfer;
  }

  @override
  void update(void Function(FamilyTransferBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FamilyTransfer build() => _build();

  _$FamilyTransfer _build() {
    final _$result =
        _$v ??
        _$FamilyTransfer._(
          memberId: BuiltValueNullFieldError.checkNotNull(
            memberId,
            r'FamilyTransfer',
            'memberId',
          ),
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'FamilyTransfer',
            'creditType',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'FamilyTransfer',
            'amountMillimes',
          ),
          dailyLimitMillimes: dailyLimitMillimes,
          endsOn: endsOn,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
