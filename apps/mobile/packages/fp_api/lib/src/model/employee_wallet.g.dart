// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_wallet.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeWallet extends EmployeeWallet {
  @override
  final String companyName;
  @override
  final int totalBalanceMillimes;
  @override
  final BuiltList<CategoryBalance> balances;

  factory _$EmployeeWallet([void Function(EmployeeWalletBuilder)? updates]) =>
      (EmployeeWalletBuilder()..update(updates))._build();

  _$EmployeeWallet._({
    required this.companyName,
    required this.totalBalanceMillimes,
    required this.balances,
  }) : super._();
  @override
  EmployeeWallet rebuild(void Function(EmployeeWalletBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmployeeWalletBuilder toBuilder() => EmployeeWalletBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeWallet &&
        companyName == other.companyName &&
        totalBalanceMillimes == other.totalBalanceMillimes &&
        balances == other.balances;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, totalBalanceMillimes.hashCode);
    _$hash = $jc(_$hash, balances.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeWallet')
          ..add('companyName', companyName)
          ..add('totalBalanceMillimes', totalBalanceMillimes)
          ..add('balances', balances))
        .toString();
  }
}

class EmployeeWalletBuilder
    implements Builder<EmployeeWallet, EmployeeWalletBuilder> {
  _$EmployeeWallet? _$v;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  int? _totalBalanceMillimes;
  int? get totalBalanceMillimes => _$this._totalBalanceMillimes;
  set totalBalanceMillimes(int? totalBalanceMillimes) =>
      _$this._totalBalanceMillimes = totalBalanceMillimes;

  ListBuilder<CategoryBalance>? _balances;
  ListBuilder<CategoryBalance> get balances =>
      _$this._balances ??= ListBuilder<CategoryBalance>();
  set balances(ListBuilder<CategoryBalance>? balances) =>
      _$this._balances = balances;

  EmployeeWalletBuilder() {
    EmployeeWallet._defaults(this);
  }

  EmployeeWalletBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _companyName = $v.companyName;
      _totalBalanceMillimes = $v.totalBalanceMillimes;
      _balances = $v.balances.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeWallet other) {
    _$v = other as _$EmployeeWallet;
  }

  @override
  void update(void Function(EmployeeWalletBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeWallet build() => _build();

  _$EmployeeWallet _build() {
    _$EmployeeWallet _$result;
    try {
      _$result =
          _$v ??
          _$EmployeeWallet._(
            companyName: BuiltValueNullFieldError.checkNotNull(
              companyName,
              r'EmployeeWallet',
              'companyName',
            ),
            totalBalanceMillimes: BuiltValueNullFieldError.checkNotNull(
              totalBalanceMillimes,
              r'EmployeeWallet',
              'totalBalanceMillimes',
            ),
            balances: balances.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'balances';
        balances.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EmployeeWallet',
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
