//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'department_assignment.g.dart';

/// DepartmentAssignment
///
/// Properties:
/// * [departmentId] - Identifiant opaque de ressource.
@BuiltValue()
abstract class DepartmentAssignment implements Built<DepartmentAssignment, DepartmentAssignmentBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'departmentId')
  String? get departmentId;

  DepartmentAssignment._();

  factory DepartmentAssignment([void updates(DepartmentAssignmentBuilder b)]) = _$DepartmentAssignment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DepartmentAssignmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DepartmentAssignment> get serializer => _$DepartmentAssignmentSerializer();
}

class _$DepartmentAssignmentSerializer implements PrimitiveSerializer<DepartmentAssignment> {
  @override
  final Iterable<Type> types = const [DepartmentAssignment, _$DepartmentAssignment];

  @override
  final String wireName = r'DepartmentAssignment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DepartmentAssignment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'departmentId';
    yield object.departmentId == null ? null : serializers.serialize(
      object.departmentId,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DepartmentAssignment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DepartmentAssignmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  DepartmentAssignment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DepartmentAssignmentBuilder();
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


