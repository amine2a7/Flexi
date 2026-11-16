//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_order.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credit_order_page.g.dart';

/// Liste paginée de CreditOrder (§7).
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class CreditOrderPage implements Built<CreditOrderPage, CreditOrderPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<CreditOrder> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  CreditOrderPage._();

  factory CreditOrderPage([void updates(CreditOrderPageBuilder b)]) = _$CreditOrderPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreditOrderPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreditOrderPage> get serializer => _$CreditOrderPageSerializer();
}

class _$CreditOrderPageSerializer implements PrimitiveSerializer<CreditOrderPage> {
  @override
  final Iterable<Type> types = const [CreditOrderPage, _$CreditOrderPage];

  @override
  final String wireName = r'CreditOrderPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreditOrderPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(CreditOrder)]),
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
    CreditOrderPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreditOrderPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreditOrder)]),
          ) as BuiltList<CreditOrder>;
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
  CreditOrderPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreditOrderPageBuilder();
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


