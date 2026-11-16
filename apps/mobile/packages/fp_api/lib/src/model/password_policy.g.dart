// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_policy.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PasswordPolicy extends PasswordPolicy {
  @override
  final BuiltList<PasswordPolicyRule> rules;

  factory _$PasswordPolicy([void Function(PasswordPolicyBuilder)? updates]) =>
      (PasswordPolicyBuilder()..update(updates))._build();

  _$PasswordPolicy._({required this.rules}) : super._();
  @override
  PasswordPolicy rebuild(void Function(PasswordPolicyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PasswordPolicyBuilder toBuilder() => PasswordPolicyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PasswordPolicy && rules == other.rules;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rules.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'PasswordPolicy',
    )..add('rules', rules)).toString();
  }
}

class PasswordPolicyBuilder
    implements Builder<PasswordPolicy, PasswordPolicyBuilder> {
  _$PasswordPolicy? _$v;

  ListBuilder<PasswordPolicyRule>? _rules;
  ListBuilder<PasswordPolicyRule> get rules =>
      _$this._rules ??= ListBuilder<PasswordPolicyRule>();
  set rules(ListBuilder<PasswordPolicyRule>? rules) => _$this._rules = rules;

  PasswordPolicyBuilder() {
    PasswordPolicy._defaults(this);
  }

  PasswordPolicyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rules = $v.rules.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PasswordPolicy other) {
    _$v = other as _$PasswordPolicy;
  }

  @override
  void update(void Function(PasswordPolicyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PasswordPolicy build() => _build();

  _$PasswordPolicy _build() {
    _$PasswordPolicy _$result;
    try {
      _$result = _$v ?? _$PasswordPolicy._(rules: rules.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rules';
        rules.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PasswordPolicy',
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
