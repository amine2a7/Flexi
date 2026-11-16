// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_accounts_setting.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FamilyAccountsSetting extends FamilyAccountsSetting {
  @override
  final bool enabled;

  factory _$FamilyAccountsSetting([
    void Function(FamilyAccountsSettingBuilder)? updates,
  ]) => (FamilyAccountsSettingBuilder()..update(updates))._build();

  _$FamilyAccountsSetting._({required this.enabled}) : super._();
  @override
  FamilyAccountsSetting rebuild(
    void Function(FamilyAccountsSettingBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  FamilyAccountsSettingBuilder toBuilder() =>
      FamilyAccountsSettingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FamilyAccountsSetting && enabled == other.enabled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'FamilyAccountsSetting',
    )..add('enabled', enabled)).toString();
  }
}

class FamilyAccountsSettingBuilder
    implements Builder<FamilyAccountsSetting, FamilyAccountsSettingBuilder> {
  _$FamilyAccountsSetting? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  FamilyAccountsSettingBuilder() {
    FamilyAccountsSetting._defaults(this);
  }

  FamilyAccountsSettingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FamilyAccountsSetting other) {
    _$v = other as _$FamilyAccountsSetting;
  }

  @override
  void update(void Function(FamilyAccountsSettingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FamilyAccountsSetting build() => _build();

  _$FamilyAccountsSetting _build() {
    final _$result =
        _$v ??
        _$FamilyAccountsSetting._(
          enabled: BuiltValueNullFieldError.checkNotNull(
            enabled,
            r'FamilyAccountsSetting',
            'enabled',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
