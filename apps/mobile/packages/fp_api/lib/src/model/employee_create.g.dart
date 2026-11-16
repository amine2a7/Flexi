// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeCreate extends EmployeeCreate {
  @override
  final String? position;
  @override
  final String? departmentId;
  @override
  final String employeeNumber;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String email;
  @override
  final String phone;

  factory _$EmployeeCreate([void Function(EmployeeCreateBuilder)? updates]) =>
      (EmployeeCreateBuilder()..update(updates))._build();

  _$EmployeeCreate._({
    this.position,
    this.departmentId,
    required this.employeeNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  }) : super._();
  @override
  EmployeeCreate rebuild(void Function(EmployeeCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmployeeCreateBuilder toBuilder() => EmployeeCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeCreate &&
        position == other.position &&
        departmentId == other.departmentId &&
        employeeNumber == other.employeeNumber &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        email == other.email &&
        phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, departmentId.hashCode);
    _$hash = $jc(_$hash, employeeNumber.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeCreate')
          ..add('position', position)
          ..add('departmentId', departmentId)
          ..add('employeeNumber', employeeNumber)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('email', email)
          ..add('phone', phone))
        .toString();
  }
}

class EmployeeCreateBuilder
    implements Builder<EmployeeCreate, EmployeeCreateBuilder> {
  _$EmployeeCreate? _$v;

  String? _position;
  String? get position => _$this._position;
  set position(String? position) => _$this._position = position;

  String? _departmentId;
  String? get departmentId => _$this._departmentId;
  set departmentId(String? departmentId) => _$this._departmentId = departmentId;

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

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  EmployeeCreateBuilder() {
    EmployeeCreate._defaults(this);
  }

  EmployeeCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _position = $v.position;
      _departmentId = $v.departmentId;
      _employeeNumber = $v.employeeNumber;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _email = $v.email;
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeCreate other) {
    _$v = other as _$EmployeeCreate;
  }

  @override
  void update(void Function(EmployeeCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeCreate build() => _build();

  _$EmployeeCreate _build() {
    final _$result =
        _$v ??
        _$EmployeeCreate._(
          position: position,
          departmentId: departmentId,
          employeeNumber: BuiltValueNullFieldError.checkNotNull(
            employeeNumber,
            r'EmployeeCreate',
            'employeeNumber',
          ),
          firstName: BuiltValueNullFieldError.checkNotNull(
            firstName,
            r'EmployeeCreate',
            'firstName',
          ),
          lastName: BuiltValueNullFieldError.checkNotNull(
            lastName,
            r'EmployeeCreate',
            'lastName',
          ),
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'EmployeeCreate',
            'email',
          ),
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'EmployeeCreate',
            'phone',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
