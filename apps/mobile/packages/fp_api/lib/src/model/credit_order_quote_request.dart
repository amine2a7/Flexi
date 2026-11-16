//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_order_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credit_order_quote_request.g.dart';

/// CreditOrderQuoteRequest
///
/// Properties:
/// * [lines] 
@BuiltValue()
abstract class CreditOrderQuoteRequest implements Built<CreditOrderQuoteRequest, CreditOrderQuoteRequestBuilder> {
  @BuiltValueField(wireName: r'lines')
  BuiltList<CreditOrderLine> get lines;

  CreditOrderQuoteRequest._();

  factory CreditOrderQuoteRequest([void updates(CreditOrderQuoteRequestBuilder b)]) = _$CreditOrderQuoteRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreditOrderQuoteRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreditOrderQuoteRequest> get serializer => _$CreditOrderQuoteRequestSerializer();
}

class _$CreditOrderQuoteRequestSerializer implements PrimitiveSerializer<CreditOrderQuoteRequest> {
  @override
  final Iterable<Type> types = const [CreditOrderQuoteRequest, _$CreditOrderQuoteRequest];

  @override
  final String wireName = r'CreditOrderQuoteRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreditOrderQuoteRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(CreditOrderLine)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreditOrderQuoteRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreditOrderQuoteRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreditOrderLine)]),
          ) as BuiltList<CreditOrderLine>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreditOrderQuoteRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreditOrderQuoteRequestBuilder();
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


