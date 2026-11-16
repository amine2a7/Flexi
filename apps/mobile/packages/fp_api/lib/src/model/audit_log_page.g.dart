// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuditLogPage extends AuditLogPage {
  @override
  final BuiltList<AuditLogEntry> data;
  @override
  final PageInfo page;

  factory _$AuditLogPage([void Function(AuditLogPageBuilder)? updates]) =>
      (AuditLogPageBuilder()..update(updates))._build();

  _$AuditLogPage._({required this.data, required this.page}) : super._();
  @override
  AuditLogPage rebuild(void Function(AuditLogPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuditLogPageBuilder toBuilder() => AuditLogPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuditLogPage && data == other.data && page == other.page;
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
    return (newBuiltValueToStringHelper(r'AuditLogPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class AuditLogPageBuilder
    implements Builder<AuditLogPage, AuditLogPageBuilder> {
  _$AuditLogPage? _$v;

  ListBuilder<AuditLogEntry>? _data;
  ListBuilder<AuditLogEntry> get data =>
      _$this._data ??= ListBuilder<AuditLogEntry>();
  set data(ListBuilder<AuditLogEntry>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  AuditLogPageBuilder() {
    AuditLogPage._defaults(this);
  }

  AuditLogPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuditLogPage other) {
    _$v = other as _$AuditLogPage;
  }

  @override
  void update(void Function(AuditLogPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuditLogPage build() => _build();

  _$AuditLogPage _build() {
    _$AuditLogPage _$result;
    try {
      _$result =
          _$v ?? _$AuditLogPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AuditLogPage',
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
