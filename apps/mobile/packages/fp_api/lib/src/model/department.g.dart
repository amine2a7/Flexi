// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Department extends Department {
  @override
  final bool archived;
  @override
  final String id;
  @override
  final String name;
  @override
  final int employeeCount;

  factory _$Department([void Function(DepartmentBuilder)? updates]) =>
      (DepartmentBuilder()..update(updates))._build();

  _$Department._({
    required this.archived,
    required this.id,
    required this.name,
    required this.employeeCount,
  }) : super._();
  @override
  Department rebuild(void Function(DepartmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DepartmentBuilder toBuilder() => DepartmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Department &&
        archived == other.archived &&
        id == other.id &&
        name == other.name &&
        employeeCount == other.employeeCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, archived.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, employeeCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Department')
          ..add('archived', archived)
          ..add('id', id)
          ..add('name', name)
          ..add('employeeCount', employeeCount))
        .toString();
  }
}

class DepartmentBuilder implements Builder<Department, DepartmentBuilder> {
  _$Department? _$v;

  bool? _archived;
  bool? get archived => _$this._archived;
  set archived(bool? archived) => _$this._archived = archived;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _employeeCount;
  int? get employeeCount => _$this._employeeCount;
  set employeeCount(int? employeeCount) =>
      _$this._employeeCount = employeeCount;

  DepartmentBuilder() {
    Department._defaults(this);
  }

  DepartmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _archived = $v.archived;
      _id = $v.id;
      _name = $v.name;
      _employeeCount = $v.employeeCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Department other) {
    _$v = other as _$Department;
  }

  @override
  void update(void Function(DepartmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Department build() => _build();

  _$Department _build() {
    final _$result =
        _$v ??
        _$Department._(
          archived: BuiltValueNullFieldError.checkNotNull(
            archived,
            r'Department',
            'archived',
          ),
          id: BuiltValueNullFieldError.checkNotNull(id, r'Department', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'Department',
            'name',
          ),
          employeeCount: BuiltValueNullFieldError.checkNotNull(
            employeeCount,
            r'Department',
            'employeeCount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
