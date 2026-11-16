// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvoicePage extends InvoicePage {
  @override
  final BuiltList<Invoice> data;
  @override
  final PageInfo page;

  factory _$InvoicePage([void Function(InvoicePageBuilder)? updates]) =>
      (InvoicePageBuilder()..update(updates))._build();

  _$InvoicePage._({required this.data, required this.page}) : super._();
  @override
  InvoicePage rebuild(void Function(InvoicePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoicePageBuilder toBuilder() => InvoicePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoicePage && data == other.data && page == other.page;
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
    return (newBuiltValueToStringHelper(r'InvoicePage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class InvoicePageBuilder implements Builder<InvoicePage, InvoicePageBuilder> {
  _$InvoicePage? _$v;

  ListBuilder<Invoice>? _data;
  ListBuilder<Invoice> get data => _$this._data ??= ListBuilder<Invoice>();
  set data(ListBuilder<Invoice>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  InvoicePageBuilder() {
    InvoicePage._defaults(this);
  }

  InvoicePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoicePage other) {
    _$v = other as _$InvoicePage;
  }

  @override
  void update(void Function(InvoicePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoicePage build() => _build();

  _$InvoicePage _build() {
    _$InvoicePage _$result;
    try {
      _$result = _$v ?? _$InvoicePage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'InvoicePage',
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
