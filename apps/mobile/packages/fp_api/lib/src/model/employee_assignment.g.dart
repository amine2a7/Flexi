// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_assignment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeAssignment extends EmployeeAssignment {
  @override
  final BuiltList<String> employeeIds;
  @override
  final String? departmentId;
  @override
  final String? position;

  factory _$EmployeeAssignment([
    void Function(EmployeeAssignmentBuilder)? updates,
  ]) => (EmployeeAssignmentBuilder()..update(updates))._build();

  _$EmployeeAssignment._({
    required this.employeeIds,
    this.departmentId,
    this.position,
  }) : super._();
  @override
  EmployeeAssignment rebuild(
    void Function(EmployeeAssignmentBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeeAssignmentBuilder toBuilder() =>
      EmployeeAssignmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeAssignment &&
        employeeIds == other.employeeIds &&
        departmentId == other.departmentId &&
        position == other.position;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, employeeIds.hashCode);
    _$hash = $jc(_$hash, departmentId.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeAssignment')
          ..add('employeeIds', employeeIds)
          ..add('departmentId', departmentId)
          ..add('position', position))
        .toString();
  }
}

class EmployeeAssignmentBuilder
    implements Builder<EmployeeAssignment, EmployeeAssignmentBuilder> {
  _$EmployeeAssignment? _$v;

  ListBuilder<String>? _employeeIds;
  ListBuilder<String> get employeeIds =>
      _$this._employeeIds ??= ListBuilder<String>();
  set employeeIds(ListBuilder<String>? employeeIds) =>
      _$this._employeeIds = employeeIds;

  String? _departmentId;
  String? get departmentId => _$this._departmentId;
  set departmentId(String? departmentId) => _$this._departmentId = departmentId;

  String? _position;
  String? get position => _$this._position;
  set position(String? position) => _$this._position = position;

  EmployeeAssignmentBuilder() {
    EmployeeAssignment._defaults(this);
  }

  EmployeeAssignmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _employeeIds = $v.employeeIds.toBuilder();
      _departmentId = $v.departmentId;
      _position = $v.position;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeAssignment other) {
    _$v = other as _$EmployeeAssignment;
  }

  @override
  void update(void Function(EmployeeAssignmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeAssignment build() => _build();

  _$EmployeeAssignment _build() {
    _$EmployeeAssignment _$result;
    try {
      _$result =
          _$v ??
          _$EmployeeAssignment._(
            employeeIds: employeeIds.build(),
            departmentId: departmentId,
            position: position,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'employeeIds';
        employeeIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EmployeeAssignment',
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
