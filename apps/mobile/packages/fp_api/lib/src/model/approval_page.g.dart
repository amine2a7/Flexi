// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApprovalPage extends ApprovalPage {
  @override
  final BuiltList<Approval> data;
  @override
  final PageInfo page;

  factory _$ApprovalPage([void Function(ApprovalPageBuilder)? updates]) =>
      (ApprovalPageBuilder()..update(updates))._build();

  _$ApprovalPage._({required this.data, required this.page}) : super._();
  @override
  ApprovalPage rebuild(void Function(ApprovalPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApprovalPageBuilder toBuilder() => ApprovalPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApprovalPage && data == other.data && page == other.page;
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
    return (newBuiltValueToStringHelper(r'ApprovalPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class ApprovalPageBuilder
    implements Builder<ApprovalPage, ApprovalPageBuilder> {
  _$ApprovalPage? _$v;

  ListBuilder<Approval>? _data;
  ListBuilder<Approval> get data => _$this._data ??= ListBuilder<Approval>();
  set data(ListBuilder<Approval>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  ApprovalPageBuilder() {
    ApprovalPage._defaults(this);
  }

  ApprovalPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApprovalPage other) {
    _$v = other as _$ApprovalPage;
  }

  @override
  void update(void Function(ApprovalPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApprovalPage build() => _build();

  _$ApprovalPage _build() {
    _$ApprovalPage _$result;
    try {
      _$result =
          _$v ?? _$ApprovalPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ApprovalPage',
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
