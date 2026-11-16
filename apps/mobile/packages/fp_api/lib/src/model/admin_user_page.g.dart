// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminUserPage extends AdminUserPage {
  @override
  final BuiltList<AdminUser> data;
  @override
  final PageInfo page;

  factory _$AdminUserPage([void Function(AdminUserPageBuilder)? updates]) =>
      (AdminUserPageBuilder()..update(updates))._build();

  _$AdminUserPage._({required this.data, required this.page}) : super._();
  @override
  AdminUserPage rebuild(void Function(AdminUserPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminUserPageBuilder toBuilder() => AdminUserPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUserPage && data == other.data && page == other.page;
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
    return (newBuiltValueToStringHelper(r'AdminUserPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class AdminUserPageBuilder
    implements Builder<AdminUserPage, AdminUserPageBuilder> {
  _$AdminUserPage? _$v;

  ListBuilder<AdminUser>? _data;
  ListBuilder<AdminUser> get data => _$this._data ??= ListBuilder<AdminUser>();
  set data(ListBuilder<AdminUser>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  AdminUserPageBuilder() {
    AdminUserPage._defaults(this);
  }

  AdminUserPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminUserPage other) {
    _$v = other as _$AdminUserPage;
  }

  @override
  void update(void Function(AdminUserPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUserPage build() => _build();

  _$AdminUserPage _build() {
    _$AdminUserPage _$result;
    try {
      _$result =
          _$v ?? _$AdminUserPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminUserPage',
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
