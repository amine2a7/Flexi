// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_account.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantAccount extends MerchantAccount {
  @override
  final TemporaryCredentials? credentials;
  @override
  final LegalForm legalForm;
  @override
  final String id;
  @override
  final String name;
  @override
  final MerchantCategory category;
  @override
  final BuiltSet<CreditType> acceptedCreditTypes;
  @override
  final String city;
  @override
  final AccountStatus status;
  @override
  final CommissionGrid? commissionGrid;
  @override
  final DateTime createdAt;

  factory _$MerchantAccount([void Function(MerchantAccountBuilder)? updates]) =>
      (MerchantAccountBuilder()..update(updates))._build();

  _$MerchantAccount._({
    this.credentials,
    required this.legalForm,
    required this.id,
    required this.name,
    required this.category,
    required this.acceptedCreditTypes,
    required this.city,
    required this.status,
    this.commissionGrid,
    required this.createdAt,
  }) : super._();
  @override
  MerchantAccount rebuild(void Function(MerchantAccountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MerchantAccountBuilder toBuilder() => MerchantAccountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantAccount &&
        credentials == other.credentials &&
        legalForm == other.legalForm &&
        id == other.id &&
        name == other.name &&
        category == other.category &&
        acceptedCreditTypes == other.acceptedCreditTypes &&
        city == other.city &&
        status == other.status &&
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
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, acceptedCreditTypes.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, commissionGrid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantAccount')
          ..add('credentials', credentials)
          ..add('legalForm', legalForm)
          ..add('id', id)
          ..add('name', name)
          ..add('category', category)
          ..add('acceptedCreditTypes', acceptedCreditTypes)
          ..add('city', city)
          ..add('status', status)
          ..add('commissionGrid', commissionGrid)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class MerchantAccountBuilder
    implements Builder<MerchantAccount, MerchantAccountBuilder> {
  _$MerchantAccount? _$v;

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

  MerchantCategory? _category;
  MerchantCategory? get category => _$this._category;
  set category(MerchantCategory? category) => _$this._category = category;

  SetBuilder<CreditType>? _acceptedCreditTypes;
  SetBuilder<CreditType> get acceptedCreditTypes =>
      _$this._acceptedCreditTypes ??= SetBuilder<CreditType>();
  set acceptedCreditTypes(SetBuilder<CreditType>? acceptedCreditTypes) =>
      _$this._acceptedCreditTypes = acceptedCreditTypes;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  AccountStatus? _status;
  AccountStatus? get status => _$this._status;
  set status(AccountStatus? status) => _$this._status = status;

  CommissionGridBuilder? _commissionGrid;
  CommissionGridBuilder get commissionGrid =>
      _$this._commissionGrid ??= CommissionGridBuilder();
  set commissionGrid(CommissionGridBuilder? commissionGrid) =>
      _$this._commissionGrid = commissionGrid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  MerchantAccountBuilder() {
    MerchantAccount._defaults(this);
  }

  MerchantAccountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _credentials = $v.credentials?.toBuilder();
      _legalForm = $v.legalForm;
      _id = $v.id;
      _name = $v.name;
      _category = $v.category;
      _acceptedCreditTypes = $v.acceptedCreditTypes.toBuilder();
      _city = $v.city;
      _status = $v.status;
      _commissionGrid = $v.commissionGrid?.toBuilder();
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantAccount other) {
    _$v = other as _$MerchantAccount;
  }

  @override
  void update(void Function(MerchantAccountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantAccount build() => _build();

  _$MerchantAccount _build() {
    _$MerchantAccount _$result;
    try {
      _$result =
          _$v ??
          _$MerchantAccount._(
            credentials: _credentials?.build(),
            legalForm: BuiltValueNullFieldError.checkNotNull(
              legalForm,
              r'MerchantAccount',
              'legalForm',
            ),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantAccount',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantAccount',
              'name',
            ),
            category: BuiltValueNullFieldError.checkNotNull(
              category,
              r'MerchantAccount',
              'category',
            ),
            acceptedCreditTypes: acceptedCreditTypes.build(),
            city: BuiltValueNullFieldError.checkNotNull(
              city,
              r'MerchantAccount',
              'city',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'MerchantAccount',
              'status',
            ),
            commissionGrid: _commissionGrid?.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'MerchantAccount',
              'createdAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'credentials';
        _credentials?.build();

        _$failedField = 'acceptedCreditTypes';
        acceptedCreditTypes.build();

        _$failedField = 'commissionGrid';
        _commissionGrid?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantAccount',
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
