//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/employee.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_page.g.dart';

/// Liste paginée de Employee (§7).
///
/// Properties:
/// * [data] 
/// * [graceDays] - Délai de grâce appliqué à une désactivation (jours, paramétrage de l'administrateur).
/// * [page] 
@BuiltValue()
abstract class EmployeePage implements Built<EmployeePage, EmployeePageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Employee> get data;

  /// Délai de grâce appliqué à une désactivation (jours, paramétrage de l'administrateur).
  @BuiltValueField(wireName: r'graceDays')
  int? get graceDays;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  EmployeePage._();

  factory EmployeePage([void updates(EmployeePageBuilder b)]) = _$EmployeePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeePage> get serializer => _$EmployeePageSerializer();
}

class _$EmployeePageSerializer implements PrimitiveSerializer<EmployeePage> {
  @override
  final Iterable<Type> types = const [EmployeePage, _$EmployeePage];

  @override
  final String wireName = r'EmployeePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Employee)]),
    );
    if (object.graceDays != null) {
      yield r'graceDays';
      yield serializers.serialize(
        object.graceDays,
        specifiedType: const FullType(int),
      );
    }
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(PageInfo),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Employee)]),
          ) as BuiltList<Employee>;
          result.data.replace(valueDes);
          break;
        case r'graceDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.graceDays = valueDes;
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
  EmployeePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeePageBuilder();
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


