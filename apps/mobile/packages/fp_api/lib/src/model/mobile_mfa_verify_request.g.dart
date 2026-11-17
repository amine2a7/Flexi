// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_mfa_verify_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MobileMfaVerifyRequest extends MobileMfaVerifyRequest {
  @override
  final String challengeId;
  @override
  final String? code;
  @override
  final String? recoveryCode;
  @override
  final String deviceId;

  factory _$MobileMfaVerifyRequest([
    void Function(MobileMfaVerifyRequestBuilder)? updates,
  ]) => (MobileMfaVerifyRequestBuilder()..update(updates))._build();

  _$MobileMfaVerifyRequest._({
    required this.challengeId,
    this.code,
    this.recoveryCode,
    required this.deviceId,
  }) : super._();
  @override
  MobileMfaVerifyRequest rebuild(
    void Function(MobileMfaVerifyRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MobileMfaVerifyRequestBuilder toBuilder() =>
      MobileMfaVerifyRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MobileMfaVerifyRequest &&
        challengeId == other.challengeId &&
        code == other.code &&
        recoveryCode == other.recoveryCode &&
        deviceId == other.deviceId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, challengeId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, recoveryCode.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MobileMfaVerifyRequest')
          ..add('challengeId', challengeId)
          ..add('code', code)
          ..add('recoveryCode', recoveryCode)
          ..add('deviceId', deviceId))
        .toString();
  }
}

class MobileMfaVerifyRequestBuilder
    implements Builder<MobileMfaVerifyRequest, MobileMfaVerifyRequestBuilder> {
  _$MobileMfaVerifyRequest? _$v;

  String? _challengeId;
  String? get challengeId => _$this._challengeId;
  set challengeId(String? challengeId) => _$this._challengeId = challengeId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _recoveryCode;
  String? get recoveryCode => _$this._recoveryCode;
  set recoveryCode(String? recoveryCode) => _$this._recoveryCode = recoveryCode;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  MobileMfaVerifyRequestBuilder() {
    MobileMfaVerifyRequest._defaults(this);
  }

  MobileMfaVerifyRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _challengeId = $v.challengeId;
      _code = $v.code;
      _recoveryCode = $v.recoveryCode;
      _deviceId = $v.deviceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MobileMfaVerifyRequest other) {
    _$v = other as _$MobileMfaVerifyRequest;
  }

  @override
  void update(void Function(MobileMfaVerifyRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MobileMfaVerifyRequest build() => _build();

  _$MobileMfaVerifyRequest _build() {
    final _$result =
        _$v ??
        _$MobileMfaVerifyRequest._(
          challengeId: BuiltValueNullFieldError.checkNotNull(
            challengeId,
            r'MobileMfaVerifyRequest',
            'challengeId',
          ),
          code: code,
          recoveryCode: recoveryCode,
          deviceId: BuiltValueNullFieldError.checkNotNull(
            deviceId,
            r'MobileMfaVerifyRequest',
            'deviceId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
