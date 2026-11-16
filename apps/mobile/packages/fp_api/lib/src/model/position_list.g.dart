// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PositionList extends PositionList {
  @override
  final BuiltList<String> data;

  factory _$PositionList([void Function(PositionListBuilder)? updates]) =>
      (PositionListBuilder()..update(updates))._build();

  _$PositionList._({required this.data}) : super._();
  @override
  PositionList rebuild(void Function(PositionListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PositionListBuilder toBuilder() => PositionListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PositionList && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'PositionList',
    )..add('data', data)).toString();
  }
}

class PositionListBuilder
    implements Builder<PositionList, PositionListBuilder> {
  _$PositionList? _$v;

  ListBuilder<String>? _data;
  ListBuilder<String> get data => _$this._data ??= ListBuilder<String>();
  set data(ListBuilder<String>? data) => _$this._data = data;

  PositionListBuilder() {
    PositionList._defaults(this);
  }

  PositionListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PositionList other) {
    _$v = other as _$PositionList;
  }

  @override
  void update(void Function(PositionListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PositionList build() => _build();

  _$PositionList _build() {
    _$PositionList _$result;
    try {
      _$result = _$v ?? _$PositionList._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PositionList',
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
