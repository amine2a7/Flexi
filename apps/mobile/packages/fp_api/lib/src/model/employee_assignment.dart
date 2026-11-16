//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_assignment.g.dart';

/// Département et/ou poste d'un ou plusieurs employés (au moins l'un des deux ; null détache).
///
/// Properties:
/// * [employeeIds] 
/// * [departmentId] - Identifiant opaque de ressource.
/// * [position] 
@BuiltValue()
abstract class EmployeeAssignment implements Built<EmployeeAssignment, EmployeeAssignmentBuilder> {
  @BuiltValueField(wireName: r'employeeIds')
  BuiltList<String> get employeeIds;

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'departmentId')
  String? get departmentId;

  @BuiltValueField(wireName: r'position')
  String? get position;

  EmployeeAssignment._();

  factory EmployeeAssignment([void updates(EmployeeAssignmentBuilder b)]) = _$EmployeeAssignment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeAssignmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeAssignment> get serializer => _$EmployeeAssignmentSerializer();
}

class _$EmployeeAssignmentSerializer implements PrimitiveSerializer<EmployeeAssignment> {
  @override
  final Iterable<Type> types = const [EmployeeAssignment, _$EmployeeAssignment];

  @override
  final String wireName = r'EmployeeAssignment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeAssignment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'employeeIds';
    yield serializers.serialize(
      object.employeeIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.departmentId != null) {
      yield r'departmentId';
      yield serializers.serialize(
        object.departmentId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.position != null) {
      yield r'position';
      yield serializers.serialize(
        object.position,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeAssignment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeAssignmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'employeeIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.employeeIds.replace(valueDes);
          break;
        case r'departmentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.departmentId = valueDes;
          break;
        case r'position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.position = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeAssignment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeAssignmentBuilder();
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


