// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_import_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeImportPreview extends EmployeeImportPreview {
  @override
  final String previewId;
  @override
  final BuiltList<ImportRow> rows;
  @override
  final int validCount;
  @override
  final int errorCount;
  @override
  final int duplicateCount;

  factory _$EmployeeImportPreview([
    void Function(EmployeeImportPreviewBuilder)? updates,
  ]) => (EmployeeImportPreviewBuilder()..update(updates))._build();

  _$EmployeeImportPreview._({
    required this.previewId,
    required this.rows,
    required this.validCount,
    required this.errorCount,
    required this.duplicateCount,
  }) : super._();
  @override
  EmployeeImportPreview rebuild(
    void Function(EmployeeImportPreviewBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeeImportPreviewBuilder toBuilder() =>
      EmployeeImportPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeImportPreview &&
        previewId == other.previewId &&
        rows == other.rows &&
        validCount == other.validCount &&
        errorCount == other.errorCount &&
        duplicateCount == other.duplicateCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, previewId.hashCode);
    _$hash = $jc(_$hash, rows.hashCode);
    _$hash = $jc(_$hash, validCount.hashCode);
    _$hash = $jc(_$hash, errorCount.hashCode);
    _$hash = $jc(_$hash, duplicateCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeImportPreview')
          ..add('previewId', previewId)
          ..add('rows', rows)
          ..add('validCount', validCount)
          ..add('errorCount', errorCount)
          ..add('duplicateCount', duplicateCount))
        .toString();
  }
}

class EmployeeImportPreviewBuilder
    implements Builder<EmployeeImportPreview, EmployeeImportPreviewBuilder> {
  _$EmployeeImportPreview? _$v;

  String? _previewId;
  String? get previewId => _$this._previewId;
  set previewId(String? previewId) => _$this._previewId = previewId;

  ListBuilder<ImportRow>? _rows;
  ListBuilder<ImportRow> get rows => _$this._rows ??= ListBuilder<ImportRow>();
  set rows(ListBuilder<ImportRow>? rows) => _$this._rows = rows;

  int? _validCount;
  int? get validCount => _$this._validCount;
  set validCount(int? validCount) => _$this._validCount = validCount;

  int? _errorCount;
  int? get errorCount => _$this._errorCount;
  set errorCount(int? errorCount) => _$this._errorCount = errorCount;

  int? _duplicateCount;
  int? get duplicateCount => _$this._duplicateCount;
  set duplicateCount(int? duplicateCount) =>
      _$this._duplicateCount = duplicateCount;

  EmployeeImportPreviewBuilder() {
    EmployeeImportPreview._defaults(this);
  }

  EmployeeImportPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _previewId = $v.previewId;
      _rows = $v.rows.toBuilder();
      _validCount = $v.validCount;
      _errorCount = $v.errorCount;
      _duplicateCount = $v.duplicateCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeImportPreview other) {
    _$v = other as _$EmployeeImportPreview;
  }

  @override
  void update(void Function(EmployeeImportPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeImportPreview build() => _build();

  _$EmployeeImportPreview _build() {
    _$EmployeeImportPreview _$result;
    try {
      _$result =
          _$v ??
          _$EmployeeImportPreview._(
            previewId: BuiltValueNullFieldError.checkNotNull(
              previewId,
              r'EmployeeImportPreview',
              'previewId',
            ),
            rows: rows.build(),
            validCount: BuiltValueNullFieldError.checkNotNull(
              validCount,
              r'EmployeeImportPreview',
              'validCount',
            ),
            errorCount: BuiltValueNullFieldError.checkNotNull(
              errorCount,
              r'EmployeeImportPreview',
              'errorCount',
            ),
            duplicateCount: BuiltValueNullFieldError.checkNotNull(
              duplicateCount,
              r'EmployeeImportPreview',
              'duplicateCount',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rows';
        rows.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EmployeeImportPreview',
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
