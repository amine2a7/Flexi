//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/allocation_type_amount.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'allocation_template_input.g.dart';

/// AllocationTemplateInput
///
/// Properties:
/// * [autoMonthlyDay] - Jour de la relance automatique chaque mois (1 à 28) ; null = relance à la main ; absent = inchangé. Un jour déjà passé ce mois-ci commence le mois suivant.
/// * [name] 
/// * [departmentId] - Département filtré (null = tous).
/// * [position] - Poste filtré, texte libre (null = tous).
/// * [amounts] 
@BuiltValue()
abstract class AllocationTemplateInput implements Built<AllocationTemplateInput, AllocationTemplateInputBuilder> {
  /// Jour de la relance automatique chaque mois (1 à 28) ; null = relance à la main ; absent = inchangé. Un jour déjà passé ce mois-ci commence le mois suivant.
  @BuiltValueField(wireName: r'autoMonthlyDay')
  int? get autoMonthlyDay;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// Département filtré (null = tous).
  @BuiltValueField(wireName: r'departmentId')
  String? get departmentId;

  /// Poste filtré, texte libre (null = tous).
  @BuiltValueField(wireName: r'position')
  String? get position;

  @BuiltValueField(wireName: r'amounts')
  BuiltList<AllocationTypeAmount> get amounts;

  AllocationTemplateInput._();

  factory AllocationTemplateInput([void updates(AllocationTemplateInputBuilder b)]) = _$AllocationTemplateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AllocationTemplateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AllocationTemplateInput> get serializer => _$AllocationTemplateInputSerializer();
}

class _$AllocationTemplateInputSerializer implements PrimitiveSerializer<AllocationTemplateInput> {
  @override
  final Iterable<Type> types = const [AllocationTemplateInput, _$AllocationTemplateInput];

  @override
  final String wireName = r'AllocationTemplateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AllocationTemplateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.autoMonthlyDay != null) {
      yield r'autoMonthlyDay';
      yield serializers.serialize(
        object.autoMonthlyDay,
        specifiedType: const FullType.nullable(int),
      );
    }
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AllocationTemplateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AllocationTemplateInputBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AllocationTemplateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AllocationTemplateInputBuilder();
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


