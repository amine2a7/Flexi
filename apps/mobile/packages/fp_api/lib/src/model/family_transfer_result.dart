//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'family_transfer_result.g.dart';

/// FamilyTransferResult
///
/// Properties:
/// * [memberId] - Identifiant opaque de ressource.
/// * [creditType] 
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [transactionId] - Identifiant opaque de ressource.
@BuiltValue()
abstract class FamilyTransferResult implements Built<FamilyTransferResult, FamilyTransferResultBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'memberId')
  String get memberId;

  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'transactionId')
  String get transactionId;

  FamilyTransferResult._();

  factory FamilyTransferResult([void updates(FamilyTransferResultBuilder b)]) = _$FamilyTransferResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FamilyTransferResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FamilyTransferResult> get serializer => _$FamilyTransferResultSerializer();
}

class _$FamilyTransferResultSerializer implements PrimitiveSerializer<FamilyTransferResult> {
  @override
  final Iterable<Type> types = const [FamilyTransferResult, _$FamilyTransferResult];

  @override
  final String wireName = r'FamilyTransferResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FamilyTransferResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'memberId';
    yield serializers.serialize(
      object.memberId,
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
    yield r'transactionId';
    yield serializers.serialize(
      object.transactionId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FamilyTransferResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FamilyTransferResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'memberId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.memberId = valueDes;
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
        case r'transactionId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.transactionId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FamilyTransferResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FamilyTransferResultBuilder();
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


