// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_enrollment_confirm_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaEnrollmentConfirmResult extends MfaEnrollmentConfirmResult {
  @override
  final SessionNextStep nextStep;
  @override
  final String csrfToken;
  @override
  final int idleTimeoutSeconds;
  @override
  final DateTime absoluteExpiresAt;
  @override
  final BuiltSet<String> recoveryCodes;

  factory _$MfaEnrollmentConfirmResult([
    void Function(MfaEnrollmentConfirmResultBuilder)? updates,
  ]) => (MfaEnrollmentConfirmResultBuilder()..update(updates))._build();

  _$MfaEnrollmentConfirmResult._({
    required this.nextStep,
    required this.csrfToken,
    required this.idleTimeoutSeconds,
    required this.absoluteExpiresAt,
    required this.recoveryCodes,
  }) : super._();
  @override
  MfaEnrollmentConfirmResult rebuild(
    void Function(MfaEnrollmentConfirmResultBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MfaEnrollmentConfirmResultBuilder toBuilder() =>
      MfaEnrollmentConfirmResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaEnrollmentConfirmResult &&
        nextStep == other.nextStep &&
        csrfToken == other.csrfToken &&
        idleTimeoutSeconds == other.idleTimeoutSeconds &&
        absoluteExpiresAt == other.absoluteExpiresAt &&
        recoveryCodes == other.recoveryCodes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nextStep.hashCode);
    _$hash = $jc(_$hash, csrfToken.hashCode);
    _$hash = $jc(_$hash, idleTimeoutSeconds.hashCode);
    _$hash = $jc(_$hash, absoluteExpiresAt.hashCode);
    _$hash = $jc(_$hash, recoveryCodes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaEnrollmentConfirmResult')
          ..add('nextStep', nextStep)
          ..add('csrfToken', csrfToken)
          ..add('idleTimeoutSeconds', idleTimeoutSeconds)
          ..add('absoluteExpiresAt', absoluteExpiresAt)
          ..add('recoveryCodes', recoveryCodes))
        .toString();
  }
}

class MfaEnrollmentConfirmResultBuilder
    implements
        Builder<MfaEnrollmentConfirmResult, MfaEnrollmentConfirmResultBuilder> {
  _$MfaEnrollmentConfirmResult? _$v;

  SessionNextStep? _nextStep;
  SessionNextStep? get nextStep => _$this._nextStep;
  set nextStep(SessionNextStep? nextStep) => _$this._nextStep = nextStep;

  String? _csrfToken;
  String? get csrfToken => _$this._csrfToken;
  set csrfToken(String? csrfToken) => _$this._csrfToken = csrfToken;

  int? _idleTimeoutSeconds;
  int? get idleTimeoutSeconds => _$this._idleTimeoutSeconds;
  set idleTimeoutSeconds(int? idleTimeoutSeconds) =>
      _$this._idleTimeoutSeconds = idleTimeoutSeconds;

  DateTime? _absoluteExpiresAt;
  DateTime? get absoluteExpiresAt => _$this._absoluteExpiresAt;
  set absoluteExpiresAt(DateTime? absoluteExpiresAt) =>
      _$this._absoluteExpiresAt = absoluteExpiresAt;

  SetBuilder<String>? _recoveryCodes;
  SetBuilder<String> get recoveryCodes =>
      _$this._recoveryCodes ??= SetBuilder<String>();
  set recoveryCodes(SetBuilder<String>? recoveryCodes) =>
      _$this._recoveryCodes = recoveryCodes;

  MfaEnrollmentConfirmResultBuilder() {
    MfaEnrollmentConfirmResult._defaults(this);
  }

  MfaEnrollmentConfirmResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nextStep = $v.nextStep;
      _csrfToken = $v.csrfToken;
      _idleTimeoutSeconds = $v.idleTimeoutSeconds;
      _absoluteExpiresAt = $v.absoluteExpiresAt;
      _recoveryCodes = $v.recoveryCodes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaEnrollmentConfirmResult other) {
    _$v = other as _$MfaEnrollmentConfirmResult;
  }

  @override
  void update(void Function(MfaEnrollmentConfirmResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaEnrollmentConfirmResult build() => _build();

  _$MfaEnrollmentConfirmResult _build() {
    _$MfaEnrollmentConfirmResult _$result;
    try {
      _$result =
          _$v ??
          _$MfaEnrollmentConfirmResult._(
            nextStep: BuiltValueNullFieldError.checkNotNull(
              nextStep,
              r'MfaEnrollmentConfirmResult',
              'nextStep',
            ),
            csrfToken: BuiltValueNullFieldError.checkNotNull(
              csrfToken,
              r'MfaEnrollmentConfirmResult',
              'csrfToken',
            ),
            idleTimeoutSeconds: BuiltValueNullFieldError.checkNotNull(
              idleTimeoutSeconds,
              r'MfaEnrollmentConfirmResult',
              'idleTimeoutSeconds',
            ),
            absoluteExpiresAt: BuiltValueNullFieldError.checkNotNull(
              absoluteExpiresAt,
              r'MfaEnrollmentConfirmResult',
              'absoluteExpiresAt',
            ),
            recoveryCodes: recoveryCodes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'recoveryCodes';
        recoveryCodes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MfaEnrollmentConfirmResult',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
