//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/payout_event.dart';
import 'package:fp_api/src/model/payout_payment.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:fp_api/src/model/payout_request_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_request_detail.g.dart';

/// Demande de virement avec les étapes franchies (du plus ancien au plus récent).
///
/// Properties:
/// * [creditType] 
/// * [id] - Identifiant opaque de ressource.
/// * [reference] 
/// * [status] 
/// * [grossMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [commissionRateBps] - Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
/// * [commissionMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [vatRateBps] - TVA sur la commission, figée (décision du 2026-11-03).
/// * [vatMillimes] - TVA de la commission arrondie, au millime le plus proche.
/// * [stampDutyMillimes] - Timbre fiscal, figé.
/// * [withholdingRateBps] - Retenue à la source (taux de la forme juridique, au-delà du seuil ; 0 sinon).
/// * [withholdingMillimes] - Retenue à la source sur la commission, ajoutée comme la TVA.
/// * [transferFeeMillimes] - Frais de virement.
/// * [netMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [requestedAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [payment] 
/// * [maskedIban] - RIB masqué (4 derniers chiffres).
/// * [history] 
@BuiltValue()
abstract class PayoutRequestDetail implements Built<PayoutRequestDetail, PayoutRequestDetailBuilder> {
  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'status')
  PayoutRequestStatus get status;
  // enum statusEnum {  REQUESTED,  CHECKED,  SENT,  EXECUTED,  REJECTED,  ON_HOLD,  };

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'grossMillimes')
  int get grossMillimes;

  /// Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
  @BuiltValueField(wireName: r'commissionRateBps')
  int get commissionRateBps;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'commissionMillimes')
  int get commissionMillimes;

  /// TVA sur la commission, figée (décision du 2026-11-03).
  @BuiltValueField(wireName: r'vatRateBps')
  int get vatRateBps;

  /// TVA de la commission arrondie, au millime le plus proche.
  @BuiltValueField(wireName: r'vatMillimes')
  int get vatMillimes;

  /// Timbre fiscal, figé.
  @BuiltValueField(wireName: r'stampDutyMillimes')
  int get stampDutyMillimes;

  /// Retenue à la source (taux de la forme juridique, au-delà du seuil ; 0 sinon).
  @BuiltValueField(wireName: r'withholdingRateBps')
  int get withholdingRateBps;

  /// Retenue à la source sur la commission, ajoutée comme la TVA.
  @BuiltValueField(wireName: r'withholdingMillimes')
  int get withholdingMillimes;

  /// Frais de virement.
  @BuiltValueField(wireName: r'transferFeeMillimes')
  int get transferFeeMillimes;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'netMillimes')
  int get netMillimes;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'requestedAt')
  DateTime get requestedAt;

  @BuiltValueField(wireName: r'payment')
  PayoutPayment? get payment;

  /// RIB masqué (4 derniers chiffres).
  @BuiltValueField(wireName: r'maskedIban')
  String get maskedIban;

  @BuiltValueField(wireName: r'history')
  BuiltList<PayoutEvent> get history;

  PayoutRequestDetail._();

  factory PayoutRequestDetail([void updates(PayoutRequestDetailBuilder b)]) = _$PayoutRequestDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutRequestDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutRequestDetail> get serializer => _$PayoutRequestDetailSerializer();
}

class _$PayoutRequestDetailSerializer implements PrimitiveSerializer<PayoutRequestDetail> {
  @override
  final Iterable<Type> types = const [PayoutRequestDetail, _$PayoutRequestDetail];

  @override
  final String wireName = r'PayoutRequestDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutRequestDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'creditType';
    yield serializers.serialize(
      object.creditType,
      specifiedType: const FullType(CreditType),
    );
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
      specifiedType: const FullType(PayoutRequestStatus),
    );
    yield r'grossMillimes';
    yield serializers.serialize(
      object.grossMillimes,
      specifiedType: const FullType(int),
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
    yield r'vatRateBps';
    yield serializers.serialize(
      object.vatRateBps,
      specifiedType: const FullType(int),
    );
    yield r'vatMillimes';
    yield serializers.serialize(
      object.vatMillimes,
      specifiedType: const FullType(int),
    );
    yield r'stampDutyMillimes';
    yield serializers.serialize(
      object.stampDutyMillimes,
      specifiedType: const FullType(int),
    );
    yield r'withholdingRateBps';
    yield serializers.serialize(
      object.withholdingRateBps,
      specifiedType: const FullType(int),
    );
    yield r'withholdingMillimes';
    yield serializers.serialize(
      object.withholdingMillimes,
      specifiedType: const FullType(int),
    );
    yield r'transferFeeMillimes';
    yield serializers.serialize(
      object.transferFeeMillimes,
      specifiedType: const FullType(int),
    );
    yield r'netMillimes';
    yield serializers.serialize(
      object.netMillimes,
      specifiedType: const FullType(int),
    );
    yield r'requestedAt';
    yield serializers.serialize(
      object.requestedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.payment != null) {
      yield r'payment';
      yield serializers.serialize(
        object.payment,
        specifiedType: const FullType(PayoutPayment),
      );
    }
    yield r'maskedIban';
    yield serializers.serialize(
      object.maskedIban,
      specifiedType: const FullType(String),
    );
    yield r'history';
    yield serializers.serialize(
      object.history,
      specifiedType: const FullType(BuiltList, [FullType(PayoutEvent)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PayoutRequestDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutRequestDetailBuilder result,
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
            specifiedType: const FullType(PayoutRequestStatus),
          ) as PayoutRequestStatus;
          result.status = valueDes;
          break;
        case r'grossMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.grossMillimes = valueDes;
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
        case r'vatRateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vatRateBps = valueDes;
          break;
        case r'vatMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vatMillimes = valueDes;
          break;
        case r'stampDutyMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stampDutyMillimes = valueDes;
          break;
        case r'withholdingRateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.withholdingRateBps = valueDes;
          break;
        case r'withholdingMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.withholdingMillimes = valueDes;
          break;
        case r'transferFeeMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.transferFeeMillimes = valueDes;
          break;
        case r'netMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.netMillimes = valueDes;
          break;
        case r'requestedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.requestedAt = valueDes;
          break;
        case r'payment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PayoutPayment),
          ) as PayoutPayment?;
          if (valueDes == null) continue;
          result.payment.replace(valueDes);
          break;
        case r'maskedIban':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.maskedIban = valueDes;
          break;
        case r'history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PayoutEvent)]),
          ) as BuiltList<PayoutEvent>;
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
  PayoutRequestDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutRequestDetailBuilder();
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


