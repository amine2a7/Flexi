//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/import_row.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_import_preview.g.dart';

/// EmployeeImportPreview
///
/// Properties:
/// * [previewId] - Identifiant opaque de ressource.
/// * [rows] 
/// * [validCount] 
/// * [errorCount] 
/// * [duplicateCount] 
@BuiltValue()
abstract class EmployeeImportPreview implements Built<EmployeeImportPreview, EmployeeImportPreviewBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'previewId')
  String get previewId;

  @BuiltValueField(wireName: r'rows')
  BuiltList<ImportRow> get rows;

  @BuiltValueField(wireName: r'validCount')
  int get validCount;

  @BuiltValueField(wireName: r'errorCount')
  int get errorCount;

  @BuiltValueField(wireName: r'duplicateCount')
  int get duplicateCount;

  EmployeeImportPreview._();

  factory EmployeeImportPreview([void updates(EmployeeImportPreviewBuilder b)]) = _$EmployeeImportPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeImportPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeImportPreview> get serializer => _$EmployeeImportPreviewSerializer();
}

class _$EmployeeImportPreviewSerializer implements PrimitiveSerializer<EmployeeImportPreview> {
  @override
  final Iterable<Type> types = const [EmployeeImportPreview, _$EmployeeImportPreview];

  @override
  final String wireName = r'EmployeeImportPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeImportPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'previewId';
    yield serializers.serialize(
      object.previewId,
      specifiedType: const FullType(String),
    );
    yield r'rows';
    yield serializers.serialize(
      object.rows,
      specifiedType: const FullType(BuiltList, [FullType(ImportRow)]),
    );
    yield r'validCount';
    yield serializers.serialize(
      object.validCount,
      specifiedType: const FullType(int),
    );
    yield r'errorCount';
    yield serializers.serialize(
      object.errorCount,
      specifiedType: const FullType(int),
    );
    yield r'duplicateCount';
    yield serializers.serialize(
      object.duplicateCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeImportPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeImportPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'previewId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.previewId = valueDes;
          break;
        case r'rows':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ImportRow)]),
          ) as BuiltList<ImportRow>;
          result.rows.replace(valueDes);
          break;
        case r'validCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.validCount = valueDes;
          break;
        case r'errorCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.errorCount = valueDes;
          break;
        case r'duplicateCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.duplicateCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeImportPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeImportPreviewBuilder();
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


