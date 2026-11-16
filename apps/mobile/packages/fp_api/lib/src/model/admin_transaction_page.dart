//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:fp_api/src/model/admin_transaction.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_transaction_page.g.dart';

/// AdminTransactionPage
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class AdminTransactionPage implements Built<AdminTransactionPage, AdminTransactionPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<AdminTransaction> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  AdminTransactionPage._();

  factory AdminTransactionPage([void updates(AdminTransactionPageBuilder b)]) = _$AdminTransactionPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTransactionPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTransactionPage> get serializer => _$AdminTransactionPageSerializer();
}

class _$AdminTransactionPageSerializer implements PrimitiveSerializer<AdminTransactionPage> {
  @override
  final Iterable<Type> types = const [AdminTransactionPage, _$AdminTransactionPage];

  @override
  final String wireName = r'AdminTransactionPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTransactionPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(AdminTransaction)]),
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
    AdminTransactionPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminTransactionPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminTransaction)]),
          ) as BuiltList<AdminTransaction>;
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
  AdminTransactionPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTransactionPageBuilder();
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


