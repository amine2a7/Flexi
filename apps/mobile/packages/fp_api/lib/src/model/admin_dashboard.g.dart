// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboard extends AdminDashboard {
  @override
  final int merchantsCount;
  @override
  final int companiesCount;
  @override
  final int todayVolumeMillimes;
  @override
  final int pendingApprovalsCount;
  @override
  final int pendingKycCount;
  @override
  final int nextSettlementNetMillimes;
  @override
  final BuiltList<CreditTypeAmount> monthByCreditType;
  @override
  final BuiltList<AdminMonthlyFlow> monthlyFlows;

  factory _$AdminDashboard([void Function(AdminDashboardBuilder)? updates]) =>
      (AdminDashboardBuilder()..update(updates))._build();

  _$AdminDashboard._({
    required this.merchantsCount,
    required this.companiesCount,
    required this.todayVolumeMillimes,
    required this.pendingApprovalsCount,
    required this.pendingKycCount,
    required this.nextSettlementNetMillimes,
    required this.monthByCreditType,
    required this.monthlyFlows,
  }) : super._();
  @override
  AdminDashboard rebuild(void Function(AdminDashboardBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardBuilder toBuilder() => AdminDashboardBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboard &&
        merchantsCount == other.merchantsCount &&
        companiesCount == other.companiesCount &&
        todayVolumeMillimes == other.todayVolumeMillimes &&
        pendingApprovalsCount == other.pendingApprovalsCount &&
        pendingKycCount == other.pendingKycCount &&
        nextSettlementNetMillimes == other.nextSettlementNetMillimes &&
        monthByCreditType == other.monthByCreditType &&
        monthlyFlows == other.monthlyFlows;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, merchantsCount.hashCode);
    _$hash = $jc(_$hash, companiesCount.hashCode);
    _$hash = $jc(_$hash, todayVolumeMillimes.hashCode);
    _$hash = $jc(_$hash, pendingApprovalsCount.hashCode);
    _$hash = $jc(_$hash, pendingKycCount.hashCode);
    _$hash = $jc(_$hash, nextSettlementNetMillimes.hashCode);
    _$hash = $jc(_$hash, monthByCreditType.hashCode);
    _$hash = $jc(_$hash, monthlyFlows.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboard')
          ..add('merchantsCount', merchantsCount)
          ..add('companiesCount', companiesCount)
          ..add('todayVolumeMillimes', todayVolumeMillimes)
          ..add('pendingApprovalsCount', pendingApprovalsCount)
          ..add('pendingKycCount', pendingKycCount)
          ..add('nextSettlementNetMillimes', nextSettlementNetMillimes)
          ..add('monthByCreditType', monthByCreditType)
          ..add('monthlyFlows', monthlyFlows))
        .toString();
  }
}

class AdminDashboardBuilder
    implements Builder<AdminDashboard, AdminDashboardBuilder> {
  _$AdminDashboard? _$v;

  int? _merchantsCount;
  int? get merchantsCount => _$this._merchantsCount;
  set merchantsCount(int? merchantsCount) =>
      _$this._merchantsCount = merchantsCount;

  int? _companiesCount;
  int? get companiesCount => _$this._companiesCount;
  set companiesCount(int? companiesCount) =>
      _$this._companiesCount = companiesCount;

  int? _todayVolumeMillimes;
  int? get todayVolumeMillimes => _$this._todayVolumeMillimes;
  set todayVolumeMillimes(int? todayVolumeMillimes) =>
      _$this._todayVolumeMillimes = todayVolumeMillimes;

  int? _pendingApprovalsCount;
  int? get pendingApprovalsCount => _$this._pendingApprovalsCount;
  set pendingApprovalsCount(int? pendingApprovalsCount) =>
      _$this._pendingApprovalsCount = pendingApprovalsCount;

  int? _pendingKycCount;
  int? get pendingKycCount => _$this._pendingKycCount;
  set pendingKycCount(int? pendingKycCount) =>
      _$this._pendingKycCount = pendingKycCount;

  int? _nextSettlementNetMillimes;
  int? get nextSettlementNetMillimes => _$this._nextSettlementNetMillimes;
  set nextSettlementNetMillimes(int? nextSettlementNetMillimes) =>
      _$this._nextSettlementNetMillimes = nextSettlementNetMillimes;

  ListBuilder<CreditTypeAmount>? _monthByCreditType;
  ListBuilder<CreditTypeAmount> get monthByCreditType =>
      _$this._monthByCreditType ??= ListBuilder<CreditTypeAmount>();
  set monthByCreditType(ListBuilder<CreditTypeAmount>? monthByCreditType) =>
      _$this._monthByCreditType = monthByCreditType;

  ListBuilder<AdminMonthlyFlow>? _monthlyFlows;
  ListBuilder<AdminMonthlyFlow> get monthlyFlows =>
      _$this._monthlyFlows ??= ListBuilder<AdminMonthlyFlow>();
  set monthlyFlows(ListBuilder<AdminMonthlyFlow>? monthlyFlows) =>
      _$this._monthlyFlows = monthlyFlows;

  AdminDashboardBuilder() {
    AdminDashboard._defaults(this);
  }

  AdminDashboardBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _merchantsCount = $v.merchantsCount;
      _companiesCount = $v.companiesCount;
      _todayVolumeMillimes = $v.todayVolumeMillimes;
      _pendingApprovalsCount = $v.pendingApprovalsCount;
      _pendingKycCount = $v.pendingKycCount;
      _nextSettlementNetMillimes = $v.nextSettlementNetMillimes;
      _monthByCreditType = $v.monthByCreditType.toBuilder();
      _monthlyFlows = $v.monthlyFlows.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboard other) {
    _$v = other as _$AdminDashboard;
  }

  @override
  void update(void Function(AdminDashboardBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboard build() => _build();

  _$AdminDashboard _build() {
    _$AdminDashboard _$result;
    try {
      _$result =
          _$v ??
          _$AdminDashboard._(
            merchantsCount: BuiltValueNullFieldError.checkNotNull(
              merchantsCount,
              r'AdminDashboard',
              'merchantsCount',
            ),
            companiesCount: BuiltValueNullFieldError.checkNotNull(
              companiesCount,
              r'AdminDashboard',
              'companiesCount',
            ),
            todayVolumeMillimes: BuiltValueNullFieldError.checkNotNull(
              todayVolumeMillimes,
              r'AdminDashboard',
              'todayVolumeMillimes',
            ),
            pendingApprovalsCount: BuiltValueNullFieldError.checkNotNull(
              pendingApprovalsCount,
              r'AdminDashboard',
              'pendingApprovalsCount',
            ),
            pendingKycCount: BuiltValueNullFieldError.checkNotNull(
              pendingKycCount,
              r'AdminDashboard',
              'pendingKycCount',
            ),
            nextSettlementNetMillimes: BuiltValueNullFieldError.checkNotNull(
              nextSettlementNetMillimes,
              r'AdminDashboard',
              'nextSettlementNetMillimes',
            ),
            monthByCreditType: monthByCreditType.build(),
            monthlyFlows: monthlyFlows.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'monthByCreditType';
        monthByCreditType.build();
        _$failedField = 'monthlyFlows';
        monthlyFlows.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDashboard',
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
