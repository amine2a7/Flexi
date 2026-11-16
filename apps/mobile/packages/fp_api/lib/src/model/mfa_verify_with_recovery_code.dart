//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_verify_with_recovery_code.g.dart';

/// MfaVerifyWithRecoveryCode
///
/// Properties:
/// * [challengeId] 
/// * [recoveryCode] - Code de secours MFA (DP n° 10) : 10 caractères à usage unique, alphabet sans caractère ambigu (provisoire). Saisie insensible à la casse et aux tirets : le client met en majuscules et retire espaces et tirets avant l'envoi. Jamais journalisé. 
@BuiltValue()
abstract class MfaVerifyWithRecoveryCode implements Built<MfaVerifyWithRecoveryCode, MfaVerifyWithRecoveryCodeBuilder> {
  @BuiltValueField(wireName: r'challengeId')
  String get challengeId;

  /// Code de secours MFA (DP n° 10) : 10 caractères à usage unique, alphabet sans caractère ambigu (provisoire). Saisie insensible à la casse et aux tirets : le client met en majuscules et retire espaces et tirets avant l'envoi. Jamais journalisé. 
  @BuiltValueField(wireName: r'recoveryCode')
  String get recoveryCode;

  MfaVerifyWithRecoveryCode._();

  factory MfaVerifyWithRecoveryCode([void updates(MfaVerifyWithRecoveryCodeBuilder b)]) = _$MfaVerifyWithRecoveryCode;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaVerifyWithRecoveryCodeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaVerifyWithRecoveryCode> get serializer => _$MfaVerifyWithRecoveryCodeSerializer();
}

class _$MfaVerifyWithRecoveryCodeSerializer implements PrimitiveSerializer<MfaVerifyWithRecoveryCode> {
  @override
  final Iterable<Type> types = const [MfaVerifyWithRecoveryCode, _$MfaVerifyWithRecoveryCode];

  @override
  final String wireName = r'MfaVerifyWithRecoveryCode';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaVerifyWithRecoveryCode object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'challengeId';
    yield serializers.serialize(
      object.challengeId,
      specifiedType: const FullType(String),
    );
    yield r'recoveryCode';
    yield serializers.serialize(
      object.recoveryCode,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaVerifyWithRecoveryCode object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaVerifyWithRecoveryCodeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'challengeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.challengeId = valueDes;
          break;
        case r'recoveryCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.recoveryCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaVerifyWithRecoveryCode deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaVerifyWithRecoveryCodeBuilder();
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


