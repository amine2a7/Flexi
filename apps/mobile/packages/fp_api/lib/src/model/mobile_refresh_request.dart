//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mobile_refresh_request.g.dart';

/// MobileRefreshRequest
///
/// Properties:
/// * [refreshToken] - Jeton de renouvellement à usage unique. Jamais journalisé.
/// * [deviceId] - Identifiant de l'installation de l'application (généré par l'app, gardé dans le Keychain / Keystore). La session mobile y est liée : un jeton présenté depuis un autre appareil est refusé. 
@BuiltValue()
abstract class MobileRefreshRequest implements Built<MobileRefreshRequest, MobileRefreshRequestBuilder> {
  /// Jeton de renouvellement à usage unique. Jamais journalisé.
  @BuiltValueField(wireName: r'refreshToken')
  String get refreshToken;

  /// Identifiant de l'installation de l'application (généré par l'app, gardé dans le Keychain / Keystore). La session mobile y est liée : un jeton présenté depuis un autre appareil est refusé. 
  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  MobileRefreshRequest._();

  factory MobileRefreshRequest([void updates(MobileRefreshRequestBuilder b)]) = _$MobileRefreshRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MobileRefreshRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MobileRefreshRequest> get serializer => _$MobileRefreshRequestSerializer();
}

class _$MobileRefreshRequestSerializer implements PrimitiveSerializer<MobileRefreshRequest> {
  @override
  final Iterable<Type> types = const [MobileRefreshRequest, _$MobileRefreshRequest];

  @override
  final String wireName = r'MobileRefreshRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MobileRefreshRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'refreshToken';
    yield serializers.serialize(
      object.refreshToken,
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
    MobileRefreshRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MobileRefreshRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'refreshToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refreshToken = valueDes;
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
  MobileRefreshRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MobileRefreshRequestBuilder();
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


