//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/mobile_session.dart';
import 'package:fp_api/src/model/mfa_challenge_result.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'mobile_login200_response.g.dart';

/// MobileLogin200Response
///
/// Properties:
/// * [nextStep] 
/// * [accessToken] 
/// * [refreshToken] 
/// * [accessExpiresAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [refreshExpiresAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [restrictedUntil] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [challengeId] - Identifiant opaque du défi, usage unique, valable 5 min (DP n° 23).
/// * [challengeExpiresAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class MobileLogin200Response implements Built<MobileLogin200Response, MobileLogin200ResponseBuilder> {
  /// One Of [MfaChallengeResult], [MobileSession]
  OneOf get oneOf;

  MobileLogin200Response._();

  factory MobileLogin200Response([void updates(MobileLogin200ResponseBuilder b)]) = _$MobileLogin200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MobileLogin200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MobileLogin200Response> get serializer => _$MobileLogin200ResponseSerializer();
}

class _$MobileLogin200ResponseSerializer implements PrimitiveSerializer<MobileLogin200Response> {
  @override
  final Iterable<Type> types = const [MobileLogin200Response, _$MobileLogin200Response];

  @override
  final String wireName = r'MobileLogin200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MobileLogin200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    MobileLogin200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(oneOf.value, specifiedType: FullType(oneOf.valueType))!;
  }

  @override
  MobileLogin200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MobileLogin200ResponseBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [FullType(MobileSession), FullType(MfaChallengeResult), ]);
    oneOfDataSrc = serialized;
    result.oneOf = serializers.deserialize(oneOfDataSrc, specifiedType: targetType) as OneOf;
    return result.build();
  }
}


class MobileLogin200ResponseNextStepEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MFA_CHALLENGE')
  static const MobileLogin200ResponseNextStepEnum MFA_CHALLENGE = _$mobileLogin200ResponseNextStepEnum_MFA_CHALLENGE;

  static Serializer<MobileLogin200ResponseNextStepEnum> get serializer => _$mobileLogin200ResponseNextStepEnumSerializer;

  const MobileLogin200ResponseNextStepEnum._(String name): super(name);

  static BuiltSet<MobileLogin200ResponseNextStepEnum> get values => _$mobileLogin200ResponseNextStepEnumValues;
  static MobileLogin200ResponseNextStepEnum valueOf(String name) => _$mobileLogin200ResponseNextStepEnumValueOf(name);
}

