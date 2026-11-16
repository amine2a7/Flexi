// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_message.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactMessage extends ContactMessage {
  @override
  final String id;
  @override
  final String reference;
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
  @override
  final ContactMessageStatus status;
  @override
  final DateTime receivedAt;
  @override
  final DateTime? handledAt;
  @override
  final String? handledBy;
  @override
  final String? note;

  factory _$ContactMessage([void Function(ContactMessageBuilder)? updates]) =>
      (ContactMessageBuilder()..update(updates))._build();

  _$ContactMessage._({
    required this.id,
    required this.reference,
    required this.name,
    required this.email,
    this.phone,
    this.companyName,
    required this.requesterType,
    required this.message,
    required this.status,
    required this.receivedAt,
    this.handledAt,
    this.handledBy,
    this.note,
  }) : super._();
  @override
  ContactMessage rebuild(void Function(ContactMessageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContactMessageBuilder toBuilder() => ContactMessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactMessage &&
        id == other.id &&
        reference == other.reference &&
        name == other.name &&
        email == other.email &&
        phone == other.phone &&
        companyName == other.companyName &&
        requesterType == other.requesterType &&
        message == other.message &&
        status == other.status &&
        receivedAt == other.receivedAt &&
        handledAt == other.handledAt &&
        handledBy == other.handledBy &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, requesterType.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, receivedAt.hashCode);
    _$hash = $jc(_$hash, handledAt.hashCode);
    _$hash = $jc(_$hash, handledBy.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContactMessage')
          ..add('id', id)
          ..add('reference', reference)
          ..add('name', name)
          ..add('email', email)
          ..add('phone', phone)
          ..add('companyName', companyName)
          ..add('requesterType', requesterType)
          ..add('message', message)
          ..add('status', status)
          ..add('receivedAt', receivedAt)
          ..add('handledAt', handledAt)
          ..add('handledBy', handledBy)
          ..add('note', note))
        .toString();
  }
}

class ContactMessageBuilder
    implements Builder<ContactMessage, ContactMessageBuilder> {
  _$ContactMessage? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

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

  ContactMessageStatus? _status;
  ContactMessageStatus? get status => _$this._status;
  set status(ContactMessageStatus? status) => _$this._status = status;

  DateTime? _receivedAt;
  DateTime? get receivedAt => _$this._receivedAt;
  set receivedAt(DateTime? receivedAt) => _$this._receivedAt = receivedAt;

  DateTime? _handledAt;
  DateTime? get handledAt => _$this._handledAt;
  set handledAt(DateTime? handledAt) => _$this._handledAt = handledAt;

  String? _handledBy;
  String? get handledBy => _$this._handledBy;
  set handledBy(String? handledBy) => _$this._handledBy = handledBy;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ContactMessageBuilder() {
    ContactMessage._defaults(this);
  }

  ContactMessageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _name = $v.name;
      _email = $v.email;
      _phone = $v.phone;
      _companyName = $v.companyName;
      _requesterType = $v.requesterType;
      _message = $v.message;
      _status = $v.status;
      _receivedAt = $v.receivedAt;
      _handledAt = $v.handledAt;
      _handledBy = $v.handledBy;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactMessage other) {
    _$v = other as _$ContactMessage;
  }

  @override
  void update(void Function(ContactMessageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactMessage build() => _build();

  _$ContactMessage _build() {
    final _$result =
        _$v ??
        _$ContactMessage._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'ContactMessage',
            'id',
          ),
          reference: BuiltValueNullFieldError.checkNotNull(
            reference,
            r'ContactMessage',
            'reference',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'ContactMessage',
            'name',
          ),
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'ContactMessage',
            'email',
          ),
          phone: phone,
          companyName: companyName,
          requesterType: BuiltValueNullFieldError.checkNotNull(
            requesterType,
            r'ContactMessage',
            'requesterType',
          ),
          message: BuiltValueNullFieldError.checkNotNull(
            message,
            r'ContactMessage',
            'message',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'ContactMessage',
            'status',
          ),
          receivedAt: BuiltValueNullFieldError.checkNotNull(
            receivedAt,
            r'ContactMessage',
            'receivedAt',
          ),
          handledAt: handledAt,
          handledBy: handledBy,
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
