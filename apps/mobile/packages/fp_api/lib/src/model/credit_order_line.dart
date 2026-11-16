//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credit_order_line.g.dart';

/// CreditOrderLine
///
/// Properties:
/// * [creditType] 
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
@BuiltValue()
abstract class CreditOrderLine implements Built<CreditOrderLine, CreditOrderLineBuilder> {
  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  CreditOrderLine._();

  factory CreditOrderLine([void updates(CreditOrderLineBuilder b)]) = _$CreditOrderLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreditOrderLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreditOrderLine> get serializer => _$CreditOrderLineSerializer();
}

class _$CreditOrderLineSerializer implements PrimitiveSerializer<CreditOrderLine> {
  @override
  final Iterable<Type> types = const [CreditOrderLine, _$CreditOrderLine];

  @override
  final String wireName = r'CreditOrderLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreditOrderLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'creditType';
    yield serializers.serialize(
      object.creditType,
      specifiedType: const FullType(CreditType),
    );
    yield r'amountMillimes';
    yield serializers.serialize(
      object.amountMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreditOrderLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreditOrderLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'creditType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreditType),
          ) as CreditType;
          result.creditType = valueDes;
          break;
        case r'amountMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreditOrderLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreditOrderLineBuilder();
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


