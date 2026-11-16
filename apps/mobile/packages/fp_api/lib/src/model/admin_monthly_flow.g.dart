// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_monthly_flow.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMonthlyFlow extends AdminMonthlyFlow {
  @override
  final String month;
  @override
  final int creditedMillimes;
  @override
  final int paymentsMillimes;

  factory _$AdminMonthlyFlow([
    void Function(AdminMonthlyFlowBuilder)? updates,
  ]) => (AdminMonthlyFlowBuilder()..update(updates))._build();

  _$AdminMonthlyFlow._({
    required this.month,
    required this.creditedMillimes,
    required this.paymentsMillimes,
  }) : super._();
  @override
  AdminMonthlyFlow rebuild(void Function(AdminMonthlyFlowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminMonthlyFlowBuilder toBuilder() =>
      AdminMonthlyFlowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMonthlyFlow &&
        month == other.month &&
        creditedMillimes == other.creditedMillimes &&
        paymentsMillimes == other.paymentsMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, month.hashCode);
    _$hash = $jc(_$hash, creditedMillimes.hashCode);
    _$hash = $jc(_$hash, paymentsMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMonthlyFlow')
          ..add('month', month)
          ..add('creditedMillimes', creditedMillimes)
          ..add('paymentsMillimes', paymentsMillimes))
        .toString();
  }
}

class AdminMonthlyFlowBuilder
    implements Builder<AdminMonthlyFlow, AdminMonthlyFlowBuilder> {
  _$AdminMonthlyFlow? _$v;

  String? _month;
  String? get month => _$this._month;
  set month(String? month) => _$this._month = month;

  int? _creditedMillimes;
  int? get creditedMillimes => _$this._creditedMillimes;
  set creditedMillimes(int? creditedMillimes) =>
      _$this._creditedMillimes = creditedMillimes;

  int? _paymentsMillimes;
  int? get paymentsMillimes => _$this._paymentsMillimes;
  set paymentsMillimes(int? paymentsMillimes) =>
      _$this._paymentsMillimes = paymentsMillimes;

  AdminMonthlyFlowBuilder() {
    AdminMonthlyFlow._defaults(this);
  }

  AdminMonthlyFlowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _month = $v.month;
      _creditedMillimes = $v.creditedMillimes;
      _paymentsMillimes = $v.paymentsMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMonthlyFlow other) {
    _$v = other as _$AdminMonthlyFlow;
  }

  @override
  void update(void Function(AdminMonthlyFlowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMonthlyFlow build() => _build();

  _$AdminMonthlyFlow _build() {
    final _$result =
        _$v ??
        _$AdminMonthlyFlow._(
          month: BuiltValueNullFieldError.checkNotNull(
            month,
            r'AdminMonthlyFlow',
            'month',
          ),
          creditedMillimes: BuiltValueNullFieldError.checkNotNull(
            creditedMillimes,
            r'AdminMonthlyFlow',
            'creditedMillimes',
          ),
          paymentsMillimes: BuiltValueNullFieldError.checkNotNull(
            paymentsMillimes,
            r'AdminMonthlyFlow',
            'paymentsMillimes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
