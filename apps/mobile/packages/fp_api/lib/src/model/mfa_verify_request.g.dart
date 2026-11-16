// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_verify_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaVerifyRequest extends MfaVerifyRequest {
  @override
  final OneOf oneOf;

  factory _$MfaVerifyRequest([
    void Function(MfaVerifyRequestBuilder)? updates,
  ]) => (MfaVerifyRequestBuilder()..update(updates))._build();

  _$MfaVerifyRequest._({required this.oneOf}) : super._();
  @override
  MfaVerifyRequest rebuild(void Function(MfaVerifyRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaVerifyRequestBuilder toBuilder() =>
      MfaVerifyRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaVerifyRequest && oneOf == other.oneOf;
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
      r'MfaVerifyRequest',
    )..add('oneOf', oneOf)).toString();
  }
}

class MfaVerifyRequestBuilder
    implements Builder<MfaVerifyRequest, MfaVerifyRequestBuilder> {
  _$MfaVerifyRequest? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  MfaVerifyRequestBuilder() {
    MfaVerifyRequest._defaults(this);
  }

  MfaVerifyRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaVerifyRequest other) {
    _$v = other as _$MfaVerifyRequest;
  }

  @override
  void update(void Function(MfaVerifyRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaVerifyRequest build() => _build();

  _$MfaVerifyRequest _build() {
    final _$result =
        _$v ??
        _$MfaVerifyRequest._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'MfaVerifyRequest',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
