// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_import_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AllocationImportRequest extends AllocationImportRequest {
  @override
  final String csv;

  factory _$AllocationImportRequest([
    void Function(AllocationImportRequestBuilder)? updates,
  ]) => (AllocationImportRequestBuilder()..update(updates))._build();

  _$AllocationImportRequest._({required this.csv}) : super._();
  @override
  AllocationImportRequest rebuild(
    void Function(AllocationImportRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AllocationImportRequestBuilder toBuilder() =>
      AllocationImportRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocationImportRequest && csv == other.csv;
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
      r'AllocationImportRequest',
    )..add('csv', csv)).toString();
  }
}

class AllocationImportRequestBuilder
    implements
        Builder<AllocationImportRequest, AllocationImportRequestBuilder> {
  _$AllocationImportRequest? _$v;

  String? _csv;
  String? get csv => _$this._csv;
  set csv(String? csv) => _$this._csv = csv;

  AllocationImportRequestBuilder() {
    AllocationImportRequest._defaults(this);
  }

  AllocationImportRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _csv = $v.csv;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocationImportRequest other) {
    _$v = other as _$AllocationImportRequest;
  }

  @override
  void update(void Function(AllocationImportRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AllocationImportRequest build() => _build();

  _$AllocationImportRequest _build() {
    final _$result =
        _$v ??
        _$AllocationImportRequest._(
          csv: BuiltValueNullFieldError.checkNotNull(
            csv,
            r'AllocationImportRequest',
            'csv',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
