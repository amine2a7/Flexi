//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_verify_with_totp.g.dart';

/// MfaVerifyWithTotp
///
/// Properties:
/// * [challengeId] 
/// * [code] - Code TOTP (RFC 6238) à 6 chiffres (DP n° 23). Jamais journalisé.
@BuiltValue()
abstract class MfaVerifyWithTotp implements Built<MfaVerifyWithTotp, MfaVerifyWithTotpBuilder> {
  @BuiltValueField(wireName: r'challengeId')
  String get challengeId;

  /// Code TOTP (RFC 6238) à 6 chiffres (DP n° 23). Jamais journalisé.
  @BuiltValueField(wireName: r'code')
  String get code;

  MfaVerifyWithTotp._();

  factory MfaVerifyWithTotp([void updates(MfaVerifyWithTotpBuilder b)]) = _$MfaVerifyWithTotp;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaVerifyWithTotpBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaVerifyWithTotp> get serializer => _$MfaVerifyWithTotpSerializer();
}

class _$MfaVerifyWithTotpSerializer implements PrimitiveSerializer<MfaVerifyWithTotp> {
  @override
  final Iterable<Type> types = const [MfaVerifyWithTotp, _$MfaVerifyWithTotp];

  @override
  final String wireName = r'MfaVerifyWithTotp';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaVerifyWithTotp object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'challengeId';
    yield serializers.serialize(
      object.challengeId,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaVerifyWithTotp object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaVerifyWithTotpBuilder result,
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
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaVerifyWithTotp deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaVerifyWithTotpBuilder();
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


