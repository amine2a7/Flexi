//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type_amount.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'allocation_result.g.dart';

/// AllocationResult
///
/// Properties:
/// * [balances] - Soldes par type de l'entreprise après l'attribution.
/// * [allocatedCount] 
/// * [allocatedMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [walletBalanceMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
@BuiltValue()
abstract class AllocationResult implements Built<AllocationResult, AllocationResultBuilder> {
  /// Soldes par type de l'entreprise après l'attribution.
  @BuiltValueField(wireName: r'balances')
  BuiltList<CreditTypeAmount> get balances;

  @BuiltValueField(wireName: r'allocatedCount')
  int get allocatedCount;

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'allocatedMillimes')
  int get allocatedMillimes;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'walletBalanceMillimes')
  int get walletBalanceMillimes;

  AllocationResult._();

  factory AllocationResult([void updates(AllocationResultBuilder b)]) = _$AllocationResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AllocationResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AllocationResult> get serializer => _$AllocationResultSerializer();
}

class _$AllocationResultSerializer implements PrimitiveSerializer<AllocationResult> {
  @override
  final Iterable<Type> types = const [AllocationResult, _$AllocationResult];

  @override
  final String wireName = r'AllocationResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AllocationResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'balances';
    yield serializers.serialize(
      object.balances,
      specifiedType: const FullType(BuiltList, [FullType(CreditTypeAmount)]),
    );
    yield r'allocatedCount';
    yield serializers.serialize(
      object.allocatedCount,
      specifiedType: const FullType(int),
    );
    yield r'allocatedMillimes';
    yield serializers.serialize(
      object.allocatedMillimes,
      specifiedType: const FullType(int),
    );
    yield r'walletBalanceMillimes';
    yield serializers.serialize(
      object.walletBalanceMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AllocationResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AllocationResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'balances':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreditTypeAmount)]),
          ) as BuiltList<CreditTypeAmount>;
          result.balances.replace(valueDes);
          break;
        case r'allocatedCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.allocatedCount = valueDes;
          break;
        case r'allocatedMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.allocatedMillimes = valueDes;
          break;
        case r'walletBalanceMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.walletBalanceMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AllocationResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AllocationResultBuilder();
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


