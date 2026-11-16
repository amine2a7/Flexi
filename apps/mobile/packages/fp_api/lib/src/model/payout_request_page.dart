//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:fp_api/src/model/payout_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_request_page.g.dart';

/// Liste paginée de PayoutRequest (§7).
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class PayoutRequestPage implements Built<PayoutRequestPage, PayoutRequestPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<PayoutRequest> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  PayoutRequestPage._();

  factory PayoutRequestPage([void updates(PayoutRequestPageBuilder b)]) = _$PayoutRequestPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutRequestPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutRequestPage> get serializer => _$PayoutRequestPageSerializer();
}

class _$PayoutRequestPageSerializer implements PrimitiveSerializer<PayoutRequestPage> {
  @override
  final Iterable<Type> types = const [PayoutRequestPage, _$PayoutRequestPage];

  @override
  final String wireName = r'PayoutRequestPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutRequestPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(PayoutRequest)]),
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
    PayoutRequestPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutRequestPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PayoutRequest)]),
          ) as BuiltList<PayoutRequest>;
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
  PayoutRequestPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutRequestPageBuilder();
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


