//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_enrollment_confirm_request.g.dart';

/// MfaEnrollmentConfirmRequest
///
/// Properties:
/// * [code] - Code TOTP (RFC 6238) à 6 chiffres (DP n° 23). Jamais journalisé.
@BuiltValue()
abstract class MfaEnrollmentConfirmRequest implements Built<MfaEnrollmentConfirmRequest, MfaEnrollmentConfirmRequestBuilder> {
  /// Code TOTP (RFC 6238) à 6 chiffres (DP n° 23). Jamais journalisé.
  @BuiltValueField(wireName: r'code')
  String get code;

  MfaEnrollmentConfirmRequest._();

  factory MfaEnrollmentConfirmRequest([void updates(MfaEnrollmentConfirmRequestBuilder b)]) = _$MfaEnrollmentConfirmRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaEnrollmentConfirmRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaEnrollmentConfirmRequest> get serializer => _$MfaEnrollmentConfirmRequestSerializer();
}

class _$MfaEnrollmentConfirmRequestSerializer implements PrimitiveSerializer<MfaEnrollmentConfirmRequest> {
  @override
  final Iterable<Type> types = const [MfaEnrollmentConfirmRequest, _$MfaEnrollmentConfirmRequest];

  @override
  final String wireName = r'MfaEnrollmentConfirmRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaEnrollmentConfirmRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaEnrollmentConfirmRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaEnrollmentConfirmRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  MfaEnrollmentConfirmRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaEnrollmentConfirmRequestBuilder();
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


