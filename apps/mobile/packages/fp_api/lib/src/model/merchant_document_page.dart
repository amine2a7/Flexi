//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/merchant_document.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_document_page.g.dart';

/// Liste paginée de MerchantDocument (§7).
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class MerchantDocumentPage implements Built<MerchantDocumentPage, MerchantDocumentPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<MerchantDocument> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  MerchantDocumentPage._();

  factory MerchantDocumentPage([void updates(MerchantDocumentPageBuilder b)]) = _$MerchantDocumentPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantDocumentPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantDocumentPage> get serializer => _$MerchantDocumentPageSerializer();
}

class _$MerchantDocumentPageSerializer implements PrimitiveSerializer<MerchantDocumentPage> {
  @override
  final Iterable<Type> types = const [MerchantDocumentPage, _$MerchantDocumentPage];

  @override
  final String wireName = r'MerchantDocumentPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantDocumentPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(MerchantDocument)]),
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
    MerchantDocumentPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantDocumentPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantDocument)]),
          ) as BuiltList<MerchantDocument>;
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
  MerchantDocumentPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantDocumentPageBuilder();
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


