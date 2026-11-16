// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payout_request_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPayoutRequestPage extends AdminPayoutRequestPage {
  @override
  final BuiltList<AdminPayoutRequest> data;
  @override
  final PageInfo page;

  factory _$AdminPayoutRequestPage([
    void Function(AdminPayoutRequestPageBuilder)? updates,
  ]) => (AdminPayoutRequestPageBuilder()..update(updates))._build();

  _$AdminPayoutRequestPage._({required this.data, required this.page})
    : super._();
  @override
  AdminPayoutRequestPage rebuild(
    void Function(AdminPayoutRequestPageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPayoutRequestPageBuilder toBuilder() =>
      AdminPayoutRequestPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPayoutRequestPage &&
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
    return (newBuiltValueToStringHelper(r'AdminPayoutRequestPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class AdminPayoutRequestPageBuilder
    implements Builder<AdminPayoutRequestPage, AdminPayoutRequestPageBuilder> {
  _$AdminPayoutRequestPage? _$v;

  ListBuilder<AdminPayoutRequest>? _data;
  ListBuilder<AdminPayoutRequest> get data =>
      _$this._data ??= ListBuilder<AdminPayoutRequest>();
  set data(ListBuilder<AdminPayoutRequest>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  AdminPayoutRequestPageBuilder() {
    AdminPayoutRequestPage._defaults(this);
  }

  AdminPayoutRequestPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPayoutRequestPage other) {
    _$v = other as _$AdminPayoutRequestPage;
  }

  @override
  void update(void Function(AdminPayoutRequestPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPayoutRequestPage build() => _build();

  _$AdminPayoutRequestPage _build() {
    _$AdminPayoutRequestPage _$result;
    try {
      _$result =
          _$v ??
          _$AdminPayoutRequestPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminPayoutRequestPage',
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
