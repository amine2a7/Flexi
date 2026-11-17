//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/checkout_refusal_reason.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_refusal.g.dart';

/// Dernier refus d'une confirmation par un client (la demande reste en attente, rien n'est débité) : envoyé en temps réel à la caisse avec le prénom du client, jamais un montant ni un solde. 
///
/// Properties:
/// * [code] 
/// * [reason] 
/// * [customerFirstName] 
/// * [occurredAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class CheckoutRefusal implements Built<CheckoutRefusal, CheckoutRefusalBuilder> {
  @BuiltValueField(wireName: r'code')
  CheckoutRefusalCodeEnum get code;
  // enum codeEnum {  INSUFFICIENT_FUNDS,  LIMIT_EXCEEDED,  CHECKOUT_REFUSED,  PAYMENT_DECLINED,  };

  @BuiltValueField(wireName: r'reason')
  CheckoutRefusalReason? get reason;
  // enum reasonEnum {  CREDIT_TYPE_NOT_ACCEPTED,  MERCHANT_NOT_ACTIVE,  CHECKOUT_EXPIRED,  ALREADY_PAID,  STICKER_INVALID,  NO_PENDING_CHECKOUT,  };

  @BuiltValueField(wireName: r'customerFirstName')
  String get customerFirstName;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'occurredAt')
  DateTime get occurredAt;

  CheckoutRefusal._();

  factory CheckoutRefusal([void updates(CheckoutRefusalBuilder b)]) = _$CheckoutRefusal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutRefusalBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutRefusal> get serializer => _$CheckoutRefusalSerializer();
}

class _$CheckoutRefusalSerializer implements PrimitiveSerializer<CheckoutRefusal> {
  @override
  final Iterable<Type> types = const [CheckoutRefusal, _$CheckoutRefusal];

  @override
  final String wireName = r'CheckoutRefusal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutRefusal object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(CheckoutRefusalCodeEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(CheckoutRefusalReason),
      );
    }
    yield r'customerFirstName';
    yield serializers.serialize(
      object.customerFirstName,
      specifiedType: const FullType(String),
    );
    yield r'occurredAt';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutRefusal object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckoutRefusalBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CheckoutRefusalCodeEnum),
          ) as CheckoutRefusalCodeEnum;
          result.code = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CheckoutRefusalReason),
          ) as CheckoutRefusalReason?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'customerFirstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.customerFirstName = valueDes;
          break;
        case r'occurredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutRefusal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutRefusalBuilder();
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


class CheckoutRefusalCodeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INSUFFICIENT_FUNDS')
  static const CheckoutRefusalCodeEnum INSUFFICIENT_FUNDS = _$checkoutRefusalCodeEnum_INSUFFICIENT_FUNDS;
  @BuiltValueEnumConst(wireName: r'LIMIT_EXCEEDED')
  static const CheckoutRefusalCodeEnum LIMIT_EXCEEDED = _$checkoutRefusalCodeEnum_LIMIT_EXCEEDED;
  @BuiltValueEnumConst(wireName: r'CHECKOUT_REFUSED')
  static const CheckoutRefusalCodeEnum CHECKOUT_REFUSED = _$checkoutRefusalCodeEnum_CHECKOUT_REFUSED;
  @BuiltValueEnumConst(wireName: r'PAYMENT_DECLINED')
  static const CheckoutRefusalCodeEnum PAYMENT_DECLINED = _$checkoutRefusalCodeEnum_PAYMENT_DECLINED;

  static Serializer<CheckoutRefusalCodeEnum> get serializer => _$checkoutRefusalCodeEnumSerializer;

  const CheckoutRefusalCodeEnum._(String name): super(name);

  static BuiltSet<CheckoutRefusalCodeEnum> get values => _$checkoutRefusalCodeEnumValues;
  static CheckoutRefusalCodeEnum valueOf(String name) => _$checkoutRefusalCodeEnumValueOf(name);
}

