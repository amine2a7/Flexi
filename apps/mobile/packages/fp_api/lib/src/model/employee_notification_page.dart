//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/employee_notification.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_notification_page.g.dart';

/// EmployeeNotificationPage
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class EmployeeNotificationPage implements Built<EmployeeNotificationPage, EmployeeNotificationPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<EmployeeNotification> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  EmployeeNotificationPage._();

  factory EmployeeNotificationPage([void updates(EmployeeNotificationPageBuilder b)]) = _$EmployeeNotificationPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeNotificationPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeNotificationPage> get serializer => _$EmployeeNotificationPageSerializer();
}

class _$EmployeeNotificationPageSerializer implements PrimitiveSerializer<EmployeeNotificationPage> {
  @override
  final Iterable<Type> types = const [EmployeeNotificationPage, _$EmployeeNotificationPage];

  @override
  final String wireName = r'EmployeeNotificationPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeNotificationPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(EmployeeNotification)]),
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
    EmployeeNotificationPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeNotificationPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EmployeeNotification)]),
          ) as BuiltList<EmployeeNotification>;
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
  EmployeeNotificationPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeNotificationPageBuilder();
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


