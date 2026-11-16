// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_assignment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DepartmentAssignment extends DepartmentAssignment {
  @override
  final String? departmentId;

  factory _$DepartmentAssignment([
    void Function(DepartmentAssignmentBuilder)? updates,
  ]) => (DepartmentAssignmentBuilder()..update(updates))._build();

  _$DepartmentAssignment._({this.departmentId}) : super._();
  @override
  DepartmentAssignment rebuild(
    void Function(DepartmentAssignmentBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DepartmentAssignmentBuilder toBuilder() =>
      DepartmentAssignmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DepartmentAssignment && departmentId == other.departmentId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, departmentId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'DepartmentAssignment',
    )..add('departmentId', departmentId)).toString();
  }
}

class DepartmentAssignmentBuilder
    implements Builder<DepartmentAssignment, DepartmentAssignmentBuilder> {
  _$DepartmentAssignment? _$v;

  String? _departmentId;
  String? get departmentId => _$this._departmentId;
  set departmentId(String? departmentId) => _$this._departmentId = departmentId;

  DepartmentAssignmentBuilder() {
    DepartmentAssignment._defaults(this);
  }

  DepartmentAssignmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _departmentId = $v.departmentId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DepartmentAssignment other) {
    _$v = other as _$DepartmentAssignment;
  }

  @override
  void update(void Function(DepartmentAssignmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DepartmentAssignment build() => _build();

  _$DepartmentAssignment _build() {
    final _$result =
        _$v ?? _$DepartmentAssignment._(departmentId: departmentId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
