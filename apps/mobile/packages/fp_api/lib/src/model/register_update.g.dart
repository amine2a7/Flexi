// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterUpdate extends RegisterUpdate {
  @override
  final String? name;
  @override
  final RegisterStatus? status;

  factory _$RegisterUpdate([void Function(RegisterUpdateBuilder)? updates]) =>
      (RegisterUpdateBuilder()..update(updates))._build();

  _$RegisterUpdate._({this.name, this.status}) : super._();
  @override
  RegisterUpdate rebuild(void Function(RegisterUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterUpdateBuilder toBuilder() => RegisterUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterUpdate &&
        name == other.name &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterUpdate')
          ..add('name', name)
          ..add('status', status))
        .toString();
  }
}

class RegisterUpdateBuilder
    implements Builder<RegisterUpdate, RegisterUpdateBuilder> {
  _$RegisterUpdate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  RegisterStatus? _status;
  RegisterStatus? get status => _$this._status;
  set status(RegisterStatus? status) => _$this._status = status;

  RegisterUpdateBuilder() {
    RegisterUpdate._defaults(this);
  }

  RegisterUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterUpdate other) {
    _$v = other as _$RegisterUpdate;
  }

  @override
  void update(void Function(RegisterUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterUpdate build() => _build();

  _$RegisterUpdate _build() {
    final _$result = _$v ?? _$RegisterUpdate._(name: name, status: status);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
