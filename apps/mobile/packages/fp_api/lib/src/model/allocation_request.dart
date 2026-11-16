//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/allocation_line.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'allocation_request.g.dart';

/// AllocationRequest
///
/// Properties:
/// * [templateId] - Modèle relancé (processus v2) ; marqué relancé, gardé sur chaque attribution.
/// * [allocations] 
@BuiltValue()
abstract class AllocationRequest implements Built<AllocationRequest, AllocationRequestBuilder> {
  /// Modèle relancé (processus v2) ; marqué relancé, gardé sur chaque attribution.
  @BuiltValueField(wireName: r'templateId')
  String? get templateId;

  @BuiltValueField(wireName: r'allocations')
  BuiltList<AllocationLine> get allocations;

  AllocationRequest._();

  factory AllocationRequest([void updates(AllocationRequestBuilder b)]) = _$AllocationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AllocationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AllocationRequest> get serializer => _$AllocationRequestSerializer();
}

class _$AllocationRequestSerializer implements PrimitiveSerializer<AllocationRequest> {
  @override
  final Iterable<Type> types = const [AllocationRequest, _$AllocationRequest];

  @override
  final String wireName = r'AllocationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AllocationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.templateId != null) {
      yield r'templateId';
      yield serializers.serialize(
        object.templateId,
        specifiedType: const FullType(String),
      );
    }
    yield r'allocations';
    yield serializers.serialize(
      object.allocations,
      specifiedType: const FullType(BuiltList, [FullType(AllocationLine)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AllocationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AllocationRequestBuilder result,
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
        case r'allocations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AllocationLine)]),
          ) as BuiltList<AllocationLine>;
          result.allocations.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AllocationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AllocationRequestBuilder();
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


