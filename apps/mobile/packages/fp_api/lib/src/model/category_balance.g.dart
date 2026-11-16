// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_balance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CategoryBalance extends CategoryBalance {
  @override
  final CreditType creditType;
  @override
  final int balanceMillimes;
  @override
  final int expiringMillimes;
  @override
  final int dailyLimitMillimes;
  @override
  final int todaySpentMillimes;
  @override
  final bool enabled;
  @override
  final Date? nextExpiryDate;

  factory _$CategoryBalance([void Function(CategoryBalanceBuilder)? updates]) =>
      (CategoryBalanceBuilder()..update(updates))._build();

  _$CategoryBalance._({
    required this.creditType,
    required this.balanceMillimes,
    required this.expiringMillimes,
    required this.dailyLimitMillimes,
    required this.todaySpentMillimes,
    required this.enabled,
    this.nextExpiryDate,
  }) : super._();
  @override
  CategoryBalance rebuild(void Function(CategoryBalanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CategoryBalanceBuilder toBuilder() => CategoryBalanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CategoryBalance &&
        creditType == other.creditType &&
        balanceMillimes == other.balanceMillimes &&
        expiringMillimes == other.expiringMillimes &&
        dailyLimitMillimes == other.dailyLimitMillimes &&
        todaySpentMillimes == other.todaySpentMillimes &&
        enabled == other.enabled &&
        nextExpiryDate == other.nextExpiryDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, balanceMillimes.hashCode);
    _$hash = $jc(_$hash, expiringMillimes.hashCode);
    _$hash = $jc(_$hash, dailyLimitMillimes.hashCode);
    _$hash = $jc(_$hash, todaySpentMillimes.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, nextExpiryDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CategoryBalance')
          ..add('creditType', creditType)
          ..add('balanceMillimes', balanceMillimes)
          ..add('expiringMillimes', expiringMillimes)
          ..add('dailyLimitMillimes', dailyLimitMillimes)
          ..add('todaySpentMillimes', todaySpentMillimes)
          ..add('enabled', enabled)
          ..add('nextExpiryDate', nextExpiryDate))
        .toString();
  }
}

class CategoryBalanceBuilder
    implements Builder<CategoryBalance, CategoryBalanceBuilder> {
  _$CategoryBalance? _$v;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  int? _balanceMillimes;
  int? get balanceMillimes => _$this._balanceMillimes;
  set balanceMillimes(int? balanceMillimes) =>
      _$this._balanceMillimes = balanceMillimes;

  int? _expiringMillimes;
  int? get expiringMillimes => _$this._expiringMillimes;
  set expiringMillimes(int? expiringMillimes) =>
      _$this._expiringMillimes = expiringMillimes;

  int? _dailyLimitMillimes;
  int? get dailyLimitMillimes => _$this._dailyLimitMillimes;
  set dailyLimitMillimes(int? dailyLimitMillimes) =>
      _$this._dailyLimitMillimes = dailyLimitMillimes;

  int? _todaySpentMillimes;
  int? get todaySpentMillimes => _$this._todaySpentMillimes;
  set todaySpentMillimes(int? todaySpentMillimes) =>
      _$this._todaySpentMillimes = todaySpentMillimes;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  Date? _nextExpiryDate;
  Date? get nextExpiryDate => _$this._nextExpiryDate;
  set nextExpiryDate(Date? nextExpiryDate) =>
      _$this._nextExpiryDate = nextExpiryDate;

  CategoryBalanceBuilder() {
    CategoryBalance._defaults(this);
  }

  CategoryBalanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _creditType = $v.creditType;
      _balanceMillimes = $v.balanceMillimes;
      _expiringMillimes = $v.expiringMillimes;
      _dailyLimitMillimes = $v.dailyLimitMillimes;
      _todaySpentMillimes = $v.todaySpentMillimes;
      _enabled = $v.enabled;
      _nextExpiryDate = $v.nextExpiryDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CategoryBalance other) {
    _$v = other as _$CategoryBalance;
  }

  @override
  void update(void Function(CategoryBalanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CategoryBalance build() => _build();

  _$CategoryBalance _build() {
    final _$result =
        _$v ??
        _$CategoryBalance._(
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'CategoryBalance',
            'creditType',
          ),
          balanceMillimes: BuiltValueNullFieldError.checkNotNull(
            balanceMillimes,
            r'CategoryBalance',
            'balanceMillimes',
          ),
          expiringMillimes: BuiltValueNullFieldError.checkNotNull(
            expiringMillimes,
            r'CategoryBalance',
            'expiringMillimes',
          ),
          dailyLimitMillimes: BuiltValueNullFieldError.checkNotNull(
            dailyLimitMillimes,
            r'CategoryBalance',
            'dailyLimitMillimes',
          ),
          todaySpentMillimes: BuiltValueNullFieldError.checkNotNull(
            todaySpentMillimes,
            r'CategoryBalance',
            'todaySpentMillimes',
          ),
          enabled: BuiltValueNullFieldError.checkNotNull(
            enabled,
            r'CategoryBalance',
            'enabled',
          ),
          nextExpiryDate: nextExpiryDate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
