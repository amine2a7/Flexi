//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paginated_envelope.g.dart';

/// Enveloppe commune des listes. Chaque endpoint de liste la spécialise avec `allOf` en précisant le type des éléments de `data`. 
///
/// Properties:
/// * [data] 
/// * [page] 
@BuiltValue()
abstract class PaginatedEnvelope implements Built<PaginatedEnvelope, PaginatedEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<JsonObject?> get data;

  @BuiltValueField(wireName: r'page')
  PageInfo get page;

  PaginatedEnvelope._();

  factory PaginatedEnvelope([void updates(PaginatedEnvelopeBuilder b)]) = _$PaginatedEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaginatedEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaginatedEnvelope> get serializer => _$PaginatedEnvelopeSerializer();
}

class _$PaginatedEnvelopeSerializer implements PrimitiveSerializer<PaginatedEnvelope> {
  @override
  final Iterable<Type> types = const [PaginatedEnvelope, _$PaginatedEnvelope];

  @override
  final String wireName = r'PaginatedEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaginatedEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType.nullable(JsonObject)]),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(PageInfo),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaginatedEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaginatedEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType.nullable(JsonObject)]),
          ) as BuiltList<JsonObject?>;
          result.data.replace(valueDes);
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PageInfo),
          ) as PageInfo;
          result.page.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaginatedEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaginatedEnvelopeBuilder();
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


