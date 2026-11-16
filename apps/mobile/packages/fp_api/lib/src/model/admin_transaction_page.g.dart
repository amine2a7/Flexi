// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_transaction_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTransactionPage extends AdminTransactionPage {
  @override
  final BuiltList<AdminTransaction> data;
  @override
  final PageInfo page;

  factory _$AdminTransactionPage([
    void Function(AdminTransactionPageBuilder)? updates,
  ]) => (AdminTransactionPageBuilder()..update(updates))._build();

  _$AdminTransactionPage._({required this.data, required this.page})
    : super._();
  @override
  AdminTransactionPage rebuild(
    void Function(AdminTransactionPageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTransactionPageBuilder toBuilder() =>
      AdminTransactionPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTransactionPage &&
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
    return (newBuiltValueToStringHelper(r'AdminTransactionPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class AdminTransactionPageBuilder
    implements Builder<AdminTransactionPage, AdminTransactionPageBuilder> {
  _$AdminTransactionPage? _$v;

  ListBuilder<AdminTransaction>? _data;
  ListBuilder<AdminTransaction> get data =>
      _$this._data ??= ListBuilder<AdminTransaction>();
  set data(ListBuilder<AdminTransaction>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  AdminTransactionPageBuilder() {
    AdminTransactionPage._defaults(this);
  }

  AdminTransactionPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTransactionPage other) {
    _$v = other as _$AdminTransactionPage;
  }

  @override
  void update(void Function(AdminTransactionPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTransactionPage build() => _build();

  _$AdminTransactionPage _build() {
    _$AdminTransactionPage _$result;
    try {
      _$result =
          _$v ??
          _$AdminTransactionPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTransactionPage',
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
