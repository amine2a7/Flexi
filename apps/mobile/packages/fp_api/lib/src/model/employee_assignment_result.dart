//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_assignment_result.g.dart';

/// EmployeeAssignmentResult
///
/// Properties:
/// * [employeeIds] 
/// * [departmentId] - Identifiant opaque de ressource.
/// * [position] 
@BuiltValue()
abstract class EmployeeAssignmentResult implements Built<EmployeeAssignmentResult, EmployeeAssignmentResultBuilder> {
  @BuiltValueField(wireName: r'employeeIds')
  BuiltList<String> get employeeIds;

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'departmentId')
  String? get departmentId;

  @BuiltValueField(wireName: r'position')
  String? get position;

  EmployeeAssignmentResult._();

  factory EmployeeAssignmentResult([void updates(EmployeeAssignmentResultBuilder b)]) = _$EmployeeAssignmentResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeAssignmentResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeAssignmentResult> get serializer => _$EmployeeAssignmentResultSerializer();
}

class _$EmployeeAssignmentResultSerializer implements PrimitiveSerializer<EmployeeAssignmentResult> {
  @override
  final Iterable<Type> types = const [EmployeeAssignmentResult, _$EmployeeAssignmentResult];

  @override
  final String wireName = r'EmployeeAssignmentResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeAssignmentResult object, {
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
    EmployeeAssignmentResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeAssignmentResultBuilder result,
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
  EmployeeAssignmentResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeAssignmentResultBuilder();
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


