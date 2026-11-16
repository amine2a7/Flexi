// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AllocationLine extends AllocationLine {
  @override
  final String employeeId;
  @override
  final CreditType creditType;
  @override
  final int amountMillimes;

  factory _$AllocationLine([void Function(AllocationLineBuilder)? updates]) =>
      (AllocationLineBuilder()..update(updates))._build();

  _$AllocationLine._({
    required this.employeeId,
    required this.creditType,
    required this.amountMillimes,
  }) : super._();
  @override
  AllocationLine rebuild(void Function(AllocationLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AllocationLineBuilder toBuilder() => AllocationLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocationLine &&
        employeeId == other.employeeId &&
        creditType == other.creditType &&
        amountMillimes == other.amountMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, employeeId.hashCode);
    _$hash = $jc(_$hash, creditType.hashCode);
    _$hash = $jc(_$hash, amountMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AllocationLine')
          ..add('employeeId', employeeId)
          ..add('creditType', creditType)
          ..add('amountMillimes', amountMillimes))
        .toString();
  }
}

class AllocationLineBuilder
    implements Builder<AllocationLine, AllocationLineBuilder> {
  _$AllocationLine? _$v;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  CreditType? _creditType;
  CreditType? get creditType => _$this._creditType;
  set creditType(CreditType? creditType) => _$this._creditType = creditType;

  int? _amountMillimes;
  int? get amountMillimes => _$this._amountMillimes;
  set amountMillimes(int? amountMillimes) =>
      _$this._amountMillimes = amountMillimes;

  AllocationLineBuilder() {
    AllocationLine._defaults(this);
  }

  AllocationLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _employeeId = $v.employeeId;
      _creditType = $v.creditType;
      _amountMillimes = $v.amountMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocationLine other) {
    _$v = other as _$AllocationLine;
  }

  @override
  void update(void Function(AllocationLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AllocationLine build() => _build();

  _$AllocationLine _build() {
    final _$result =
        _$v ??
        _$AllocationLine._(
          employeeId: BuiltValueNullFieldError.checkNotNull(
            employeeId,
            r'AllocationLine',
            'employeeId',
          ),
          creditType: BuiltValueNullFieldError.checkNotNull(
            creditType,
            r'AllocationLine',
            'creditType',
          ),
          amountMillimes: BuiltValueNullFieldError.checkNotNull(
            amountMillimes,
            r'AllocationLine',
            'amountMillimes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
