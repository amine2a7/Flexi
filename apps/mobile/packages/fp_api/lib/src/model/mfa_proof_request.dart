//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_proof_request.g.dart';

/// Preuve de possession du compte et de la MFA actuelle (session complète).
///
/// Properties:
/// * [currentPassword] 
/// * [currentCode] - Code de l'ancien secret TOTP (6 chiffres) ou code de secours encore valable.
@BuiltValue()
abstract class MfaProofRequest implements Built<MfaProofRequest, MfaProofRequestBuilder> {
  @BuiltValueField(wireName: r'currentPassword')
  String get currentPassword;

  /// Code de l'ancien secret TOTP (6 chiffres) ou code de secours encore valable.
  @BuiltValueField(wireName: r'currentCode')
  String get currentCode;

  MfaProofRequest._();

  factory MfaProofRequest([void updates(MfaProofRequestBuilder b)]) = _$MfaProofRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaProofRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaProofRequest> get serializer => _$MfaProofRequestSerializer();
}

class _$MfaProofRequestSerializer implements PrimitiveSerializer<MfaProofRequest> {
  @override
  final Iterable<Type> types = const [MfaProofRequest, _$MfaProofRequest];

  @override
  final String wireName = r'MfaProofRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaProofRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currentPassword';
    yield serializers.serialize(
      object.currentPassword,
      specifiedType: const FullType(String),
    );
    yield r'currentCode';
    yield serializers.serialize(
      object.currentCode,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaProofRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaProofRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currentPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currentPassword = valueDes;
          break;
        case r'currentCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currentCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaProofRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaProofRequestBuilder();
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


