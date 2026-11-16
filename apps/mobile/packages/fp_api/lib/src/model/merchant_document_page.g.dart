// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_document_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantDocumentPage extends MerchantDocumentPage {
  @override
  final BuiltList<MerchantDocument> data;
  @override
  final PageInfo page;

  factory _$MerchantDocumentPage([
    void Function(MerchantDocumentPageBuilder)? updates,
  ]) => (MerchantDocumentPageBuilder()..update(updates))._build();

  _$MerchantDocumentPage._({required this.data, required this.page})
    : super._();
  @override
  MerchantDocumentPage rebuild(
    void Function(MerchantDocumentPageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantDocumentPageBuilder toBuilder() =>
      MerchantDocumentPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantDocumentPage &&
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
    return (newBuiltValueToStringHelper(r'MerchantDocumentPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class MerchantDocumentPageBuilder
    implements Builder<MerchantDocumentPage, MerchantDocumentPageBuilder> {
  _$MerchantDocumentPage? _$v;

  ListBuilder<MerchantDocument>? _data;
  ListBuilder<MerchantDocument> get data =>
      _$this._data ??= ListBuilder<MerchantDocument>();
  set data(ListBuilder<MerchantDocument>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  MerchantDocumentPageBuilder() {
    MerchantDocumentPage._defaults(this);
  }

  MerchantDocumentPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantDocumentPage other) {
    _$v = other as _$MerchantDocumentPage;
  }

  @override
  void update(void Function(MerchantDocumentPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantDocumentPage build() => _build();

  _$MerchantDocumentPage _build() {
    _$MerchantDocumentPage _$result;
    try {
      _$result =
          _$v ??
          _$MerchantDocumentPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantDocumentPage',
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
