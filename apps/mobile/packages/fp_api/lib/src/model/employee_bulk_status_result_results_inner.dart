//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_bulk_status_result_results_inner.g.dart';

/// EmployeeBulkStatusResultResultsInner
///
/// Properties:
/// * [employeeId] - Identifiant opaque de ressource.
/// * [outcome] 
@BuiltValue()
abstract class EmployeeBulkStatusResultResultsInner implements Built<EmployeeBulkStatusResultResultsInner, EmployeeBulkStatusResultResultsInnerBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'employeeId')
  String get employeeId;

  @BuiltValueField(wireName: r'outcome')
  EmployeeBulkStatusResultResultsInnerOutcomeEnum get outcome;
  // enum outcomeEnum {  DONE,  SKIPPED,  };

  EmployeeBulkStatusResultResultsInner._();

  factory EmployeeBulkStatusResultResultsInner([void updates(EmployeeBulkStatusResultResultsInnerBuilder b)]) = _$EmployeeBulkStatusResultResultsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeBulkStatusResultResultsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeBulkStatusResultResultsInner> get serializer => _$EmployeeBulkStatusResultResultsInnerSerializer();
}

class _$EmployeeBulkStatusResultResultsInnerSerializer implements PrimitiveSerializer<EmployeeBulkStatusResultResultsInner> {
  @override
  final Iterable<Type> types = const [EmployeeBulkStatusResultResultsInner, _$EmployeeBulkStatusResultResultsInner];

  @override
  final String wireName = r'EmployeeBulkStatusResultResultsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeBulkStatusResultResultsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'employeeId';
    yield serializers.serialize(
      object.employeeId,
      specifiedType: const FullType(String),
    );
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(EmployeeBulkStatusResultResultsInnerOutcomeEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeBulkStatusResultResultsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeBulkStatusResultResultsInnerBuilder result,
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
        case r'outcome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EmployeeBulkStatusResultResultsInnerOutcomeEnum),
          ) as EmployeeBulkStatusResultResultsInnerOutcomeEnum;
          result.outcome = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeBulkStatusResultResultsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeBulkStatusResultResultsInnerBuilder();
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


class EmployeeBulkStatusResultResultsInnerOutcomeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DONE')
  static const EmployeeBulkStatusResultResultsInnerOutcomeEnum DONE = _$employeeBulkStatusResultResultsInnerOutcomeEnum_DONE;
  @BuiltValueEnumConst(wireName: r'SKIPPED')
  static const EmployeeBulkStatusResultResultsInnerOutcomeEnum SKIPPED = _$employeeBulkStatusResultResultsInnerOutcomeEnum_SKIPPED;

  static Serializer<EmployeeBulkStatusResultResultsInnerOutcomeEnum> get serializer => _$employeeBulkStatusResultResultsInnerOutcomeEnumSerializer;

  const EmployeeBulkStatusResultResultsInnerOutcomeEnum._(String name): super(name);

  static BuiltSet<EmployeeBulkStatusResultResultsInnerOutcomeEnum> get values => _$employeeBulkStatusResultResultsInnerOutcomeEnumValues;
  static EmployeeBulkStatusResultResultsInnerOutcomeEnum valueOf(String name) => _$employeeBulkStatusResultResultsInnerOutcomeEnumValueOf(name);
}

