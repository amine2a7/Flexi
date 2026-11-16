// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_reset_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PasswordResetRequest extends PasswordResetRequest {
  @override
  final OneOf oneOf;

  factory _$PasswordResetRequest([
    void Function(PasswordResetRequestBuilder)? updates,
  ]) => (PasswordResetRequestBuilder()..update(updates))._build();

  _$PasswordResetRequest._({required this.oneOf}) : super._();
  @override
  PasswordResetRequest rebuild(
    void Function(PasswordResetRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PasswordResetRequestBuilder toBuilder() =>
      PasswordResetRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PasswordResetRequest && oneOf == other.oneOf;
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
      r'PasswordResetRequest',
    )..add('oneOf', oneOf)).toString();
  }
}

class PasswordResetRequestBuilder
    implements Builder<PasswordResetRequest, PasswordResetRequestBuilder> {
  _$PasswordResetRequest? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  PasswordResetRequestBuilder() {
    PasswordResetRequest._defaults(this);
  }

  PasswordResetRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PasswordResetRequest other) {
    _$v = other as _$PasswordResetRequest;
  }

  @override
  void update(void Function(PasswordResetRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PasswordResetRequest build() => _build();

  _$PasswordResetRequest _build() {
    final _$result =
        _$v ??
        _$PasswordResetRequest._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'PasswordResetRequest',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
