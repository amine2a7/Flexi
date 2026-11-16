//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_enrollment.g.dart';

/// Secret TOTP en attente de confirmation (10 min, DP n° 23). Affiché une seule fois, jamais journalisé, jamais conservé par le client après l'écran. 
///
/// Properties:
/// * [otpauthUri] - URI `otpauth://totp/FlexiPay:<libellé>?secret=…&issuer=FlexiPay&algorithm=SHA1&digits=6&period=30` (DP n° 23), à transformer en QR **côté client**. Le libellé ne contient ni e-mail ni téléphone. 
/// * [secretBase32] - Même secret, en Base32, pour la saisie manuelle.
/// * [expiresAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class MfaEnrollment implements Built<MfaEnrollment, MfaEnrollmentBuilder> {
  /// URI `otpauth://totp/FlexiPay:<libellé>?secret=…&issuer=FlexiPay&algorithm=SHA1&digits=6&period=30` (DP n° 23), à transformer en QR **côté client**. Le libellé ne contient ni e-mail ni téléphone. 
  @BuiltValueField(wireName: r'otpauthUri')
  String get otpauthUri;

  /// Même secret, en Base32, pour la saisie manuelle.
  @BuiltValueField(wireName: r'secretBase32')
  String get secretBase32;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  MfaEnrollment._();

  factory MfaEnrollment([void updates(MfaEnrollmentBuilder b)]) = _$MfaEnrollment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaEnrollmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaEnrollment> get serializer => _$MfaEnrollmentSerializer();
}

class _$MfaEnrollmentSerializer implements PrimitiveSerializer<MfaEnrollment> {
  @override
  final Iterable<Type> types = const [MfaEnrollment, _$MfaEnrollment];

  @override
  final String wireName = r'MfaEnrollment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaEnrollment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'otpauthUri';
    yield serializers.serialize(
      object.otpauthUri,
      specifiedType: const FullType(String),
    );
    yield r'secretBase32';
    yield serializers.serialize(
      object.secretBase32,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaEnrollment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaEnrollmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'otpauthUri':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.otpauthUri = valueDes;
          break;
        case r'secretBase32':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.secretBase32 = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaEnrollment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaEnrollmentBuilder();
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


