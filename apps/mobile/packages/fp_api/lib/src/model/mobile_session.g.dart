// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_session.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MobileSession extends MobileSession {
  @override
  final SessionNextStep nextStep;
  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final DateTime accessExpiresAt;
  @override
  final DateTime refreshExpiresAt;
  @override
  final DateTime? restrictedUntil;

  factory _$MobileSession([void Function(MobileSessionBuilder)? updates]) =>
      (MobileSessionBuilder()..update(updates))._build();

  _$MobileSession._({
    required this.nextStep,
    required this.accessToken,
    required this.refreshToken,
    required this.accessExpiresAt,
    required this.refreshExpiresAt,
    this.restrictedUntil,
  }) : super._();
  @override
  MobileSession rebuild(void Function(MobileSessionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MobileSessionBuilder toBuilder() => MobileSessionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MobileSession &&
        nextStep == other.nextStep &&
        accessToken == other.accessToken &&
        refreshToken == other.refreshToken &&
        accessExpiresAt == other.accessExpiresAt &&
        refreshExpiresAt == other.refreshExpiresAt &&
        restrictedUntil == other.restrictedUntil;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nextStep.hashCode);
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, accessExpiresAt.hashCode);
    _$hash = $jc(_$hash, refreshExpiresAt.hashCode);
    _$hash = $jc(_$hash, restrictedUntil.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MobileSession')
          ..add('nextStep', nextStep)
          ..add('accessToken', accessToken)
          ..add('refreshToken', refreshToken)
          ..add('accessExpiresAt', accessExpiresAt)
          ..add('refreshExpiresAt', refreshExpiresAt)
          ..add('restrictedUntil', restrictedUntil))
        .toString();
  }
}

class MobileSessionBuilder
    implements Builder<MobileSession, MobileSessionBuilder> {
  _$MobileSession? _$v;

  SessionNextStep? _nextStep;
  SessionNextStep? get nextStep => _$this._nextStep;
  set nextStep(SessionNextStep? nextStep) => _$this._nextStep = nextStep;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  DateTime? _accessExpiresAt;
  DateTime? get accessExpiresAt => _$this._accessExpiresAt;
  set accessExpiresAt(DateTime? accessExpiresAt) =>
      _$this._accessExpiresAt = accessExpiresAt;

  DateTime? _refreshExpiresAt;
  DateTime? get refreshExpiresAt => _$this._refreshExpiresAt;
  set refreshExpiresAt(DateTime? refreshExpiresAt) =>
      _$this._refreshExpiresAt = refreshExpiresAt;

  DateTime? _restrictedUntil;
  DateTime? get restrictedUntil => _$this._restrictedUntil;
  set restrictedUntil(DateTime? restrictedUntil) =>
      _$this._restrictedUntil = restrictedUntil;

  MobileSessionBuilder() {
    MobileSession._defaults(this);
  }

  MobileSessionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nextStep = $v.nextStep;
      _accessToken = $v.accessToken;
      _refreshToken = $v.refreshToken;
      _accessExpiresAt = $v.accessExpiresAt;
      _refreshExpiresAt = $v.refreshExpiresAt;
      _restrictedUntil = $v.restrictedUntil;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MobileSession other) {
    _$v = other as _$MobileSession;
  }

  @override
  void update(void Function(MobileSessionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MobileSession build() => _build();

  _$MobileSession _build() {
    final _$result =
        _$v ??
        _$MobileSession._(
          nextStep: BuiltValueNullFieldError.checkNotNull(
            nextStep,
            r'MobileSession',
            'nextStep',
          ),
          accessToken: BuiltValueNullFieldError.checkNotNull(
            accessToken,
            r'MobileSession',
            'accessToken',
          ),
          refreshToken: BuiltValueNullFieldError.checkNotNull(
            refreshToken,
            r'MobileSession',
            'refreshToken',
          ),
          accessExpiresAt: BuiltValueNullFieldError.checkNotNull(
            accessExpiresAt,
            r'MobileSession',
            'accessExpiresAt',
          ),
          refreshExpiresAt: BuiltValueNullFieldError.checkNotNull(
            refreshExpiresAt,
            r'MobileSession',
            'refreshExpiresAt',
          ),
          restrictedUntil: restrictedUntil,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
