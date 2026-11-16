// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputePage extends DisputePage {
  @override
  final BuiltList<Dispute> data;
  @override
  final PageInfo page;

  factory _$DisputePage([void Function(DisputePageBuilder)? updates]) =>
      (DisputePageBuilder()..update(updates))._build();

  _$DisputePage._({required this.data, required this.page}) : super._();
  @override
  DisputePage rebuild(void Function(DisputePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputePageBuilder toBuilder() => DisputePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputePage && data == other.data && page == other.page;
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
    return (newBuiltValueToStringHelper(r'DisputePage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class DisputePageBuilder implements Builder<DisputePage, DisputePageBuilder> {
  _$DisputePage? _$v;

  ListBuilder<Dispute>? _data;
  ListBuilder<Dispute> get data => _$this._data ??= ListBuilder<Dispute>();
  set data(ListBuilder<Dispute>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  DisputePageBuilder() {
    DisputePage._defaults(this);
  }

  DisputePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputePage other) {
    _$v = other as _$DisputePage;
  }

  @override
  void update(void Function(DisputePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputePage build() => _build();

  _$DisputePage _build() {
    _$DisputePage _$result;
    try {
      _$result = _$v ?? _$DisputePage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'DisputePage',
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
