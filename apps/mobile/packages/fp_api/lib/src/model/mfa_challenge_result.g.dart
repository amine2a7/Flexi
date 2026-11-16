// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_challenge_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MfaChallengeResultNextStepEnum
_$mfaChallengeResultNextStepEnum_MFA_CHALLENGE =
    const MfaChallengeResultNextStepEnum._('MFA_CHALLENGE');

MfaChallengeResultNextStepEnum _$mfaChallengeResultNextStepEnumValueOf(
  String name,
) {
  switch (name) {
    case 'MFA_CHALLENGE':
      return _$mfaChallengeResultNextStepEnum_MFA_CHALLENGE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MfaChallengeResultNextStepEnum>
_$mfaChallengeResultNextStepEnumValues =
    BuiltSet<MfaChallengeResultNextStepEnum>(
      const <MfaChallengeResultNextStepEnum>[
        _$mfaChallengeResultNextStepEnum_MFA_CHALLENGE,
      ],
    );

Serializer<MfaChallengeResultNextStepEnum>
_$mfaChallengeResultNextStepEnumSerializer =
    _$MfaChallengeResultNextStepEnumSerializer();

class _$MfaChallengeResultNextStepEnumSerializer
    implements PrimitiveSerializer<MfaChallengeResultNextStepEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MFA_CHALLENGE': 'MFA_CHALLENGE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MFA_CHALLENGE': 'MFA_CHALLENGE',
  };

  @override
  final Iterable<Type> types = const <Type>[MfaChallengeResultNextStepEnum];
  @override
  final String wireName = 'MfaChallengeResultNextStepEnum';

  @override
  Object serialize(
    Serializers serializers,
    MfaChallengeResultNextStepEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MfaChallengeResultNextStepEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MfaChallengeResultNextStepEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MfaChallengeResult extends MfaChallengeResult {
  @override
  final MfaChallengeResultNextStepEnum nextStep;
  @override
  final String challengeId;
  @override
  final DateTime challengeExpiresAt;

  factory _$MfaChallengeResult([
    void Function(MfaChallengeResultBuilder)? updates,
  ]) => (MfaChallengeResultBuilder()..update(updates))._build();

  _$MfaChallengeResult._({
    required this.nextStep,
    required this.challengeId,
    required this.challengeExpiresAt,
  }) : super._();
  @override
  MfaChallengeResult rebuild(
    void Function(MfaChallengeResultBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MfaChallengeResultBuilder toBuilder() =>
      MfaChallengeResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaChallengeResult &&
        nextStep == other.nextStep &&
        challengeId == other.challengeId &&
        challengeExpiresAt == other.challengeExpiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nextStep.hashCode);
    _$hash = $jc(_$hash, challengeId.hashCode);
    _$hash = $jc(_$hash, challengeExpiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaChallengeResult')
          ..add('nextStep', nextStep)
          ..add('challengeId', challengeId)
          ..add('challengeExpiresAt', challengeExpiresAt))
        .toString();
  }
}

class MfaChallengeResultBuilder
    implements Builder<MfaChallengeResult, MfaChallengeResultBuilder> {
  _$MfaChallengeResult? _$v;

  MfaChallengeResultNextStepEnum? _nextStep;
  MfaChallengeResultNextStepEnum? get nextStep => _$this._nextStep;
  set nextStep(MfaChallengeResultNextStepEnum? nextStep) =>
      _$this._nextStep = nextStep;

  String? _challengeId;
  String? get challengeId => _$this._challengeId;
  set challengeId(String? challengeId) => _$this._challengeId = challengeId;

  DateTime? _challengeExpiresAt;
  DateTime? get challengeExpiresAt => _$this._challengeExpiresAt;
  set challengeExpiresAt(DateTime? challengeExpiresAt) =>
      _$this._challengeExpiresAt = challengeExpiresAt;

  MfaChallengeResultBuilder() {
    MfaChallengeResult._defaults(this);
  }

  MfaChallengeResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nextStep = $v.nextStep;
      _challengeId = $v.challengeId;
      _challengeExpiresAt = $v.challengeExpiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaChallengeResult other) {
    _$v = other as _$MfaChallengeResult;
  }

  @override
  void update(void Function(MfaChallengeResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaChallengeResult build() => _build();

  _$MfaChallengeResult _build() {
    final _$result =
        _$v ??
        _$MfaChallengeResult._(
          nextStep: BuiltValueNullFieldError.checkNotNull(
            nextStep,
            r'MfaChallengeResult',
            'nextStep',
          ),
          challengeId: BuiltValueNullFieldError.checkNotNull(
            challengeId,
            r'MfaChallengeResult',
            'challengeId',
          ),
          challengeExpiresAt: BuiltValueNullFieldError.checkNotNull(
            challengeExpiresAt,
            r'MfaChallengeResult',
            'challengeExpiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
