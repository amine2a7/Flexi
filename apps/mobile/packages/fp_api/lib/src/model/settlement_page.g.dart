// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettlementPage extends SettlementPage {
  @override
  final BuiltList<Settlement> data;
  @override
  final PageInfo page;

  factory _$SettlementPage([void Function(SettlementPageBuilder)? updates]) =>
      (SettlementPageBuilder()..update(updates))._build();

  _$SettlementPage._({required this.data, required this.page}) : super._();
  @override
  SettlementPage rebuild(void Function(SettlementPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettlementPageBuilder toBuilder() => SettlementPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettlementPage && data == other.data && page == other.page;
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
    return (newBuiltValueToStringHelper(r'SettlementPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class SettlementPageBuilder
    implements Builder<SettlementPage, SettlementPageBuilder> {
  _$SettlementPage? _$v;

  ListBuilder<Settlement>? _data;
  ListBuilder<Settlement> get data =>
      _$this._data ??= ListBuilder<Settlement>();
  set data(ListBuilder<Settlement>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  SettlementPageBuilder() {
    SettlementPage._defaults(this);
  }

  SettlementPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettlementPage other) {
    _$v = other as _$SettlementPage;
  }

  @override
  void update(void Function(SettlementPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettlementPage build() => _build();

  _$SettlementPage _build() {
    _$SettlementPage _$result;
    try {
      _$result =
          _$v ?? _$SettlementPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SettlementPage',
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
