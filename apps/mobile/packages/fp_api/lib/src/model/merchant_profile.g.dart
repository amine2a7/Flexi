// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantProfile extends MerchantProfile {
  @override
  final String name;
  @override
  final MerchantCategory category;
  @override
  final String city;
  @override
  final String address;
  @override
  final String phone;
  @override
  final String maskedIban;
  @override
  final String paymentCode;
  @override
  final BuiltSet<CreditType> acceptedCreditTypes;
  @override
  final CommissionGrid? commissionGrid;
  @override
  final BuiltList<PointOfSale> pointsOfSale;
  @override
  final BuiltList<StaffMember> staff;

  factory _$MerchantProfile([void Function(MerchantProfileBuilder)? updates]) =>
      (MerchantProfileBuilder()..update(updates))._build();

  _$MerchantProfile._({
    required this.name,
    required this.category,
    required this.city,
    required this.address,
    required this.phone,
    required this.maskedIban,
    required this.paymentCode,
    required this.acceptedCreditTypes,
    this.commissionGrid,
    required this.pointsOfSale,
    required this.staff,
  }) : super._();
  @override
  MerchantProfile rebuild(void Function(MerchantProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MerchantProfileBuilder toBuilder() => MerchantProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantProfile &&
        name == other.name &&
        category == other.category &&
        city == other.city &&
        address == other.address &&
        phone == other.phone &&
        maskedIban == other.maskedIban &&
        paymentCode == other.paymentCode &&
        acceptedCreditTypes == other.acceptedCreditTypes &&
        commissionGrid == other.commissionGrid &&
        pointsOfSale == other.pointsOfSale &&
        staff == other.staff;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, maskedIban.hashCode);
    _$hash = $jc(_$hash, paymentCode.hashCode);
    _$hash = $jc(_$hash, acceptedCreditTypes.hashCode);
    _$hash = $jc(_$hash, commissionGrid.hashCode);
    _$hash = $jc(_$hash, pointsOfSale.hashCode);
    _$hash = $jc(_$hash, staff.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantProfile')
          ..add('name', name)
          ..add('category', category)
          ..add('city', city)
          ..add('address', address)
          ..add('phone', phone)
          ..add('maskedIban', maskedIban)
          ..add('paymentCode', paymentCode)
          ..add('acceptedCreditTypes', acceptedCreditTypes)
          ..add('commissionGrid', commissionGrid)
          ..add('pointsOfSale', pointsOfSale)
          ..add('staff', staff))
        .toString();
  }
}

class MerchantProfileBuilder
    implements Builder<MerchantProfile, MerchantProfileBuilder> {
  _$MerchantProfile? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MerchantCategory? _category;
  MerchantCategory? get category => _$this._category;
  set category(MerchantCategory? category) => _$this._category = category;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _maskedIban;
  String? get maskedIban => _$this._maskedIban;
  set maskedIban(String? maskedIban) => _$this._maskedIban = maskedIban;

  String? _paymentCode;
  String? get paymentCode => _$this._paymentCode;
  set paymentCode(String? paymentCode) => _$this._paymentCode = paymentCode;

  SetBuilder<CreditType>? _acceptedCreditTypes;
  SetBuilder<CreditType> get acceptedCreditTypes =>
      _$this._acceptedCreditTypes ??= SetBuilder<CreditType>();
  set acceptedCreditTypes(SetBuilder<CreditType>? acceptedCreditTypes) =>
      _$this._acceptedCreditTypes = acceptedCreditTypes;

  CommissionGridBuilder? _commissionGrid;
  CommissionGridBuilder get commissionGrid =>
      _$this._commissionGrid ??= CommissionGridBuilder();
  set commissionGrid(CommissionGridBuilder? commissionGrid) =>
      _$this._commissionGrid = commissionGrid;

  ListBuilder<PointOfSale>? _pointsOfSale;
  ListBuilder<PointOfSale> get pointsOfSale =>
      _$this._pointsOfSale ??= ListBuilder<PointOfSale>();
  set pointsOfSale(ListBuilder<PointOfSale>? pointsOfSale) =>
      _$this._pointsOfSale = pointsOfSale;

  ListBuilder<StaffMember>? _staff;
  ListBuilder<StaffMember> get staff =>
      _$this._staff ??= ListBuilder<StaffMember>();
  set staff(ListBuilder<StaffMember>? staff) => _$this._staff = staff;

  MerchantProfileBuilder() {
    MerchantProfile._defaults(this);
  }

  MerchantProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _category = $v.category;
      _city = $v.city;
      _address = $v.address;
      _phone = $v.phone;
      _maskedIban = $v.maskedIban;
      _paymentCode = $v.paymentCode;
      _acceptedCreditTypes = $v.acceptedCreditTypes.toBuilder();
      _commissionGrid = $v.commissionGrid?.toBuilder();
      _pointsOfSale = $v.pointsOfSale.toBuilder();
      _staff = $v.staff.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantProfile other) {
    _$v = other as _$MerchantProfile;
  }

  @override
  void update(void Function(MerchantProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantProfile build() => _build();

  _$MerchantProfile _build() {
    _$MerchantProfile _$result;
    try {
      _$result =
          _$v ??
          _$MerchantProfile._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantProfile',
              'name',
            ),
            category: BuiltValueNullFieldError.checkNotNull(
              category,
              r'MerchantProfile',
              'category',
            ),
            city: BuiltValueNullFieldError.checkNotNull(
              city,
              r'MerchantProfile',
              'city',
            ),
            address: BuiltValueNullFieldError.checkNotNull(
              address,
              r'MerchantProfile',
              'address',
            ),
            phone: BuiltValueNullFieldError.checkNotNull(
              phone,
              r'MerchantProfile',
              'phone',
            ),
            maskedIban: BuiltValueNullFieldError.checkNotNull(
              maskedIban,
              r'MerchantProfile',
              'maskedIban',
            ),
            paymentCode: BuiltValueNullFieldError.checkNotNull(
              paymentCode,
              r'MerchantProfile',
              'paymentCode',
            ),
            acceptedCreditTypes: acceptedCreditTypes.build(),
            commissionGrid: _commissionGrid?.build(),
            pointsOfSale: pointsOfSale.build(),
            staff: staff.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'acceptedCreditTypes';
        acceptedCreditTypes.build();
        _$failedField = 'commissionGrid';
        _commissionGrid?.build();
        _$failedField = 'pointsOfSale';
        pointsOfSale.build();
        _$failedField = 'staff';
        staff.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantProfile',
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
