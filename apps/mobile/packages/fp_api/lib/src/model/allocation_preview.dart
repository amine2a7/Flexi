//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/allocation_preview_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/allocation_preview_employee.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'allocation_preview.g.dart';

/// AllocationPreview
///
/// Properties:
/// * [employees] 
/// * [employeeCount] 
/// * [lines] 
/// * [sufficient] - Vrai si chaque type a assez de solde.
@BuiltValue()
abstract class AllocationPreview implements Built<AllocationPreview, AllocationPreviewBuilder> {
  @BuiltValueField(wireName: r'employees')
  BuiltList<AllocationPreviewEmployee> get employees;

  @BuiltValueField(wireName: r'employeeCount')
  int get employeeCount;

  @BuiltValueField(wireName: r'lines')
  BuiltList<AllocationPreviewLine> get lines;

  /// Vrai si chaque type a assez de solde.
  @BuiltValueField(wireName: r'sufficient')
  bool get sufficient;

  AllocationPreview._();

  factory AllocationPreview([void updates(AllocationPreviewBuilder b)]) = _$AllocationPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AllocationPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AllocationPreview> get serializer => _$AllocationPreviewSerializer();
}

class _$AllocationPreviewSerializer implements PrimitiveSerializer<AllocationPreview> {
  @override
  final Iterable<Type> types = const [AllocationPreview, _$AllocationPreview];

  @override
  final String wireName = r'AllocationPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AllocationPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'employees';
    yield serializers.serialize(
      object.employees,
      specifiedType: const FullType(BuiltList, [FullType(AllocationPreviewEmployee)]),
    );
    yield r'employeeCount';
    yield serializers.serialize(
      object.employeeCount,
      specifiedType: const FullType(int),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(AllocationPreviewLine)]),
    );
    yield r'sufficient';
    yield serializers.serialize(
      object.sufficient,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AllocationPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AllocationPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'employees':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AllocationPreviewEmployee)]),
          ) as BuiltList<AllocationPreviewEmployee>;
          result.employees.replace(valueDes);
          break;
        case r'employeeCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.employeeCount = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AllocationPreviewLine)]),
          ) as BuiltList<AllocationPreviewLine>;
          result.lines.replace(valueDes);
          break;
        case r'sufficient':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.sufficient = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AllocationPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AllocationPreviewBuilder();
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


