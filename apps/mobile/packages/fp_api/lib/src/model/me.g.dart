// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Me extends Me {
  @override
  final String id;
  @override
  final String displayName;
  @override
  final Role role;
  @override
  final SubRole? subRole;
  @override
  final BuiltSet<String> permissions;
  @override
  final TenantSummary? tenant;
  @override
  final MeMfa mfa;
  @override
  final bool onboardingTourDone;

  factory _$Me([void Function(MeBuilder)? updates]) =>
      (MeBuilder()..update(updates))._build();

  _$Me._({
    required this.id,
    required this.displayName,
    required this.role,
    this.subRole,
    required this.permissions,
    this.tenant,
    required this.mfa,
    required this.onboardingTourDone,
  }) : super._();
  @override
  Me rebuild(void Function(MeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MeBuilder toBuilder() => MeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Me &&
        id == other.id &&
        displayName == other.displayName &&
        role == other.role &&
        subRole == other.subRole &&
        permissions == other.permissions &&
        tenant == other.tenant &&
        mfa == other.mfa &&
        onboardingTourDone == other.onboardingTourDone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, subRole.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, tenant.hashCode);
    _$hash = $jc(_$hash, mfa.hashCode);
    _$hash = $jc(_$hash, onboardingTourDone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Me')
          ..add('id', id)
          ..add('displayName', displayName)
          ..add('role', role)
          ..add('subRole', subRole)
          ..add('permissions', permissions)
          ..add('tenant', tenant)
          ..add('mfa', mfa)
          ..add('onboardingTourDone', onboardingTourDone))
        .toString();
  }
}

class MeBuilder implements Builder<Me, MeBuilder> {
  _$Me? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  Role? _role;
  Role? get role => _$this._role;
  set role(Role? role) => _$this._role = role;

  SubRole? _subRole;
  SubRole? get subRole => _$this._subRole;
  set subRole(SubRole? subRole) => _$this._subRole = subRole;

  SetBuilder<String>? _permissions;
  SetBuilder<String> get permissions =>
      _$this._permissions ??= SetBuilder<String>();
  set permissions(SetBuilder<String>? permissions) =>
      _$this._permissions = permissions;

  TenantSummaryBuilder? _tenant;
  TenantSummaryBuilder get tenant => _$this._tenant ??= TenantSummaryBuilder();
  set tenant(TenantSummaryBuilder? tenant) => _$this._tenant = tenant;

  MeMfaBuilder? _mfa;
  MeMfaBuilder get mfa => _$this._mfa ??= MeMfaBuilder();
  set mfa(MeMfaBuilder? mfa) => _$this._mfa = mfa;

  bool? _onboardingTourDone;
  bool? get onboardingTourDone => _$this._onboardingTourDone;
  set onboardingTourDone(bool? onboardingTourDone) =>
      _$this._onboardingTourDone = onboardingTourDone;

  MeBuilder() {
    Me._defaults(this);
  }

  MeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _displayName = $v.displayName;
      _role = $v.role;
      _subRole = $v.subRole;
      _permissions = $v.permissions.toBuilder();
      _tenant = $v.tenant?.toBuilder();
      _mfa = $v.mfa.toBuilder();
      _onboardingTourDone = $v.onboardingTourDone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Me other) {
    _$v = other as _$Me;
  }

  @override
  void update(void Function(MeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Me build() => _build();

  _$Me _build() {
    _$Me _$result;
    try {
      _$result =
          _$v ??
          _$Me._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Me', 'id'),
            displayName: BuiltValueNullFieldError.checkNotNull(
              displayName,
              r'Me',
              'displayName',
            ),
            role: BuiltValueNullFieldError.checkNotNull(role, r'Me', 'role'),
            subRole: subRole,
            permissions: permissions.build(),
            tenant: _tenant?.build(),
            mfa: mfa.build(),
            onboardingTourDone: BuiltValueNullFieldError.checkNotNull(
              onboardingTourDone,
              r'Me',
              'onboardingTourDone',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissions';
        permissions.build();
        _$failedField = 'tenant';
        _tenant?.build();
        _$failedField = 'mfa';
        mfa.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Me', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
