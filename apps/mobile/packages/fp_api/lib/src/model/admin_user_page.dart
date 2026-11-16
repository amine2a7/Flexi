//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:fp_api/src/model/admin_user.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_user_page.g.dart';

/// Liste paginée de AdminUser (§7).
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class AdminUserPage implements Built<AdminUserPage, AdminUserPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<AdminUser> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  AdminUserPage._();

  factory AdminUserPage([void updates(AdminUserPageBuilder b)]) = _$AdminUserPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUserPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUserPage> get serializer => _$AdminUserPageSerializer();
}

class _$AdminUserPageSerializer implements PrimitiveSerializer<AdminUserPage> {
  @override
  final Iterable<Type> types = const [AdminUserPage, _$AdminUserPage];

  @override
  final String wireName = r'AdminUserPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUserPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(AdminUser)]),
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
    AdminUserPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminUserPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminUser)]),
          ) as BuiltList<AdminUser>;
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
  AdminUserPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUserPageBuilder();
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


