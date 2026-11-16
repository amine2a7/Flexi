// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_tenant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminUserTenant extends AdminUserTenant {
  @override
  final String id;
  @override
  final String name;

  factory _$AdminUserTenant([void Function(AdminUserTenantBuilder)? updates]) =>
      (AdminUserTenantBuilder()..update(updates))._build();

  _$AdminUserTenant._({required this.id, required this.name}) : super._();
  @override
  AdminUserTenant rebuild(void Function(AdminUserTenantBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminUserTenantBuilder toBuilder() => AdminUserTenantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUserTenant && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminUserTenant')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AdminUserTenantBuilder
    implements Builder<AdminUserTenant, AdminUserTenantBuilder> {
  _$AdminUserTenant? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminUserTenantBuilder() {
    AdminUserTenant._defaults(this);
  }

  AdminUserTenantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminUserTenant other) {
    _$v = other as _$AdminUserTenant;
  }

  @override
  void update(void Function(AdminUserTenantBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUserTenant build() => _build();

  _$AdminUserTenant _build() {
    final _$result =
        _$v ??
        _$AdminUserTenant._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminUserTenant',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminUserTenant',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
