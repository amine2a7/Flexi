//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/settlement_batch.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'settlement_batch_page.g.dart';

/// Liste paginée de SettlementBatch (§7).
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class SettlementBatchPage implements Built<SettlementBatchPage, SettlementBatchPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<SettlementBatch> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  SettlementBatchPage._();

  factory SettlementBatchPage([void updates(SettlementBatchPageBuilder b)]) = _$SettlementBatchPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettlementBatchPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettlementBatchPage> get serializer => _$SettlementBatchPageSerializer();
}

class _$SettlementBatchPageSerializer implements PrimitiveSerializer<SettlementBatchPage> {
  @override
  final Iterable<Type> types = const [SettlementBatchPage, _$SettlementBatchPage];

  @override
  final String wireName = r'SettlementBatchPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettlementBatchPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(SettlementBatch)]),
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
    SettlementBatchPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SettlementBatchPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SettlementBatch)]),
          ) as BuiltList<SettlementBatch>;
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
  SettlementBatchPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettlementBatchPageBuilder();
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


