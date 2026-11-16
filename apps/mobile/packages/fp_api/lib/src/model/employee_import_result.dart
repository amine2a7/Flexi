//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_import_result.g.dart';

/// EmployeeImportResult
///
/// Properties:
/// * [createdCount] 
@BuiltValue()
abstract class EmployeeImportResult implements Built<EmployeeImportResult, EmployeeImportResultBuilder> {
  @BuiltValueField(wireName: r'createdCount')
  int get createdCount;

  EmployeeImportResult._();

  factory EmployeeImportResult([void updates(EmployeeImportResultBuilder b)]) = _$EmployeeImportResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeImportResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeImportResult> get serializer => _$EmployeeImportResultSerializer();
}

class _$EmployeeImportResultSerializer implements PrimitiveSerializer<EmployeeImportResult> {
  @override
  final Iterable<Type> types = const [EmployeeImportResult, _$EmployeeImportResult];

  @override
  final String wireName = r'EmployeeImportResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeImportResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'createdCount';
    yield serializers.serialize(
      object.createdCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeImportResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeImportResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'createdCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.createdCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeImportResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeImportResultBuilder();
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


