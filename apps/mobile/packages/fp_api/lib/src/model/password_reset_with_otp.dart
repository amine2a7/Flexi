//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'password_reset_with_otp.g.dart';

/// PasswordResetWithOtp
///
/// Properties:
/// * [identifier] - Numéro de téléphone saisi à la demande. Jamais renvoyé ni journalisé en clair.
/// * [otp] - Code SMS à 6 chiffres (10 min, 5 essais). Jamais journalisé.
/// * [newPassword] 
@BuiltValue()
abstract class PasswordResetWithOtp implements Built<PasswordResetWithOtp, PasswordResetWithOtpBuilder> {
  /// Numéro de téléphone saisi à la demande. Jamais renvoyé ni journalisé en clair.
  @BuiltValueField(wireName: r'identifier')
  String get identifier;

  /// Code SMS à 6 chiffres (10 min, 5 essais). Jamais journalisé.
  @BuiltValueField(wireName: r'otp')
  String get otp;

  @BuiltValueField(wireName: r'newPassword')
  String get newPassword;

  PasswordResetWithOtp._();

  factory PasswordResetWithOtp([void updates(PasswordResetWithOtpBuilder b)]) = _$PasswordResetWithOtp;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PasswordResetWithOtpBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PasswordResetWithOtp> get serializer => _$PasswordResetWithOtpSerializer();
}

class _$PasswordResetWithOtpSerializer implements PrimitiveSerializer<PasswordResetWithOtp> {
  @override
  final Iterable<Type> types = const [PasswordResetWithOtp, _$PasswordResetWithOtp];

  @override
  final String wireName = r'PasswordResetWithOtp';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PasswordResetWithOtp object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'identifier';
    yield serializers.serialize(
      object.identifier,
      specifiedType: const FullType(String),
    );
    yield r'otp';
    yield serializers.serialize(
      object.otp,
      specifiedType: const FullType(String),
    );
    yield r'newPassword';
    yield serializers.serialize(
      object.newPassword,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PasswordResetWithOtp object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PasswordResetWithOtpBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'identifier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.identifier = valueDes;
          break;
        case r'otp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.otp = valueDes;
          break;
        case r'newPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.newPassword = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PasswordResetWithOtp deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PasswordResetWithOtpBuilder();
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


