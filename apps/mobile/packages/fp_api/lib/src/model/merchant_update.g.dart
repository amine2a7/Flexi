// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantUpdate extends MerchantUpdate {
  @override
  final String? name;
  @override
  final MerchantCategory? category;
  @override
  final String? city;
  @override
  final String? address;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? reason;

  factory _$MerchantUpdate([void Function(MerchantUpdateBuilder)? updates]) =>
      (MerchantUpdateBuilder()..update(updates))._build();

  _$MerchantUpdate._({
    this.name,
    this.category,
    this.city,
    this.address,
    this.phone,
    this.email,
    this.reason,
  }) : super._();
  @override
  MerchantUpdate rebuild(void Function(MerchantUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MerchantUpdateBuilder toBuilder() => MerchantUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantUpdate &&
        name == other.name &&
        category == other.category &&
        city == other.city &&
        address == other.address &&
        phone == other.phone &&
        email == other.email &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantUpdate')
          ..add('name', name)
          ..add('category', category)
          ..add('city', city)
          ..add('address', address)
          ..add('phone', phone)
          ..add('email', email)
          ..add('reason', reason))
        .toString();
  }
}

class MerchantUpdateBuilder
    implements Builder<MerchantUpdate, MerchantUpdateBuilder> {
  _$MerchantUpdate? _$v;

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

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  MerchantUpdateBuilder() {
    MerchantUpdate._defaults(this);
  }

  MerchantUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _category = $v.category;
      _city = $v.city;
      _address = $v.address;
      _phone = $v.phone;
      _email = $v.email;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantUpdate other) {
    _$v = other as _$MerchantUpdate;
  }

  @override
  void update(void Function(MerchantUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantUpdate build() => _build();

  _$MerchantUpdate _build() {
    final _$result =
        _$v ??
        _$MerchantUpdate._(
          name: name,
          category: category,
          city: city,
          address: address,
          phone: phone,
          email: email,
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
