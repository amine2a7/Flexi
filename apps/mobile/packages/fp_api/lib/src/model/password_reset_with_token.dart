//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'password_reset_with_token.g.dart';

/// PasswordResetWithToken
///
/// Properties:
/// * [token] - Jeton à usage unique lu dans le fragment de l'URL du lien. Jamais journalisé.
/// * [newPassword] 
@BuiltValue()
abstract class PasswordResetWithToken implements Built<PasswordResetWithToken, PasswordResetWithTokenBuilder> {
  /// Jeton à usage unique lu dans le fragment de l'URL du lien. Jamais journalisé.
  @BuiltValueField(wireName: r'token')
  String get token;

  @BuiltValueField(wireName: r'newPassword')
  String get newPassword;

  PasswordResetWithToken._();

  factory PasswordResetWithToken([void updates(PasswordResetWithTokenBuilder b)]) = _$PasswordResetWithToken;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PasswordResetWithTokenBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PasswordResetWithToken> get serializer => _$PasswordResetWithTokenSerializer();
}

class _$PasswordResetWithTokenSerializer implements PrimitiveSerializer<PasswordResetWithToken> {
  @override
  final Iterable<Type> types = const [PasswordResetWithToken, _$PasswordResetWithToken];

  @override
  final String wireName = r'PasswordResetWithToken';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PasswordResetWithToken object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
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
    PasswordResetWithToken object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PasswordResetWithTokenBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
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
  PasswordResetWithToken deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PasswordResetWithTokenBuilder();
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


