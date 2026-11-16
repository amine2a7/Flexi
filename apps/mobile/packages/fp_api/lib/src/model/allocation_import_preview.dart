//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type_amount.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/allocation_import_row.dart';
import 'package:fp_api/src/model/allocation_line.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'allocation_import_preview.g.dart';

/// AllocationImportPreview
///
/// Properties:
/// * [rows] 
/// * [lines] - Lignes valides, prêtes pour `POST /v1/company/allocations`.
/// * [totals] - Total à attribuer par type (à comparer aux soldes par type).
/// * [validCount] 
/// * [errorCount] 
@BuiltValue()
abstract class AllocationImportPreview implements Built<AllocationImportPreview, AllocationImportPreviewBuilder> {
  @BuiltValueField(wireName: r'rows')
  BuiltList<AllocationImportRow> get rows;

  /// Lignes valides, prêtes pour `POST /v1/company/allocations`.
  @BuiltValueField(wireName: r'lines')
  BuiltList<AllocationLine> get lines;

  /// Total à attribuer par type (à comparer aux soldes par type).
  @BuiltValueField(wireName: r'totals')
  BuiltList<CreditTypeAmount> get totals;

  @BuiltValueField(wireName: r'validCount')
  int get validCount;

  @BuiltValueField(wireName: r'errorCount')
  int get errorCount;

  AllocationImportPreview._();

  factory AllocationImportPreview([void updates(AllocationImportPreviewBuilder b)]) = _$AllocationImportPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AllocationImportPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AllocationImportPreview> get serializer => _$AllocationImportPreviewSerializer();
}

class _$AllocationImportPreviewSerializer implements PrimitiveSerializer<AllocationImportPreview> {
  @override
  final Iterable<Type> types = const [AllocationImportPreview, _$AllocationImportPreview];

  @override
  final String wireName = r'AllocationImportPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AllocationImportPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rows';
    yield serializers.serialize(
      object.rows,
      specifiedType: const FullType(BuiltList, [FullType(AllocationImportRow)]),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(AllocationLine)]),
    );
    yield r'totals';
    yield serializers.serialize(
      object.totals,
      specifiedType: const FullType(BuiltList, [FullType(CreditTypeAmount)]),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AllocationImportPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AllocationImportPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rows':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AllocationImportRow)]),
          ) as BuiltList<AllocationImportRow>;
          result.rows.replace(valueDes);
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AllocationLine)]),
          ) as BuiltList<AllocationLine>;
          result.lines.replace(valueDes);
          break;
        case r'totals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreditTypeAmount)]),
          ) as BuiltList<CreditTypeAmount>;
          result.totals.replace(valueDes);
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AllocationImportPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AllocationImportPreviewBuilder();
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


