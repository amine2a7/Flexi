// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member_balance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FamilyMemberBalance extends FamilyMemberBalance {
  @override
  final CreditType creditType;
  @override
  final int amountMillimes;
  @override
  final int? dailyLimitMillimes;
  @override
  final Date? endsOn;

  factory _$FamilyMemberBalance([
    void Function(FamilyMemberBalanceBuilder)? updates,
  ]) => (FamilyMemberBalanceBuilder()..update(updates))._build();

  _$FamilyMemberBalance._({
    required this.creditType,
    required this.amountMillimes,
    this.dailyLimitMillimes,
    this.endsOn,
  }) : super._();
  @override
  FamilyMemberBalance rebuild(
    void Function(FamilyMemberBalanceBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  FamilyMemberBalanceBuilder toBuilder() =>
      FamilyMemberBalanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FamilyMemberBalance &&
        creditType == other.creditType &&
        amountMillimes == other.amountMillimes &&
        dailyLimitMillimes == other.dailyLimitMillimes &&
        endsOn == other.endsOn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jc(_$hash, dailyLimitMillimes.hashCode);
    _$hash = $jc(_$hash, endsOn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FamilyMemberBalance')
          ..add('creditType', creditType)
          ..add('amountMillimes', amountMillimes)
          ..add('dailyLimitMillimes', dailyLimitMillimes)
          ..add('endsOn', endsOn))
        .toString();
  }
}

class FamilyMemberBalanceBuilder
    implements Builder<FamilyMemberBalance, FamilyMemberBalanceBuilder> {
  _$FamilyMemberBalance? _$v;

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

  FamilyMemberBalanceBuilder() {
    FamilyMemberBalance._defaults(this);
  }

  FamilyMemberBalanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _creditType = $v.creditType;
      _amountMillimes = $v.amountMillimes;
      _dailyLimitMillimes = $v.dailyLimitMillimes;
      _endsOn = $v.endsOn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FamilyMemberBalance other) {
    _$v = other as _$FamilyMemberBalance;
  }

  @override
  void update(void Function(FamilyMemberBalanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FamilyMemberBalance build() => _build();

  _$FamilyMemberBalance _build() {
    final _$result =
        _$v ??
        _$FamilyMemberBalance._(
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'FamilyMemberBalance',
            'creditType',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'FamilyMemberBalance',
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
