//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/merchant_payment.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_payment_page.g.dart';

/// Liste paginée de MerchantPayment (§7).
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class MerchantPaymentPage implements Built<MerchantPaymentPage, MerchantPaymentPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<MerchantPayment> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  MerchantPaymentPage._();

  factory MerchantPaymentPage([void updates(MerchantPaymentPageBuilder b)]) = _$MerchantPaymentPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPaymentPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPaymentPage> get serializer => _$MerchantPaymentPageSerializer();
}

class _$MerchantPaymentPageSerializer implements PrimitiveSerializer<MerchantPaymentPage> {
  @override
  final Iterable<Type> types = const [MerchantPaymentPage, _$MerchantPaymentPage];

  @override
  final String wireName = r'MerchantPaymentPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPaymentPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(MerchantPayment)]),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(PageInfo),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPaymentPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantPaymentPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantPayment)]),
          ) as BuiltList<MerchantPayment>;
          result.data.replace(valueDes);
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PageInfo),
          ) as PageInfo;
          result.page.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantPaymentPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPaymentPageBuilder();
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


