//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/mfa_challenge_result.dart';
import 'package:fp_api/src/model/session_result.dart';
import 'package:fp_api/src/model/session_next_step.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'login_result.g.dart';

/// Résultat d'une connexion acceptée : défi MFA (`nextStep: MFA_CHALLENGE`) ou session (`SessionResult`, `nextStep` ∈ `NONE`, `PASSWORD_CHANGE`, `MFA_ENROLL`). 
///
/// Properties:
/// * [nextStep] 
/// * [challengeId] - Identifiant opaque du défi, usage unique, valable 5 min (DP n° 23).
/// * [challengeExpiresAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [csrfToken] - Jeton anti-CSRF lié à la session (§6), à conserver **en mémoire** uniquement et à envoyer dans `X-CSRF-Token` sur `POST`, `PUT`, `PATCH`, `DELETE`. Renouvelé à chaque réponse qui établit ou renouvelle la session. 
/// * [idleTimeoutSeconds] - Délai d'inactivité de la session (DP n° 18 : 900 s). Toute requête authentifiée le remet à zéro ; avertissement 2 min avant. 
/// * [absoluteExpiresAt] - Échéance absolue de la session (DP n° 18 : 8 h Entreprise et Commerçant, 4 h Administrateur ; égale à `restrictedUntil` en session restreinte `PASSWORD_CHANGE`). Jamais prolongée par le rafraîchissement. 
/// * [restrictedUntil] - Présent seulement quand `nextStep` = `PASSWORD_CHANGE` : échéance **absolue** de la session restreinte (10 min après la vérification du mot de passe temporaire, jamais prolongée par le rafraîchissement). Sert à l'avertissement d'expiration (WCAG 2.2.1). À l'échéance : `401 UNAUTHENTICATED` générique ; le mot de passe temporaire reste valable jusqu'à ses 72 h ou jusqu'au changement réussi. 
@BuiltValue()
abstract class LoginResult implements Built<LoginResult, LoginResultBuilder> {
  /// One Of [MfaChallengeResult], [SessionResult]
  OneOf get oneOf;

  LoginResult._();

  factory LoginResult([void updates(LoginResultBuilder b)]) = _$LoginResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoginResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoginResult> get serializer => _$LoginResultSerializer();
}

class _$LoginResultSerializer implements PrimitiveSerializer<LoginResult> {
  @override
  final Iterable<Type> types = const [LoginResult, _$LoginResult];

  @override
  final String wireName = r'LoginResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoginResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    LoginResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(oneOf.value, specifiedType: FullType(oneOf.valueType))!;
  }

  @override
  LoginResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoginResultBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [FullType(MfaChallengeResult), FullType(SessionResult), ]);
    oneOfDataSrc = serialized;
    result.oneOf = serializers.deserialize(oneOfDataSrc, specifiedType: targetType) as OneOf;
    return result.build();
  }
}


