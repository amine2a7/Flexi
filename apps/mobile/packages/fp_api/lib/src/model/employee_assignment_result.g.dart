// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_assignment_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeAssignmentResult extends EmployeeAssignmentResult {
  @override
  final BuiltList<String> employeeIds;
  @override
  final String? departmentId;
  @override
  final String? position;

  factory _$EmployeeAssignmentResult([
    void Function(EmployeeAssignmentResultBuilder)? updates,
  ]) => (EmployeeAssignmentResultBuilder()..update(updates))._build();

  _$EmployeeAssignmentResult._({
    required this.employeeIds,
    this.departmentId,
    this.position,
  }) : super._();
  @override
  EmployeeAssignmentResult rebuild(
    void Function(EmployeeAssignmentResultBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EmployeeAssignmentResultBuilder toBuilder() =>
      EmployeeAssignmentResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeAssignmentResult &&
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
    return (newBuiltValueToStringHelper(r'EmployeeAssignmentResult')
          ..add('employeeIds', employeeIds)
          ..add('departmentId', departmentId)
          ..add('position', position))
        .toString();
  }
}

class EmployeeAssignmentResultBuilder
    implements
        Builder<EmployeeAssignmentResult, EmployeeAssignmentResultBuilder> {
  _$EmployeeAssignmentResult? _$v;

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

  EmployeeAssignmentResultBuilder() {
    EmployeeAssignmentResult._defaults(this);
  }

  EmployeeAssignmentResultBuilder get _$this {
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
  void replace(EmployeeAssignmentResult other) {
    _$v = other as _$EmployeeAssignmentResult;
  }

  @override
  void update(void Function(EmployeeAssignmentResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeAssignmentResult build() => _build();

  _$EmployeeAssignmentResult _build() {
    _$EmployeeAssignmentResult _$result;
    try {
      _$result =
          _$v ??
          _$EmployeeAssignmentResult._(
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
          r'EmployeeAssignmentResult',
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
