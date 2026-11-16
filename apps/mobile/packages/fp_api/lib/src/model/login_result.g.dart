// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoginResult extends LoginResult {
  @override
  final OneOf oneOf;

  factory _$LoginResult([void Function(LoginResultBuilder)? updates]) =>
      (LoginResultBuilder()..update(updates))._build();

  _$LoginResult._({required this.oneOf}) : super._();
  @override
  LoginResult rebuild(void Function(LoginResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginResultBuilder toBuilder() => LoginResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginResult && oneOf == other.oneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'LoginResult',
    )..add('oneOf', oneOf)).toString();
  }
}

class LoginResultBuilder implements Builder<LoginResult, LoginResultBuilder> {
  _$LoginResult? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  LoginResultBuilder() {
    LoginResult._defaults(this);
  }

  LoginResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginResult other) {
    _$v = other as _$LoginResult;
  }

  @override
  void update(void Function(LoginResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginResult build() => _build();

  _$LoginResult _build() {
    final _$result =
        _$v ??
        _$LoginResult._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'LoginResult',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
