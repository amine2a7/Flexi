//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mobile_mfa_verify_request.g.dart';

/// MobileMfaVerifyRequest
///
/// Properties:
/// * [challengeId] 
/// * [code] 
/// * [recoveryCode] 
/// * [deviceId] - Identifiant de l'installation de l'application (généré par l'app, gardé dans le Keychain / Keystore). La session mobile y est liée : un jeton présenté depuis un autre appareil est refusé. 
@BuiltValue()
abstract class MobileMfaVerifyRequest implements Built<MobileMfaVerifyRequest, MobileMfaVerifyRequestBuilder> {
  @BuiltValueField(wireName: r'challengeId')
  String get challengeId;

  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'recoveryCode')
  String? get recoveryCode;

  /// Identifiant de l'installation de l'application (généré par l'app, gardé dans le Keychain / Keystore). La session mobile y est liée : un jeton présenté depuis un autre appareil est refusé. 
  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  MobileMfaVerifyRequest._();

  factory MobileMfaVerifyRequest([void updates(MobileMfaVerifyRequestBuilder b)]) = _$MobileMfaVerifyRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MobileMfaVerifyRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MobileMfaVerifyRequest> get serializer => _$MobileMfaVerifyRequestSerializer();
}

class _$MobileMfaVerifyRequestSerializer implements PrimitiveSerializer<MobileMfaVerifyRequest> {
  @override
  final Iterable<Type> types = const [MobileMfaVerifyRequest, _$MobileMfaVerifyRequest];

  @override
  final String wireName = r'MobileMfaVerifyRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MobileMfaVerifyRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'challengeId';
    yield serializers.serialize(
      object.challengeId,
      specifiedType: const FullType(String),
    );
    if (object.code != null) {
      yield r'code';
      yield serializers.serialize(
        object.code,
        specifiedType: const FullType(String),
      );
    }
    if (object.recoveryCode != null) {
      yield r'recoveryCode';
      yield serializers.serialize(
        object.recoveryCode,
        specifiedType: const FullType(String),
      );
    }
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MobileMfaVerifyRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MobileMfaVerifyRequestBuilder result,
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.code = valueDes;
          break;
        case r'recoveryCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.recoveryCode = valueDes;
          break;
        case r'deviceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MobileMfaVerifyRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MobileMfaVerifyRequestBuilder();
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


