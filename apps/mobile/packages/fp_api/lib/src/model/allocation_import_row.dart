//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type_amount.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'allocation_import_row.g.dart';

/// AllocationImportRow
///
/// Properties:
/// * [line] 
/// * [employeeNumber] 
/// * [employeeName] 
/// * [amounts] 
/// * [issues] - Erreurs de la ligne (vide si elle est valide).
@BuiltValue()
abstract class AllocationImportRow implements Built<AllocationImportRow, AllocationImportRowBuilder> {
  @BuiltValueField(wireName: r'line')
  int get line;

  @BuiltValueField(wireName: r'employeeNumber')
  String get employeeNumber;

  @BuiltValueField(wireName: r'employeeName')
  String? get employeeName;

  @BuiltValueField(wireName: r'amounts')
  BuiltList<CreditTypeAmount> get amounts;

  /// Erreurs de la ligne (vide si elle est valide).
  @BuiltValueField(wireName: r'issues')
  BuiltList<AllocationImportRowIssuesEnum> get issues;
  // enum issuesEnum {  UNKNOWN_EMPLOYEE,  INVALID_AMOUNT,  NO_AMOUNT,  TYPE_DISABLED,  };

  AllocationImportRow._();

  factory AllocationImportRow([void updates(AllocationImportRowBuilder b)]) = _$AllocationImportRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AllocationImportRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AllocationImportRow> get serializer => _$AllocationImportRowSerializer();
}

class _$AllocationImportRowSerializer implements PrimitiveSerializer<AllocationImportRow> {
  @override
  final Iterable<Type> types = const [AllocationImportRow, _$AllocationImportRow];

  @override
  final String wireName = r'AllocationImportRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AllocationImportRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'line';
    yield serializers.serialize(
      object.line,
      specifiedType: const FullType(int),
    );
    yield r'employeeNumber';
    yield serializers.serialize(
      object.employeeNumber,
      specifiedType: const FullType(String),
    );
    if (object.employeeName != null) {
      yield r'employeeName';
      yield serializers.serialize(
        object.employeeName,
        specifiedType: const FullType(String),
      );
    }
    yield r'amounts';
    yield serializers.serialize(
      object.amounts,
      specifiedType: const FullType(BuiltList, [FullType(CreditTypeAmount)]),
    );
    yield r'issues';
    yield serializers.serialize(
      object.issues,
      specifiedType: const FullType(BuiltList, [FullType(AllocationImportRowIssuesEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AllocationImportRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AllocationImportRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'line':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.line = valueDes;
          break;
        case r'employeeNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.employeeNumber = valueDes;
          break;
        case r'employeeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.employeeName = valueDes;
          break;
        case r'amounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreditTypeAmount)]),
          ) as BuiltList<CreditTypeAmount>;
          result.amounts.replace(valueDes);
          break;
        case r'issues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AllocationImportRowIssuesEnum)]),
          ) as BuiltList<AllocationImportRowIssuesEnum>;
          result.issues.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AllocationImportRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AllocationImportRowBuilder();
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


class AllocationImportRowIssuesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'UNKNOWN_EMPLOYEE')
  static const AllocationImportRowIssuesEnum UNKNOWN_EMPLOYEE = _$allocationImportRowIssuesEnum_UNKNOWN_EMPLOYEE;
  @BuiltValueEnumConst(wireName: r'INVALID_AMOUNT')
  static const AllocationImportRowIssuesEnum INVALID_AMOUNT = _$allocationImportRowIssuesEnum_INVALID_AMOUNT;
  @BuiltValueEnumConst(wireName: r'NO_AMOUNT')
  static const AllocationImportRowIssuesEnum NO_AMOUNT = _$allocationImportRowIssuesEnum_NO_AMOUNT;
  @BuiltValueEnumConst(wireName: r'TYPE_DISABLED')
  static const AllocationImportRowIssuesEnum TYPE_DISABLED = _$allocationImportRowIssuesEnum_TYPE_DISABLED;

  static Serializer<AllocationImportRowIssuesEnum> get serializer => _$allocationImportRowIssuesEnumSerializer;

  const AllocationImportRowIssuesEnum._(String name): super(name);

  static BuiltSet<AllocationImportRowIssuesEnum> get values => _$allocationImportRowIssuesEnumValues;
  static AllocationImportRowIssuesEnum valueOf(String name) => _$allocationImportRowIssuesEnumValueOf(name);
}

