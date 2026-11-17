//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/register_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_update.g.dart';

/// RegisterUpdate
///
/// Properties:
/// * [name] 
/// * [status] 
@BuiltValue()
abstract class RegisterUpdate implements Built<RegisterUpdate, RegisterUpdateBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'status')
  RegisterStatus? get status;
  // enum statusEnum {  ACTIVE,  DISABLED,  };

  RegisterUpdate._();

  factory RegisterUpdate([void updates(RegisterUpdateBuilder b)]) = _$RegisterUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterUpdate> get serializer => _$RegisterUpdateSerializer();
}

class _$RegisterUpdateSerializer implements PrimitiveSerializer<RegisterUpdate> {
  @override
  final Iterable<Type> types = const [RegisterUpdate, _$RegisterUpdate];

  @override
  final String wireName = r'RegisterUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(RegisterStatus),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RegisterUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegisterUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RegisterStatus),
          ) as RegisterStatus?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegisterUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterUpdateBuilder();
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


