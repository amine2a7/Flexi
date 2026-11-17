// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterList extends RegisterList {
  @override
  final BuiltList<Register> data;

  factory _$RegisterList([void Function(RegisterListBuilder)? updates]) =>
      (RegisterListBuilder()..update(updates))._build();

  _$RegisterList._({required this.data}) : super._();
  @override
  RegisterList rebuild(void Function(RegisterListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterListBuilder toBuilder() => RegisterListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterList && data == other.data;
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
      r'RegisterList',
    )..add('data', data)).toString();
  }
}

class RegisterListBuilder
    implements Builder<RegisterList, RegisterListBuilder> {
  _$RegisterList? _$v;

  ListBuilder<Register>? _data;
  ListBuilder<Register> get data => _$this._data ??= ListBuilder<Register>();
  set data(ListBuilder<Register>? data) => _$this._data = data;

  RegisterListBuilder() {
    RegisterList._defaults(this);
  }

  RegisterListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterList other) {
    _$v = other as _$RegisterList;
  }

  @override
  void update(void Function(RegisterListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterList build() => _build();

  _$RegisterList _build() {
    _$RegisterList _$result;
    try {
      _$result = _$v ?? _$RegisterList._(data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'RegisterList',
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
