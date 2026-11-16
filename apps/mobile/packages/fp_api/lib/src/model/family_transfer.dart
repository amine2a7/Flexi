//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/date.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'family_transfer.g.dart';

/// FamilyTransfer
///
/// Properties:
/// * [memberId] - Identifiant opaque de ressource.
/// * [creditType] 
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [dailyLimitMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [endsOn] 
@BuiltValue()
abstract class FamilyTransfer implements Built<FamilyTransfer, FamilyTransferBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'memberId')
  String get memberId;

  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'dailyLimitMillimes')
  int? get dailyLimitMillimes;

  @BuiltValueField(wireName: r'endsOn')
  Date? get endsOn;

  FamilyTransfer._();

  factory FamilyTransfer([void updates(FamilyTransferBuilder b)]) = _$FamilyTransfer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FamilyTransferBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FamilyTransfer> get serializer => _$FamilyTransferSerializer();
}

class _$FamilyTransferSerializer implements PrimitiveSerializer<FamilyTransfer> {
  @override
  final Iterable<Type> types = const [FamilyTransfer, _$FamilyTransfer];

  @override
  final String wireName = r'FamilyTransfer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FamilyTransfer object, {
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
    yield r'dailyLimitMillimes';
    yield object.dailyLimitMillimes == null ? null : serializers.serialize(
      object.dailyLimitMillimes,
      specifiedType: const FullType.nullable(int),
    );
    yield r'endsOn';
    yield object.endsOn == null ? null : serializers.serialize(
      object.endsOn,
      specifiedType: const FullType.nullable(Date),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FamilyTransfer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FamilyTransferBuilder result,
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
        case r'dailyLimitMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.dailyLimitMillimes = valueDes;
          break;
        case r'endsOn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.endsOn = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FamilyTransfer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FamilyTransferBuilder();
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


