// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fraud_alert_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FraudAlertPage extends FraudAlertPage {
  @override
  final BuiltList<FraudAlert> data;
  @override
  final PageInfo page;

  factory _$FraudAlertPage([void Function(FraudAlertPageBuilder)? updates]) =>
      (FraudAlertPageBuilder()..update(updates))._build();

  _$FraudAlertPage._({required this.data, required this.page}) : super._();
  @override
  FraudAlertPage rebuild(void Function(FraudAlertPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FraudAlertPageBuilder toBuilder() => FraudAlertPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FraudAlertPage && data == other.data && page == other.page;
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
    return (newBuiltValueToStringHelper(r'FraudAlertPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class FraudAlertPageBuilder
    implements Builder<FraudAlertPage, FraudAlertPageBuilder> {
  _$FraudAlertPage? _$v;

  ListBuilder<FraudAlert>? _data;
  ListBuilder<FraudAlert> get data =>
      _$this._data ??= ListBuilder<FraudAlert>();
  set data(ListBuilder<FraudAlert>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  FraudAlertPageBuilder() {
    FraudAlertPage._defaults(this);
  }

  FraudAlertPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FraudAlertPage other) {
    _$v = other as _$FraudAlertPage;
  }

  @override
  void update(void Function(FraudAlertPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FraudAlertPage build() => _build();

  _$FraudAlertPage _build() {
    _$FraudAlertPage _$result;
    try {
      _$result =
          _$v ?? _$FraudAlertPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'FraudAlertPage',
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
