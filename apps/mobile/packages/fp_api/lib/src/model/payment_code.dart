//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_code.g.dart';

/// PaymentCode
///
/// Properties:
/// * [code] - Code à 8 chiffres, à usage unique.
/// * [qrPayload] - Contenu du QR (`flexipay:pay:<code>`).
/// * [expiresAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [validitySeconds] 
@BuiltValue()
abstract class PaymentCode implements Built<PaymentCode, PaymentCodeBuilder> {
  /// Code à 8 chiffres, à usage unique.
  @BuiltValueField(wireName: r'code')
  String get code;

  /// Contenu du QR (`flexipay:pay:<code>`).
  @BuiltValueField(wireName: r'qrPayload')
  String get qrPayload;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'validitySeconds')
  int get validitySeconds;

  PaymentCode._();

  factory PaymentCode([void updates(PaymentCodeBuilder b)]) = _$PaymentCode;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentCodeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentCode> get serializer => _$PaymentCodeSerializer();
}

class _$PaymentCodeSerializer implements PrimitiveSerializer<PaymentCode> {
  @override
  final Iterable<Type> types = const [PaymentCode, _$PaymentCode];

  @override
  final String wireName = r'PaymentCode';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentCode object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'qrPayload';
    yield serializers.serialize(
      object.qrPayload,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'validitySeconds';
    yield serializers.serialize(
      object.validitySeconds,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentCode object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentCodeBuilder result,
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
        case r'qrPayload':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.qrPayload = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'validitySeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.validitySeconds = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentCode deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentCodeBuilder();
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


