//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'rename_department_request.g.dart';

/// RenameDepartmentRequest
///
/// Properties:
/// * [name] 
@BuiltValue()
abstract class RenameDepartmentRequest implements Built<RenameDepartmentRequest, RenameDepartmentRequestBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  RenameDepartmentRequest._();

  factory RenameDepartmentRequest([void updates(RenameDepartmentRequestBuilder b)]) = _$RenameDepartmentRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RenameDepartmentRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RenameDepartmentRequest> get serializer => _$RenameDepartmentRequestSerializer();
}

class _$RenameDepartmentRequestSerializer implements PrimitiveSerializer<RenameDepartmentRequest> {
  @override
  final Iterable<Type> types = const [RenameDepartmentRequest, _$RenameDepartmentRequest];

  @override
  final String wireName = r'RenameDepartmentRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RenameDepartmentRequest object, {
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
    RenameDepartmentRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RenameDepartmentRequestBuilder result,
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
  RenameDepartmentRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RenameDepartmentRequestBuilder();
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


