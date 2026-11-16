// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_preview_employee.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AllocationPreviewEmployee extends AllocationPreviewEmployee {
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

  factory _$AllocationPreviewEmployee([
    void Function(AllocationPreviewEmployeeBuilder)? updates,
  ]) => (AllocationPreviewEmployeeBuilder()..update(updates))._build();

  _$AllocationPreviewEmployee._({
    required this.id,
    required this.employeeNumber,
    required this.firstName,
    required this.lastName,
    this.departmentName,
    this.position,
  }) : super._();
  @override
  AllocationPreviewEmployee rebuild(
    void Function(AllocationPreviewEmployeeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AllocationPreviewEmployeeBuilder toBuilder() =>
      AllocationPreviewEmployeeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AllocationPreviewEmployee &&
        id == other.id &&
        employeeNumber == other.employeeNumber &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        departmentName == other.departmentName &&
        position == other.position;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AllocationPreviewEmployee')
          ..add('id', id)
          ..add('employeeNumber', employeeNumber)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('departmentName', departmentName)
          ..add('position', position))
        .toString();
  }
}

class AllocationPreviewEmployeeBuilder
    implements
        Builder<AllocationPreviewEmployee, AllocationPreviewEmployeeBuilder> {
  _$AllocationPreviewEmployee? _$v;

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

  AllocationPreviewEmployeeBuilder() {
    AllocationPreviewEmployee._defaults(this);
  }

  AllocationPreviewEmployeeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _employeeNumber = $v.employeeNumber;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _departmentName = $v.departmentName;
      _position = $v.position;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AllocationPreviewEmployee other) {
    _$v = other as _$AllocationPreviewEmployee;
  }

  @override
  void update(void Function(AllocationPreviewEmployeeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AllocationPreviewEmployee build() => _build();

  _$AllocationPreviewEmployee _build() {
    final _$result =
        _$v ??
        _$AllocationPreviewEmployee._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AllocationPreviewEmployee',
            'id',
          ),
          employeeNumber: BuiltValueNullFieldError.checkNotNull(
            employeeNumber,
            r'AllocationPreviewEmployee',
            'employeeNumber',
          ),
          firstName: BuiltValueNullFieldError.checkNotNull(
            firstName,
            r'AllocationPreviewEmployee',
            'firstName',
          ),
          lastName: BuiltValueNullFieldError.checkNotNull(
            lastName,
            r'AllocationPreviewEmployee',
            'lastName',
          ),
          departmentName: departmentName,
          position: position,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
