// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_employee.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OverviewEmployee extends OverviewEmployee {
  @override
  final String id;
  @override
  final String employeeNumber;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? departmentName;
  @override
  final String? position;
  @override
  final EmployeeStatus status;

  factory _$OverviewEmployee([
    void Function(OverviewEmployeeBuilder)? updates,
  ]) => (OverviewEmployeeBuilder()..update(updates))._build();

  _$OverviewEmployee._({
    required this.id,
    required this.employeeNumber,
    required this.firstName,
    required this.lastName,
    this.departmentName,
    this.position,
    required this.status,
  }) : super._();
  @override
  OverviewEmployee rebuild(void Function(OverviewEmployeeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OverviewEmployeeBuilder toBuilder() =>
      OverviewEmployeeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OverviewEmployee &&
        id == other.id &&
        employeeNumber == other.employeeNumber &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        departmentName == other.departmentName &&
        position == other.position &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, employeeNumber.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, departmentName.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OverviewEmployee')
          ..add('id', id)
          ..add('employeeNumber', employeeNumber)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('departmentName', departmentName)
          ..add('position', position)
          ..add('status', status))
        .toString();
  }
}

class OverviewEmployeeBuilder
    implements Builder<OverviewEmployee, OverviewEmployeeBuilder> {
  _$OverviewEmployee? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _employeeNumber;
  String? get employeeNumber => _$this._employeeNumber;
  set employeeNumber(String? employeeNumber) =>
      _$this._employeeNumber = employeeNumber;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _departmentName;
  String? get departmentName => _$this._departmentName;
  set departmentName(String? departmentName) =>
      _$this._departmentName = departmentName;

  String? _position;
  String? get position => _$this._position;
  set position(String? position) => _$this._position = position;

  EmployeeStatus? _status;
  EmployeeStatus? get status => _$this._status;
  set status(EmployeeStatus? status) => _$this._status = status;

  OverviewEmployeeBuilder() {
    OverviewEmployee._defaults(this);
  }

  OverviewEmployeeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _employeeNumber = $v.employeeNumber;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _departmentName = $v.departmentName;
      _position = $v.position;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OverviewEmployee other) {
    _$v = other as _$OverviewEmployee;
  }

  @override
  void update(void Function(OverviewEmployeeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OverviewEmployee build() => _build();

  _$OverviewEmployee _build() {
    final _$result =
        _$v ??
        _$OverviewEmployee._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'OverviewEmployee',
            'id',
          ),
          employeeNumber: BuiltValueNullFieldError.checkNotNull(
            employeeNumber,
            r'OverviewEmployee',
            'employeeNumber',
          ),
          firstName: BuiltValueNullFieldError.checkNotNull(
            firstName,
            r'OverviewEmployee',
            'firstName',
          ),
          lastName: BuiltValueNullFieldError.checkNotNull(
            lastName,
            r'OverviewEmployee',
            'lastName',
          ),
          departmentName: departmentName,
          position: position,
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'OverviewEmployee',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
