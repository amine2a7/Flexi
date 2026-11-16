//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_initiate_request.g.dart';

/// PaymentInitiateRequest
///
/// Properties:
/// * [customerCode] - Code à 8 chiffres affiché par le client (60 s). Jamais journalisé.
/// * [creditType] - Type encaissé, parmi ceux acceptés par le commerçant (`422` sinon).
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
@BuiltValue()
abstract class PaymentInitiateRequest implements Built<PaymentInitiateRequest, PaymentInitiateRequestBuilder> {
  /// Code à 8 chiffres affiché par le client (60 s). Jamais journalisé.
  @BuiltValueField(wireName: r'customerCode')
  String get customerCode;

  /// Type encaissé, parmi ceux acceptés par le commerçant (`422` sinon).
  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  PaymentInitiateRequest._();

  factory PaymentInitiateRequest([void updates(PaymentInitiateRequestBuilder b)]) = _$PaymentInitiateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentInitiateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentInitiateRequest> get serializer => _$PaymentInitiateRequestSerializer();
}

class _$PaymentInitiateRequestSerializer implements PrimitiveSerializer<PaymentInitiateRequest> {
  @override
  final Iterable<Type> types = const [PaymentInitiateRequest, _$PaymentInitiateRequest];

  @override
  final String wireName = r'PaymentInitiateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentInitiateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'customerCode';
    yield serializers.serialize(
      object.customerCode,
      specifiedType: const FullType(String),
    );
    yield r'creditType';
    yield serializers.serialize(
      object.creditType,
      specifiedType: const FullType(CreditType),
    );
    yield r'amountMillimes';
    yield serializers.serialize(
      object.amountMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentInitiateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentInitiateRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'customerCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.customerCode = valueDes;
          break;
        case r'creditType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreditType),
          ) as CreditType;
          result.creditType = valueDes;
          break;
        case r'amountMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentInitiateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentInitiateRequestBuilder();
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


