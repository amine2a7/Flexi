// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_monthly_flow.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyMonthlyFlow extends CompanyMonthlyFlow {
  @override
  final String month;
  @override
  final int creditedMillimes;
  @override
  final int allocatedMillimes;

  factory _$CompanyMonthlyFlow([
    void Function(CompanyMonthlyFlowBuilder)? updates,
  ]) => (CompanyMonthlyFlowBuilder()..update(updates))._build();

  _$CompanyMonthlyFlow._({
    required this.month,
    required this.creditedMillimes,
    required this.allocatedMillimes,
  }) : super._();
  @override
  CompanyMonthlyFlow rebuild(
    void Function(CompanyMonthlyFlowBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CompanyMonthlyFlowBuilder toBuilder() =>
      CompanyMonthlyFlowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyMonthlyFlow &&
        month == other.month &&
        creditedMillimes == other.creditedMillimes &&
        allocatedMillimes == other.allocatedMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, month.hashCode);
    _$hash = $jc(_$hash, creditedMillimes.hashCode);
    _$hash = $jc(_$hash, allocatedMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyMonthlyFlow')
          ..add('month', month)
          ..add('creditedMillimes', creditedMillimes)
          ..add('allocatedMillimes', allocatedMillimes))
        .toString();
  }
}

class CompanyMonthlyFlowBuilder
    implements Builder<CompanyMonthlyFlow, CompanyMonthlyFlowBuilder> {
  _$CompanyMonthlyFlow? _$v;

  String? _month;
  String? get month => _$this._month;
  set month(String? month) => _$this._month = month;

  int? _creditedMillimes;
  int? get creditedMillimes => _$this._creditedMillimes;
  set creditedMillimes(int? creditedMillimes) =>
      _$this._creditedMillimes = creditedMillimes;

  int? _allocatedMillimes;
  int? get allocatedMillimes => _$this._allocatedMillimes;
  set allocatedMillimes(int? allocatedMillimes) =>
      _$this._allocatedMillimes = allocatedMillimes;

  CompanyMonthlyFlowBuilder() {
    CompanyMonthlyFlow._defaults(this);
  }

  CompanyMonthlyFlowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _month = $v.month;
      _creditedMillimes = $v.creditedMillimes;
      _allocatedMillimes = $v.allocatedMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyMonthlyFlow other) {
    _$v = other as _$CompanyMonthlyFlow;
  }

  @override
  void update(void Function(CompanyMonthlyFlowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyMonthlyFlow build() => _build();

  _$CompanyMonthlyFlow _build() {
    final _$result =
        _$v ??
        _$CompanyMonthlyFlow._(
          month: BuiltValueNullFieldError.checkNotNull(
            month,
            r'CompanyMonthlyFlow',
            'month',
          ),
          creditedMillimes: BuiltValueNullFieldError.checkNotNull(
            creditedMillimes,
            r'CompanyMonthlyFlow',
            'creditedMillimes',
          ),
          allocatedMillimes: BuiltValueNullFieldError.checkNotNull(
            allocatedMillimes,
            r'CompanyMonthlyFlow',
            'allocatedMillimes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
