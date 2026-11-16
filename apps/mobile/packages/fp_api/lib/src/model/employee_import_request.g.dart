// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_import_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeImportRequest extends EmployeeImportRequest {
  @override
  final String csv;

  factory _$EmployeeImportRequest([
    void Function(EmployeeImportRequestBuilder)? updates,
  ]) => (EmployeeImportRequestBuilder()..update(updates))._build();

  _$EmployeeImportRequest._({required this.csv}) : super._();
  @override
  EmployeeImportRequest rebuild(
    void Function(EmployeeImportRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeeImportRequestBuilder toBuilder() =>
      EmployeeImportRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeImportRequest && csv == other.csv;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, csv.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'EmployeeImportRequest',
    )..add('csv', csv)).toString();
  }
}

class EmployeeImportRequestBuilder
    implements Builder<EmployeeImportRequest, EmployeeImportRequestBuilder> {
  _$EmployeeImportRequest? _$v;

  String? _csv;
  String? get csv => _$this._csv;
  set csv(String? csv) => _$this._csv = csv;

  EmployeeImportRequestBuilder() {
    EmployeeImportRequest._defaults(this);
  }

  EmployeeImportRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _csv = $v.csv;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeImportRequest other) {
    _$v = other as _$EmployeeImportRequest;
  }

  @override
  void update(void Function(EmployeeImportRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeImportRequest build() => _build();

  _$EmployeeImportRequest _build() {
    final _$result =
        _$v ??
        _$EmployeeImportRequest._(
          csv: BuiltValueNullFieldError.checkNotNull(
            csv,
            r'EmployeeImportRequest',
            'csv',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
