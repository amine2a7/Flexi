// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_account.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyAccount extends CompanyAccount {
  @override
  final TemporaryCredentials? credentials;
  @override
  final LegalForm legalForm;
  @override
  final String id;
  @override
  final String name;
  @override
  final String city;
  @override
  final AccountStatus status;
  @override
  final int employeesCount;
  @override
  final CommissionGrid? commissionGrid;
  @override
  final DateTime createdAt;

  factory _$CompanyAccount([void Function(CompanyAccountBuilder)? updates]) =>
      (CompanyAccountBuilder()..update(updates))._build();

  _$CompanyAccount._({
    this.credentials,
    required this.legalForm,
    required this.id,
    required this.name,
    required this.city,
    required this.status,
    required this.employeesCount,
    this.commissionGrid,
    required this.createdAt,
  }) : super._();
  @override
  CompanyAccount rebuild(void Function(CompanyAccountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyAccountBuilder toBuilder() => CompanyAccountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyAccount &&
        credentials == other.credentials &&
        legalForm == other.legalForm &&
        id == other.id &&
        name == other.name &&
        city == other.city &&
        status == other.status &&
        employeesCount == other.employeesCount &&
        commissionGrid == other.commissionGrid &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, credentials.hashCode);
    _$hash = $jc(_$hash, legalForm.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, employeesCount.hashCode);
    _$hash = $jc(_$hash, commissionGrid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyAccount')
          ..add('credentials', credentials)
          ..add('legalForm', legalForm)
          ..add('id', id)
          ..add('name', name)
          ..add('city', city)
          ..add('status', status)
          ..add('employeesCount', employeesCount)
          ..add('commissionGrid', commissionGrid)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class CompanyAccountBuilder
    implements Builder<CompanyAccount, CompanyAccountBuilder> {
  _$CompanyAccount? _$v;

  TemporaryCredentialsBuilder? _credentials;
  TemporaryCredentialsBuilder get credentials =>
      _$this._credentials ??= TemporaryCredentialsBuilder();
  set credentials(TemporaryCredentialsBuilder? credentials) =>
      _$this._credentials = credentials;

  LegalForm? _legalForm;
  LegalForm? get legalForm => _$this._legalForm;
  set legalForm(LegalForm? legalForm) => _$this._legalForm = legalForm;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  AccountStatus? _status;
  AccountStatus? get status => _$this._status;
  set status(AccountStatus? status) => _$this._status = status;

  int? _employeesCount;
  int? get employeesCount => _$this._employeesCount;
  set employeesCount(int? employeesCount) =>
      _$this._employeesCount = employeesCount;

  CommissionGridBuilder? _commissionGrid;
  CommissionGridBuilder get commissionGrid =>
      _$this._commissionGrid ??= CommissionGridBuilder();
  set commissionGrid(CommissionGridBuilder? commissionGrid) =>
      _$this._commissionGrid = commissionGrid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  CompanyAccountBuilder() {
    CompanyAccount._defaults(this);
  }

  CompanyAccountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _credentials = $v.credentials?.toBuilder();
      _legalForm = $v.legalForm;
      _id = $v.id;
      _name = $v.name;
      _city = $v.city;
      _status = $v.status;
      _employeesCount = $v.employeesCount;
      _commissionGrid = $v.commissionGrid?.toBuilder();
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyAccount other) {
    _$v = other as _$CompanyAccount;
  }

  @override
  void update(void Function(CompanyAccountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyAccount build() => _build();

  _$CompanyAccount _build() {
    _$CompanyAccount _$result;
    try {
      _$result =
          _$v ??
          _$CompanyAccount._(
            credentials: _credentials?.build(),
            legalForm: BuiltValueNullFieldError.checkNotNull(
              legalForm,
              r'CompanyAccount',
              'legalForm',
            ),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CompanyAccount',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CompanyAccount',
              'name',
            ),
            city: BuiltValueNullFieldError.checkNotNull(
              city,
              r'CompanyAccount',
              'city',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'CompanyAccount',
              'status',
            ),
            employeesCount: BuiltValueNullFieldError.checkNotNull(
              employeesCount,
              r'CompanyAccount',
              'employeesCount',
            ),
            commissionGrid: _commissionGrid?.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'CompanyAccount',
              'createdAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'credentials';
        _credentials?.build();

        _$failedField = 'commissionGrid';
        _commissionGrid?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CompanyAccount',
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
