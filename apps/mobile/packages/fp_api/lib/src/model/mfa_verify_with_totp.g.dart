// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_verify_with_totp.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaVerifyWithTotp extends MfaVerifyWithTotp {
  @override
  final String challengeId;
  @override
  final String code;

  factory _$MfaVerifyWithTotp([
    void Function(MfaVerifyWithTotpBuilder)? updates,
  ]) => (MfaVerifyWithTotpBuilder()..update(updates))._build();

  _$MfaVerifyWithTotp._({required this.challengeId, required this.code})
    : super._();
  @override
  MfaVerifyWithTotp rebuild(void Function(MfaVerifyWithTotpBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaVerifyWithTotpBuilder toBuilder() =>
      MfaVerifyWithTotpBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaVerifyWithTotp &&
        challengeId == other.challengeId &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, challengeId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaVerifyWithTotp')
          ..add('challengeId', challengeId)
          ..add('code', code))
        .toString();
  }
}

class MfaVerifyWithTotpBuilder
    implements Builder<MfaVerifyWithTotp, MfaVerifyWithTotpBuilder> {
  _$MfaVerifyWithTotp? _$v;

  String? _challengeId;
  String? get challengeId => _$this._challengeId;
  set challengeId(String? challengeId) => _$this._challengeId = challengeId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  MfaVerifyWithTotpBuilder() {
    MfaVerifyWithTotp._defaults(this);
  }

  MfaVerifyWithTotpBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _challengeId = $v.challengeId;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaVerifyWithTotp other) {
    _$v = other as _$MfaVerifyWithTotp;
  }

  @override
  void update(void Function(MfaVerifyWithTotpBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaVerifyWithTotp build() => _build();

  _$MfaVerifyWithTotp _build() {
    final _$result =
        _$v ??
        _$MfaVerifyWithTotp._(
          challengeId: BuiltValueNullFieldError.checkNotNull(
            challengeId,
            r'MfaVerifyWithTotp',
            'challengeId',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'MfaVerifyWithTotp',
            'code',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
