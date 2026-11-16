// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_operation_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeOperationPage extends EmployeeOperationPage {
  @override
  final BuiltList<EmployeeOperation> data;
  @override
  final PageInfo page;

  factory _$EmployeeOperationPage([
    void Function(EmployeeOperationPageBuilder)? updates,
  ]) => (EmployeeOperationPageBuilder()..update(updates))._build();

  _$EmployeeOperationPage._({required this.data, required this.page})
    : super._();
  @override
  EmployeeOperationPage rebuild(
    void Function(EmployeeOperationPageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeeOperationPageBuilder toBuilder() =>
      EmployeeOperationPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeOperationPage &&
        data == other.data &&
        page == other.page;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeOperationPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class EmployeeOperationPageBuilder
    implements Builder<EmployeeOperationPage, EmployeeOperationPageBuilder> {
  _$EmployeeOperationPage? _$v;

  ListBuilder<EmployeeOperation>? _data;
  ListBuilder<EmployeeOperation> get data =>
      _$this._data ??= ListBuilder<EmployeeOperation>();
  set data(ListBuilder<EmployeeOperation>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  EmployeeOperationPageBuilder() {
    EmployeeOperationPage._defaults(this);
  }

  EmployeeOperationPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeOperationPage other) {
    _$v = other as _$EmployeeOperationPage;
  }

  @override
  void update(void Function(EmployeeOperationPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeOperationPage build() => _build();

  _$EmployeeOperationPage _build() {
    _$EmployeeOperationPage _$result;
    try {
      _$result =
          _$v ??
          _$EmployeeOperationPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EmployeeOperationPage',
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
