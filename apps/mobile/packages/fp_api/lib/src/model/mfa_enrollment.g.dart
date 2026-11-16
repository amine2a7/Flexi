// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_enrollment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaEnrollment extends MfaEnrollment {
  @override
  final String otpauthUri;
  @override
  final String secretBase32;
  @override
  final DateTime expiresAt;

  factory _$MfaEnrollment([void Function(MfaEnrollmentBuilder)? updates]) =>
      (MfaEnrollmentBuilder()..update(updates))._build();

  _$MfaEnrollment._({
    required this.otpauthUri,
    required this.secretBase32,
    required this.expiresAt,
  }) : super._();
  @override
  MfaEnrollment rebuild(void Function(MfaEnrollmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaEnrollmentBuilder toBuilder() => MfaEnrollmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaEnrollment &&
        otpauthUri == other.otpauthUri &&
        secretBase32 == other.secretBase32 &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, otpauthUri.hashCode);
    _$hash = $jc(_$hash, secretBase32.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaEnrollment')
          ..add('otpauthUri', otpauthUri)
          ..add('secretBase32', secretBase32)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class MfaEnrollmentBuilder
    implements Builder<MfaEnrollment, MfaEnrollmentBuilder> {
  _$MfaEnrollment? _$v;

  String? _otpauthUri;
  String? get otpauthUri => _$this._otpauthUri;
  set otpauthUri(String? otpauthUri) => _$this._otpauthUri = otpauthUri;

  String? _secretBase32;
  String? get secretBase32 => _$this._secretBase32;
  set secretBase32(String? secretBase32) => _$this._secretBase32 = secretBase32;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  MfaEnrollmentBuilder() {
    MfaEnrollment._defaults(this);
  }

  MfaEnrollmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _otpauthUri = $v.otpauthUri;
      _secretBase32 = $v.secretBase32;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaEnrollment other) {
    _$v = other as _$MfaEnrollment;
  }

  @override
  void update(void Function(MfaEnrollmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaEnrollment build() => _build();

  _$MfaEnrollment _build() {
    final _$result =
        _$v ??
        _$MfaEnrollment._(
          otpauthUri: BuiltValueNullFieldError.checkNotNull(
            otpauthUri,
            r'MfaEnrollment',
            'otpauthUri',
          ),
          secretBase32: BuiltValueNullFieldError.checkNotNull(
            secretBase32,
            r'MfaEnrollment',
            'secretBase32',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'MfaEnrollment',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
