//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_department.g.dart';

/// EmployeeDepartment
///
/// Properties:
/// * [employeeId] - Identifiant opaque de ressource.
/// * [departmentId] - Identifiant opaque de ressource.
@BuiltValue()
abstract class EmployeeDepartment implements Built<EmployeeDepartment, EmployeeDepartmentBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'employeeId')
  String get employeeId;

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'departmentId')
  String? get departmentId;

  EmployeeDepartment._();

  factory EmployeeDepartment([void updates(EmployeeDepartmentBuilder b)]) = _$EmployeeDepartment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeDepartmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeDepartment> get serializer => _$EmployeeDepartmentSerializer();
}

class _$EmployeeDepartmentSerializer implements PrimitiveSerializer<EmployeeDepartment> {
  @override
  final Iterable<Type> types = const [EmployeeDepartment, _$EmployeeDepartment];

  @override
  final String wireName = r'EmployeeDepartment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeDepartment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'employeeId';
    yield serializers.serialize(
      object.employeeId,
      specifiedType: const FullType(String),
    );
    yield r'departmentId';
    yield object.departmentId == null ? null : serializers.serialize(
      object.departmentId,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeDepartment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeDepartmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'employeeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.employeeId = valueDes;
          break;
        case r'departmentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.departmentId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeDepartment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeDepartmentBuilder();
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


