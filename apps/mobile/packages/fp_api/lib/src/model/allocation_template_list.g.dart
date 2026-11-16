// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_template_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AllocationTemplateList extends AllocationTemplateList {
  @override
  final BuiltList<AllocationTemplate> data;

  factory _$AllocationTemplateList([
    void Function(AllocationTemplateListBuilder)? updates,
  ]) => (AllocationTemplateListBuilder()..update(updates))._build();

  _$AllocationTemplateList._({required this.data}) : super._();
  @override
  AllocationTemplateList rebuild(
    void Function(AllocationTemplateListBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AllocationTemplateListBuilder toBuilder() =>
      AllocationTemplateListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocationTemplateList && data == other.data;
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
      r'AllocationTemplateList',
    )..add('data', data)).toString();
  }
}

class AllocationTemplateListBuilder
    implements Builder<AllocationTemplateList, AllocationTemplateListBuilder> {
  _$AllocationTemplateList? _$v;

  ListBuilder<AllocationTemplate>? _data;
  ListBuilder<AllocationTemplate> get data =>
      _$this._data ??= ListBuilder<AllocationTemplate>();
  set data(ListBuilder<AllocationTemplate>? data) => _$this._data = data;

  AllocationTemplateListBuilder() {
    AllocationTemplateList._defaults(this);
  }

  AllocationTemplateListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocationTemplateList other) {
    _$v = other as _$AllocationTemplateList;
  }

  @override
  void update(void Function(AllocationTemplateListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AllocationTemplateList build() => _build();

  _$AllocationTemplateList _build() {
    _$AllocationTemplateList _$result;
    try {
      _$result = _$v ?? _$AllocationTemplateList._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AllocationTemplateList',
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
