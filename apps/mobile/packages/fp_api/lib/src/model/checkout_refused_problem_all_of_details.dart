//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/checkout_refusal_reason.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_refused_problem_all_of_details.g.dart';

/// CheckoutRefusedProblemAllOfDetails
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class CheckoutRefusedProblemAllOfDetails implements Built<CheckoutRefusedProblemAllOfDetails, CheckoutRefusedProblemAllOfDetailsBuilder> {
  @BuiltValueField(wireName: r'reason')
  CheckoutRefusalReason get reason;
  // enum reasonEnum {  CREDIT_TYPE_NOT_ACCEPTED,  MERCHANT_NOT_ACTIVE,  CHECKOUT_EXPIRED,  ALREADY_PAID,  STICKER_INVALID,  NO_PENDING_CHECKOUT,  };

  CheckoutRefusedProblemAllOfDetails._();

  factory CheckoutRefusedProblemAllOfDetails([void updates(CheckoutRefusedProblemAllOfDetailsBuilder b)]) = _$CheckoutRefusedProblemAllOfDetails;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutRefusedProblemAllOfDetailsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutRefusedProblemAllOfDetails> get serializer => _$CheckoutRefusedProblemAllOfDetailsSerializer();
}

class _$CheckoutRefusedProblemAllOfDetailsSerializer implements PrimitiveSerializer<CheckoutRefusedProblemAllOfDetails> {
  @override
  final Iterable<Type> types = const [CheckoutRefusedProblemAllOfDetails, _$CheckoutRefusedProblemAllOfDetails];

  @override
  final String wireName = r'CheckoutRefusedProblemAllOfDetails';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutRefusedProblemAllOfDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(CheckoutRefusalReason),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutRefusedProblemAllOfDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckoutRefusedProblemAllOfDetailsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CheckoutRefusalReason),
          ) as CheckoutRefusalReason;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutRefusedProblemAllOfDetails deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutRefusedProblemAllOfDetailsBuilder();
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


