// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_forgot_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PasswordForgotRequest extends PasswordForgotRequest {
  @override
  final String identifier;

  factory _$PasswordForgotRequest([
    void Function(PasswordForgotRequestBuilder)? updates,
  ]) => (PasswordForgotRequestBuilder()..update(updates))._build();

  _$PasswordForgotRequest._({required this.identifier}) : super._();
  @override
  PasswordForgotRequest rebuild(
    void Function(PasswordForgotRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PasswordForgotRequestBuilder toBuilder() =>
      PasswordForgotRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PasswordForgotRequest && identifier == other.identifier;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, identifier.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'PasswordForgotRequest',
    )..add('identifier', identifier)).toString();
  }
}

class PasswordForgotRequestBuilder
    implements Builder<PasswordForgotRequest, PasswordForgotRequestBuilder> {
  _$PasswordForgotRequest? _$v;

  String? _identifier;
  String? get identifier => _$this._identifier;
  set identifier(String? identifier) => _$this._identifier = identifier;

  PasswordForgotRequestBuilder() {
    PasswordForgotRequest._defaults(this);
  }

  PasswordForgotRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _identifier = $v.identifier;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PasswordForgotRequest other) {
    _$v = other as _$PasswordForgotRequest;
  }

  @override
  void update(void Function(PasswordForgotRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PasswordForgotRequest build() => _build();

  _$PasswordForgotRequest _build() {
    final _$result =
        _$v ??
        _$PasswordForgotRequest._(
          identifier: BuiltValueNullFieldError.checkNotNull(
            identifier,
            r'PasswordForgotRequest',
            'identifier',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
