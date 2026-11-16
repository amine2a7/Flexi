// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_code.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentCode extends PaymentCode {
  @override
  final String code;
  @override
  final String qrPayload;
  @override
  final DateTime expiresAt;
  @override
  final int validitySeconds;

  factory _$PaymentCode([void Function(PaymentCodeBuilder)? updates]) =>
      (PaymentCodeBuilder()..update(updates))._build();

  _$PaymentCode._({
    required this.code,
    required this.qrPayload,
    required this.expiresAt,
    required this.validitySeconds,
  }) : super._();
  @override
  PaymentCode rebuild(void Function(PaymentCodeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentCodeBuilder toBuilder() => PaymentCodeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentCode &&
        code == other.code &&
        qrPayload == other.qrPayload &&
        expiresAt == other.expiresAt &&
        validitySeconds == other.validitySeconds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, qrPayload.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, validitySeconds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentCode')
          ..add('code', code)
          ..add('qrPayload', qrPayload)
          ..add('expiresAt', expiresAt)
          ..add('validitySeconds', validitySeconds))
        .toString();
  }
}

class PaymentCodeBuilder implements Builder<PaymentCode, PaymentCodeBuilder> {
  _$PaymentCode? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _qrPayload;
  String? get qrPayload => _$this._qrPayload;
  set qrPayload(String? qrPayload) => _$this._qrPayload = qrPayload;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  int? _validitySeconds;
  int? get validitySeconds => _$this._validitySeconds;
  set validitySeconds(int? validitySeconds) =>
      _$this._validitySeconds = validitySeconds;

  PaymentCodeBuilder() {
    PaymentCode._defaults(this);
  }

  PaymentCodeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _qrPayload = $v.qrPayload;
      _expiresAt = $v.expiresAt;
      _validitySeconds = $v.validitySeconds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentCode other) {
    _$v = other as _$PaymentCode;
  }

  @override
  void update(void Function(PaymentCodeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentCode build() => _build();

  _$PaymentCode _build() {
    final _$result =
        _$v ??
        _$PaymentCode._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'PaymentCode',
            'code',
          ),
          qrPayload: BuiltValueNullFieldError.checkNotNull(
            qrPayload,
            r'PaymentCode',
            'qrPayload',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'PaymentCode',
            'expiresAt',
          ),
          validitySeconds: BuiltValueNullFieldError.checkNotNull(
            validitySeconds,
            r'PaymentCode',
            'validitySeconds',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
