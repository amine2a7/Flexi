// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeePage extends EmployeePage {
  @override
  final BuiltList<Employee> data;
  @override
  final int? graceDays;
  @override
  final PageInfo page;

  factory _$EmployeePage([void Function(EmployeePageBuilder)? updates]) =>
      (EmployeePageBuilder()..update(updates))._build();

  _$EmployeePage._({required this.data, this.graceDays, required this.page})
    : super._();
  @override
  EmployeePage rebuild(void Function(EmployeePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmployeePageBuilder toBuilder() => EmployeePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeePage &&
        data == other.data &&
        graceDays == other.graceDays &&
        page == other.page;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, graceDays.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeePage')
          ..add('data', data)
          ..add('graceDays', graceDays)
          ..add('page', page))
        .toString();
  }
}

class EmployeePageBuilder
    implements Builder<EmployeePage, EmployeePageBuilder> {
  _$EmployeePage? _$v;

  ListBuilder<Employee>? _data;
  ListBuilder<Employee> get data => _$this._data ??= ListBuilder<Employee>();
  set data(ListBuilder<Employee>? data) => _$this._data = data;

  int? _graceDays;
  int? get graceDays => _$this._graceDays;
  set graceDays(int? graceDays) => _$this._graceDays = graceDays;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  EmployeePageBuilder() {
    EmployeePage._defaults(this);
  }

  EmployeePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _graceDays = $v.graceDays;
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeePage other) {
    _$v = other as _$EmployeePage;
  }

  @override
  void update(void Function(EmployeePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeePage build() => _build();

  _$EmployeePage _build() {
    _$EmployeePage _$result;
    try {
      _$result =
          _$v ??
          _$EmployeePage._(
            data: data.build(),
            graceDays: graceDays,
            page: page.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();

        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EmployeePage',
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
