// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_import_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeImportResult extends EmployeeImportResult {
  @override
  final int createdCount;

  factory _$EmployeeImportResult([
    void Function(EmployeeImportResultBuilder)? updates,
  ]) => (EmployeeImportResultBuilder()..update(updates))._build();

  _$EmployeeImportResult._({required this.createdCount}) : super._();
  @override
  EmployeeImportResult rebuild(
    void Function(EmployeeImportResultBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeeImportResultBuilder toBuilder() =>
      EmployeeImportResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeImportResult && createdCount == other.createdCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'EmployeeImportResult',
    )..add('createdCount', createdCount)).toString();
  }
}

class EmployeeImportResultBuilder
    implements Builder<EmployeeImportResult, EmployeeImportResultBuilder> {
  _$EmployeeImportResult? _$v;

  int? _createdCount;
  int? get createdCount => _$this._createdCount;
  set createdCount(int? createdCount) => _$this._createdCount = createdCount;

  EmployeeImportResultBuilder() {
    EmployeeImportResult._defaults(this);
  }

  EmployeeImportResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdCount = $v.createdCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeImportResult other) {
    _$v = other as _$EmployeeImportResult;
  }

  @override
  void update(void Function(EmployeeImportResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeImportResult build() => _build();

  _$EmployeeImportResult _build() {
    final _$result =
        _$v ??
        _$EmployeeImportResult._(
          createdCount: BuiltValueNullFieldError.checkNotNull(
            createdCount,
            r'EmployeeImportResult',
            'createdCount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
