// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantCreate extends MerchantCreate {
  @override
  final LegalForm legalForm;
  @override
  final BuiltSet<CreditType> acceptedCreditTypes;
  @override
  final String name;
  @override
  final MerchantCategory category;
  @override
  final String city;
  @override
  final String phone;
  @override
  final String email;
  @override
  final BuiltList<CommissionTier> commissionGrid;

  factory _$MerchantCreate([void Function(MerchantCreateBuilder)? updates]) =>
      (MerchantCreateBuilder()..update(updates))._build();

  _$MerchantCreate._({
    required this.legalForm,
    required this.acceptedCreditTypes,
    required this.name,
    required this.category,
    required this.city,
    required this.phone,
    required this.email,
    required this.commissionGrid,
  }) : super._();
  @override
  MerchantCreate rebuild(void Function(MerchantCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MerchantCreateBuilder toBuilder() => MerchantCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantCreate &&
        legalForm == other.legalForm &&
        acceptedCreditTypes == other.acceptedCreditTypes &&
        name == other.name &&
        category == other.category &&
        city == other.city &&
        phone == other.phone &&
        email == other.email &&
        commissionGrid == other.commissionGrid;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, legalForm.hashCode);
    _$hash = $jc(_$hash, acceptedCreditTypes.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, commissionGrid.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantCreate')
          ..add('legalForm', legalForm)
          ..add('acceptedCreditTypes', acceptedCreditTypes)
          ..add('name', name)
          ..add('category', category)
          ..add('city', city)
          ..add('phone', phone)
          ..add('email', email)
          ..add('commissionGrid', commissionGrid))
        .toString();
  }
}

class MerchantCreateBuilder
    implements Builder<MerchantCreate, MerchantCreateBuilder> {
  _$MerchantCreate? _$v;

  LegalForm? _legalForm;
  LegalForm? get legalForm => _$this._legalForm;
  set legalForm(LegalForm? legalForm) => _$this._legalForm = legalForm;

  SetBuilder<CreditType>? _acceptedCreditTypes;
  SetBuilder<CreditType> get acceptedCreditTypes =>
      _$this._acceptedCreditTypes ??= SetBuilder<CreditType>();
  set acceptedCreditTypes(SetBuilder<CreditType>? acceptedCreditTypes) =>
      _$this._acceptedCreditTypes = acceptedCreditTypes;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MerchantCategory? _category;
  MerchantCategory? get category => _$this._category;
  set category(MerchantCategory? category) => _$this._category = category;

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

  MerchantCreateBuilder() {
    MerchantCreate._defaults(this);
  }

  MerchantCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _legalForm = $v.legalForm;
      _acceptedCreditTypes = $v.acceptedCreditTypes.toBuilder();
      _name = $v.name;
      _category = $v.category;
      _city = $v.city;
      _phone = $v.phone;
      _email = $v.email;
      _commissionGrid = $v.commissionGrid.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantCreate other) {
    _$v = other as _$MerchantCreate;
  }

  @override
  void update(void Function(MerchantCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantCreate build() => _build();

  _$MerchantCreate _build() {
    _$MerchantCreate _$result;
    try {
      _$result =
          _$v ??
          _$MerchantCreate._(
            legalForm: BuiltValueNullFieldError.checkNotNull(
              legalForm,
              r'MerchantCreate',
              'legalForm',
            ),
            acceptedCreditTypes: acceptedCreditTypes.build(),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantCreate',
              'name',
            ),
            category: BuiltValueNullFieldError.checkNotNull(
              category,
              r'MerchantCreate',
              'category',
            ),
            city: BuiltValueNullFieldError.checkNotNull(
              city,
              r'MerchantCreate',
              'city',
            ),
            phone: BuiltValueNullFieldError.checkNotNull(
              phone,
              r'MerchantCreate',
              'phone',
            ),
            email: BuiltValueNullFieldError.checkNotNull(
              email,
              r'MerchantCreate',
              'email',
            ),
            commissionGrid: commissionGrid.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'acceptedCreditTypes';
        acceptedCreditTypes.build();

        _$failedField = 'commissionGrid';
        commissionGrid.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantCreate',
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
