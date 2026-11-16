//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'temporary_credentials.g.dart';

/// Identifiant et mot de passe temporaire, renvoyés UNE seule fois (création d'une entreprise ou d'un commerçant, « Générer un nouveau mot de passe »), seulement à un administrateur qui gère les comptes. Jamais stockés en clair ; une fenêtre fermée = une nouvelle génération. 
///
/// Properties:
/// * [email] 
/// * [temporaryPassword] 
@BuiltValue()
abstract class TemporaryCredentials implements Built<TemporaryCredentials, TemporaryCredentialsBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'temporaryPassword')
  String get temporaryPassword;

  TemporaryCredentials._();

  factory TemporaryCredentials([void updates(TemporaryCredentialsBuilder b)]) = _$TemporaryCredentials;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TemporaryCredentialsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TemporaryCredentials> get serializer => _$TemporaryCredentialsSerializer();
}

class _$TemporaryCredentialsSerializer implements PrimitiveSerializer<TemporaryCredentials> {
  @override
  final Iterable<Type> types = const [TemporaryCredentials, _$TemporaryCredentials];

  @override
  final String wireName = r'TemporaryCredentials';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TemporaryCredentials object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'temporaryPassword';
    yield serializers.serialize(
      object.temporaryPassword,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TemporaryCredentials object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TemporaryCredentialsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'temporaryPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.temporaryPassword = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TemporaryCredentials deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TemporaryCredentialsBuilder();
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


