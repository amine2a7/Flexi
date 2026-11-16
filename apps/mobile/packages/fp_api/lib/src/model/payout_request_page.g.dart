// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_request_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutRequestPage extends PayoutRequestPage {
  @override
  final BuiltList<PayoutRequest> data;
  @override
  final PageInfo page;

  factory _$PayoutRequestPage([
    void Function(PayoutRequestPageBuilder)? updates,
  ]) => (PayoutRequestPageBuilder()..update(updates))._build();

  _$PayoutRequestPage._({required this.data, required this.page}) : super._();
  @override
  PayoutRequestPage rebuild(void Function(PayoutRequestPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PayoutRequestPageBuilder toBuilder() =>
      PayoutRequestPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutRequestPage &&
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
    return (newBuiltValueToStringHelper(r'PayoutRequestPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class PayoutRequestPageBuilder
    implements Builder<PayoutRequestPage, PayoutRequestPageBuilder> {
  _$PayoutRequestPage? _$v;

  ListBuilder<PayoutRequest>? _data;
  ListBuilder<PayoutRequest> get data =>
      _$this._data ??= ListBuilder<PayoutRequest>();
  set data(ListBuilder<PayoutRequest>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  PayoutRequestPageBuilder() {
    PayoutRequestPage._defaults(this);
  }

  PayoutRequestPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutRequestPage other) {
    _$v = other as _$PayoutRequestPage;
  }

  @override
  void update(void Function(PayoutRequestPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutRequestPage build() => _build();

  _$PayoutRequestPage _build() {
    _$PayoutRequestPage _$result;
    try {
      _$result =
          _$v ?? _$PayoutRequestPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PayoutRequestPage',
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
