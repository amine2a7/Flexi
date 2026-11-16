//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_quote_request.g.dart';

/// PayoutQuoteRequest
///
/// Properties:
/// * [creditType] - Un virement porte sur les créances d'un seul type (commission du type).
/// * [grossMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
@BuiltValue()
abstract class PayoutQuoteRequest implements Built<PayoutQuoteRequest, PayoutQuoteRequestBuilder> {
  /// Un virement porte sur les créances d'un seul type (commission du type).
  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'grossMillimes')
  int get grossMillimes;

  PayoutQuoteRequest._();

  factory PayoutQuoteRequest([void updates(PayoutQuoteRequestBuilder b)]) = _$PayoutQuoteRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutQuoteRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutQuoteRequest> get serializer => _$PayoutQuoteRequestSerializer();
}

class _$PayoutQuoteRequestSerializer implements PrimitiveSerializer<PayoutQuoteRequest> {
  @override
  final Iterable<Type> types = const [PayoutQuoteRequest, _$PayoutQuoteRequest];

  @override
  final String wireName = r'PayoutQuoteRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutQuoteRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'creditType';
    yield serializers.serialize(
      object.creditType,
      specifiedType: const FullType(CreditType),
    );
    yield r'grossMillimes';
    yield serializers.serialize(
      object.grossMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PayoutQuoteRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutQuoteRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'creditType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreditType),
          ) as CreditType;
          result.creditType = valueDes;
          break;
        case r'grossMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.grossMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PayoutQuoteRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutQuoteRequestBuilder();
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


