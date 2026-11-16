//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/department.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'department_list.g.dart';

/// DepartmentList
///
/// Properties:
/// * [data] 
@BuiltValue()
abstract class DepartmentList implements Built<DepartmentList, DepartmentListBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Department> get data;

  DepartmentList._();

  factory DepartmentList([void updates(DepartmentListBuilder b)]) = _$DepartmentList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DepartmentListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DepartmentList> get serializer => _$DepartmentListSerializer();
}

class _$DepartmentListSerializer implements PrimitiveSerializer<DepartmentList> {
  @override
  final Iterable<Type> types = const [DepartmentList, _$DepartmentList];

  @override
  final String wireName = r'DepartmentList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DepartmentList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Department)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DepartmentList object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DepartmentListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Department)]),
          ) as BuiltList<Department>;
          result.data.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DepartmentList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DepartmentListBuilder();
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


