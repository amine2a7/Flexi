//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/payment_event.dart';
import 'package:fp_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/payment_status.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:fp_api/src/model/customer_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_payment_detail.g.dart';

/// Encaissement avec sa commission, sa date de règlement et ses étapes.
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [reference] 
/// * [status] 
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [customer] 
/// * [createdAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [expiresAt] - Fin de validité tant que `INITIATED` ; `null` ensuite.
/// * [creditType] 
/// * [commissionRateBps] - Taux figé au moment de l'encaissement.
/// * [commissionMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [netMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [settlementDate] - Date de règlement J+2 (fuseau Africa/Tunis) ; `null` si non encaissé.
/// * [history] 
@BuiltValue()
abstract class MerchantPaymentDetail implements Built<MerchantPaymentDetail, MerchantPaymentDetailBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'status')
  PaymentStatus get status;
  // enum statusEnum {  INITIATED,  CONFIRMED,  SETTLED,  REFUSED,  DISPUTED,  REFUNDED,  };

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  @BuiltValueField(wireName: r'customer')
  CustomerSummary get customer;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Fin de validité tant que `INITIATED` ; `null` ensuite.
  @BuiltValueField(wireName: r'expiresAt')
  DateTime? get expiresAt;

  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Taux figé au moment de l'encaissement.
  @BuiltValueField(wireName: r'commissionRateBps')
  int get commissionRateBps;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'commissionMillimes')
  int get commissionMillimes;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'netMillimes')
  int get netMillimes;

  /// Date de règlement J+2 (fuseau Africa/Tunis) ; `null` si non encaissé.
  @BuiltValueField(wireName: r'settlementDate')
  Date? get settlementDate;

  @BuiltValueField(wireName: r'history')
  BuiltList<PaymentEvent> get history;

  MerchantPaymentDetail._();

  factory MerchantPaymentDetail([void updates(MerchantPaymentDetailBuilder b)]) = _$MerchantPaymentDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPaymentDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPaymentDetail> get serializer => _$MerchantPaymentDetailSerializer();
}

class _$MerchantPaymentDetailSerializer implements PrimitiveSerializer<MerchantPaymentDetail> {
  @override
  final Iterable<Type> types = const [MerchantPaymentDetail, _$MerchantPaymentDetail];

  @override
  final String wireName = r'MerchantPaymentDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPaymentDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PaymentStatus),
    );
    yield r'amountMillimes';
    yield serializers.serialize(
      object.amountMillimes,
      specifiedType: const FullType(int),
    );
    yield r'customer';
    yield serializers.serialize(
      object.customer,
      specifiedType: const FullType(CustomerSummary),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'expiresAt';
    yield object.expiresAt == null ? null : serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'creditType';
    yield serializers.serialize(
      object.creditType,
      specifiedType: const FullType(CreditType),
    );
    yield r'commissionRateBps';
    yield serializers.serialize(
      object.commissionRateBps,
      specifiedType: const FullType(int),
    );
    yield r'commissionMillimes';
    yield serializers.serialize(
      object.commissionMillimes,
      specifiedType: const FullType(int),
    );
    yield r'netMillimes';
    yield serializers.serialize(
      object.netMillimes,
      specifiedType: const FullType(int),
    );
    yield r'settlementDate';
    yield object.settlementDate == null ? null : serializers.serialize(
      object.settlementDate,
      specifiedType: const FullType.nullable(Date),
    );
    yield r'history';
    yield serializers.serialize(
      object.history,
      specifiedType: const FullType(BuiltList, [FullType(PaymentEvent)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPaymentDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantPaymentDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentStatus),
          ) as PaymentStatus;
          result.status = valueDes;
          break;
        case r'amountMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountMillimes = valueDes;
          break;
        case r'customer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CustomerSummary),
          ) as CustomerSummary;
          result.customer.replace(valueDes);
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'creditType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreditType),
          ) as CreditType;
          result.creditType = valueDes;
          break;
        case r'commissionRateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commissionRateBps = valueDes;
          break;
        case r'commissionMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commissionMillimes = valueDes;
          break;
        case r'netMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.netMillimes = valueDes;
          break;
        case r'settlementDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.settlementDate = valueDes;
          break;
        case r'history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PaymentEvent)]),
          ) as BuiltList<PaymentEvent>;
          result.history.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantPaymentDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPaymentDetailBuilder();
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


