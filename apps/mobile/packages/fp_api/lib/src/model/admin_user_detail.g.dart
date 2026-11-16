// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminUserDetail extends AdminUserDetail {
  @override
  final TemporaryCredentials? credentials;
  @override
  final int? graceDays;
  @override
  final bool mfaEnabled;
  @override
  final bool pinLocked;
  @override
  final int? balanceMillimes;
  @override
  final BuiltList<UserAuditEntry> history;
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

  factory _$AdminUserDetail([void Function(AdminUserDetailBuilder)? updates]) =>
      (AdminUserDetailBuilder()..update(updates))._build();

  _$AdminUserDetail._({
    this.credentials,
    this.graceDays,
    required this.mfaEnabled,
    required this.pinLocked,
    this.balanceMillimes,
    required this.history,
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
  AdminUserDetail rebuild(void Function(AdminUserDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminUserDetailBuilder toBuilder() => AdminUserDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUserDetail &&
        credentials == other.credentials &&
        graceDays == other.graceDays &&
        mfaEnabled == other.mfaEnabled &&
        pinLocked == other.pinLocked &&
        balanceMillimes == other.balanceMillimes &&
        history == other.history &&
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
    _$hash = $jc(_$hash, credentials.hashCode);
    _$hash = $jc(_$hash, graceDays.hashCode);
    _$hash = $jc(_$hash, mfaEnabled.hashCode);
    _$hash = $jc(_$hash, pinLocked.hashCode);
    _$hash = $jc(_$hash, balanceMillimes.hashCode);
    _$hash = $jc(_$hash, history.hashCode);
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
    return (newBuiltValueToStringHelper(r'AdminUserDetail')
          ..add('credentials', credentials)
          ..add('graceDays', graceDays)
          ..add('mfaEnabled', mfaEnabled)
          ..add('pinLocked', pinLocked)
          ..add('balanceMillimes', balanceMillimes)
          ..add('history', history)
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

class AdminUserDetailBuilder
    implements
        Builder<AdminUserDetail, AdminUserDetailBuilder>,
        AdminUserBuilder {
  _$AdminUserDetail? _$v;

  TemporaryCredentialsBuilder? _credentials;
  TemporaryCredentialsBuilder get credentials =>
      _$this._credentials ??= TemporaryCredentialsBuilder();
  set credentials(covariant TemporaryCredentialsBuilder? credentials) =>
      _$this._credentials = credentials;

  int? _graceDays;
  int? get graceDays => _$this._graceDays;
  set graceDays(covariant int? graceDays) => _$this._graceDays = graceDays;

  bool? _mfaEnabled;
  bool? get mfaEnabled => _$this._mfaEnabled;
  set mfaEnabled(covariant bool? mfaEnabled) => _$this._mfaEnabled = mfaEnabled;

  bool? _pinLocked;
  bool? get pinLocked => _$this._pinLocked;
  set pinLocked(covariant bool? pinLocked) => _$this._pinLocked = pinLocked;

  int? _balanceMillimes;
  int? get balanceMillimes => _$this._balanceMillimes;
  set balanceMillimes(covariant int? balanceMillimes) =>
      _$this._balanceMillimes = balanceMillimes;

  ListBuilder<UserAuditEntry>? _history;
  ListBuilder<UserAuditEntry> get history =>
      _$this._history ??= ListBuilder<UserAuditEntry>();
  set history(covariant ListBuilder<UserAuditEntry>? history) =>
      _$this._history = history;

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

  AdminUserDetailBuilder() {
    AdminUserDetail._defaults(this);
  }

  AdminUserDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _credentials = $v.credentials?.toBuilder();
      _graceDays = $v.graceDays;
      _mfaEnabled = $v.mfaEnabled;
      _pinLocked = $v.pinLocked;
      _balanceMillimes = $v.balanceMillimes;
      _history = $v.history.toBuilder();
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
  void replace(covariant AdminUserDetail other) {
    _$v = other as _$AdminUserDetail;
  }

  @override
  void update(void Function(AdminUserDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUserDetail build() => _build();

  _$AdminUserDetail _build() {
    _$AdminUserDetail _$result;
    try {
      _$result =
          _$v ??
          _$AdminUserDetail._(
            credentials: _credentials?.build(),
            graceDays: graceDays,
            mfaEnabled: BuiltValueNullFieldError.checkNotNull(
              mfaEnabled,
              r'AdminUserDetail',
              'mfaEnabled',
            ),
            pinLocked: BuiltValueNullFieldError.checkNotNull(
              pinLocked,
              r'AdminUserDetail',
              'pinLocked',
            ),
            balanceMillimes: balanceMillimes,
            history: history.build(),
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminUserDetail',
              'id',
            ),
            displayName: BuiltValueNullFieldError.checkNotNull(
              displayName,
              r'AdminUserDetail',
              'displayName',
            ),
            email: BuiltValueNullFieldError.checkNotNull(
              email,
              r'AdminUserDetail',
              'email',
            ),
            role: BuiltValueNullFieldError.checkNotNull(
              role,
              r'AdminUserDetail',
              'role',
            ),
            subRole: subRole,
            tenant: _tenant?.build(),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminUserDetail',
              'status',
            ),
            graceUntil: graceUntil,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminUserDetail',
              'createdAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'credentials';
        _credentials?.build();

        _$failedField = 'history';
        history.build();

        _$failedField = 'tenant';
        _tenant?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminUserDetail',
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
