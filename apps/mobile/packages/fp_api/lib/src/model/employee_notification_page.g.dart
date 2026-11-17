// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_notification_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeNotificationPage extends EmployeeNotificationPage {
  @override
  final BuiltList<EmployeeNotification> data;
  @override
  final PageInfo page;

  factory _$EmployeeNotificationPage([
    void Function(EmployeeNotificationPageBuilder)? updates,
  ]) => (EmployeeNotificationPageBuilder()..update(updates))._build();

  _$EmployeeNotificationPage._({required this.data, required this.page})
    : super._();
  @override
  EmployeeNotificationPage rebuild(
    void Function(EmployeeNotificationPageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeeNotificationPageBuilder toBuilder() =>
      EmployeeNotificationPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeNotificationPage &&
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
    return (newBuiltValueToStringHelper(r'EmployeeNotificationPage')
          ..add('data', data)
          ..add('page', page))
        .toString();
  }
}

class EmployeeNotificationPageBuilder
    implements
        Builder<EmployeeNotificationPage, EmployeeNotificationPageBuilder> {
  _$EmployeeNotificationPage? _$v;

  ListBuilder<EmployeeNotification>? _data;
  ListBuilder<EmployeeNotification> get data =>
      _$this._data ??= ListBuilder<EmployeeNotification>();
  set data(ListBuilder<EmployeeNotification>? data) => _$this._data = data;

  PageInfoBuilder? _page;
  PageInfoBuilder get page => _$this._page ??= PageInfoBuilder();
  set page(PageInfoBuilder? page) => _$this._page = page;

  EmployeeNotificationPageBuilder() {
    EmployeeNotificationPage._defaults(this);
  }

  EmployeeNotificationPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _page = $v.page.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeNotificationPage other) {
    _$v = other as _$EmployeeNotificationPage;
  }

  @override
  void update(void Function(EmployeeNotificationPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeNotificationPage build() => _build();

  _$EmployeeNotificationPage _build() {
    _$EmployeeNotificationPage _$result;
    try {
      _$result =
          _$v ??
          _$EmployeeNotificationPage._(data: data.build(), page: page.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'page';
        page.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EmployeeNotificationPage',
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
