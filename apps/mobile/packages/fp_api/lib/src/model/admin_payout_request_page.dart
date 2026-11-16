//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:fp_api/src/model/admin_payout_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_payout_request_page.g.dart';

/// AdminPayoutRequestPage
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class AdminPayoutRequestPage implements Built<AdminPayoutRequestPage, AdminPayoutRequestPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<AdminPayoutRequest> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  AdminPayoutRequestPage._();

  factory AdminPayoutRequestPage([void updates(AdminPayoutRequestPageBuilder b)]) = _$AdminPayoutRequestPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPayoutRequestPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPayoutRequestPage> get serializer => _$AdminPayoutRequestPageSerializer();
}

class _$AdminPayoutRequestPageSerializer implements PrimitiveSerializer<AdminPayoutRequestPage> {
  @override
  final Iterable<Type> types = const [AdminPayoutRequestPage, _$AdminPayoutRequestPage];

  @override
  final String wireName = r'AdminPayoutRequestPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPayoutRequestPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(AdminPayoutRequest)]),
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
    AdminPayoutRequestPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPayoutRequestPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPayoutRequest)]),
          ) as BuiltList<AdminPayoutRequest>;
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
  AdminPayoutRequestPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPayoutRequestPageBuilder();
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


