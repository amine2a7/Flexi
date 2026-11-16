//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'allocation_line.g.dart';

/// AllocationLine
///
/// Properties:
/// * [employeeId] - Identifiant opaque de ressource.
/// * [creditType] - Type attribué : le solde de ce type de l'entreprise est débité.
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
@BuiltValue()
abstract class AllocationLine implements Built<AllocationLine, AllocationLineBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'employeeId')
  String get employeeId;

  /// Type attribué : le solde de ce type de l'entreprise est débité.
  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  AllocationLine._();

  factory AllocationLine([void updates(AllocationLineBuilder b)]) = _$AllocationLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AllocationLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AllocationLine> get serializer => _$AllocationLineSerializer();
}

class _$AllocationLineSerializer implements PrimitiveSerializer<AllocationLine> {
  @override
  final Iterable<Type> types = const [AllocationLine, _$AllocationLine];

  @override
  final String wireName = r'AllocationLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AllocationLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'employeeId';
    yield serializers.serialize(
      object.employeeId,
      specifiedType: const FullType(String),
    );
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
    AllocationLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AllocationLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'employeeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.employeeId = valueDes;
          break;
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
  AllocationLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AllocationLineBuilder();
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


