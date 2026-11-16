// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receivable_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReceivablePage extends ReceivablePage {
  @override
  final BuiltList<Receivable> data;
  @override
  final PageInfo page;
  @override
  final int totalMillimes;

  factory _$ReceivablePage([void Function(ReceivablePageBuilder)? updates]) =>
      (ReceivablePageBuilder()..update(updates))._build();

  _$ReceivablePage._({
    required this.data,
    required this.page,
    required this.totalMillimes,
  }) : super._();
  @override
  ReceivablePage rebuild(void Function(ReceivablePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReceivablePageBuilder toBuilder() => ReceivablePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReceivablePage &&
        data == other.data &&
        page == other.page &&
        totalMillimes == other.totalMillimes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, totalMillimes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReceivablePage')
          ..add('data', data)
          ..add('page', page)
          ..add('totalMillimes', totalMillimes))
        .toString();
  }
}

class ReceivablePageBuilder
    implements Builder<ReceivablePage, ReceivablePageBuilder> {
  _$ReceivablePage? _$v;

  ListBuilder<Receivable>? _data;
  ListBuilder<Receivable> get data =>
      _$this._data ??= ListBuilder<Receivable>();
  set data(ListBuilder<Receivable>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  int? _totalMillimes;
  int? get totalMillimes => _$this._totalMillimes;
  set totalMillimes(int? totalMillimes) =>
      _$this._totalMillimes = totalMillimes;

  ReceivablePageBuilder() {
    ReceivablePage._defaults(this);
  }

  ReceivablePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _totalMillimes = $v.totalMillimes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReceivablePage other) {
    _$v = other as _$ReceivablePage;
  }

  @override
  void update(void Function(ReceivablePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReceivablePage build() => _build();

  _$ReceivablePage _build() {
    _$ReceivablePage _$result;
    try {
      _$result =
          _$v ??
          _$ReceivablePage._(
            data: data.build(),
            page: page.build(),
            totalMillimes: BuiltValueNullFieldError.checkNotNull(
              totalMillimes,
              r'ReceivablePage',
              'totalMillimes',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ReceivablePage',
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
