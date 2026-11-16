// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_dashboard.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyDashboard extends CompanyDashboard {
  @override
  final BuiltList<CreditTypeAmount> balances;
  @override
  final int walletBalanceMillimes;
  @override
  final int employeesCount;
  @override
  final int activeEmployeesCount;
  @override
  final int monthAllocatedMillimes;
  @override
  final int pendingOrdersCount;
  @override
  final BuiltList<CreditOrder> recentOrders;
  @override
  final BuiltList<CompanyMonthlyFlow> monthlyFlows;

  factory _$CompanyDashboard([
    void Function(CompanyDashboardBuilder)? updates,
  ]) => (CompanyDashboardBuilder()..update(updates))._build();

  _$CompanyDashboard._({
    required this.balances,
    required this.walletBalanceMillimes,
    required this.employeesCount,
    required this.activeEmployeesCount,
    required this.monthAllocatedMillimes,
    required this.pendingOrdersCount,
    required this.recentOrders,
    required this.monthlyFlows,
  }) : super._();
  @override
  CompanyDashboard rebuild(void Function(CompanyDashboardBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyDashboardBuilder toBuilder() =>
      CompanyDashboardBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyDashboard &&
        balances == other.balances &&
        walletBalanceMillimes == other.walletBalanceMillimes &&
        employeesCount == other.employeesCount &&
        activeEmployeesCount == other.activeEmployeesCount &&
        monthAllocatedMillimes == other.monthAllocatedMillimes &&
        pendingOrdersCount == other.pendingOrdersCount &&
        recentOrders == other.recentOrders &&
        monthlyFlows == other.monthlyFlows;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, balances.hashCode);
    _$hash = $jc(_$hash, walletBalanceMillimes.hashCode);
    _$hash = $jc(_$hash, employeesCount.hashCode);
    _$hash = $jc(_$hash, activeEmployeesCount.hashCode);
    _$hash = $jc(_$hash, monthAllocatedMillimes.hashCode);
    _$hash = $jc(_$hash, pendingOrdersCount.hashCode);
    _$hash = $jc(_$hash, recentOrders.hashCode);
    _$hash = $jc(_$hash, monthlyFlows.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyDashboard')
          ..add('balances', balances)
          ..add('walletBalanceMillimes', walletBalanceMillimes)
          ..add('employeesCount', employeesCount)
          ..add('activeEmployeesCount', activeEmployeesCount)
          ..add('monthAllocatedMillimes', monthAllocatedMillimes)
          ..add('pendingOrdersCount', pendingOrdersCount)
          ..add('recentOrders', recentOrders)
          ..add('monthlyFlows', monthlyFlows))
        .toString();
  }
}

class CompanyDashboardBuilder
    implements Builder<CompanyDashboard, CompanyDashboardBuilder> {
  _$CompanyDashboard? _$v;

  ListBuilder<CreditTypeAmount>? _balances;
  ListBuilder<CreditTypeAmount> get balances =>
      _$this._balances ??= ListBuilder<CreditTypeAmount>();
  set balances(ListBuilder<CreditTypeAmount>? balances) =>
      _$this._balances = balances;

  int? _walletBalanceMillimes;
  int? get walletBalanceMillimes => _$this._walletBalanceMillimes;
  set walletBalanceMillimes(int? walletBalanceMillimes) =>
      _$this._walletBalanceMillimes = walletBalanceMillimes;

  int? _employeesCount;
  int? get employeesCount => _$this._employeesCount;
  set employeesCount(int? employeesCount) =>
      _$this._employeesCount = employeesCount;

  int? _activeEmployeesCount;
  int? get activeEmployeesCount => _$this._activeEmployeesCount;
  set activeEmployeesCount(int? activeEmployeesCount) =>
      _$this._activeEmployeesCount = activeEmployeesCount;

  int? _monthAllocatedMillimes;
  int? get monthAllocatedMillimes => _$this._monthAllocatedMillimes;
  set monthAllocatedMillimes(int? monthAllocatedMillimes) =>
      _$this._monthAllocatedMillimes = monthAllocatedMillimes;

  int? _pendingOrdersCount;
  int? get pendingOrdersCount => _$this._pendingOrdersCount;
  set pendingOrdersCount(int? pendingOrdersCount) =>
      _$this._pendingOrdersCount = pendingOrdersCount;

  ListBuilder<CreditOrder>? _recentOrders;
  ListBuilder<CreditOrder> get recentOrders =>
      _$this._recentOrders ??= ListBuilder<CreditOrder>();
  set recentOrders(ListBuilder<CreditOrder>? recentOrders) =>
      _$this._recentOrders = recentOrders;

  ListBuilder<CompanyMonthlyFlow>? _monthlyFlows;
  ListBuilder<CompanyMonthlyFlow> get monthlyFlows =>
      _$this._monthlyFlows ??= ListBuilder<CompanyMonthlyFlow>();
  set monthlyFlows(ListBuilder<CompanyMonthlyFlow>? monthlyFlows) =>
      _$this._monthlyFlows = monthlyFlows;

  CompanyDashboardBuilder() {
    CompanyDashboard._defaults(this);
  }

  CompanyDashboardBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _balances = $v.balances.toBuilder();
      _walletBalanceMillimes = $v.walletBalanceMillimes;
      _employeesCount = $v.employeesCount;
      _activeEmployeesCount = $v.activeEmployeesCount;
      _monthAllocatedMillimes = $v.monthAllocatedMillimes;
      _pendingOrdersCount = $v.pendingOrdersCount;
      _recentOrders = $v.recentOrders.toBuilder();
      _monthlyFlows = $v.monthlyFlows.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyDashboard other) {
    _$v = other as _$CompanyDashboard;
  }

  @override
  void update(void Function(CompanyDashboardBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyDashboard build() => _build();

  _$CompanyDashboard _build() {
    _$CompanyDashboard _$result;
    try {
      _$result =
          _$v ??
          _$CompanyDashboard._(
            balances: balances.build(),
            walletBalanceMillimes: BuiltValueNullFieldError.checkNotNull(
              walletBalanceMillimes,
              r'CompanyDashboard',
              'walletBalanceMillimes',
            ),
            employeesCount: BuiltValueNullFieldError.checkNotNull(
              employeesCount,
              r'CompanyDashboard',
              'employeesCount',
            ),
            activeEmployeesCount: BuiltValueNullFieldError.checkNotNull(
              activeEmployeesCount,
              r'CompanyDashboard',
              'activeEmployeesCount',
            ),
            monthAllocatedMillimes: BuiltValueNullFieldError.checkNotNull(
              monthAllocatedMillimes,
              r'CompanyDashboard',
              'monthAllocatedMillimes',
            ),
            pendingOrdersCount: BuiltValueNullFieldError.checkNotNull(
              pendingOrdersCount,
              r'CompanyDashboard',
              'pendingOrdersCount',
            ),
            recentOrders: recentOrders.build(),
            monthlyFlows: monthlyFlows.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'balances';
        balances.build();

        _$failedField = 'recentOrders';
        recentOrders.build();
        _$failedField = 'monthlyFlows';
        monthlyFlows.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CompanyDashboard',
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
