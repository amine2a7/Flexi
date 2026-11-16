// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_payment_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPaymentPage extends MerchantPaymentPage {
  @override
  final BuiltList<MerchantPayment> data;
  @override
  final PageInfo page;

  factory _$MerchantPaymentPage([
    void Function(MerchantPaymentPageBuilder)? updates,
  ]) => (MerchantPaymentPageBuilder()..update(updates))._build();

  _$MerchantPaymentPage._({required this.data, required this.page}) : super._();
  @override
  MerchantPaymentPage rebuild(
    void Function(MerchantPaymentPageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPaymentPageBuilder toBuilder() =>
      MerchantPaymentPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPaymentPage &&
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
    return (newBuiltValueToStringHelper(r'MerchantPaymentPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class MerchantPaymentPageBuilder
    implements Builder<MerchantPaymentPage, MerchantPaymentPageBuilder> {
  _$MerchantPaymentPage? _$v;

  ListBuilder<MerchantPayment>? _data;
  ListBuilder<MerchantPayment> get data =>
      _$this._data ??= ListBuilder<MerchantPayment>();
  set data(ListBuilder<MerchantPayment>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  MerchantPaymentPageBuilder() {
    MerchantPaymentPage._defaults(this);
  }

  MerchantPaymentPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPaymentPage other) {
    _$v = other as _$MerchantPaymentPage;
  }

  @override
  void update(void Function(MerchantPaymentPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPaymentPage build() => _build();

  _$MerchantPaymentPage _build() {
    _$MerchantPaymentPage _$result;
    try {
      _$result =
          _$v ??
          _$MerchantPaymentPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantPaymentPage',
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
