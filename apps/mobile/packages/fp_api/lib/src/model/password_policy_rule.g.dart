// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_policy_rule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PasswordPolicyRule extends PasswordPolicyRule {
  @override
  final PasswordPolicyRuleCode code;
  @override
  final BuiltMap<String, int>? params;

  factory _$PasswordPolicyRule([
    void Function(PasswordPolicyRuleBuilder)? updates,
  ]) => (PasswordPolicyRuleBuilder()..update(updates))._build();

  _$PasswordPolicyRule._({required this.code, this.params}) : super._();
  @override
  PasswordPolicyRule rebuild(
    void Function(PasswordPolicyRuleBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PasswordPolicyRuleBuilder toBuilder() =>
      PasswordPolicyRuleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PasswordPolicyRule &&
        code == other.code &&
        params == other.params;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, params.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PasswordPolicyRule')
          ..add('code', code)
          ..add('params', params))
        .toString();
  }
}

class PasswordPolicyRuleBuilder
    implements Builder<PasswordPolicyRule, PasswordPolicyRuleBuilder> {
  _$PasswordPolicyRule? _$v;

  PasswordPolicyRuleCode? _code;
  PasswordPolicyRuleCode? get code => _$this._code;
  set code(PasswordPolicyRuleCode? code) => _$this._code = code;

  MapBuilder<String, int>? _params;
  MapBuilder<String, int> get params =>
      _$this._params ??= MapBuilder<String, int>();
  set params(MapBuilder<String, int>? params) => _$this._params = params;

  PasswordPolicyRuleBuilder() {
    PasswordPolicyRule._defaults(this);
  }

  PasswordPolicyRuleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _params = $v.params?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PasswordPolicyRule other) {
    _$v = other as _$PasswordPolicyRule;
  }

  @override
  void update(void Function(PasswordPolicyRuleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PasswordPolicyRule build() => _build();

  _$PasswordPolicyRule _build() {
    _$PasswordPolicyRule _$result;
    try {
      _$result =
          _$v ??
          _$PasswordPolicyRule._(
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'PasswordPolicyRule',
              'code',
            ),
            params: _params?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'params';
        _params?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PasswordPolicyRule',
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
