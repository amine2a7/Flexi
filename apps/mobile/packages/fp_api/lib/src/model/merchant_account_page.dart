//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/merchant_account.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_account_page.g.dart';

/// Liste paginée de MerchantAccount (§7).
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class MerchantAccountPage implements Built<MerchantAccountPage, MerchantAccountPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<MerchantAccount> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  MerchantAccountPage._();

  factory MerchantAccountPage([void updates(MerchantAccountPageBuilder b)]) = _$MerchantAccountPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantAccountPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantAccountPage> get serializer => _$MerchantAccountPageSerializer();
}

class _$MerchantAccountPageSerializer implements PrimitiveSerializer<MerchantAccountPage> {
  @override
  final Iterable<Type> types = const [MerchantAccountPage, _$MerchantAccountPage];

  @override
  final String wireName = r'MerchantAccountPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantAccountPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(MerchantAccount)]),
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
    MerchantAccountPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantAccountPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantAccount)]),
          ) as BuiltList<MerchantAccount>;
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
  MerchantAccountPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantAccountPageBuilder();
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


