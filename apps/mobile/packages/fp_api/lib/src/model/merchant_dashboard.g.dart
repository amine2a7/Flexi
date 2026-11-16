// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_dashboard.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantDashboard extends MerchantDashboard {
  @override
  final int todayCollectedMillimes;
  @override
  final int todayPaymentsCount;
  @override
  final int receivablesMillimes;
  @override
  final Date? nextSettlementDate;
  @override
  final int? commissionRateBps;
  @override
  final BuiltList<MerchantPayment> recentPayments;
  @override
  final BuiltList<CreditTypeAmount> monthByCreditType;
  @override
  final BuiltList<MerchantMonthlyFlow> monthlyFlows;

  factory _$MerchantDashboard([
    void Function(MerchantDashboardBuilder)? updates,
  ]) => (MerchantDashboardBuilder()..update(updates))._build();

  _$MerchantDashboard._({
    required this.todayCollectedMillimes,
    required this.todayPaymentsCount,
    required this.receivablesMillimes,
    this.nextSettlementDate,
    this.commissionRateBps,
    required this.recentPayments,
    required this.monthByCreditType,
    required this.monthlyFlows,
  }) : super._();
  @override
  MerchantDashboard rebuild(void Function(MerchantDashboardBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MerchantDashboardBuilder toBuilder() =>
      MerchantDashboardBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantDashboard &&
        todayCollectedMillimes == other.todayCollectedMillimes &&
        todayPaymentsCount == other.todayPaymentsCount &&
        receivablesMillimes == other.receivablesMillimes &&
        nextSettlementDate == other.nextSettlementDate &&
        commissionRateBps == other.commissionRateBps &&
        recentPayments == other.recentPayments &&
        monthByCreditType == other.monthByCreditType &&
        monthlyFlows == other.monthlyFlows;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, todayCollectedMillimes.hashCode);
    _$hash = $jc(_$hash, todayPaymentsCount.hashCode);
    _$hash = $jc(_$hash, receivablesMillimes.hashCode);
    _$hash = $jc(_$hash, nextSettlementDate.hashCode);
    _$hash = $jc(_$hash, commissionRateBps.hashCode);
    _$hash = $jc(_$hash, recentPayments.hashCode);
    _$hash = $jc(_$hash, monthByCreditType.hashCode);
    _$hash = $jc(_$hash, monthlyFlows.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantDashboard')
          ..add('todayCollectedMillimes', todayCollectedMillimes)
          ..add('todayPaymentsCount', todayPaymentsCount)
          ..add('receivablesMillimes', receivablesMillimes)
          ..add('nextSettlementDate', nextSettlementDate)
          ..add('commissionRateBps', commissionRateBps)
          ..add('recentPayments', recentPayments)
          ..add('monthByCreditType', monthByCreditType)
          ..add('monthlyFlows', monthlyFlows))
        .toString();
  }
}

class MerchantDashboardBuilder
    implements Builder<MerchantDashboard, MerchantDashboardBuilder> {
  _$MerchantDashboard? _$v;

  int? _todayCollectedMillimes;
  int? get todayCollectedMillimes => _$this._todayCollectedMillimes;
  set todayCollectedMillimes(int? todayCollectedMillimes) =>
      _$this._todayCollectedMillimes = todayCollectedMillimes;

  int? _todayPaymentsCount;
  int? get todayPaymentsCount => _$this._todayPaymentsCount;
  set todayPaymentsCount(int? todayPaymentsCount) =>
      _$this._todayPaymentsCount = todayPaymentsCount;

  int? _receivablesMillimes;
  int? get receivablesMillimes => _$this._receivablesMillimes;
  set receivablesMillimes(int? receivablesMillimes) =>
      _$this._receivablesMillimes = receivablesMillimes;

  Date? _nextSettlementDate;
  Date? get nextSettlementDate => _$this._nextSettlementDate;
  set nextSettlementDate(Date? nextSettlementDate) =>
      _$this._nextSettlementDate = nextSettlementDate;

  int? _commissionRateBps;
  int? get commissionRateBps => _$this._commissionRateBps;
  set commissionRateBps(int? commissionRateBps) =>
      _$this._commissionRateBps = commissionRateBps;

  ListBuilder<MerchantPayment>? _recentPayments;
  ListBuilder<MerchantPayment> get recentPayments =>
      _$this._recentPayments ??= ListBuilder<MerchantPayment>();
  set recentPayments(ListBuilder<MerchantPayment>? recentPayments) =>
      _$this._recentPayments = recentPayments;

  ListBuilder<CreditTypeAmount>? _monthByCreditType;
  ListBuilder<CreditTypeAmount> get monthByCreditType =>
      _$this._monthByCreditType ??= ListBuilder<CreditTypeAmount>();
  set monthByCreditType(ListBuilder<CreditTypeAmount>? monthByCreditType) =>
      _$this._monthByCreditType = monthByCreditType;

  ListBuilder<MerchantMonthlyFlow>? _monthlyFlows;
  ListBuilder<MerchantMonthlyFlow> get monthlyFlows =>
      _$this._monthlyFlows ??= ListBuilder<MerchantMonthlyFlow>();
  set monthlyFlows(ListBuilder<MerchantMonthlyFlow>? monthlyFlows) =>
      _$this._monthlyFlows = monthlyFlows;

  MerchantDashboardBuilder() {
    MerchantDashboard._defaults(this);
  }

  MerchantDashboardBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _todayCollectedMillimes = $v.todayCollectedMillimes;
      _todayPaymentsCount = $v.todayPaymentsCount;
      _receivablesMillimes = $v.receivablesMillimes;
      _nextSettlementDate = $v.nextSettlementDate;
      _commissionRateBps = $v.commissionRateBps;
      _recentPayments = $v.recentPayments.toBuilder();
      _monthByCreditType = $v.monthByCreditType.toBuilder();
      _monthlyFlows = $v.monthlyFlows.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantDashboard other) {
    _$v = other as _$MerchantDashboard;
  }

  @override
  void update(void Function(MerchantDashboardBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantDashboard build() => _build();

  _$MerchantDashboard _build() {
    _$MerchantDashboard _$result;
    try {
      _$result =
          _$v ??
          _$MerchantDashboard._(
            todayCollectedMillimes: BuiltValueNullFieldError.checkNotNull(
              todayCollectedMillimes,
              r'MerchantDashboard',
              'todayCollectedMillimes',
            ),
            todayPaymentsCount: BuiltValueNullFieldError.checkNotNull(
              todayPaymentsCount,
              r'MerchantDashboard',
              'todayPaymentsCount',
            ),
            receivablesMillimes: BuiltValueNullFieldError.checkNotNull(
              receivablesMillimes,
              r'MerchantDashboard',
              'receivablesMillimes',
            ),
            nextSettlementDate: nextSettlementDate,
            commissionRateBps: commissionRateBps,
            recentPayments: recentPayments.build(),
            monthByCreditType: monthByCreditType.build(),
            monthlyFlows: monthlyFlows.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'recentPayments';
        recentPayments.build();
        _$failedField = 'monthByCreditType';
        monthByCreditType.build();
        _$failedField = 'monthlyFlows';
        monthlyFlows.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantDashboard',
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
