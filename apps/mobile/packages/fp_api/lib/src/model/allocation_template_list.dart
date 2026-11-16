//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/allocation_template.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'allocation_template_list.g.dart';

/// AllocationTemplateList
///
/// Properties:
/// * [data] 
@BuiltValue()
abstract class AllocationTemplateList implements Built<AllocationTemplateList, AllocationTemplateListBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<AllocationTemplate> get data;

  AllocationTemplateList._();

  factory AllocationTemplateList([void updates(AllocationTemplateListBuilder b)]) = _$AllocationTemplateList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AllocationTemplateListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AllocationTemplateList> get serializer => _$AllocationTemplateListSerializer();
}

class _$AllocationTemplateListSerializer implements PrimitiveSerializer<AllocationTemplateList> {
  @override
  final Iterable<Type> types = const [AllocationTemplateList, _$AllocationTemplateList];

  @override
  final String wireName = r'AllocationTemplateList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AllocationTemplateList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(AllocationTemplate)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AllocationTemplateList object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AllocationTemplateListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AllocationTemplate)]),
          ) as BuiltList<AllocationTemplate>;
          result.data.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AllocationTemplateList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AllocationTemplateListBuilder();
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


