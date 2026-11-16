// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_message_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactMessageCreate extends ContactMessageCreate {
  @override
  final String name;
  @override
  final String email;
  @override
  final String? phone;
  @override
  final String? companyName;
  @override
  final ContactRequesterType requesterType;
  @override
  final String message;

  factory _$ContactMessageCreate([
    void Function(ContactMessageCreateBuilder)? updates,
  ]) => (ContactMessageCreateBuilder()..update(updates))._build();

  _$ContactMessageCreate._({
    required this.name,
    required this.email,
    this.phone,
    this.companyName,
    required this.requesterType,
    required this.message,
  }) : super._();
  @override
  ContactMessageCreate rebuild(
    void Function(ContactMessageCreateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ContactMessageCreateBuilder toBuilder() =>
      ContactMessageCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactMessageCreate &&
        name == other.name &&
        email == other.email &&
        phone == other.phone &&
        companyName == other.companyName &&
        requesterType == other.requesterType &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, requesterType.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContactMessageCreate')
          ..add('name', name)
          ..add('email', email)
          ..add('phone', phone)
          ..add('companyName', companyName)
          ..add('requesterType', requesterType)
          ..add('message', message))
        .toString();
  }
}

class ContactMessageCreateBuilder
    implements Builder<ContactMessageCreate, ContactMessageCreateBuilder> {
  _$ContactMessageCreate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  ContactRequesterType? _requesterType;
  ContactRequesterType? get requesterType => _$this._requesterType;
  set requesterType(ContactRequesterType? requesterType) =>
      _$this._requesterType = requesterType;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ContactMessageCreateBuilder() {
    ContactMessageCreate._defaults(this);
  }

  ContactMessageCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _email = $v.email;
      _phone = $v.phone;
      _companyName = $v.companyName;
      _requesterType = $v.requesterType;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactMessageCreate other) {
    _$v = other as _$ContactMessageCreate;
  }

  @override
  void update(void Function(ContactMessageCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactMessageCreate build() => _build();

  _$ContactMessageCreate _build() {
    final _$result =
        _$v ??
        _$ContactMessageCreate._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'ContactMessageCreate',
            'name',
          ),
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'ContactMessageCreate',
            'email',
          ),
          phone: phone,
          companyName: companyName,
          requesterType: BuiltValueNullFieldError.checkNotNull(
            requesterType,
            r'ContactMessageCreate',
            'requesterType',
          ),
          message: BuiltValueNullFieldError.checkNotNull(
            message,
            r'ContactMessageCreate',
            'message',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
