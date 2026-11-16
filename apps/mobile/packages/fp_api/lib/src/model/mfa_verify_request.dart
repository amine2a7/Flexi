//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/mfa_verify_with_recovery_code.dart';
import 'package:fp_api/src/model/mfa_verify_with_totp.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'mfa_verify_request.g.dart';

/// Code TOTP (`code`) **ou** code de secours (`recoveryCode`), jamais les deux.
///
/// Properties:
/// * [challengeId] 
/// * [code] - Code TOTP (RFC 6238) à 6 chiffres (DP n° 23). Jamais journalisé.
/// * [recoveryCode] - Code de secours MFA (DP n° 10) : 10 caractères à usage unique, alphabet sans caractère ambigu (provisoire). Saisie insensible à la casse et aux tirets : le client met en majuscules et retire espaces et tirets avant l'envoi. Jamais journalisé. 
@BuiltValue()
abstract class MfaVerifyRequest implements Built<MfaVerifyRequest, MfaVerifyRequestBuilder> {
  /// One Of [MfaVerifyWithRecoveryCode], [MfaVerifyWithTotp]
  OneOf get oneOf;

  MfaVerifyRequest._();

  factory MfaVerifyRequest([void updates(MfaVerifyRequestBuilder b)]) = _$MfaVerifyRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaVerifyRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaVerifyRequest> get serializer => _$MfaVerifyRequestSerializer();
}

class _$MfaVerifyRequestSerializer implements PrimitiveSerializer<MfaVerifyRequest> {
  @override
  final Iterable<Type> types = const [MfaVerifyRequest, _$MfaVerifyRequest];

  @override
  final String wireName = r'MfaVerifyRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaVerifyRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaVerifyRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(oneOf.value, specifiedType: FullType(oneOf.valueType))!;
  }

  @override
  MfaVerifyRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaVerifyRequestBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [FullType(MfaVerifyWithTotp), FullType(MfaVerifyWithRecoveryCode), ]);
    oneOfDataSrc = serialized;
    result.oneOf = serializers.deserialize(oneOfDataSrc, specifiedType: targetType) as OneOf;
    return result.build();
  }
}


