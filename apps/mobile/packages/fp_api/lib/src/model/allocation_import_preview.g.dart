// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_import_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AllocationImportPreview extends AllocationImportPreview {
  @override
  final BuiltList<AllocationImportRow> rows;
  @override
  final BuiltList<AllocationLine> lines;
  @override
  final BuiltList<CreditTypeAmount> totals;
  @override
  final int validCount;
  @override
  final int errorCount;

  factory _$AllocationImportPreview([
    void Function(AllocationImportPreviewBuilder)? updates,
  ]) => (AllocationImportPreviewBuilder()..update(updates))._build();

  _$AllocationImportPreview._({
    required this.rows,
    required this.lines,
    required this.totals,
    required this.validCount,
    required this.errorCount,
  }) : super._();
  @override
  AllocationImportPreview rebuild(
    void Function(AllocationImportPreviewBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AllocationImportPreviewBuilder toBuilder() =>
      AllocationImportPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocationImportPreview &&
        rows == other.rows &&
        lines == other.lines &&
        totals == other.totals &&
        validCount == other.validCount &&
        errorCount == other.errorCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rows.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, totals.hashCode);
    _$hash = $jc(_$hash, validCount.hashCode);
    _$hash = $jc(_$hash, errorCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AllocationImportPreview')
          ..add('rows', rows)
          ..add('lines', lines)
          ..add('totals', totals)
          ..add('validCount', validCount)
          ..add('errorCount', errorCount))
        .toString();
  }
}

class AllocationImportPreviewBuilder
    implements
        Builder<AllocationImportPreview, AllocationImportPreviewBuilder> {
  _$AllocationImportPreview? _$v;

  ListBuilder<AllocationImportRow>? _rows;
  ListBuilder<AllocationImportRow> get rows =>
      _$this._rows ??= ListBuilder<AllocationImportRow>();
  set rows(ListBuilder<AllocationImportRow>? rows) => _$this._rows = rows;

  ListBuilder<AllocationLine>? _lines;
  ListBuilder<AllocationLine> get lines =>
      _$this._lines ??= ListBuilder<AllocationLine>();
  set lines(ListBuilder<AllocationLine>? lines) => _$this._lines = lines;

  ListBuilder<CreditTypeAmount>? _totals;
  ListBuilder<CreditTypeAmount> get totals =>
      _$this._totals ??= ListBuilder<CreditTypeAmount>();
  set totals(ListBuilder<CreditTypeAmount>? totals) => _$this._totals = totals;

  int? _validCount;
  int? get validCount => _$this._validCount;
  set validCount(int? validCount) => _$this._validCount = validCount;

  int? _errorCount;
  int? get errorCount => _$this._errorCount;
  set errorCount(int? errorCount) => _$this._errorCount = errorCount;

  AllocationImportPreviewBuilder() {
    AllocationImportPreview._defaults(this);
  }

  AllocationImportPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rows = $v.rows.toBuilder();
      _lines = $v.lines.toBuilder();
      _totals = $v.totals.toBuilder();
      _validCount = $v.validCount;
      _errorCount = $v.errorCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocationImportPreview other) {
    _$v = other as _$AllocationImportPreview;
  }

  @override
  void update(void Function(AllocationImportPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AllocationImportPreview build() => _build();

  _$AllocationImportPreview _build() {
    _$AllocationImportPreview _$result;
    try {
      _$result =
          _$v ??
          _$AllocationImportPreview._(
            rows: rows.build(),
            lines: lines.build(),
            totals: totals.build(),
            validCount: BuiltValueNullFieldError.checkNotNull(
              validCount,
              r'AllocationImportPreview',
              'validCount',
            ),
            errorCount: BuiltValueNullFieldError.checkNotNull(
              errorCount,
              r'AllocationImportPreview',
              'errorCount',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rows';
        rows.build();
        _$failedField = 'lines';
        lines.build();
        _$failedField = 'totals';
        totals.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AllocationImportPreview',
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
