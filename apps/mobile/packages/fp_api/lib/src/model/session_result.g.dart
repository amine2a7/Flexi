// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SessionResult extends SessionResult {
  @override
  final SessionNextStep nextStep;
  @override
  final String csrfToken;
  @override
  final int idleTimeoutSeconds;
  @override
  final DateTime absoluteExpiresAt;
  @override
  final DateTime? restrictedUntil;

  factory _$SessionResult([void Function(SessionResultBuilder)? updates]) =>
      (SessionResultBuilder()..update(updates))._build();

  _$SessionResult._({
    required this.nextStep,
    required this.csrfToken,
    required this.idleTimeoutSeconds,
    required this.absoluteExpiresAt,
    this.restrictedUntil,
  }) : super._();
  @override
  SessionResult rebuild(void Function(SessionResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SessionResultBuilder toBuilder() => SessionResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SessionResult &&
        nextStep == other.nextStep &&
        csrfToken == other.csrfToken &&
        idleTimeoutSeconds == other.idleTimeoutSeconds &&
        absoluteExpiresAt == other.absoluteExpiresAt &&
        restrictedUntil == other.restrictedUntil;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nextStep.hashCode);
    _$hash = $jc(_$hash, csrfToken.hashCode);
    _$hash = $jc(_$hash, idleTimeoutSeconds.hashCode);
    _$hash = $jc(_$hash, absoluteExpiresAt.hashCode);
    _$hash = $jc(_$hash, restrictedUntil.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SessionResult')
          ..add('nextStep', nextStep)
          ..add('csrfToken', csrfToken)
          ..add('idleTimeoutSeconds', idleTimeoutSeconds)
          ..add('absoluteExpiresAt', absoluteExpiresAt)
          ..add('restrictedUntil', restrictedUntil))
        .toString();
  }
}

class SessionResultBuilder
    implements Builder<SessionResult, SessionResultBuilder> {
  _$SessionResult? _$v;

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

  DateTime? _restrictedUntil;
  DateTime? get restrictedUntil => _$this._restrictedUntil;
  set restrictedUntil(DateTime? restrictedUntil) =>
      _$this._restrictedUntil = restrictedUntil;

  SessionResultBuilder() {
    SessionResult._defaults(this);
  }

  SessionResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nextStep = $v.nextStep;
      _csrfToken = $v.csrfToken;
      _idleTimeoutSeconds = $v.idleTimeoutSeconds;
      _absoluteExpiresAt = $v.absoluteExpiresAt;
      _restrictedUntil = $v.restrictedUntil;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SessionResult other) {
    _$v = other as _$SessionResult;
  }

  @override
  void update(void Function(SessionResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SessionResult build() => _build();

  _$SessionResult _build() {
    final _$result =
        _$v ??
        _$SessionResult._(
          nextStep: BuiltValueNullFieldError.checkNotNull(
            nextStep,
            r'SessionResult',
            'nextStep',
          ),
          csrfToken: BuiltValueNullFieldError.checkNotNull(
            csrfToken,
            r'SessionResult',
            'csrfToken',
          ),
          idleTimeoutSeconds: BuiltValueNullFieldError.checkNotNull(
            idleTimeoutSeconds,
            r'SessionResult',
            'idleTimeoutSeconds',
          ),
          absoluteExpiresAt: BuiltValueNullFieldError.checkNotNull(
            absoluteExpiresAt,
            r'SessionResult',
            'absoluteExpiresAt',
          ),
          restrictedUntil: restrictedUntil,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
