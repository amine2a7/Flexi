// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImportRow extends ImportRow {
  @override
  final int line;
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
  final BuiltList<ImportIssue> issues;

  factory _$ImportRow([void Function(ImportRowBuilder)? updates]) =>
      (ImportRowBuilder()..update(updates))._build();

  _$ImportRow._({
    required this.line,
    required this.employeeNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.issues,
  }) : super._();
  @override
  ImportRow rebuild(void Function(ImportRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImportRowBuilder toBuilder() => ImportRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImportRow &&
        line == other.line &&
        employeeNumber == other.employeeNumber &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        email == other.email &&
        phone == other.phone &&
        issues == other.issues;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, line.hashCode);
    _$hash = $jc(_$hash, employeeNumber.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, issues.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImportRow')
          ..add('line', line)
          ..add('employeeNumber', employeeNumber)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('email', email)
          ..add('phone', phone)
          ..add('issues', issues))
        .toString();
  }
}

class ImportRowBuilder implements Builder<ImportRow, ImportRowBuilder> {
  _$ImportRow? _$v;

  int? _line;
  int? get line => _$this._line;
  set line(int? line) => _$this._line = line;

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

  ListBuilder<ImportIssue>? _issues;
  ListBuilder<ImportIssue> get issues =>
      _$this._issues ??= ListBuilder<ImportIssue>();
  set issues(ListBuilder<ImportIssue>? issues) => _$this._issues = issues;

  ImportRowBuilder() {
    ImportRow._defaults(this);
  }

  ImportRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _line = $v.line;
      _employeeNumber = $v.employeeNumber;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _email = $v.email;
      _phone = $v.phone;
      _issues = $v.issues.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImportRow other) {
    _$v = other as _$ImportRow;
  }

  @override
  void update(void Function(ImportRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImportRow build() => _build();

  _$ImportRow _build() {
    _$ImportRow _$result;
    try {
      _$result =
          _$v ??
          _$ImportRow._(
            line: BuiltValueNullFieldError.checkNotNull(
              line,
              r'ImportRow',
              'line',
            ),
            employeeNumber: BuiltValueNullFieldError.checkNotNull(
              employeeNumber,
              r'ImportRow',
              'employeeNumber',
            ),
            firstName: BuiltValueNullFieldError.checkNotNull(
              firstName,
              r'ImportRow',
              'firstName',
            ),
            lastName: BuiltValueNullFieldError.checkNotNull(
              lastName,
              r'ImportRow',
              'lastName',
            ),
            email: BuiltValueNullFieldError.checkNotNull(
              email,
              r'ImportRow',
              'email',
            ),
            phone: BuiltValueNullFieldError.checkNotNull(
              phone,
              r'ImportRow',
              'phone',
            ),
            issues: issues.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'issues';
        issues.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ImportRow',
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
