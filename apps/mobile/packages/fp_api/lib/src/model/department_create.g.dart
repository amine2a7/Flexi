// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DepartmentCreate extends DepartmentCreate {
  @override
  final String name;

  factory _$DepartmentCreate([
    void Function(DepartmentCreateBuilder)? updates,
  ]) => (DepartmentCreateBuilder()..update(updates))._build();

  _$DepartmentCreate._({required this.name}) : super._();
  @override
  DepartmentCreate rebuild(void Function(DepartmentCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DepartmentCreateBuilder toBuilder() =>
      DepartmentCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DepartmentCreate && name == other.name;
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
      r'DepartmentCreate',
    )..add('name', name)).toString();
  }
}

class DepartmentCreateBuilder
    implements Builder<DepartmentCreate, DepartmentCreateBuilder> {
  _$DepartmentCreate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DepartmentCreateBuilder() {
    DepartmentCreate._defaults(this);
  }

  DepartmentCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DepartmentCreate other) {
    _$v = other as _$DepartmentCreate;
  }

  @override
  void update(void Function(DepartmentCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DepartmentCreate build() => _build();

  _$DepartmentCreate _build() {
    final _$result =
        _$v ??
        _$DepartmentCreate._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'DepartmentCreate',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
