//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:fp_api/src/model/dispute.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_page.g.dart';

/// DisputePage
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class DisputePage implements Built<DisputePage, DisputePageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Dispute> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  DisputePage._();

  factory DisputePage([void updates(DisputePageBuilder b)]) = _$DisputePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputePage> get serializer => _$DisputePageSerializer();
}

class _$DisputePageSerializer implements PrimitiveSerializer<DisputePage> {
  @override
  final Iterable<Type> types = const [DisputePage, _$DisputePage];

  @override
  final String wireName = r'DisputePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Dispute)]),
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
    DisputePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Dispute)]),
          ) as BuiltList<Dispute>;
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
  DisputePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputePageBuilder();
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


