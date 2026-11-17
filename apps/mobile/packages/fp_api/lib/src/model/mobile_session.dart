//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/session_next_step.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mobile_session.g.dart';

/// Session mobile : jetons à garder dans le Keychain / Keystore uniquement. Jeton d'accès 15 min (`Authorization: Bearer`) ; jeton de renouvellement à usage unique : sa réutilisation révoque toute la session. Déconnexion = révocation. Échéance absolue (`refreshExpiresAt`), jamais repoussée par le renouvellement : bénéficiaire et propriétaire commerçant 30 jours, caissier 12 heures. 
///
/// Properties:
/// * [nextStep] 
/// * [accessToken] 
/// * [refreshToken] 
/// * [accessExpiresAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [refreshExpiresAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [restrictedUntil] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class MobileSession implements Built<MobileSession, MobileSessionBuilder> {
  @BuiltValueField(wireName: r'nextStep')
  SessionNextStep get nextStep;
  // enum nextStepEnum {  NONE,  PASSWORD_CHANGE,  MFA_ENROLL,  };

  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'accessExpiresAt')
  DateTime get accessExpiresAt;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'refreshExpiresAt')
  DateTime get refreshExpiresAt;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'restrictedUntil')
  DateTime? get restrictedUntil;

  MobileSession._();

  factory MobileSession([void updates(MobileSessionBuilder b)]) = _$MobileSession;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MobileSessionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MobileSession> get serializer => _$MobileSessionSerializer();
}

class _$MobileSessionSerializer implements PrimitiveSerializer<MobileSession> {
  @override
  final Iterable<Type> types = const [MobileSession, _$MobileSession];

  @override
  final String wireName = r'MobileSession';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MobileSession object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nextStep';
    yield serializers.serialize(
      object.nextStep,
      specifiedType: const FullType(SessionNextStep),
    );
    yield r'accessToken';
    yield serializers.serialize(
      object.accessToken,
      specifiedType: const FullType(String),
    );
    yield r'refreshToken';
    yield serializers.serialize(
      object.refreshToken,
      specifiedType: const FullType(String),
    );
    yield r'accessExpiresAt';
    yield serializers.serialize(
      object.accessExpiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'refreshExpiresAt';
    yield serializers.serialize(
      object.refreshExpiresAt,
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
    MobileSession object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MobileSessionBuilder result,
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
        case r'accessToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
          break;
        case r'refreshToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refreshToken = valueDes;
          break;
        case r'accessExpiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.accessExpiresAt = valueDes;
          break;
        case r'refreshExpiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.refreshExpiresAt = valueDes;
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
  MobileSession deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MobileSessionBuilder();
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


