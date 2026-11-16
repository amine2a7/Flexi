// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_proof_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaProofRequest extends MfaProofRequest {
  @override
  final String currentPassword;
  @override
  final String currentCode;

  factory _$MfaProofRequest([void Function(MfaProofRequestBuilder)? updates]) =>
      (MfaProofRequestBuilder()..update(updates))._build();

  _$MfaProofRequest._({
    required this.currentPassword,
    required this.currentCode,
  }) : super._();
  @override
  MfaProofRequest rebuild(void Function(MfaProofRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaProofRequestBuilder toBuilder() => MfaProofRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaProofRequest &&
        currentPassword == other.currentPassword &&
        currentCode == other.currentCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPassword.hashCode);
    _$hash = $jc(_$hash, currentCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaProofRequest')
          ..add('currentPassword', currentPassword)
          ..add('currentCode', currentCode))
        .toString();
  }
}

class MfaProofRequestBuilder
    implements Builder<MfaProofRequest, MfaProofRequestBuilder> {
  _$MfaProofRequest? _$v;

  String? _currentPassword;
  String? get currentPassword => _$this._currentPassword;
  set currentPassword(String? currentPassword) =>
      _$this._currentPassword = currentPassword;

  String? _currentCode;
  String? get currentCode => _$this._currentCode;
  set currentCode(String? currentCode) => _$this._currentCode = currentCode;

  MfaProofRequestBuilder() {
    MfaProofRequest._defaults(this);
  }

  MfaProofRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPassword = $v.currentPassword;
      _currentCode = $v.currentCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaProofRequest other) {
    _$v = other as _$MfaProofRequest;
  }

  @override
  void update(void Function(MfaProofRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaProofRequest build() => _build();

  _$MfaProofRequest _build() {
    final _$result =
        _$v ??
        _$MfaProofRequest._(
          currentPassword: BuiltValueNullFieldError.checkNotNull(
            currentPassword,
            r'MfaProofRequest',
            'currentPassword',
          ),
          currentCode: BuiltValueNullFieldError.checkNotNull(
            currentCode,
            r'MfaProofRequest',
            'currentCode',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
