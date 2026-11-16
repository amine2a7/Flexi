// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_overview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyOverview extends CompanyOverview {
  @override
  final OverviewKyc? kyc;
  @override
  final BuiltList<OverviewUser> users;
  @override
  final BuiltList<Department> departments;
  @override
  final int employeeCount;
  @override
  final BuiltList<OverviewEmployee> employees;
  @override
  final BuiltList<CreditTypeAmount> balances;
  @override
  final BuiltList<OverviewOrder> orders;
  @override
  final BuiltList<OverviewAllocation> allocations;
  @override
  final BuiltList<AllocationTemplate> templates;
  @override
  final BuiltList<OverviewInvoice> invoices;

  factory _$CompanyOverview([void Function(CompanyOverviewBuilder)? updates]) =>
      (CompanyOverviewBuilder()..update(updates))._build();

  _$CompanyOverview._({
    this.kyc,
    required this.users,
    required this.departments,
    required this.employeeCount,
    required this.employees,
    required this.balances,
    required this.orders,
    required this.allocations,
    required this.templates,
    required this.invoices,
  }) : super._();
  @override
  CompanyOverview rebuild(void Function(CompanyOverviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyOverviewBuilder toBuilder() => CompanyOverviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyOverview &&
        kyc == other.kyc &&
        users == other.users &&
        departments == other.departments &&
        employeeCount == other.employeeCount &&
        employees == other.employees &&
        balances == other.balances &&
        orders == other.orders &&
        allocations == other.allocations &&
        templates == other.templates &&
        invoices == other.invoices;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kyc.hashCode);
    _$hash = $jc(_$hash, users.hashCode);
    _$hash = $jc(_$hash, departments.hashCode);
    _$hash = $jc(_$hash, employeeCount.hashCode);
    _$hash = $jc(_$hash, employees.hashCode);
    _$hash = $jc(_$hash, balances.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, allocations.hashCode);
    _$hash = $jc(_$hash, templates.hashCode);
    _$hash = $jc(_$hash, invoices.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyOverview')
          ..add('kyc', kyc)
          ..add('users', users)
          ..add('departments', departments)
          ..add('employeeCount', employeeCount)
          ..add('employees', employees)
          ..add('balances', balances)
          ..add('orders', orders)
          ..add('allocations', allocations)
          ..add('templates', templates)
          ..add('invoices', invoices))
        .toString();
  }
}

class CompanyOverviewBuilder
    implements Builder<CompanyOverview, CompanyOverviewBuilder> {
  _$CompanyOverview? _$v;

  OverviewKycBuilder? _kyc;
  OverviewKycBuilder get kyc => _$this._kyc ??= OverviewKycBuilder();
  set kyc(OverviewKycBuilder? kyc) => _$this._kyc = kyc;

  ListBuilder<OverviewUser>? _users;
  ListBuilder<OverviewUser> get users =>
      _$this._users ??= ListBuilder<OverviewUser>();
  set users(ListBuilder<OverviewUser>? users) => _$this._users = users;

  ListBuilder<Department>? _departments;
  ListBuilder<Department> get departments =>
      _$this._departments ??= ListBuilder<Department>();
  set departments(ListBuilder<Department>? departments) =>
      _$this._departments = departments;

  int? _employeeCount;
  int? get employeeCount => _$this._employeeCount;
  set employeeCount(int? employeeCount) =>
      _$this._employeeCount = employeeCount;

  ListBuilder<OverviewEmployee>? _employees;
  ListBuilder<OverviewEmployee> get employees =>
      _$this._employees ??= ListBuilder<OverviewEmployee>();
  set employees(ListBuilder<OverviewEmployee>? employees) =>
      _$this._employees = employees;

  ListBuilder<CreditTypeAmount>? _balances;
  ListBuilder<CreditTypeAmount> get balances =>
      _$this._balances ??= ListBuilder<CreditTypeAmount>();
  set balances(ListBuilder<CreditTypeAmount>? balances) =>
      _$this._balances = balances;

  ListBuilder<OverviewOrder>? _orders;
  ListBuilder<OverviewOrder> get orders =>
      _$this._orders ??= ListBuilder<OverviewOrder>();
  set orders(ListBuilder<OverviewOrder>? orders) => _$this._orders = orders;

  ListBuilder<OverviewAllocation>? _allocations;
  ListBuilder<OverviewAllocation> get allocations =>
      _$this._allocations ??= ListBuilder<OverviewAllocation>();
  set allocations(ListBuilder<OverviewAllocation>? allocations) =>
      _$this._allocations = allocations;

  ListBuilder<AllocationTemplate>? _templates;
  ListBuilder<AllocationTemplate> get templates =>
      _$this._templates ??= ListBuilder<AllocationTemplate>();
  set templates(ListBuilder<AllocationTemplate>? templates) =>
      _$this._templates = templates;

  ListBuilder<OverviewInvoice>? _invoices;
  ListBuilder<OverviewInvoice> get invoices =>
      _$this._invoices ??= ListBuilder<OverviewInvoice>();
  set invoices(ListBuilder<OverviewInvoice>? invoices) =>
      _$this._invoices = invoices;

  CompanyOverviewBuilder() {
    CompanyOverview._defaults(this);
  }

  CompanyOverviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kyc = $v.kyc?.toBuilder();
      _users = $v.users.toBuilder();
      _departments = $v.departments.toBuilder();
      _employeeCount = $v.employeeCount;
      _employees = $v.employees.toBuilder();
      _balances = $v.balances.toBuilder();
      _orders = $v.orders.toBuilder();
      _allocations = $v.allocations.toBuilder();
      _templates = $v.templates.toBuilder();
      _invoices = $v.invoices.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyOverview other) {
    _$v = other as _$CompanyOverview;
  }

  @override
  void update(void Function(CompanyOverviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyOverview build() => _build();

  _$CompanyOverview _build() {
    _$CompanyOverview _$result;
    try {
      _$result =
          _$v ??
          _$CompanyOverview._(
            kyc: _kyc?.build(),
            users: users.build(),
            departments: departments.build(),
            employeeCount: BuiltValueNullFieldError.checkNotNull(
              employeeCount,
              r'CompanyOverview',
              'employeeCount',
            ),
            employees: employees.build(),
            balances: balances.build(),
            orders: orders.build(),
            allocations: allocations.build(),
            templates: templates.build(),
            invoices: invoices.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'kyc';
        _kyc?.build();
        _$failedField = 'users';
        users.build();
        _$failedField = 'departments';
        departments.build();

        _$failedField = 'employees';
        employees.build();
        _$failedField = 'balances';
        balances.build();
        _$failedField = 'orders';
        orders.build();
        _$failedField = 'allocations';
        allocations.build();
        _$failedField = 'templates';
        templates.build();
        _$failedField = 'invoices';
        invoices.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CompanyOverview',
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
