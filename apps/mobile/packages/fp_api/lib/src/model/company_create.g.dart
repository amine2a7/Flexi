// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyCreate extends CompanyCreate {
  @override
  final LegalForm legalForm;
  @override
  final String name;
  @override
  final String city;
  @override
  final String phone;
  @override
  final String email;
  @override
  final BuiltList<CommissionTier> commissionGrid;

  factory _$CompanyCreate([void Function(CompanyCreateBuilder)? updates]) =>
      (CompanyCreateBuilder()..update(updates))._build();

  _$CompanyCreate._({
    required this.legalForm,
    required this.name,
    required this.city,
    required this.phone,
    required this.email,
    required this.commissionGrid,
  }) : super._();
  @override
  CompanyCreate rebuild(void Function(CompanyCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyCreateBuilder toBuilder() => CompanyCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyCreate &&
        legalForm == other.legalForm &&
        name == other.name &&
        city == other.city &&
        phone == other.phone &&
        email == other.email &&
        commissionGrid == other.commissionGrid;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, legalForm.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, commissionGrid.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyCreate')
          ..add('legalForm', legalForm)
          ..add('name', name)
          ..add('city', city)
          ..add('phone', phone)
          ..add('email', email)
          ..add('commissionGrid', commissionGrid))
        .toString();
  }
}

class CompanyCreateBuilder
    implements Builder<CompanyCreate, CompanyCreateBuilder> {
  _$CompanyCreate? _$v;

  LegalForm? _legalForm;
  LegalForm? get legalForm => _$this._legalForm;
  set legalForm(LegalForm? legalForm) => _$this._legalForm = legalForm;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  ListBuilder<CommissionTier>? _commissionGrid;
  ListBuilder<CommissionTier> get commissionGrid =>
      _$this._commissionGrid ??= ListBuilder<CommissionTier>();
  set commissionGrid(ListBuilder<CommissionTier>? commissionGrid) =>
      _$this._commissionGrid = commissionGrid;

  CompanyCreateBuilder() {
    CompanyCreate._defaults(this);
  }

  CompanyCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _legalForm = $v.legalForm;
      _name = $v.name;
      _city = $v.city;
      _phone = $v.phone;
      _email = $v.email;
      _commissionGrid = $v.commissionGrid.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyCreate other) {
    _$v = other as _$CompanyCreate;
  }

  @override
  void update(void Function(CompanyCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyCreate build() => _build();

  _$CompanyCreate _build() {
    _$CompanyCreate _$result;
    try {
      _$result =
          _$v ??
          _$CompanyCreate._(
            legalForm: BuiltValueNullFieldError.checkNotNull(
              legalForm,
              r'CompanyCreate',
              'legalForm',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CompanyCreate',
              'name',
            ),
            city: BuiltValueNullFieldError.checkNotNull(
              city,
              r'CompanyCreate',
              'city',
            ),
            phone: BuiltValueNullFieldError.checkNotNull(
              phone,
              r'CompanyCreate',
              'phone',
            ),
            email: BuiltValueNullFieldError.checkNotNull(
              email,
              r'CompanyCreate',
              'email',
            ),
            commissionGrid: commissionGrid.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'commissionGrid';
        commissionGrid.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CompanyCreate',
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
