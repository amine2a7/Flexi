//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_challenge_result.g.dart';

/// Mot de passe accepté, défi MFA à résoudre ; aucune session ni cookie.
///
/// Properties:
/// * [nextStep] 
/// * [challengeId] - Identifiant opaque du défi, usage unique, valable 5 min (DP n° 23).
/// * [challengeExpiresAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class MfaChallengeResult implements Built<MfaChallengeResult, MfaChallengeResultBuilder> {
  @BuiltValueField(wireName: r'nextStep')
  MfaChallengeResultNextStepEnum get nextStep;
  // enum nextStepEnum {  MFA_CHALLENGE,  };

  /// Identifiant opaque du défi, usage unique, valable 5 min (DP n° 23).
  @BuiltValueField(wireName: r'challengeId')
  String get challengeId;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'challengeExpiresAt')
  DateTime get challengeExpiresAt;

  MfaChallengeResult._();

  factory MfaChallengeResult([void updates(MfaChallengeResultBuilder b)]) = _$MfaChallengeResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaChallengeResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaChallengeResult> get serializer => _$MfaChallengeResultSerializer();
}

class _$MfaChallengeResultSerializer implements PrimitiveSerializer<MfaChallengeResult> {
  @override
  final Iterable<Type> types = const [MfaChallengeResult, _$MfaChallengeResult];

  @override
  final String wireName = r'MfaChallengeResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaChallengeResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nextStep';
    yield serializers.serialize(
      object.nextStep,
      specifiedType: const FullType(MfaChallengeResultNextStepEnum),
    );
    yield r'challengeId';
    yield serializers.serialize(
      object.challengeId,
      specifiedType: const FullType(String),
    );
    yield r'challengeExpiresAt';
    yield serializers.serialize(
      object.challengeExpiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaChallengeResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaChallengeResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'nextStep':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MfaChallengeResultNextStepEnum),
          ) as MfaChallengeResultNextStepEnum;
          result.nextStep = valueDes;
          break;
        case r'challengeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.challengeId = valueDes;
          break;
        case r'challengeExpiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.challengeExpiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaChallengeResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaChallengeResultBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


class MfaChallengeResultNextStepEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MFA_CHALLENGE')
  static const MfaChallengeResultNextStepEnum MFA_CHALLENGE = _$mfaChallengeResultNextStepEnum_MFA_CHALLENGE;

  static Serializer<MfaChallengeResultNextStepEnum> get serializer => _$mfaChallengeResultNextStepEnumSerializer;

  const MfaChallengeResultNextStepEnum._(String name): super(name);

  static BuiltSet<MfaChallengeResultNextStepEnum> get values => _$mfaChallengeResultNextStepEnumValues;
  static MfaChallengeResultNextStepEnum valueOf(String name) => _$mfaChallengeResultNextStepEnumValueOf(name);
}

