// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_account_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantAccountPage extends MerchantAccountPage {
  @override
  final BuiltList<MerchantAccount> data;
  @override
  final PageInfo page;

  factory _$MerchantAccountPage([
    void Function(MerchantAccountPageBuilder)? updates,
  ]) => (MerchantAccountPageBuilder()..update(updates))._build();

  _$MerchantAccountPage._({required this.data, required this.page}) : super._();
  @override
  MerchantAccountPage rebuild(
    void Function(MerchantAccountPageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantAccountPageBuilder toBuilder() =>
      MerchantAccountPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantAccountPage &&
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
    return (newBuiltValueToStringHelper(r'MerchantAccountPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class MerchantAccountPageBuilder
    implements Builder<MerchantAccountPage, MerchantAccountPageBuilder> {
  _$MerchantAccountPage? _$v;

  ListBuilder<MerchantAccount>? _data;
  ListBuilder<MerchantAccount> get data =>
      _$this._data ??= ListBuilder<MerchantAccount>();
  set data(ListBuilder<MerchantAccount>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  MerchantAccountPageBuilder() {
    MerchantAccountPage._defaults(this);
  }

  MerchantAccountPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantAccountPage other) {
    _$v = other as _$MerchantAccountPage;
  }

  @override
  void update(void Function(MerchantAccountPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantAccountPage build() => _build();

  _$MerchantAccountPage _build() {
    _$MerchantAccountPage _$result;
    try {
      _$result =
          _$v ??
          _$MerchantAccountPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantAccountPage',
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
