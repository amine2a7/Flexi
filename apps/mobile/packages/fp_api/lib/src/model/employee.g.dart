// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Employee extends Employee {
  @override
  final TemporaryCredentials? credentials;
  @override
  final String? position;
  @override
  final String? departmentId;
  @override
  final bool? invitationExpired;
  @override
  final String id;
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
  @override
  final EmployeeStatus status;
  @override
  final int monthAllocatedMillimes;
  @override
  final DateTime? graceUntil;

  factory _$Employee([void Function(EmployeeBuilder)? updates]) =>
      (EmployeeBuilder()..update(updates))._build();

  _$Employee._({
    this.credentials,
    this.position,
    this.departmentId,
    this.invitationExpired,
    required this.id,
    required this.employeeNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.status,
    required this.monthAllocatedMillimes,
    this.graceUntil,
  }) : super._();
  @override
  Employee rebuild(void Function(EmployeeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmployeeBuilder toBuilder() => EmployeeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Employee &&
        credentials == other.credentials &&
        position == other.position &&
        departmentId == other.departmentId &&
        invitationExpired == other.invitationExpired &&
        id == other.id &&
        employeeNumber == other.employeeNumber &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        email == other.email &&
        phone == other.phone &&
        status == other.status &&
        monthAllocatedMillimes == other.monthAllocatedMillimes &&
        graceUntil == other.graceUntil;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, credentials.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, departmentId.hashCode);
    _$hash = $jc(_$hash, invitationExpired.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, employeeNumber.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, monthAllocatedMillimes.hashCode);
    _$hash = $jc(_$hash, graceUntil.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Employee')
          ..add('credentials', credentials)
          ..add('position', position)
          ..add('departmentId', departmentId)
          ..add('invitationExpired', invitationExpired)
          ..add('id', id)
          ..add('employeeNumber', employeeNumber)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('email', email)
          ..add('phone', phone)
          ..add('status', status)
          ..add('monthAllocatedMillimes', monthAllocatedMillimes)
          ..add('graceUntil', graceUntil))
        .toString();
  }
}

class EmployeeBuilder implements Builder<Employee, EmployeeBuilder> {
  _$Employee? _$v;

  TemporaryCredentialsBuilder? _credentials;
  TemporaryCredentialsBuilder get credentials =>
      _$this._credentials ??= TemporaryCredentialsBuilder();
  set credentials(TemporaryCredentialsBuilder? credentials) =>
      _$this._credentials = credentials;

  String? _position;
  String? get position => _$this._position;
  set position(String? position) => _$this._position = position;

  String? _departmentId;
  String? get departmentId => _$this._departmentId;
  set departmentId(String? departmentId) => _$this._departmentId = departmentId;

  bool? _invitationExpired;
  bool? get invitationExpired => _$this._invitationExpired;
  set invitationExpired(bool? invitationExpired) =>
      _$this._invitationExpired = invitationExpired;

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

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  EmployeeStatus? _status;
  EmployeeStatus? get status => _$this._status;
  set status(EmployeeStatus? status) => _$this._status = status;

  int? _monthAllocatedMillimes;
  int? get monthAllocatedMillimes => _$this._monthAllocatedMillimes;
  set monthAllocatedMillimes(int? monthAllocatedMillimes) =>
      _$this._monthAllocatedMillimes = monthAllocatedMillimes;

  DateTime? _graceUntil;
  DateTime? get graceUntil => _$this._graceUntil;
  set graceUntil(DateTime? graceUntil) => _$this._graceUntil = graceUntil;

  EmployeeBuilder() {
    Employee._defaults(this);
  }

  EmployeeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _credentials = $v.credentials?.toBuilder();
      _position = $v.position;
      _departmentId = $v.departmentId;
      _invitationExpired = $v.invitationExpired;
      _id = $v.id;
      _employeeNumber = $v.employeeNumber;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _email = $v.email;
      _phone = $v.phone;
      _status = $v.status;
      _monthAllocatedMillimes = $v.monthAllocatedMillimes;
      _graceUntil = $v.graceUntil;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Employee other) {
    _$v = other as _$Employee;
  }

  @override
  void update(void Function(EmployeeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Employee build() => _build();

  _$Employee _build() {
    _$Employee _$result;
    try {
      _$result =
          _$v ??
          _$Employee._(
            credentials: _credentials?.build(),
            position: position,
            departmentId: departmentId,
            invitationExpired: invitationExpired,
            id: BuiltValueNullFieldError.checkNotNull(id, r'Employee', 'id'),
            employeeNumber: BuiltValueNullFieldError.checkNotNull(
              employeeNumber,
              r'Employee',
              'employeeNumber',
            ),
            firstName: BuiltValueNullFieldError.checkNotNull(
              firstName,
              r'Employee',
              'firstName',
            ),
            lastName: BuiltValueNullFieldError.checkNotNull(
              lastName,
              r'Employee',
              'lastName',
            ),
            email: BuiltValueNullFieldError.checkNotNull(
              email,
              r'Employee',
              'email',
            ),
            phone: BuiltValueNullFieldError.checkNotNull(
              phone,
              r'Employee',
              'phone',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'Employee',
              'status',
            ),
            monthAllocatedMillimes: BuiltValueNullFieldError.checkNotNull(
              monthAllocatedMillimes,
              r'Employee',
              'monthAllocatedMillimes',
            ),
            graceUntil: graceUntil,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'credentials';
        _credentials?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Employee',
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
