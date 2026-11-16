// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_account_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyAccountPage extends CompanyAccountPage {
  @override
  final BuiltList<CompanyAccount> data;
  @override
  final PageInfo page;

  factory _$CompanyAccountPage([
    void Function(CompanyAccountPageBuilder)? updates,
  ]) => (CompanyAccountPageBuilder()..update(updates))._build();

  _$CompanyAccountPage._({required this.data, required this.page}) : super._();
  @override
  CompanyAccountPage rebuild(
    void Function(CompanyAccountPageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CompanyAccountPageBuilder toBuilder() =>
      CompanyAccountPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyAccountPage &&
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
    return (newBuiltValueToStringHelper(r'CompanyAccountPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class CompanyAccountPageBuilder
    implements Builder<CompanyAccountPage, CompanyAccountPageBuilder> {
  _$CompanyAccountPage? _$v;

  ListBuilder<CompanyAccount>? _data;
  ListBuilder<CompanyAccount> get data =>
      _$this._data ??= ListBuilder<CompanyAccount>();
  set data(ListBuilder<CompanyAccount>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  CompanyAccountPageBuilder() {
    CompanyAccountPage._defaults(this);
  }

  CompanyAccountPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyAccountPage other) {
    _$v = other as _$CompanyAccountPage;
  }

  @override
  void update(void Function(CompanyAccountPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyAccountPage build() => _build();

  _$CompanyAccountPage _build() {
    _$CompanyAccountPage _$result;
    try {
      _$result =
          _$v ?? _$CompanyAccountPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CompanyAccountPage',
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
