//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'position_list.g.dart';

/// PositionList
///
/// Properties:
/// * [data] 
@BuiltValue()
abstract class PositionList implements Built<PositionList, PositionListBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<String> get data;

  PositionList._();

  factory PositionList([void updates(PositionListBuilder b)]) = _$PositionList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PositionListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PositionList> get serializer => _$PositionListSerializer();
}

class _$PositionListSerializer implements PrimitiveSerializer<PositionList> {
  @override
  final Iterable<Type> types = const [PositionList, _$PositionList];

  @override
  final String wireName = r'PositionList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PositionList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PositionList object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PositionListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
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
  PositionList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PositionListBuilder();
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


