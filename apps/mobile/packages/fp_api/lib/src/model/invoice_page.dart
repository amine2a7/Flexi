//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:fp_api/src/model/invoice.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_page.g.dart';

/// Liste paginée de Invoice (§7).
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class InvoicePage implements Built<InvoicePage, InvoicePageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Invoice> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  InvoicePage._();

  factory InvoicePage([void updates(InvoicePageBuilder b)]) = _$InvoicePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoicePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoicePage> get serializer => _$InvoicePageSerializer();
}

class _$InvoicePageSerializer implements PrimitiveSerializer<InvoicePage> {
  @override
  final Iterable<Type> types = const [InvoicePage, _$InvoicePage];

  @override
  final String wireName = r'InvoicePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoicePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Invoice)]),
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
    InvoicePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoicePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Invoice)]),
          ) as BuiltList<Invoice>;
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
  InvoicePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoicePageBuilder();
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


