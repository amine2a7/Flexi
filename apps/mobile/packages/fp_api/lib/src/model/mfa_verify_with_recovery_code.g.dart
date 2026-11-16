// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_verify_with_recovery_code.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaVerifyWithRecoveryCode extends MfaVerifyWithRecoveryCode {
  @override
  final String challengeId;
  @override
  final String recoveryCode;

  factory _$MfaVerifyWithRecoveryCode([
    void Function(MfaVerifyWithRecoveryCodeBuilder)? updates,
  ]) => (MfaVerifyWithRecoveryCodeBuilder()..update(updates))._build();

  _$MfaVerifyWithRecoveryCode._({
    required this.challengeId,
    required this.recoveryCode,
  }) : super._();
  @override
  MfaVerifyWithRecoveryCode rebuild(
    void Function(MfaVerifyWithRecoveryCodeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MfaVerifyWithRecoveryCodeBuilder toBuilder() =>
      MfaVerifyWithRecoveryCodeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaVerifyWithRecoveryCode &&
        challengeId == other.challengeId &&
        recoveryCode == other.recoveryCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, challengeId.hashCode);
    _$hash = $jc(_$hash, recoveryCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaVerifyWithRecoveryCode')
          ..add('challengeId', challengeId)
          ..add('recoveryCode', recoveryCode))
        .toString();
  }
}

class MfaVerifyWithRecoveryCodeBuilder
    implements
        Builder<MfaVerifyWithRecoveryCode, MfaVerifyWithRecoveryCodeBuilder> {
  _$MfaVerifyWithRecoveryCode? _$v;

  String? _challengeId;
  String? get challengeId => _$this._challengeId;
  set challengeId(String? challengeId) => _$this._challengeId = challengeId;

  String? _recoveryCode;
  String? get recoveryCode => _$this._recoveryCode;
  set recoveryCode(String? recoveryCode) => _$this._recoveryCode = recoveryCode;

  MfaVerifyWithRecoveryCodeBuilder() {
    MfaVerifyWithRecoveryCode._defaults(this);
  }

  MfaVerifyWithRecoveryCodeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _challengeId = $v.challengeId;
      _recoveryCode = $v.recoveryCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaVerifyWithRecoveryCode other) {
    _$v = other as _$MfaVerifyWithRecoveryCode;
  }

  @override
  void update(void Function(MfaVerifyWithRecoveryCodeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaVerifyWithRecoveryCode build() => _build();

  _$MfaVerifyWithRecoveryCode _build() {
    final _$result =
        _$v ??
        _$MfaVerifyWithRecoveryCode._(
          challengeId: BuiltValueNullFieldError.checkNotNull(
            challengeId,
            r'MfaVerifyWithRecoveryCode',
            'challengeId',
          ),
          recoveryCode: BuiltValueNullFieldError.checkNotNull(
            recoveryCode,
            r'MfaVerifyWithRecoveryCode',
            'recoveryCode',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
