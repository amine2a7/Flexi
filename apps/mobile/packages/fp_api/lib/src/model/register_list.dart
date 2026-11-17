//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/register.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_list.g.dart';

/// RegisterList
///
/// Properties:
/// * [data] 
@BuiltValue()
abstract class RegisterList implements Built<RegisterList, RegisterListBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Register> get data;

  RegisterList._();

  factory RegisterList([void updates(RegisterListBuilder b)]) = _$RegisterList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterList> get serializer => _$RegisterListSerializer();
}

class _$RegisterListSerializer implements PrimitiveSerializer<RegisterList> {
  @override
  final Iterable<Type> types = const [RegisterList, _$RegisterList];

  @override
  final String wireName = r'RegisterList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Register)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RegisterList object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegisterListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Register)]),
          ) as BuiltList<Register>;
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
  RegisterList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterListBuilder();
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


