//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/employee_operation.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_operation_page.g.dart';

/// EmployeeOperationPage
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class EmployeeOperationPage implements Built<EmployeeOperationPage, EmployeeOperationPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<EmployeeOperation> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  EmployeeOperationPage._();

  factory EmployeeOperationPage([void updates(EmployeeOperationPageBuilder b)]) = _$EmployeeOperationPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeOperationPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeOperationPage> get serializer => _$EmployeeOperationPageSerializer();
}

class _$EmployeeOperationPageSerializer implements PrimitiveSerializer<EmployeeOperationPage> {
  @override
  final Iterable<Type> types = const [EmployeeOperationPage, _$EmployeeOperationPage];

  @override
  final String wireName = r'EmployeeOperationPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeOperationPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(EmployeeOperation)]),
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
    EmployeeOperationPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeOperationPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EmployeeOperation)]),
          ) as BuiltList<EmployeeOperation>;
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
  EmployeeOperationPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeOperationPageBuilder();
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


