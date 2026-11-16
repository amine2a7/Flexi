// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_lookup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantLookup extends MerchantLookup {
  @override
  final String merchantCode;
  @override
  final String merchantName;
  @override
  final String city;
  @override
  final BuiltSet<CreditType> acceptedCreditTypes;
  @override
  final MerchantCategory category;

  factory _$MerchantLookup([void Function(MerchantLookupBuilder)? updates]) =>
      (MerchantLookupBuilder()..update(updates))._build();

  _$MerchantLookup._({
    required this.merchantCode,
    required this.merchantName,
    required this.city,
    required this.acceptedCreditTypes,
    required this.category,
  }) : super._();
  @override
  MerchantLookup rebuild(void Function(MerchantLookupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MerchantLookupBuilder toBuilder() => MerchantLookupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantLookup &&
        merchantCode == other.merchantCode &&
        merchantName == other.merchantName &&
        city == other.city &&
        acceptedCreditTypes == other.acceptedCreditTypes &&
        category == other.category;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, merchantCode.hashCode);
    _$hash = $jc(_$hash, merchantName.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, acceptedCreditTypes.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantLookup')
          ..add('merchantCode', merchantCode)
          ..add('merchantName', merchantName)
          ..add('city', city)
          ..add('acceptedCreditTypes', acceptedCreditTypes)
          ..add('category', category))
        .toString();
  }
}

class MerchantLookupBuilder
    implements Builder<MerchantLookup, MerchantLookupBuilder> {
  _$MerchantLookup? _$v;

  String? _merchantCode;
  String? get merchantCode => _$this._merchantCode;
  set merchantCode(String? merchantCode) => _$this._merchantCode = merchantCode;

  String? _merchantName;
  String? get merchantName => _$this._merchantName;
  set merchantName(String? merchantName) => _$this._merchantName = merchantName;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  SetBuilder<CreditType>? _acceptedCreditTypes;
  SetBuilder<CreditType> get acceptedCreditTypes =>
      _$this._acceptedCreditTypes ??= SetBuilder<CreditType>();
  set acceptedCreditTypes(SetBuilder<CreditType>? acceptedCreditTypes) =>
      _$this._acceptedCreditTypes = acceptedCreditTypes;

  MerchantCategory? _category;
  MerchantCategory? get category => _$this._category;
  set category(MerchantCategory? category) => _$this._category = category;

  MerchantLookupBuilder() {
    MerchantLookup._defaults(this);
  }

  MerchantLookupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _merchantCode = $v.merchantCode;
      _merchantName = $v.merchantName;
      _city = $v.city;
      _acceptedCreditTypes = $v.acceptedCreditTypes.toBuilder();
      _category = $v.category;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantLookup other) {
    _$v = other as _$MerchantLookup;
  }

  @override
  void update(void Function(MerchantLookupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantLookup build() => _build();

  _$MerchantLookup _build() {
    _$MerchantLookup _$result;
    try {
      _$result =
          _$v ??
          _$MerchantLookup._(
            merchantCode: BuiltValueNullFieldError.checkNotNull(
              merchantCode,
              r'MerchantLookup',
              'merchantCode',
            ),
            merchantName: BuiltValueNullFieldError.checkNotNull(
              merchantName,
              r'MerchantLookup',
              'merchantName',
            ),
            city: BuiltValueNullFieldError.checkNotNull(
              city,
              r'MerchantLookup',
              'city',
            ),
            acceptedCreditTypes: acceptedCreditTypes.build(),
            category: BuiltValueNullFieldError.checkNotNull(
              category,
              r'MerchantLookup',
              'category',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'acceptedCreditTypes';
        acceptedCreditTypes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantLookup',
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
