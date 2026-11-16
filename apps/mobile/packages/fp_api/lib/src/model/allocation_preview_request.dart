//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/allocation_type_amount.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'allocation_preview_request.g.dart';

/// AllocationPreviewRequest
///
/// Properties:
/// * [templateId] - Relancer un modèle (ses filtres ; ses montants si `amounts` est vide).
/// * [departmentId] - Identifiant opaque de ressource.
/// * [position] 
/// * [q] 
/// * [employeeIds] - Liste explicite (sélection à la main) ; sinon les filtres.
/// * [amounts] 
@BuiltValue()
abstract class AllocationPreviewRequest implements Built<AllocationPreviewRequest, AllocationPreviewRequestBuilder> {
  /// Relancer un modèle (ses filtres ; ses montants si `amounts` est vide).
  @BuiltValueField(wireName: r'templateId')
  String? get templateId;

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'departmentId')
  String? get departmentId;

  @BuiltValueField(wireName: r'position')
  String? get position;

  @BuiltValueField(wireName: r'q')
  String? get q;

  /// Liste explicite (sélection à la main) ; sinon les filtres.
  @BuiltValueField(wireName: r'employeeIds')
  BuiltList<String>? get employeeIds;

  @BuiltValueField(wireName: r'amounts')
  BuiltList<AllocationTypeAmount> get amounts;

  AllocationPreviewRequest._();

  factory AllocationPreviewRequest([void updates(AllocationPreviewRequestBuilder b)]) = _$AllocationPreviewRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AllocationPreviewRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AllocationPreviewRequest> get serializer => _$AllocationPreviewRequestSerializer();
}

class _$AllocationPreviewRequestSerializer implements PrimitiveSerializer<AllocationPreviewRequest> {
  @override
  final Iterable<Type> types = const [AllocationPreviewRequest, _$AllocationPreviewRequest];

  @override
  final String wireName = r'AllocationPreviewRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AllocationPreviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.templateId != null) {
      yield r'templateId';
      yield serializers.serialize(
        object.templateId,
        specifiedType: const FullType(String),
      );
    }
    if (object.departmentId != null) {
      yield r'departmentId';
      yield serializers.serialize(
        object.departmentId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.position != null) {
      yield r'position';
      yield serializers.serialize(
        object.position,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.q != null) {
      yield r'q';
      yield serializers.serialize(
        object.q,
        specifiedType: const FullType(String),
      );
    }
    if (object.employeeIds != null) {
      yield r'employeeIds';
      yield serializers.serialize(
        object.employeeIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    yield r'amounts';
    yield serializers.serialize(
      object.amounts,
      specifiedType: const FullType(BuiltList, [FullType(AllocationTypeAmount)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AllocationPreviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AllocationPreviewRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'templateId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.templateId = valueDes;
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
        case r'q':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.q = valueDes;
          break;
        case r'employeeIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.employeeIds.replace(valueDes);
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
  AllocationPreviewRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AllocationPreviewRequestBuilder();
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


