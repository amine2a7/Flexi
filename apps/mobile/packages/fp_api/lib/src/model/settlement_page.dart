//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:fp_api/src/model/settlement.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'settlement_page.g.dart';

/// Liste paginée de Settlement (§7).
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class SettlementPage implements Built<SettlementPage, SettlementPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Settlement> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  SettlementPage._();

  factory SettlementPage([void updates(SettlementPageBuilder b)]) = _$SettlementPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettlementPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettlementPage> get serializer => _$SettlementPageSerializer();
}

class _$SettlementPageSerializer implements PrimitiveSerializer<SettlementPage> {
  @override
  final Iterable<Type> types = const [SettlementPage, _$SettlementPage];

  @override
  final String wireName = r'SettlementPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettlementPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Settlement)]),
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
    SettlementPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SettlementPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Settlement)]),
          ) as BuiltList<Settlement>;
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
  SettlementPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettlementPageBuilder();
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


