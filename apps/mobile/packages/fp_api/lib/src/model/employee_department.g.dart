// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_department.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeDepartment extends EmployeeDepartment {
  @override
  final String employeeId;
  @override
  final String? departmentId;

  factory _$EmployeeDepartment([
    void Function(EmployeeDepartmentBuilder)? updates,
  ]) => (EmployeeDepartmentBuilder()..update(updates))._build();

  _$EmployeeDepartment._({required this.employeeId, this.departmentId})
    : super._();
  @override
  EmployeeDepartment rebuild(
    void Function(EmployeeDepartmentBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeeDepartmentBuilder toBuilder() =>
      EmployeeDepartmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeDepartment &&
        employeeId == other.employeeId &&
        departmentId == other.departmentId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, employeeId.hashCode);
    _$hash = $jc(_$hash, departmentId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeDepartment')
          ..add('employeeId', employeeId)
          ..add('departmentId', departmentId))
        .toString();
  }
}

class EmployeeDepartmentBuilder
    implements Builder<EmployeeDepartment, EmployeeDepartmentBuilder> {
  _$EmployeeDepartment? _$v;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  String? _departmentId;
  String? get departmentId => _$this._departmentId;
  set departmentId(String? departmentId) => _$this._departmentId = departmentId;

  EmployeeDepartmentBuilder() {
    EmployeeDepartment._defaults(this);
  }

  EmployeeDepartmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _employeeId = $v.employeeId;
      _departmentId = $v.departmentId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeDepartment other) {
    _$v = other as _$EmployeeDepartment;
  }

  @override
  void update(void Function(EmployeeDepartmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeDepartment build() => _build();

  _$EmployeeDepartment _build() {
    final _$result =
        _$v ??
        _$EmployeeDepartment._(
          employeeId: BuiltValueNullFieldError.checkNotNull(
            employeeId,
            r'EmployeeDepartment',
            'employeeId',
          ),
          departmentId: departmentId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
