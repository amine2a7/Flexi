//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/session_next_step.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'session_result.g.dart';

/// Session ouverte ou renouvelée (cookies posés par la même réponse).
///
/// Properties:
/// * [nextStep] 
/// * [csrfToken] - Jeton anti-CSRF lié à la session (§6), à conserver **en mémoire** uniquement et à envoyer dans `X-CSRF-Token` sur `POST`, `PUT`, `PATCH`, `DELETE`. Renouvelé à chaque réponse qui établit ou renouvelle la session. 
/// * [idleTimeoutSeconds] - Délai d'inactivité de la session (DP n° 18 : 900 s). Toute requête authentifiée le remet à zéro ; avertissement 2 min avant. 
/// * [absoluteExpiresAt] - Échéance absolue de la session (DP n° 18 : 8 h Entreprise et Commerçant, 4 h Administrateur ; égale à `restrictedUntil` en session restreinte `PASSWORD_CHANGE`). Jamais prolongée par le rafraîchissement. 
/// * [restrictedUntil] - Présent seulement quand `nextStep` = `PASSWORD_CHANGE` : échéance **absolue** de la session restreinte (10 min après la vérification du mot de passe temporaire, jamais prolongée par le rafraîchissement). Sert à l'avertissement d'expiration (WCAG 2.2.1). À l'échéance : `401 UNAUTHENTICATED` générique ; le mot de passe temporaire reste valable jusqu'à ses 72 h ou jusqu'au changement réussi. 
@BuiltValue()
abstract class SessionResult implements Built<SessionResult, SessionResultBuilder> {
  @BuiltValueField(wireName: r'nextStep')
  SessionNextStep get nextStep;
  // enum nextStepEnum {  NONE,  PASSWORD_CHANGE,  MFA_ENROLL,  };

  /// Jeton anti-CSRF lié à la session (§6), à conserver **en mémoire** uniquement et à envoyer dans `X-CSRF-Token` sur `POST`, `PUT`, `PATCH`, `DELETE`. Renouvelé à chaque réponse qui établit ou renouvelle la session. 
  @BuiltValueField(wireName: r'csrfToken')
  String get csrfToken;

  /// Délai d'inactivité de la session (DP n° 18 : 900 s). Toute requête authentifiée le remet à zéro ; avertissement 2 min avant. 
  @BuiltValueField(wireName: r'idleTimeoutSeconds')
  int get idleTimeoutSeconds;

  /// Échéance absolue de la session (DP n° 18 : 8 h Entreprise et Commerçant, 4 h Administrateur ; égale à `restrictedUntil` en session restreinte `PASSWORD_CHANGE`). Jamais prolongée par le rafraîchissement. 
  @BuiltValueField(wireName: r'absoluteExpiresAt')
  DateTime get absoluteExpiresAt;

  /// Présent seulement quand `nextStep` = `PASSWORD_CHANGE` : échéance **absolue** de la session restreinte (10 min après la vérification du mot de passe temporaire, jamais prolongée par le rafraîchissement). Sert à l'avertissement d'expiration (WCAG 2.2.1). À l'échéance : `401 UNAUTHENTICATED` générique ; le mot de passe temporaire reste valable jusqu'à ses 72 h ou jusqu'au changement réussi. 
  @BuiltValueField(wireName: r'restrictedUntil')
  DateTime? get restrictedUntil;

  SessionResult._();

  factory SessionResult([void updates(SessionResultBuilder b)]) = _$SessionResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SessionResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SessionResult> get serializer => _$SessionResultSerializer();
}

class _$SessionResultSerializer implements PrimitiveSerializer<SessionResult> {
  @override
  final Iterable<Type> types = const [SessionResult, _$SessionResult];

  @override
  final String wireName = r'SessionResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SessionResult object, {
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
    if (object.restrictedUntil != null) {
      yield r'restrictedUntil';
      yield serializers.serialize(
        object.restrictedUntil,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SessionResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SessionResultBuilder result,
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
        case r'restrictedUntil':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.restrictedUntil = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SessionResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SessionResultBuilder();
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


