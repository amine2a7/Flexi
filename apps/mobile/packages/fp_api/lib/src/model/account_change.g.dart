// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AccountChangeFieldsEnum _$accountChangeFieldsEnum_fieldName =
    const AccountChangeFieldsEnum._('fieldName');
const AccountChangeFieldsEnum _$accountChangeFieldsEnum_city =
    const AccountChangeFieldsEnum._('city');
const AccountChangeFieldsEnum _$accountChangeFieldsEnum_address =
    const AccountChangeFieldsEnum._('address');
const AccountChangeFieldsEnum _$accountChangeFieldsEnum_category =
    const AccountChangeFieldsEnum._('category');
const AccountChangeFieldsEnum _$accountChangeFieldsEnum_phone =
    const AccountChangeFieldsEnum._('phone');
const AccountChangeFieldsEnum _$accountChangeFieldsEnum_email =
    const AccountChangeFieldsEnum._('email');
const AccountChangeFieldsEnum _$accountChangeFieldsEnum_iban =
    const AccountChangeFieldsEnum._('iban');
const AccountChangeFieldsEnum _$accountChangeFieldsEnum_commissionGrid =
    const AccountChangeFieldsEnum._('commissionGrid');

AccountChangeFieldsEnum _$accountChangeFieldsEnumValueOf(String name) {
  switch (name) {
    case 'fieldName':
      return _$accountChangeFieldsEnum_fieldName;
    case 'city':
      return _$accountChangeFieldsEnum_city;
    case 'address':
      return _$accountChangeFieldsEnum_address;
    case 'category':
      return _$accountChangeFieldsEnum_category;
    case 'phone':
      return _$accountChangeFieldsEnum_phone;
    case 'email':
      return _$accountChangeFieldsEnum_email;
    case 'iban':
      return _$accountChangeFieldsEnum_iban;
    case 'commissionGrid':
      return _$accountChangeFieldsEnum_commissionGrid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AccountChangeFieldsEnum> _$accountChangeFieldsEnumValues =
    BuiltSet<AccountChangeFieldsEnum>(const <AccountChangeFieldsEnum>[
      _$accountChangeFieldsEnum_fieldName,
      _$accountChangeFieldsEnum_city,
      _$accountChangeFieldsEnum_address,
      _$accountChangeFieldsEnum_category,
      _$accountChangeFieldsEnum_phone,
      _$accountChangeFieldsEnum_email,
      _$accountChangeFieldsEnum_iban,
      _$accountChangeFieldsEnum_commissionGrid,
    ]);

Serializer<AccountChangeFieldsEnum> _$accountChangeFieldsEnumSerializer =
    _$AccountChangeFieldsEnumSerializer();

class _$AccountChangeFieldsEnumSerializer
    implements PrimitiveSerializer<AccountChangeFieldsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'fieldName': 'name',
    'city': 'city',
    'address': 'address',
    'category': 'category',
    'phone': 'phone',
    'email': 'email',
    'iban': 'iban',
    'commissionGrid': 'commissionGrid',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'name': 'fieldName',
    'city': 'city',
    'address': 'address',
    'category': 'category',
    'phone': 'phone',
    'email': 'email',
    'iban': 'iban',
    'commissionGrid': 'commissionGrid',
  };

  @override
  final Iterable<Type> types = const <Type>[AccountChangeFieldsEnum];
  @override
  final String wireName = 'AccountChangeFieldsEnum';

  @override
  Object serialize(
    Serializers serializers,
    AccountChangeFieldsEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AccountChangeFieldsEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AccountChangeFieldsEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AccountChange extends AccountChange {
  @override
  final DateTime occurredAt;
  @override
  final String actorName;
  @override
  final BuiltList<AccountChangeFieldsEnum> fields;
  @override
  final String? reason;

  factory _$AccountChange([void Function(AccountChangeBuilder)? updates]) =>
      (AccountChangeBuilder()..update(updates))._build();

  _$AccountChange._({
    required this.occurredAt,
    required this.actorName,
    required this.fields,
    this.reason,
  }) : super._();
  @override
  AccountChange rebuild(void Function(AccountChangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountChangeBuilder toBuilder() => AccountChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountChange &&
        occurredAt == other.occurredAt &&
        actorName == other.actorName &&
        fields == other.fields &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jc(_$hash, fields.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountChange')
          ..add('occurredAt', occurredAt)
          ..add('actorName', actorName)
          ..add('fields', fields)
          ..add('reason', reason))
        .toString();
  }
}

class AccountChangeBuilder
    implements Builder<AccountChange, AccountChangeBuilder> {
  _$AccountChange? _$v;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  ListBuilder<AccountChangeFieldsEnum>? _fields;
  ListBuilder<AccountChangeFieldsEnum> get fields =>
      _$this._fields ??= ListBuilder<AccountChangeFieldsEnum>();
  set fields(ListBuilder<AccountChangeFieldsEnum>? fields) =>
      _$this._fields = fields;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AccountChangeBuilder() {
    AccountChange._defaults(this);
  }

  AccountChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _occurredAt = $v.occurredAt;
      _actorName = $v.actorName;
      _fields = $v.fields.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountChange other) {
    _$v = other as _$AccountChange;
  }

  @override
  void update(void Function(AccountChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountChange build() => _build();

  _$AccountChange _build() {
    _$AccountChange _$result;
    try {
      _$result =
          _$v ??
          _$AccountChange._(
            occurredAt: BuiltValueNullFieldError.checkNotNull(
              occurredAt,
              r'AccountChange',
              'occurredAt',
            ),
            actorName: BuiltValueNullFieldError.checkNotNull(
              actorName,
              r'AccountChange',
              'actorName',
            ),
            fields: fields.build(),
            reason: reason,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'fields';
        fields.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AccountChange',
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
