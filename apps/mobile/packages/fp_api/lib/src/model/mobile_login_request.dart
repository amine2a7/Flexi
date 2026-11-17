//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mobile_login_request.g.dart';

/// MobileLoginRequest
///
/// Properties:
/// * [identifier] 
/// * [password] - Jamais journalisé.
/// * [deviceId] - Identifiant de l'installation de l'application (généré par l'app, gardé dans le Keychain / Keystore). La session mobile y est liée : un jeton présenté depuis un autre appareil est refusé. 
@BuiltValue()
abstract class MobileLoginRequest implements Built<MobileLoginRequest, MobileLoginRequestBuilder> {
  @BuiltValueField(wireName: r'identifier')
  String get identifier;

  /// Jamais journalisé.
  @BuiltValueField(wireName: r'password')
  String get password;

  /// Identifiant de l'installation de l'application (généré par l'app, gardé dans le Keychain / Keystore). La session mobile y est liée : un jeton présenté depuis un autre appareil est refusé. 
  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  MobileLoginRequest._();

  factory MobileLoginRequest([void updates(MobileLoginRequestBuilder b)]) = _$MobileLoginRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MobileLoginRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MobileLoginRequest> get serializer => _$MobileLoginRequestSerializer();
}

class _$MobileLoginRequestSerializer implements PrimitiveSerializer<MobileLoginRequest> {
  @override
  final Iterable<Type> types = const [MobileLoginRequest, _$MobileLoginRequest];

  @override
  final String wireName = r'MobileLoginRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MobileLoginRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'identifier';
    yield serializers.serialize(
      object.identifier,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MobileLoginRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MobileLoginRequestBuilder result,
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
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
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
  MobileLoginRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MobileLoginRequestBuilder();
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


