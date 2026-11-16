//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/password_reset_with_token.dart';
import 'package:fp_api/src/model/password_reset_with_otp.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'password_reset_request.g.dart';

/// Lien par e-mail (`token`) ou code SMS (`identifier` + `otp`), DP n° 11.
///
/// Properties:
/// * [token] - Jeton à usage unique lu dans le fragment de l'URL du lien. Jamais journalisé.
/// * [newPassword] 
/// * [identifier] - Numéro de téléphone saisi à la demande. Jamais renvoyé ni journalisé en clair.
/// * [otp] - Code SMS à 6 chiffres (10 min, 5 essais). Jamais journalisé.
@BuiltValue()
abstract class PasswordResetRequest implements Built<PasswordResetRequest, PasswordResetRequestBuilder> {
  /// One Of [PasswordResetWithOtp], [PasswordResetWithToken]
  OneOf get oneOf;

  PasswordResetRequest._();

  factory PasswordResetRequest([void updates(PasswordResetRequestBuilder b)]) = _$PasswordResetRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PasswordResetRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PasswordResetRequest> get serializer => _$PasswordResetRequestSerializer();
}

class _$PasswordResetRequestSerializer implements PrimitiveSerializer<PasswordResetRequest> {
  @override
  final Iterable<Type> types = const [PasswordResetRequest, _$PasswordResetRequest];

  @override
  final String wireName = r'PasswordResetRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PasswordResetRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    PasswordResetRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(oneOf.value, specifiedType: FullType(oneOf.valueType))!;
  }

  @override
  PasswordResetRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PasswordResetRequestBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [FullType(PasswordResetWithToken), FullType(PasswordResetWithOtp), ]);
    oneOfDataSrc = serialized;
    result.oneOf = serializers.deserialize(oneOfDataSrc, specifiedType: targetType) as OneOf;
    return result.build();
  }
}


