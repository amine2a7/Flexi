// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DepartmentList extends DepartmentList {
  @override
  final BuiltList<Department> data;

  factory _$DepartmentList([void Function(DepartmentListBuilder)? updates]) =>
      (DepartmentListBuilder()..update(updates))._build();

  _$DepartmentList._({required this.data}) : super._();
  @override
  DepartmentList rebuild(void Function(DepartmentListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DepartmentListBuilder toBuilder() => DepartmentListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DepartmentList && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'DepartmentList',
    )..add('data', data)).toString();
  }
}

class DepartmentListBuilder
    implements Builder<DepartmentList, DepartmentListBuilder> {
  _$DepartmentList? _$v;

  ListBuilder<Department>? _data;
  ListBuilder<Department> get data =>
      _$this._data ??= ListBuilder<Department>();
  set data(ListBuilder<Department>? data) => _$this._data = data;

  DepartmentListBuilder() {
    DepartmentList._defaults(this);
  }

  DepartmentListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DepartmentList other) {
    _$v = other as _$DepartmentList;
  }

  @override
  void update(void Function(DepartmentListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DepartmentList build() => _build();

  _$DepartmentList _build() {
    _$DepartmentList _$result;
    try {
      _$result = _$v ?? _$DepartmentList._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'DepartmentList',
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
