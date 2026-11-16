// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_batch_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettlementBatchPage extends SettlementBatchPage {
  @override
  final BuiltList<SettlementBatch> data;
  @override
  final PageInfo page;

  factory _$SettlementBatchPage([
    void Function(SettlementBatchPageBuilder)? updates,
  ]) => (SettlementBatchPageBuilder()..update(updates))._build();

  _$SettlementBatchPage._({required this.data, required this.page}) : super._();
  @override
  SettlementBatchPage rebuild(
    void Function(SettlementBatchPageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SettlementBatchPageBuilder toBuilder() =>
      SettlementBatchPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettlementBatchPage &&
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
    return (newBuiltValueToStringHelper(r'SettlementBatchPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class SettlementBatchPageBuilder
    implements Builder<SettlementBatchPage, SettlementBatchPageBuilder> {
  _$SettlementBatchPage? _$v;

  ListBuilder<SettlementBatch>? _data;
  ListBuilder<SettlementBatch> get data =>
      _$this._data ??= ListBuilder<SettlementBatch>();
  set data(ListBuilder<SettlementBatch>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  SettlementBatchPageBuilder() {
    SettlementBatchPage._defaults(this);
  }

  SettlementBatchPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettlementBatchPage other) {
    _$v = other as _$SettlementBatchPage;
  }

  @override
  void update(void Function(SettlementBatchPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettlementBatchPage build() => _build();

  _$SettlementBatchPage _build() {
    _$SettlementBatchPage _$result;
    try {
      _$result =
          _$v ??
          _$SettlementBatchPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SettlementBatchPage',
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
