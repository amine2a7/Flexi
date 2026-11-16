//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_order_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credit_order_create.g.dart';

/// Soit quoteId (montants du devis figé, 409 QUOTE_EXPIRED après expiration, 409 si déjà utilisé), soit lines (montants calculés maintenant).
///
/// Properties:
/// * [quoteId] - Identifiant opaque de ressource.
/// * [lines] - Un montant par type de crédit commandé (types distincts).
@BuiltValue()
abstract class CreditOrderCreate implements Built<CreditOrderCreate, CreditOrderCreateBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'quoteId')
  String? get quoteId;

  /// Un montant par type de crédit commandé (types distincts).
  @BuiltValueField(wireName: r'lines')
  BuiltList<CreditOrderLine>? get lines;

  CreditOrderCreate._();

  factory CreditOrderCreate([void updates(CreditOrderCreateBuilder b)]) = _$CreditOrderCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreditOrderCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreditOrderCreate> get serializer => _$CreditOrderCreateSerializer();
}

class _$CreditOrderCreateSerializer implements PrimitiveSerializer<CreditOrderCreate> {
  @override
  final Iterable<Type> types = const [CreditOrderCreate, _$CreditOrderCreate];

  @override
  final String wireName = r'CreditOrderCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreditOrderCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.quoteId != null) {
      yield r'quoteId';
      yield serializers.serialize(
        object.quoteId,
        specifiedType: const FullType(String),
      );
    }
    if (object.lines != null) {
      yield r'lines';
      yield serializers.serialize(
        object.lines,
        specifiedType: const FullType(BuiltList, [FullType(CreditOrderLine)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreditOrderCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreditOrderCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'quoteId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.quoteId = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(CreditOrderLine)]),
          ) as BuiltList<CreditOrderLine>?;
          if (valueDes == null) continue;
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
  CreditOrderCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreditOrderCreateBuilder();
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


