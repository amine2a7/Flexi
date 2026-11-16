// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_message_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactMessagePage extends ContactMessagePage {
  @override
  final BuiltList<ContactMessage> data;
  @override
  final PageInfo page;

  factory _$ContactMessagePage([
    void Function(ContactMessagePageBuilder)? updates,
  ]) => (ContactMessagePageBuilder()..update(updates))._build();

  _$ContactMessagePage._({required this.data, required this.page}) : super._();
  @override
  ContactMessagePage rebuild(
    void Function(ContactMessagePageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ContactMessagePageBuilder toBuilder() =>
      ContactMessagePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactMessagePage &&
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
    return (newBuiltValueToStringHelper(r'ContactMessagePage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class ContactMessagePageBuilder
    implements Builder<ContactMessagePage, ContactMessagePageBuilder> {
  _$ContactMessagePage? _$v;

  ListBuilder<ContactMessage>? _data;
  ListBuilder<ContactMessage> get data =>
      _$this._data ??= ListBuilder<ContactMessage>();
  set data(ListBuilder<ContactMessage>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  ContactMessagePageBuilder() {
    ContactMessagePage._defaults(this);
  }

  ContactMessagePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactMessagePage other) {
    _$v = other as _$ContactMessagePage;
  }

  @override
  void update(void Function(ContactMessagePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactMessagePage build() => _build();

  _$ContactMessagePage _build() {
    _$ContactMessagePage _$result;
    try {
      _$result =
          _$v ?? _$ContactMessagePage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ContactMessagePage',
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
