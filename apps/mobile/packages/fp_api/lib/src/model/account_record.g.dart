// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AccountRecordKindEnum _$accountRecordKindEnum_COMPANY =
    const AccountRecordKindEnum._('COMPANY');
const AccountRecordKindEnum _$accountRecordKindEnum_MERCHANT =
    const AccountRecordKindEnum._('MERCHANT');

AccountRecordKindEnum _$accountRecordKindEnumValueOf(String name) {
  switch (name) {
    case 'COMPANY':
      return _$accountRecordKindEnum_COMPANY;
    case 'MERCHANT':
      return _$accountRecordKindEnum_MERCHANT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AccountRecordKindEnum> _$accountRecordKindEnumValues =
    BuiltSet<AccountRecordKindEnum>(const <AccountRecordKindEnum>[
      _$accountRecordKindEnum_COMPANY,
      _$accountRecordKindEnum_MERCHANT,
    ]);

Serializer<AccountRecordKindEnum> _$accountRecordKindEnumSerializer =
    _$AccountRecordKindEnumSerializer();

class _$AccountRecordKindEnumSerializer
    implements PrimitiveSerializer<AccountRecordKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COMPANY': 'COMPANY',
    'MERCHANT': 'MERCHANT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COMPANY': 'COMPANY',
    'MERCHANT': 'MERCHANT',
  };

  @override
  final Iterable<Type> types = const <Type>[AccountRecordKindEnum];
  @override
  final String wireName = 'AccountRecordKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AccountRecordKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AccountRecordKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AccountRecordKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AccountRecord extends AccountRecord {
  @override
  final String id;
  @override
  final AccountRecordKindEnum kind;
  @override
  final String name;
  @override
  final String city;
  @override
  final AccountStatus status;
  @override
  final LegalForm legalForm;
  @override
  final String email;
  @override
  final String? phone;
  @override
  final MerchantCategory? category;
  @override
  final String? address;
  @override
  final String? maskedIban;
  @override
  final CommissionGrid? commissionGrid;
  @override
  final BuiltList<CommissionGrid> gridVersions;
  @override
  final BuiltList<AccountChange> history;
  @override
  final BuiltList<Approval> requests;
  @override
  final DateTime createdAt;

  factory _$AccountRecord([void Function(AccountRecordBuilder)? updates]) =>
      (AccountRecordBuilder()..update(updates))._build();

  _$AccountRecord._({
    required this.id,
    required this.kind,
    required this.name,
    required this.city,
    required this.status,
    required this.legalForm,
    required this.email,
    this.phone,
    this.category,
    this.address,
    this.maskedIban,
    this.commissionGrid,
    required this.gridVersions,
    required this.history,
    required this.requests,
    required this.createdAt,
  }) : super._();
  @override
  AccountRecord rebuild(void Function(AccountRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountRecordBuilder toBuilder() => AccountRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountRecord &&
        id == other.id &&
        kind == other.kind &&
        name == other.name &&
        city == other.city &&
        status == other.status &&
        legalForm == other.legalForm &&
        email == other.email &&
        phone == other.phone &&
        category == other.category &&
        address == other.address &&
        maskedIban == other.maskedIban &&
        commissionGrid == other.commissionGrid &&
        gridVersions == other.gridVersions &&
        history == other.history &&
        requests == other.requests &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, legalForm.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, maskedIban.hashCode);
    _$hash = $jc(_$hash, commissionGrid.hashCode);
    _$hash = $jc(_$hash, gridVersions.hashCode);
    _$hash = $jc(_$hash, history.hashCode);
    _$hash = $jc(_$hash, requests.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountRecord')
          ..add('id', id)
          ..add('kind', kind)
          ..add('name', name)
          ..add('city', city)
          ..add('status', status)
          ..add('legalForm', legalForm)
          ..add('email', email)
          ..add('phone', phone)
          ..add('category', category)
          ..add('address', address)
          ..add('maskedIban', maskedIban)
          ..add('commissionGrid', commissionGrid)
          ..add('gridVersions', gridVersions)
          ..add('history', history)
          ..add('requests', requests)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AccountRecordBuilder
    implements Builder<AccountRecord, AccountRecordBuilder> {
  _$AccountRecord? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AccountRecordKindEnum? _kind;
  AccountRecordKindEnum? get kind => _$this._kind;
  set kind(AccountRecordKindEnum? kind) => _$this._kind = kind;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  AccountStatus? _status;
  AccountStatus? get status => _$this._status;
  set status(AccountStatus? status) => _$this._status = status;

  LegalForm? _legalForm;
  LegalForm? get legalForm => _$this._legalForm;
  set legalForm(LegalForm? legalForm) => _$this._legalForm = legalForm;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  MerchantCategory? _category;
  MerchantCategory? get category => _$this._category;
  set category(MerchantCategory? category) => _$this._category = category;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _maskedIban;
  String? get maskedIban => _$this._maskedIban;
  set maskedIban(String? maskedIban) => _$this._maskedIban = maskedIban;

  CommissionGridBuilder? _commissionGrid;
  CommissionGridBuilder get commissionGrid =>
      _$this._commissionGrid ??= CommissionGridBuilder();
  set commissionGrid(CommissionGridBuilder? commissionGrid) =>
      _$this._commissionGrid = commissionGrid;

  ListBuilder<CommissionGrid>? _gridVersions;
  ListBuilder<CommissionGrid> get gridVersions =>
      _$this._gridVersions ??= ListBuilder<CommissionGrid>();
  set gridVersions(ListBuilder<CommissionGrid>? gridVersions) =>
      _$this._gridVersions = gridVersions;

  ListBuilder<AccountChange>? _history;
  ListBuilder<AccountChange> get history =>
      _$this._history ??= ListBuilder<AccountChange>();
  set history(ListBuilder<AccountChange>? history) => _$this._history = history;

  ListBuilder<Approval>? _requests;
  ListBuilder<Approval> get requests =>
      _$this._requests ??= ListBuilder<Approval>();
  set requests(ListBuilder<Approval>? requests) => _$this._requests = requests;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AccountRecordBuilder() {
    AccountRecord._defaults(this);
  }

  AccountRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _name = $v.name;
      _city = $v.city;
      _status = $v.status;
      _legalForm = $v.legalForm;
      _email = $v.email;
      _phone = $v.phone;
      _category = $v.category;
      _address = $v.address;
      _maskedIban = $v.maskedIban;
      _commissionGrid = $v.commissionGrid?.toBuilder();
      _gridVersions = $v.gridVersions.toBuilder();
      _history = $v.history.toBuilder();
      _requests = $v.requests.toBuilder();
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountRecord other) {
    _$v = other as _$AccountRecord;
  }

  @override
  void update(void Function(AccountRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountRecord build() => _build();

  _$AccountRecord _build() {
    _$AccountRecord _$result;
    try {
      _$result =
          _$v ??
          _$AccountRecord._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AccountRecord',
              'id',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AccountRecord',
              'kind',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AccountRecord',
              'name',
            ),
            city: BuiltValueNullFieldError.checkNotNull(
              city,
              r'AccountRecord',
              'city',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AccountRecord',
              'status',
            ),
            legalForm: BuiltValueNullFieldError.checkNotNull(
              legalForm,
              r'AccountRecord',
              'legalForm',
            ),
            email: BuiltValueNullFieldError.checkNotNull(
              email,
              r'AccountRecord',
              'email',
            ),
            phone: phone,
            category: category,
            address: address,
            maskedIban: maskedIban,
            commissionGrid: _commissionGrid?.build(),
            gridVersions: gridVersions.build(),
            history: history.build(),
            requests: requests.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AccountRecord',
              'createdAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'commissionGrid';
        _commissionGrid?.build();
        _$failedField = 'gridVersions';
        gridVersions.build();
        _$failedField = 'history';
        history.build();
        _$failedField = 'requests';
        requests.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AccountRecord',
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
