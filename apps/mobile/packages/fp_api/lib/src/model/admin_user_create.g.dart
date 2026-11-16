// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminUserCreateSubRoleEnum _$adminUserCreateSubRoleEnum_SUPER_ADMIN =
    const AdminUserCreateSubRoleEnum._('SUPER_ADMIN');
const AdminUserCreateSubRoleEnum _$adminUserCreateSubRoleEnum_COMPLIANCE =
    const AdminUserCreateSubRoleEnum._('COMPLIANCE');
const AdminUserCreateSubRoleEnum _$adminUserCreateSubRoleEnum_FINANCE =
    const AdminUserCreateSubRoleEnum._('FINANCE');
const AdminUserCreateSubRoleEnum _$adminUserCreateSubRoleEnum_SUPPORT =
    const AdminUserCreateSubRoleEnum._('SUPPORT');

AdminUserCreateSubRoleEnum _$adminUserCreateSubRoleEnumValueOf(String name) {
  switch (name) {
    case 'SUPER_ADMIN':
      return _$adminUserCreateSubRoleEnum_SUPER_ADMIN;
    case 'COMPLIANCE':
      return _$adminUserCreateSubRoleEnum_COMPLIANCE;
    case 'FINANCE':
      return _$adminUserCreateSubRoleEnum_FINANCE;
    case 'SUPPORT':
      return _$adminUserCreateSubRoleEnum_SUPPORT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminUserCreateSubRoleEnum> _$adminUserCreateSubRoleEnumValues =
    BuiltSet<AdminUserCreateSubRoleEnum>(const <AdminUserCreateSubRoleEnum>[
      _$adminUserCreateSubRoleEnum_SUPER_ADMIN,
      _$adminUserCreateSubRoleEnum_COMPLIANCE,
      _$adminUserCreateSubRoleEnum_FINANCE,
      _$adminUserCreateSubRoleEnum_SUPPORT,
    ]);

Serializer<AdminUserCreateSubRoleEnum> _$adminUserCreateSubRoleEnumSerializer =
    _$AdminUserCreateSubRoleEnumSerializer();

class _$AdminUserCreateSubRoleEnumSerializer
    implements PrimitiveSerializer<AdminUserCreateSubRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SUPER_ADMIN': 'SUPER_ADMIN',
    'COMPLIANCE': 'COMPLIANCE',
    'FINANCE': 'FINANCE',
    'SUPPORT': 'SUPPORT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SUPER_ADMIN': 'SUPER_ADMIN',
    'COMPLIANCE': 'COMPLIANCE',
    'FINANCE': 'FINANCE',
    'SUPPORT': 'SUPPORT',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminUserCreateSubRoleEnum];
  @override
  final String wireName = 'AdminUserCreateSubRoleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminUserCreateSubRoleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminUserCreateSubRoleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminUserCreateSubRoleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminUserCreate extends AdminUserCreate {
  @override
  final String displayName;
  @override
  final String email;
  @override
  final AdminUserCreateSubRoleEnum subRole;
  @override
  final String reason;

  factory _$AdminUserCreate([void Function(AdminUserCreateBuilder)? updates]) =>
      (AdminUserCreateBuilder()..update(updates))._build();

  _$AdminUserCreate._({
    required this.displayName,
    required this.email,
    required this.subRole,
    required this.reason,
  }) : super._();
  @override
  AdminUserCreate rebuild(void Function(AdminUserCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminUserCreateBuilder toBuilder() => AdminUserCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUserCreate &&
        displayName == other.displayName &&
        email == other.email &&
        subRole == other.subRole &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, subRole.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminUserCreate')
          ..add('displayName', displayName)
          ..add('email', email)
          ..add('subRole', subRole)
          ..add('reason', reason))
        .toString();
  }
}

class AdminUserCreateBuilder
    implements Builder<AdminUserCreate, AdminUserCreateBuilder> {
  _$AdminUserCreate? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  AdminUserCreateSubRoleEnum? _subRole;
  AdminUserCreateSubRoleEnum? get subRole => _$this._subRole;
  set subRole(AdminUserCreateSubRoleEnum? subRole) => _$this._subRole = subRole;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminUserCreateBuilder() {
    AdminUserCreate._defaults(this);
  }

  AdminUserCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _email = $v.email;
      _subRole = $v.subRole;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminUserCreate other) {
    _$v = other as _$AdminUserCreate;
  }

  @override
  void update(void Function(AdminUserCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUserCreate build() => _build();

  _$AdminUserCreate _build() {
    final _$result =
        _$v ??
        _$AdminUserCreate._(
          displayName: BuiltValueNullFieldError.checkNotNull(
            displayName,
            r'AdminUserCreate',
            'displayName',
          ),
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'AdminUserCreate',
            'email',
          ),
          subRole: BuiltValueNullFieldError.checkNotNull(
            subRole,
            r'AdminUserCreate',
            'subRole',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminUserCreate',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
