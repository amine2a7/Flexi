//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'department_create.g.dart';

/// DepartmentCreate
///
/// Properties:
/// * [name] 
@BuiltValue()
abstract class DepartmentCreate implements Built<DepartmentCreate, DepartmentCreateBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  DepartmentCreate._();

  factory DepartmentCreate([void updates(DepartmentCreateBuilder b)]) = _$DepartmentCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DepartmentCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DepartmentCreate> get serializer => _$DepartmentCreateSerializer();
}

class _$DepartmentCreateSerializer implements PrimitiveSerializer<DepartmentCreate> {
  @override
  final Iterable<Type> types = const [DepartmentCreate, _$DepartmentCreate];

  @override
  final String wireName = r'DepartmentCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DepartmentCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DepartmentCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DepartmentCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DepartmentCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DepartmentCreateBuilder();
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


