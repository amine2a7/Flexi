// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_order_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreditOrderPage extends CreditOrderPage {
  @override
  final BuiltList<CreditOrder> data;
  @override
  final PageInfo page;

  factory _$CreditOrderPage([void Function(CreditOrderPageBuilder)? updates]) =>
      (CreditOrderPageBuilder()..update(updates))._build();

  _$CreditOrderPage._({required this.data, required this.page}) : super._();
  @override
  CreditOrderPage rebuild(void Function(CreditOrderPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreditOrderPageBuilder toBuilder() => CreditOrderPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreditOrderPage && data == other.data && page == other.page;
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
    return (newBuiltValueToStringHelper(r'CreditOrderPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class CreditOrderPageBuilder
    implements Builder<CreditOrderPage, CreditOrderPageBuilder> {
  _$CreditOrderPage? _$v;

  ListBuilder<CreditOrder>? _data;
  ListBuilder<CreditOrder> get data =>
      _$this._data ??= ListBuilder<CreditOrder>();
  set data(ListBuilder<CreditOrder>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  CreditOrderPageBuilder() {
    CreditOrderPage._defaults(this);
  }

  CreditOrderPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreditOrderPage other) {
    _$v = other as _$CreditOrderPage;
  }

  @override
  void update(void Function(CreditOrderPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreditOrderPage build() => _build();

  _$CreditOrderPage _build() {
    _$CreditOrderPage _$result;
    try {
      _$result =
          _$v ?? _$CreditOrderPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CreditOrderPage',
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
