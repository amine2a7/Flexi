// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_bulk_status_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeBulkStatusResult extends EmployeeBulkStatusResult {
  @override
  final BuiltList<EmployeeBulkStatusResultResultsInner> results;

  factory _$EmployeeBulkStatusResult([
    void Function(EmployeeBulkStatusResultBuilder)? updates,
  ]) => (EmployeeBulkStatusResultBuilder()..update(updates))._build();

  _$EmployeeBulkStatusResult._({required this.results}) : super._();
  @override
  EmployeeBulkStatusResult rebuild(
    void Function(EmployeeBulkStatusResultBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeeBulkStatusResultBuilder toBuilder() =>
      EmployeeBulkStatusResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeBulkStatusResult && results == other.results;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, results.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'EmployeeBulkStatusResult',
    )..add('results', results)).toString();
  }
}

class EmployeeBulkStatusResultBuilder
    implements
        Builder<EmployeeBulkStatusResult, EmployeeBulkStatusResultBuilder> {
  _$EmployeeBulkStatusResult? _$v;

  ListBuilder<EmployeeBulkStatusResultResultsInner>? _results;
  ListBuilder<EmployeeBulkStatusResultResultsInner> get results =>
      _$this._results ??= ListBuilder<EmployeeBulkStatusResultResultsInner>();
  set results(ListBuilder<EmployeeBulkStatusResultResultsInner>? results) =>
      _$this._results = results;

  EmployeeBulkStatusResultBuilder() {
    EmployeeBulkStatusResult._defaults(this);
  }

  EmployeeBulkStatusResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _results = $v.results.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeBulkStatusResult other) {
    _$v = other as _$EmployeeBulkStatusResult;
  }

  @override
  void update(void Function(EmployeeBulkStatusResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeBulkStatusResult build() => _build();

  _$EmployeeBulkStatusResult _build() {
    _$EmployeeBulkStatusResult _$result;
    try {
      _$result = _$v ?? _$EmployeeBulkStatusResult._(results: results.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'results';
        results.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EmployeeBulkStatusResult',
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
