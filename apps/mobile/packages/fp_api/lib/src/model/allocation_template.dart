//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/template_auto_run.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/allocation_type_amount.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'allocation_template.g.dart';

/// AllocationTemplate
///
/// Properties:
/// * [autoMonthlyDay] - Jour de la relance automatique chaque mois (1 à 28), ou null.
/// * [lastAutoRun] - Dernière relance automatique (mois et résultat) ; null si aucune.
/// * [id] - Identifiant opaque de ressource.
/// * [name] 
/// * [departmentId] - Identifiant opaque de ressource.
/// * [departmentName] 
/// * [position] 
/// * [amounts] 
/// * [lastRunAt] - Dernière relance (null si jamais relancé).
/// * [createdAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [updatedAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class AllocationTemplate implements Built<AllocationTemplate, AllocationTemplateBuilder> {
  /// Jour de la relance automatique chaque mois (1 à 28), ou null.
  @BuiltValueField(wireName: r'autoMonthlyDay')
  int? get autoMonthlyDay;

  /// Dernière relance automatique (mois et résultat) ; null si aucune.
  @BuiltValueField(wireName: r'lastAutoRun')
  TemplateAutoRun? get lastAutoRun;

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'departmentId')
  String? get departmentId;

  @BuiltValueField(wireName: r'departmentName')
  String? get departmentName;

  @BuiltValueField(wireName: r'position')
  String? get position;

  @BuiltValueField(wireName: r'amounts')
  BuiltList<AllocationTypeAmount> get amounts;

  /// Dernière relance (null si jamais relancé).
  @BuiltValueField(wireName: r'lastRunAt')
  DateTime? get lastRunAt;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  AllocationTemplate._();

  factory AllocationTemplate([void updates(AllocationTemplateBuilder b)]) = _$AllocationTemplate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AllocationTemplateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AllocationTemplate> get serializer => _$AllocationTemplateSerializer();
}

class _$AllocationTemplateSerializer implements PrimitiveSerializer<AllocationTemplate> {
  @override
  final Iterable<Type> types = const [AllocationTemplate, _$AllocationTemplate];

  @override
  final String wireName = r'AllocationTemplate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AllocationTemplate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'autoMonthlyDay';
    yield object.autoMonthlyDay == null ? null : serializers.serialize(
      object.autoMonthlyDay,
      specifiedType: const FullType.nullable(int),
    );
    yield r'lastAutoRun';
    yield object.lastAutoRun == null ? null : serializers.serialize(
      object.lastAutoRun,
      specifiedType: const FullType.nullable(TemplateAutoRun),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'departmentId';
    yield object.departmentId == null ? null : serializers.serialize(
      object.departmentId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'departmentName';
    yield object.departmentName == null ? null : serializers.serialize(
      object.departmentName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'position';
    yield object.position == null ? null : serializers.serialize(
      object.position,
      specifiedType: const FullType.nullable(String),
    );
    yield r'amounts';
    yield serializers.serialize(
      object.amounts,
      specifiedType: const FullType(BuiltList, [FullType(AllocationTypeAmount)]),
    );
    yield r'lastRunAt';
    yield object.lastRunAt == null ? null : serializers.serialize(
      object.lastRunAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AllocationTemplate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AllocationTemplateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'autoMonthlyDay':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.autoMonthlyDay = valueDes;
          break;
        case r'lastAutoRun':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TemplateAutoRun),
          ) as TemplateAutoRun?;
          if (valueDes == null) continue;
          result.lastAutoRun.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'departmentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.departmentId = valueDes;
          break;
        case r'departmentName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.departmentName = valueDes;
          break;
        case r'position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.position = valueDes;
          break;
        case r'amounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AllocationTypeAmount)]),
          ) as BuiltList<AllocationTypeAmount>;
          result.amounts.replace(valueDes);
          break;
        case r'lastRunAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastRunAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AllocationTemplate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AllocationTemplateBuilder();
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


