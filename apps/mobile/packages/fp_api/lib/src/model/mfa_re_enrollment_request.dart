//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_re_enrollment_request.g.dart';

/// Preuve exigée pour remplacer un secret MFA en session complète (WB2-S01). Les deux champs sont obligatoires dans ce cas ; le corps est absent en session restreinte `MFA_ENROLL`. 
///
/// Properties:
/// * [currentPassword] 
/// * [currentCode] - Code de l'ancien secret TOTP (6 chiffres) ou code de secours encore valable.
@BuiltValue()
abstract class MfaReEnrollmentRequest implements Built<MfaReEnrollmentRequest, MfaReEnrollmentRequestBuilder> {
  @BuiltValueField(wireName: r'currentPassword')
  String? get currentPassword;

  /// Code de l'ancien secret TOTP (6 chiffres) ou code de secours encore valable.
  @BuiltValueField(wireName: r'currentCode')
  String? get currentCode;

  MfaReEnrollmentRequest._();

  factory MfaReEnrollmentRequest([void updates(MfaReEnrollmentRequestBuilder b)]) = _$MfaReEnrollmentRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaReEnrollmentRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaReEnrollmentRequest> get serializer => _$MfaReEnrollmentRequestSerializer();
}

class _$MfaReEnrollmentRequestSerializer implements PrimitiveSerializer<MfaReEnrollmentRequest> {
  @override
  final Iterable<Type> types = const [MfaReEnrollmentRequest, _$MfaReEnrollmentRequest];

  @override
  final String wireName = r'MfaReEnrollmentRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaReEnrollmentRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.currentPassword != null) {
      yield r'currentPassword';
      yield serializers.serialize(
        object.currentPassword,
        specifiedType: const FullType(String),
      );
    }
    if (object.currentCode != null) {
      yield r'currentCode';
      yield serializers.serialize(
        object.currentCode,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaReEnrollmentRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaReEnrollmentRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currentPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.currentPassword = valueDes;
          break;
        case r'currentCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  MfaReEnrollmentRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaReEnrollmentRequestBuilder();
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


