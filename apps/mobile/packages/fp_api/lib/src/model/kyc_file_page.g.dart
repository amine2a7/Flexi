// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_file_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$KycFilePage extends KycFilePage {
  @override
  final BuiltList<KycFileSummary> data;
  @override
  final PageInfo page;

  factory _$KycFilePage([void Function(KycFilePageBuilder)? updates]) =>
      (KycFilePageBuilder()..update(updates))._build();

  _$KycFilePage._({required this.data, required this.page}) : super._();
  @override
  KycFilePage rebuild(void Function(KycFilePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KycFilePageBuilder toBuilder() => KycFilePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KycFilePage && data == other.data && page == other.page;
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
    return (newBuiltValueToStringHelper(r'KycFilePage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class KycFilePageBuilder implements Builder<KycFilePage, KycFilePageBuilder> {
  _$KycFilePage? _$v;

  ListBuilder<KycFileSummary>? _data;
  ListBuilder<KycFileSummary> get data =>
      _$this._data ??= ListBuilder<KycFileSummary>();
  set data(ListBuilder<KycFileSummary>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  KycFilePageBuilder() {
    KycFilePage._defaults(this);
  }

  KycFilePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KycFilePage other) {
    _$v = other as _$KycFilePage;
  }

  @override
  void update(void Function(KycFilePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KycFilePage build() => _build();

  _$KycFilePage _build() {
    _$KycFilePage _$result;
    try {
      _$result = _$v ?? _$KycFilePage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'KycFilePage',
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
