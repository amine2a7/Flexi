// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterCreate extends RegisterCreate {
  @override
  final String name;

  factory _$RegisterCreate([void Function(RegisterCreateBuilder)? updates]) =>
      (RegisterCreateBuilder()..update(updates))._build();

  _$RegisterCreate._({required this.name}) : super._();
  @override
  RegisterCreate rebuild(void Function(RegisterCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterCreateBuilder toBuilder() => RegisterCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterCreate && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'RegisterCreate',
    )..add('name', name)).toString();
  }
}

class RegisterCreateBuilder
    implements Builder<RegisterCreate, RegisterCreateBuilder> {
  _$RegisterCreate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  RegisterCreateBuilder() {
    RegisterCreate._defaults(this);
  }

  RegisterCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterCreate other) {
    _$v = other as _$RegisterCreate;
  }

  @override
  void update(void Function(RegisterCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterCreate build() => _build();

  _$RegisterCreate _build() {
    final _$result =
        _$v ??
        _$RegisterCreate._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'RegisterCreate',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
