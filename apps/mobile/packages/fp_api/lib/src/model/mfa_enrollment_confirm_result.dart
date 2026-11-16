//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/session_next_step.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_enrollment_confirm_result.g.dart';

/// Session complète et codes de secours (affichés une seule fois).
///
/// Properties:
/// * [nextStep] 
/// * [csrfToken] - Jeton anti-CSRF lié à la session (§6), à conserver **en mémoire** uniquement et à envoyer dans `X-CSRF-Token` sur `POST`, `PUT`, `PATCH`, `DELETE`. Renouvelé à chaque réponse qui établit ou renouvelle la session. 
/// * [idleTimeoutSeconds] 
/// * [absoluteExpiresAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [recoveryCodes] 
@BuiltValue()
abstract class MfaEnrollmentConfirmResult implements Built<MfaEnrollmentConfirmResult, MfaEnrollmentConfirmResultBuilder> {
  @BuiltValueField(wireName: r'nextStep')
  SessionNextStep get nextStep;
  // enum nextStepEnum {  NONE,  PASSWORD_CHANGE,  MFA_ENROLL,  };

  /// Jeton anti-CSRF lié à la session (§6), à conserver **en mémoire** uniquement et à envoyer dans `X-CSRF-Token` sur `POST`, `PUT`, `PATCH`, `DELETE`. Renouvelé à chaque réponse qui établit ou renouvelle la session. 
  @BuiltValueField(wireName: r'csrfToken')
  String get csrfToken;

  @BuiltValueField(wireName: r'idleTimeoutSeconds')
  int get idleTimeoutSeconds;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'absoluteExpiresAt')
  DateTime get absoluteExpiresAt;

  @BuiltValueField(wireName: r'recoveryCodes')
  BuiltSet<String> get recoveryCodes;

  MfaEnrollmentConfirmResult._();

  factory MfaEnrollmentConfirmResult([void updates(MfaEnrollmentConfirmResultBuilder b)]) = _$MfaEnrollmentConfirmResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaEnrollmentConfirmResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaEnrollmentConfirmResult> get serializer => _$MfaEnrollmentConfirmResultSerializer();
}

class _$MfaEnrollmentConfirmResultSerializer implements PrimitiveSerializer<MfaEnrollmentConfirmResult> {
  @override
  final Iterable<Type> types = const [MfaEnrollmentConfirmResult, _$MfaEnrollmentConfirmResult];

  @override
  final String wireName = r'MfaEnrollmentConfirmResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaEnrollmentConfirmResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nextStep';
    yield serializers.serialize(
      object.nextStep,
      specifiedType: const FullType(SessionNextStep),
    );
    yield r'csrfToken';
    yield serializers.serialize(
      object.csrfToken,
      specifiedType: const FullType(String),
    );
    yield r'idleTimeoutSeconds';
    yield serializers.serialize(
      object.idleTimeoutSeconds,
      specifiedType: const FullType(int),
    );
    yield r'absoluteExpiresAt';
    yield serializers.serialize(
      object.absoluteExpiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'recoveryCodes';
    yield serializers.serialize(
      object.recoveryCodes,
      specifiedType: const FullType(BuiltSet, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaEnrollmentConfirmResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaEnrollmentConfirmResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'nextStep':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SessionNextStep),
          ) as SessionNextStep;
          result.nextStep = valueDes;
          break;
        case r'csrfToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.csrfToken = valueDes;
          break;
        case r'idleTimeoutSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.idleTimeoutSeconds = valueDes;
          break;
        case r'absoluteExpiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.absoluteExpiresAt = valueDes;
          break;
        case r'recoveryCodes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(String)]),
          ) as BuiltSet<String>;
          result.recoveryCodes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaEnrollmentConfirmResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaEnrollmentConfirmResultBuilder();
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


