//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/employee_bulk_status_result_results_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_bulk_status_result.g.dart';

/// EmployeeBulkStatusResult
///
/// Properties:
/// * [results] 
@BuiltValue()
abstract class EmployeeBulkStatusResult implements Built<EmployeeBulkStatusResult, EmployeeBulkStatusResultBuilder> {
  @BuiltValueField(wireName: r'results')
  BuiltList<EmployeeBulkStatusResultResultsInner> get results;

  EmployeeBulkStatusResult._();

  factory EmployeeBulkStatusResult([void updates(EmployeeBulkStatusResultBuilder b)]) = _$EmployeeBulkStatusResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeBulkStatusResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeBulkStatusResult> get serializer => _$EmployeeBulkStatusResultSerializer();
}

class _$EmployeeBulkStatusResultSerializer implements PrimitiveSerializer<EmployeeBulkStatusResult> {
  @override
  final Iterable<Type> types = const [EmployeeBulkStatusResult, _$EmployeeBulkStatusResult];

  @override
  final String wireName = r'EmployeeBulkStatusResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeBulkStatusResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'results';
    yield serializers.serialize(
      object.results,
      specifiedType: const FullType(BuiltList, [FullType(EmployeeBulkStatusResultResultsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeBulkStatusResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeBulkStatusResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'results':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EmployeeBulkStatusResultResultsInner)]),
          ) as BuiltList<EmployeeBulkStatusResultResultsInner>;
          result.results.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeBulkStatusResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeBulkStatusResultBuilder();
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


