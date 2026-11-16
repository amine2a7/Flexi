// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompanyUpdate extends CompanyUpdate {
  @override
  final String? name;
  @override
  final String? city;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? reason;

  factory _$CompanyUpdate([void Function(CompanyUpdateBuilder)? updates]) =>
      (CompanyUpdateBuilder()..update(updates))._build();

  _$CompanyUpdate._({this.name, this.city, this.phone, this.email, this.reason})
    : super._();
  @override
  CompanyUpdate rebuild(void Function(CompanyUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyUpdateBuilder toBuilder() => CompanyUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompanyUpdate &&
        name == other.name &&
        city == other.city &&
        phone == other.phone &&
        email == other.email &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompanyUpdate')
          ..add('name', name)
          ..add('city', city)
          ..add('phone', phone)
          ..add('email', email)
          ..add('reason', reason))
        .toString();
  }
}

class CompanyUpdateBuilder
    implements Builder<CompanyUpdate, CompanyUpdateBuilder> {
  _$CompanyUpdate? _$v;

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

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CompanyUpdateBuilder() {
    CompanyUpdate._defaults(this);
  }

  CompanyUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _city = $v.city;
      _phone = $v.phone;
      _email = $v.email;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompanyUpdate other) {
    _$v = other as _$CompanyUpdate;
  }

  @override
  void update(void Function(CompanyUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompanyUpdate build() => _build();

  _$CompanyUpdate _build() {
    final _$result =
        _$v ??
        _$CompanyUpdate._(
          name: name,
          city: city,
          phone: phone,
          email: email,
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
