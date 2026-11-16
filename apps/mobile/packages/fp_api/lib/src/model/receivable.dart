//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/date.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'receivable.g.dart';

/// Paiement confirmé non encore réglé (statut affiché « En attente de règlement », DP n° 2).
///
/// Properties:
/// * [creditType] 
/// * [paymentId] - Identifiant opaque de ressource.
/// * [reference] 
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [confirmedAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [settlementDate] - Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
@BuiltValue()
abstract class Receivable implements Built<Receivable, ReceivableBuilder> {
  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'paymentId')
  String get paymentId;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'confirmedAt')
  DateTime get confirmedAt;

  /// Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
  @BuiltValueField(wireName: r'settlementDate')
  Date get settlementDate;

  Receivable._();

  factory Receivable([void updates(ReceivableBuilder b)]) = _$Receivable;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReceivableBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Receivable> get serializer => _$ReceivableSerializer();
}

class _$ReceivableSerializer implements PrimitiveSerializer<Receivable> {
  @override
  final Iterable<Type> types = const [Receivable, _$Receivable];

  @override
  final String wireName = r'Receivable';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Receivable object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'creditType';
    yield serializers.serialize(
      object.creditType,
      specifiedType: const FullType(CreditType),
    );
    yield r'paymentId';
    yield serializers.serialize(
      object.paymentId,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'amountMillimes';
    yield serializers.serialize(
      object.amountMillimes,
      specifiedType: const FullType(int),
    );
    yield r'confirmedAt';
    yield serializers.serialize(
      object.confirmedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'settlementDate';
    yield serializers.serialize(
      object.settlementDate,
      specifiedType: const FullType(Date),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Receivable object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReceivableBuilder result,
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
        case r'paymentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentId = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'amountMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountMillimes = valueDes;
          break;
        case r'confirmedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.confirmedAt = valueDes;
          break;
        case r'settlementDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.settlementDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Receivable deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReceivableBuilder();
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


