// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

abstract mixin class AdminUserBuilder {
  void replace(AdminUser other);
  void update(void Function(AdminUserBuilder) updates);
  String? get id;
  set id(String? id);

  String? get displayName;
  set displayName(String? displayName);

  String? get email;
  set email(String? email);

  Role? get role;
  set role(Role? role);

  SubRole? get subRole;
  set subRole(SubRole? subRole);

  AdminUserTenantBuilder get tenant;
  set tenant(AdminUserTenantBuilder? tenant);

  UserStatus? get status;
  set status(UserStatus? status);

  DateTime? get graceUntil;
  set graceUntil(DateTime? graceUntil);

  DateTime? get createdAt;
  set createdAt(DateTime? createdAt);
}

class _$$AdminUser extends $AdminUser {
  @override
  final String id;
  @override
  final String displayName;
  @override
  final String email;
  @override
  final Role role;
  @override
  final SubRole? subRole;
  @override
  final AdminUserTenant? tenant;
  @override
  final UserStatus status;
  @override
  final DateTime? graceUntil;
  @override
  final DateTime createdAt;

  factory _$$AdminUser([void Function($AdminUserBuilder)? updates]) =>
      ($AdminUserBuilder()..update(updates))._build();

  _$$AdminUser._({
    required this.id,
    required this.displayName,
    required this.email,
    required this.role,
    this.subRole,
    this.tenant,
    required this.status,
    this.graceUntil,
    required this.createdAt,
  }) : super._();
  @override
  $AdminUser rebuild(void Function($AdminUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  $AdminUserBuilder toBuilder() => $AdminUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is $AdminUser &&
        id == other.id &&
        displayName == other.displayName &&
        email == other.email &&
        role == other.role &&
        subRole == other.subRole &&
        tenant == other.tenant &&
        status == other.status &&
        graceUntil == other.graceUntil &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, subRole.hashCode);
    _$hash = $jc(_$hash, tenant.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, graceUntil.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'$AdminUser')
          ..add('id', id)
          ..add('displayName', displayName)
          ..add('email', email)
          ..add('role', role)
          ..add('subRole', subRole)
          ..add('tenant', tenant)
          ..add('status', status)
          ..add('graceUntil', graceUntil)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class $AdminUserBuilder
    implements Builder<$AdminUser, $AdminUserBuilder>, AdminUserBuilder {
  _$$AdminUser? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(covariant String? id) => _$this._id = id;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(covariant String? displayName) =>
      _$this._displayName = displayName;

  String? _email;
  String? get email => _$this._email;
  set email(covariant String? email) => _$this._email = email;

  Role? _role;
  Role? get role => _$this._role;
  set role(covariant Role? role) => _$this._role = role;

  SubRole? _subRole;
  SubRole? get subRole => _$this._subRole;
  set subRole(covariant SubRole? subRole) => _$this._subRole = subRole;

  AdminUserTenantBuilder? _tenant;
  AdminUserTenantBuilder get tenant =>
      _$this._tenant ??= AdminUserTenantBuilder();
  set tenant(covariant AdminUserTenantBuilder? tenant) =>
      _$this._tenant = tenant;

  UserStatus? _status;
  UserStatus? get status => _$this._status;
  set status(covariant UserStatus? status) => _$this._status = status;

  DateTime? _graceUntil;
  DateTime? get graceUntil => _$this._graceUntil;
  set graceUntil(covariant DateTime? graceUntil) =>
      _$this._graceUntil = graceUntil;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(covariant DateTime? createdAt) => _$this._createdAt = createdAt;

  $AdminUserBuilder() {
    $AdminUser._defaults(this);
  }

  $AdminUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _displayName = $v.displayName;
      _email = $v.email;
      _role = $v.role;
      _subRole = $v.subRole;
      _tenant = $v.tenant?.toBuilder();
      _status = $v.status;
      _graceUntil = $v.graceUntil;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant $AdminUser other) {
    _$v = other as _$$AdminUser;
  }

  @override
  void update(void Function($AdminUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  $AdminUser build() => _build();

  _$$AdminUser _build() {
    _$$AdminUser _$result;
    try {
      _$result =
          _$v ??
          _$$AdminUser._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'$AdminUser', 'id'),
            displayName: BuiltValueNullFieldError.checkNotNull(
              displayName,
              r'$AdminUser',
              'displayName',
            ),
            email: BuiltValueNullFieldError.checkNotNull(
              email,
              r'$AdminUser',
              'email',
            ),
            role: BuiltValueNullFieldError.checkNotNull(
              role,
              r'$AdminUser',
              'role',
            ),
            subRole: subRole,
            tenant: _tenant?.build(),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'$AdminUser',
              'status',
            ),
            graceUntil: graceUntil,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'$AdminUser',
              'createdAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tenant';
        _tenant?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'$AdminUser',
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
