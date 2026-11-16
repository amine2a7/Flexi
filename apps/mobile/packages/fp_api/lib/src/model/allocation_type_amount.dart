//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'allocation_type_amount.g.dart';

/// Montant d'un type, le même pour chaque employé sélectionné.
///
/// Properties:
/// * [creditType] 
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
@BuiltValue()
abstract class AllocationTypeAmount implements Built<AllocationTypeAmount, AllocationTypeAmountBuilder> {
  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  AllocationTypeAmount._();

  factory AllocationTypeAmount([void updates(AllocationTypeAmountBuilder b)]) = _$AllocationTypeAmount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AllocationTypeAmountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AllocationTypeAmount> get serializer => _$AllocationTypeAmountSerializer();
}

class _$AllocationTypeAmountSerializer implements PrimitiveSerializer<AllocationTypeAmount> {
  @override
  final Iterable<Type> types = const [AllocationTypeAmount, _$AllocationTypeAmount];

  @override
  final String wireName = r'AllocationTypeAmount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AllocationTypeAmount object, {
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
    AllocationTypeAmount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AllocationTypeAmountBuilder result,
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
  AllocationTypeAmount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AllocationTypeAmountBuilder();
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


