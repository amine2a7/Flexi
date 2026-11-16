// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_preview_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AllocationPreviewLine extends AllocationPreviewLine {
  @override
  final CreditType creditType;
  @override
  final int perEmployeeMillimes;
  @override
  final int totalMillimes;
  @override
  final int balanceMillimes;
  @override
  final int remainingMillimes;
  @override
  final int missingMillimes;

  factory _$AllocationPreviewLine([
    void Function(AllocationPreviewLineBuilder)? updates,
  ]) => (AllocationPreviewLineBuilder()..update(updates))._build();

  _$AllocationPreviewLine._({
    required this.creditType,
    required this.perEmployeeMillimes,
    required this.totalMillimes,
    required this.balanceMillimes,
    required this.remainingMillimes,
    required this.missingMillimes,
  }) : super._();
  @override
  AllocationPreviewLine rebuild(
    void Function(AllocationPreviewLineBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AllocationPreviewLineBuilder toBuilder() =>
      AllocationPreviewLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocationPreviewLine &&
        creditType == other.creditType &&
        perEmployeeMillimes == other.perEmployeeMillimes &&
        totalMillimes == other.totalMillimes &&
        balanceMillimes == other.balanceMillimes &&
        remainingMillimes == other.remainingMillimes &&
        missingMillimes == other.missingMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, perEmployeeMillimes.hashCode);
    _$hash = $jc(_$hash, totalMillimes.hashCode);
    _$hash = $jc(_$hash, balanceMillimes.hashCode);
    _$hash = $jc(_$hash, remainingMillimes.hashCode);
    _$hash = $jc(_$hash, missingMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AllocationPreviewLine')
          ..add('creditType', creditType)
          ..add('perEmployeeMillimes', perEmployeeMillimes)
          ..add('totalMillimes', totalMillimes)
          ..add('balanceMillimes', balanceMillimes)
          ..add('remainingMillimes', remainingMillimes)
          ..add('missingMillimes', missingMillimes))
        .toString();
  }
}

class AllocationPreviewLineBuilder
    implements Builder<AllocationPreviewLine, AllocationPreviewLineBuilder> {
  _$AllocationPreviewLine? _$v;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  int? _perEmployeeMillimes;
  int? get perEmployeeMillimes => _$this._perEmployeeMillimes;
  set perEmployeeMillimes(int? perEmployeeMillimes) =>
      _$this._perEmployeeMillimes = perEmployeeMillimes;

  int? _totalMillimes;
  int? get totalMillimes => _$this._totalMillimes;
  set totalMillimes(int? totalMillimes) =>
      _$this._totalMillimes = totalMillimes;

  int? _balanceMillimes;
  int? get balanceMillimes => _$this._balanceMillimes;
  set balanceMillimes(int? balanceMillimes) =>
      _$this._balanceMillimes = balanceMillimes;

  int? _remainingMillimes;
  int? get remainingMillimes => _$this._remainingMillimes;
  set remainingMillimes(int? remainingMillimes) =>
      _$this._remainingMillimes = remainingMillimes;

  int? _missingMillimes;
  int? get missingMillimes => _$this._missingMillimes;
  set missingMillimes(int? missingMillimes) =>
      _$this._missingMillimes = missingMillimes;

  AllocationPreviewLineBuilder() {
    AllocationPreviewLine._defaults(this);
  }

  AllocationPreviewLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _creditType = $v.creditType;
      _perEmployeeMillimes = $v.perEmployeeMillimes;
      _totalMillimes = $v.totalMillimes;
      _balanceMillimes = $v.balanceMillimes;
      _remainingMillimes = $v.remainingMillimes;
      _missingMillimes = $v.missingMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocationPreviewLine other) {
    _$v = other as _$AllocationPreviewLine;
  }

  @override
  void update(void Function(AllocationPreviewLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AllocationPreviewLine build() => _build();

  _$AllocationPreviewLine _build() {
    final _$result =
        _$v ??
        _$AllocationPreviewLine._(
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'AllocationPreviewLine',
            'creditType',
          ),
          perEmployeeMillimes: BuiltValueNullFieldError.checkNotNull(
            perEmployeeMillimes,
            r'AllocationPreviewLine',
            'perEmployeeMillimes',
          ),
          totalMillimes: BuiltValueNullFieldError.checkNotNull(
            totalMillimes,
            r'AllocationPreviewLine',
            'totalMillimes',
          ),
          balanceMillimes: BuiltValueNullFieldError.checkNotNull(
            balanceMillimes,
            r'AllocationPreviewLine',
            'balanceMillimes',
          ),
          remainingMillimes: BuiltValueNullFieldError.checkNotNull(
            remainingMillimes,
            r'AllocationPreviewLine',
            'remainingMillimes',
          ),
          missingMillimes: BuiltValueNullFieldError.checkNotNull(
            missingMillimes,
            r'AllocationPreviewLine',
            'missingMillimes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
