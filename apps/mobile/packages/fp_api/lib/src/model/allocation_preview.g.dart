// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AllocationPreview extends AllocationPreview {
  @override
  final BuiltList<AllocationPreviewEmployee> employees;
  @override
  final int employeeCount;
  @override
  final BuiltList<AllocationPreviewLine> lines;
  @override
  final bool sufficient;

  factory _$AllocationPreview([
    void Function(AllocationPreviewBuilder)? updates,
  ]) => (AllocationPreviewBuilder()..update(updates))._build();

  _$AllocationPreview._({
    required this.employees,
    required this.employeeCount,
    required this.lines,
    required this.sufficient,
  }) : super._();
  @override
  AllocationPreview rebuild(void Function(AllocationPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AllocationPreviewBuilder toBuilder() =>
      AllocationPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocationPreview &&
        employees == other.employees &&
        employeeCount == other.employeeCount &&
        lines == other.lines &&
        sufficient == other.sufficient;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, employees.hashCode);
    _$hash = $jc(_$hash, employeeCount.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, sufficient.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AllocationPreview')
          ..add('employees', employees)
          ..add('employeeCount', employeeCount)
          ..add('lines', lines)
          ..add('sufficient', sufficient))
        .toString();
  }
}

class AllocationPreviewBuilder
    implements Builder<AllocationPreview, AllocationPreviewBuilder> {
  _$AllocationPreview? _$v;

  ListBuilder<AllocationPreviewEmployee>? _employees;
  ListBuilder<AllocationPreviewEmployee> get employees =>
      _$this._employees ??= ListBuilder<AllocationPreviewEmployee>();
  set employees(ListBuilder<AllocationPreviewEmployee>? employees) =>
      _$this._employees = employees;

  int? _employeeCount;
  int? get employeeCount => _$this._employeeCount;
  set employeeCount(int? employeeCount) =>
      _$this._employeeCount = employeeCount;

  ListBuilder<AllocationPreviewLine>? _lines;
  ListBuilder<AllocationPreviewLine> get lines =>
      _$this._lines ??= ListBuilder<AllocationPreviewLine>();
  set lines(ListBuilder<AllocationPreviewLine>? lines) => _$this._lines = lines;

  bool? _sufficient;
  bool? get sufficient => _$this._sufficient;
  set sufficient(bool? sufficient) => _$this._sufficient = sufficient;

  AllocationPreviewBuilder() {
    AllocationPreview._defaults(this);
  }

  AllocationPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _employees = $v.employees.toBuilder();
      _employeeCount = $v.employeeCount;
      _lines = $v.lines.toBuilder();
      _sufficient = $v.sufficient;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocationPreview other) {
    _$v = other as _$AllocationPreview;
  }

  @override
  void update(void Function(AllocationPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AllocationPreview build() => _build();

  _$AllocationPreview _build() {
    _$AllocationPreview _$result;
    try {
      _$result =
          _$v ??
          _$AllocationPreview._(
            employees: employees.build(),
            employeeCount: BuiltValueNullFieldError.checkNotNull(
              employeeCount,
              r'AllocationPreview',
              'employeeCount',
            ),
            lines: lines.build(),
            sufficient: BuiltValueNullFieldError.checkNotNull(
              sufficient,
              r'AllocationPreview',
              'sufficient',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'employees';
        employees.build();

        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AllocationPreview',
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
