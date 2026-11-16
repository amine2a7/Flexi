//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/kyc_file_summary.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'kyc_file_page.g.dart';

/// KycFilePage
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class KycFilePage implements Built<KycFilePage, KycFilePageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<KycFileSummary> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  KycFilePage._();

  factory KycFilePage([void updates(KycFilePageBuilder b)]) = _$KycFilePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(KycFilePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<KycFilePage> get serializer => _$KycFilePageSerializer();
}

class _$KycFilePageSerializer implements PrimitiveSerializer<KycFilePage> {
  @override
  final Iterable<Type> types = const [KycFilePage, _$KycFilePage];

  @override
  final String wireName = r'KycFilePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    KycFilePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(KycFileSummary)]),
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
    KycFilePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required KycFilePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(KycFileSummary)]),
          ) as BuiltList<KycFileSummary>;
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
  KycFilePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = KycFilePageBuilder();
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


