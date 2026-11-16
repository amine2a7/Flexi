// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_allocation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OverviewAllocation extends OverviewAllocation {
  @override
  final String transactionId;
  @override
  final DateTime allocatedAt;
  @override
  final int lineCount;
  @override
  final int totalMillimes;
  @override
  final String? templateName;

  factory _$OverviewAllocation([
    void Function(OverviewAllocationBuilder)? updates,
  ]) => (OverviewAllocationBuilder()..update(updates))._build();

  _$OverviewAllocation._({
    required this.transactionId,
    required this.allocatedAt,
    required this.lineCount,
    required this.totalMillimes,
    this.templateName,
  }) : super._();
  @override
  OverviewAllocation rebuild(
    void Function(OverviewAllocationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  OverviewAllocationBuilder toBuilder() =>
      OverviewAllocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OverviewAllocation &&
        transactionId == other.transactionId &&
        allocatedAt == other.allocatedAt &&
        lineCount == other.lineCount &&
        totalMillimes == other.totalMillimes &&
        templateName == other.templateName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, transactionId.hashCode);
    _$hash = $jc(_$hash, allocatedAt.hashCode);
    _$hash = $jc(_$hash, lineCount.hashCode);
    _$hash = $jc(_$hash, totalMillimes.hashCode);
    _$hash = $jc(_$hash, templateName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OverviewAllocation')
          ..add('transactionId', transactionId)
          ..add('allocatedAt', allocatedAt)
          ..add('lineCount', lineCount)
          ..add('totalMillimes', totalMillimes)
          ..add('templateName', templateName))
        .toString();
  }
}

class OverviewAllocationBuilder
    implements Builder<OverviewAllocation, OverviewAllocationBuilder> {
  _$OverviewAllocation? _$v;

  String? _transactionId;
  String? get transactionId => _$this._transactionId;
  set transactionId(String? transactionId) =>
      _$this._transactionId = transactionId;

  DateTime? _allocatedAt;
  DateTime? get allocatedAt => _$this._allocatedAt;
  set allocatedAt(DateTime? allocatedAt) => _$this._allocatedAt = allocatedAt;

  int? _lineCount;
  int? get lineCount => _$this._lineCount;
  set lineCount(int? lineCount) => _$this._lineCount = lineCount;

  int? _totalMillimes;
  int? get totalMillimes => _$this._totalMillimes;
  set totalMillimes(int? totalMillimes) =>
      _$this._totalMillimes = totalMillimes;

  String? _templateName;
  String? get templateName => _$this._templateName;
  set templateName(String? templateName) => _$this._templateName = templateName;

  OverviewAllocationBuilder() {
    OverviewAllocation._defaults(this);
  }

  OverviewAllocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _transactionId = $v.transactionId;
      _allocatedAt = $v.allocatedAt;
      _lineCount = $v.lineCount;
      _totalMillimes = $v.totalMillimes;
      _templateName = $v.templateName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OverviewAllocation other) {
    _$v = other as _$OverviewAllocation;
  }

  @override
  void update(void Function(OverviewAllocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OverviewAllocation build() => _build();

  _$OverviewAllocation _build() {
    final _$result =
        _$v ??
        _$OverviewAllocation._(
          transactionId: BuiltValueNullFieldError.checkNotNull(
            transactionId,
            r'OverviewAllocation',
            'transactionId',
          ),
          allocatedAt: BuiltValueNullFieldError.checkNotNull(
            allocatedAt,
            r'OverviewAllocation',
            'allocatedAt',
          ),
          lineCount: BuiltValueNullFieldError.checkNotNull(
            lineCount,
            r'OverviewAllocation',
            'lineCount',
          ),
          totalMillimes: BuiltValueNullFieldError.checkNotNull(
            totalMillimes,
            r'OverviewAllocation',
            'totalMillimes',
          ),
          templateName: templateName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
