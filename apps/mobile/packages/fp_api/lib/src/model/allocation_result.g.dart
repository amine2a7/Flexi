// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AllocationResult extends AllocationResult {
  @override
  final BuiltList<CreditTypeAmount> balances;
  @override
  final int allocatedCount;
  @override
  final int allocatedMillimes;
  @override
  final int walletBalanceMillimes;

  factory _$AllocationResult([
    void Function(AllocationResultBuilder)? updates,
  ]) => (AllocationResultBuilder()..update(updates))._build();

  _$AllocationResult._({
    required this.balances,
    required this.allocatedCount,
    required this.allocatedMillimes,
    required this.walletBalanceMillimes,
  }) : super._();
  @override
  AllocationResult rebuild(void Function(AllocationResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AllocationResultBuilder toBuilder() =>
      AllocationResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocationResult &&
        balances == other.balances &&
        allocatedCount == other.allocatedCount &&
        allocatedMillimes == other.allocatedMillimes &&
        walletBalanceMillimes == other.walletBalanceMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, balances.hashCode);
    _$hash = $jc(_$hash, allocatedCount.hashCode);
    _$hash = $jc(_$hash, allocatedMillimes.hashCode);
    _$hash = $jc(_$hash, walletBalanceMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AllocationResult')
          ..add('balances', balances)
          ..add('allocatedCount', allocatedCount)
          ..add('allocatedMillimes', allocatedMillimes)
          ..add('walletBalanceMillimes', walletBalanceMillimes))
        .toString();
  }
}

class AllocationResultBuilder
    implements Builder<AllocationResult, AllocationResultBuilder> {
  _$AllocationResult? _$v;

  ListBuilder<CreditTypeAmount>? _balances;
  ListBuilder<CreditTypeAmount> get balances =>
      _$this._balances ??= ListBuilder<CreditTypeAmount>();
  set balances(ListBuilder<CreditTypeAmount>? balances) =>
      _$this._balances = balances;

  int? _allocatedCount;
  int? get allocatedCount => _$this._allocatedCount;
  set allocatedCount(int? allocatedCount) =>
      _$this._allocatedCount = allocatedCount;

  int? _allocatedMillimes;
  int? get allocatedMillimes => _$this._allocatedMillimes;
  set allocatedMillimes(int? allocatedMillimes) =>
      _$this._allocatedMillimes = allocatedMillimes;

  int? _walletBalanceMillimes;
  int? get walletBalanceMillimes => _$this._walletBalanceMillimes;
  set walletBalanceMillimes(int? walletBalanceMillimes) =>
      _$this._walletBalanceMillimes = walletBalanceMillimes;

  AllocationResultBuilder() {
    AllocationResult._defaults(this);
  }

  AllocationResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _balances = $v.balances.toBuilder();
      _allocatedCount = $v.allocatedCount;
      _allocatedMillimes = $v.allocatedMillimes;
      _walletBalanceMillimes = $v.walletBalanceMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocationResult other) {
    _$v = other as _$AllocationResult;
  }

  @override
  void update(void Function(AllocationResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AllocationResult build() => _build();

  _$AllocationResult _build() {
    _$AllocationResult _$result;
    try {
      _$result =
          _$v ??
          _$AllocationResult._(
            balances: balances.build(),
            allocatedCount: BuiltValueNullFieldError.checkNotNull(
              allocatedCount,
              r'AllocationResult',
              'allocatedCount',
            ),
            allocatedMillimes: BuiltValueNullFieldError.checkNotNull(
              allocatedMillimes,
              r'AllocationResult',
              'allocatedMillimes',
            ),
            walletBalanceMillimes: BuiltValueNullFieldError.checkNotNull(
              walletBalanceMillimes,
              r'AllocationResult',
              'walletBalanceMillimes',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'balances';
        balances.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AllocationResult',
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
