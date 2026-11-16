//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/company_account.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'company_account_page.g.dart';

/// Liste paginée de CompanyAccount (§7).
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class CompanyAccountPage implements Built<CompanyAccountPage, CompanyAccountPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<CompanyAccount> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  CompanyAccountPage._();

  factory CompanyAccountPage([void updates(CompanyAccountPageBuilder b)]) = _$CompanyAccountPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompanyAccountPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompanyAccountPage> get serializer => _$CompanyAccountPageSerializer();
}

class _$CompanyAccountPageSerializer implements PrimitiveSerializer<CompanyAccountPage> {
  @override
  final Iterable<Type> types = const [CompanyAccountPage, _$CompanyAccountPage];

  @override
  final String wireName = r'CompanyAccountPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompanyAccountPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(CompanyAccount)]),
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
    CompanyAccountPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CompanyAccountPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CompanyAccount)]),
          ) as BuiltList<CompanyAccount>;
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
  CompanyAccountPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompanyAccountPageBuilder();
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


