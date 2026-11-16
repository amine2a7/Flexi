//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_import_request.g.dart';

/// EmployeeImportRequest
///
/// Properties:
/// * [csv] - Contenu du fichier CSV (UTF-8, 1 Mo maximum).
@BuiltValue()
abstract class EmployeeImportRequest implements Built<EmployeeImportRequest, EmployeeImportRequestBuilder> {
  /// Contenu du fichier CSV (UTF-8, 1 Mo maximum).
  @BuiltValueField(wireName: r'csv')
  String get csv;

  EmployeeImportRequest._();

  factory EmployeeImportRequest([void updates(EmployeeImportRequestBuilder b)]) = _$EmployeeImportRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeImportRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeImportRequest> get serializer => _$EmployeeImportRequestSerializer();
}

class _$EmployeeImportRequestSerializer implements PrimitiveSerializer<EmployeeImportRequest> {
  @override
  final Iterable<Type> types = const [EmployeeImportRequest, _$EmployeeImportRequest];

  @override
  final String wireName = r'EmployeeImportRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeImportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'csv';
    yield serializers.serialize(
      object.csv,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeImportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeImportRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'csv':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.csv = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeImportRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeImportRequestBuilder();
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


