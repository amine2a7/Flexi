// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_login_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MobileLoginRequest extends MobileLoginRequest {
  @override
  final String identifier;
  @override
  final String password;
  @override
  final String deviceId;

  factory _$MobileLoginRequest([
    void Function(MobileLoginRequestBuilder)? updates,
  ]) => (MobileLoginRequestBuilder()..update(updates))._build();

  _$MobileLoginRequest._({
    required this.identifier,
    required this.password,
    required this.deviceId,
  }) : super._();
  @override
  MobileLoginRequest rebuild(
    void Function(MobileLoginRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MobileLoginRequestBuilder toBuilder() =>
      MobileLoginRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MobileLoginRequest &&
        identifier == other.identifier &&
        password == other.password &&
        deviceId == other.deviceId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, identifier.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MobileLoginRequest')
          ..add('identifier', identifier)
          ..add('password', password)
          ..add('deviceId', deviceId))
        .toString();
  }
}

class MobileLoginRequestBuilder
    implements Builder<MobileLoginRequest, MobileLoginRequestBuilder> {
  _$MobileLoginRequest? _$v;

  String? _identifier;
  String? get identifier => _$this._identifier;
  set identifier(String? identifier) => _$this._identifier = identifier;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  MobileLoginRequestBuilder() {
    MobileLoginRequest._defaults(this);
  }

  MobileLoginRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _identifier = $v.identifier;
      _password = $v.password;
      _deviceId = $v.deviceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MobileLoginRequest other) {
    _$v = other as _$MobileLoginRequest;
  }

  @override
  void update(void Function(MobileLoginRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MobileLoginRequest build() => _build();

  _$MobileLoginRequest _build() {
    final _$result =
        _$v ??
        _$MobileLoginRequest._(
          identifier: BuiltValueNullFieldError.checkNotNull(
            identifier,
            r'MobileLoginRequest',
            'identifier',
          ),
          password: BuiltValueNullFieldError.checkNotNull(
            password,
            r'MobileLoginRequest',
            'password',
          ),
          deviceId: BuiltValueNullFieldError.checkNotNull(
            deviceId,
            r'MobileLoginRequest',
            'deviceId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
