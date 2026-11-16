// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeProfile extends EmployeeProfile {
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String employeeNumber;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String companyName;
  @override
  final bool pinSet;

  factory _$EmployeeProfile([void Function(EmployeeProfileBuilder)? updates]) =>
      (EmployeeProfileBuilder()..update(updates))._build();

  _$EmployeeProfile._({
    required this.firstName,
    required this.lastName,
    required this.employeeNumber,
    required this.email,
    required this.phone,
    required this.companyName,
    required this.pinSet,
  }) : super._();
  @override
  EmployeeProfile rebuild(void Function(EmployeeProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmployeeProfileBuilder toBuilder() => EmployeeProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeProfile &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        employeeNumber == other.employeeNumber &&
        email == other.email &&
        phone == other.phone &&
        companyName == other.companyName &&
        pinSet == other.pinSet;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, employeeNumber.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, pinSet.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeProfile')
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('employeeNumber', employeeNumber)
          ..add('email', email)
          ..add('phone', phone)
          ..add('companyName', companyName)
          ..add('pinSet', pinSet))
        .toString();
  }
}

class EmployeeProfileBuilder
    implements Builder<EmployeeProfile, EmployeeProfileBuilder> {
  _$EmployeeProfile? _$v;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _employeeNumber;
  String? get employeeNumber => _$this._employeeNumber;
  set employeeNumber(String? employeeNumber) =>
      _$this._employeeNumber = employeeNumber;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  bool? _pinSet;
  bool? get pinSet => _$this._pinSet;
  set pinSet(bool? pinSet) => _$this._pinSet = pinSet;

  EmployeeProfileBuilder() {
    EmployeeProfile._defaults(this);
  }

  EmployeeProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _employeeNumber = $v.employeeNumber;
      _email = $v.email;
      _phone = $v.phone;
      _companyName = $v.companyName;
      _pinSet = $v.pinSet;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeProfile other) {
    _$v = other as _$EmployeeProfile;
  }

  @override
  void update(void Function(EmployeeProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeProfile build() => _build();

  _$EmployeeProfile _build() {
    final _$result =
        _$v ??
        _$EmployeeProfile._(
          firstName: BuiltValueNullFieldError.checkNotNull(
            firstName,
            r'EmployeeProfile',
            'firstName',
          ),
          lastName: BuiltValueNullFieldError.checkNotNull(
            lastName,
            r'EmployeeProfile',
            'lastName',
          ),
          employeeNumber: BuiltValueNullFieldError.checkNotNull(
            employeeNumber,
            r'EmployeeProfile',
            'employeeNumber',
          ),
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'EmployeeProfile',
            'email',
          ),
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'EmployeeProfile',
            'phone',
          ),
          companyName: BuiltValueNullFieldError.checkNotNull(
            companyName,
            r'EmployeeProfile',
            'companyName',
          ),
          pinSet: BuiltValueNullFieldError.checkNotNull(
            pinSet,
            r'EmployeeProfile',
            'pinSet',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
