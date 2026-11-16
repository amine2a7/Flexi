//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type_amount.dart';
import 'package:fp_api/src/model/date.dart';
import 'package:fp_api/src/model/merchant_payment.dart';
import 'package:fp_api/src/model/merchant_monthly_flow.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_dashboard.g.dart';

/// MerchantDashboard
///
/// Properties:
/// * [todayCollectedMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [todayPaymentsCount] 
/// * [receivablesMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [nextSettlementDate] - Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
/// * [commissionRateBps] - Taux propre au commerçant, ou `null` (taux du type de crédit, voir le devis).
/// * [recentPayments] 
/// * [monthByCreditType] - Encaissé ce mois, par type de crédit (répartition).
/// * [monthlyFlows] - Six derniers mois, du plus ancien au mois en cours (graphique du tableau de bord).
@BuiltValue()
abstract class MerchantDashboard implements Built<MerchantDashboard, MerchantDashboardBuilder> {
  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'todayCollectedMillimes')
  int get todayCollectedMillimes;

  @BuiltValueField(wireName: r'todayPaymentsCount')
  int get todayPaymentsCount;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'receivablesMillimes')
  int get receivablesMillimes;

  /// Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
  @BuiltValueField(wireName: r'nextSettlementDate')
  Date? get nextSettlementDate;

  /// Taux propre au commerçant, ou `null` (taux du type de crédit, voir le devis).
  @BuiltValueField(wireName: r'commissionRateBps')
  int? get commissionRateBps;

  @BuiltValueField(wireName: r'recentPayments')
  BuiltList<MerchantPayment> get recentPayments;

  /// Encaissé ce mois, par type de crédit (répartition).
  @BuiltValueField(wireName: r'monthByCreditType')
  BuiltList<CreditTypeAmount> get monthByCreditType;

  /// Six derniers mois, du plus ancien au mois en cours (graphique du tableau de bord).
  @BuiltValueField(wireName: r'monthlyFlows')
  BuiltList<MerchantMonthlyFlow> get monthlyFlows;

  MerchantDashboard._();

  factory MerchantDashboard([void updates(MerchantDashboardBuilder b)]) = _$MerchantDashboard;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantDashboardBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantDashboard> get serializer => _$MerchantDashboardSerializer();
}

class _$MerchantDashboardSerializer implements PrimitiveSerializer<MerchantDashboard> {
  @override
  final Iterable<Type> types = const [MerchantDashboard, _$MerchantDashboard];

  @override
  final String wireName = r'MerchantDashboard';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantDashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'todayCollectedMillimes';
    yield serializers.serialize(
      object.todayCollectedMillimes,
      specifiedType: const FullType(int),
    );
    yield r'todayPaymentsCount';
    yield serializers.serialize(
      object.todayPaymentsCount,
      specifiedType: const FullType(int),
    );
    yield r'receivablesMillimes';
    yield serializers.serialize(
      object.receivablesMillimes,
      specifiedType: const FullType(int),
    );
    yield r'nextSettlementDate';
    yield object.nextSettlementDate == null ? null : serializers.serialize(
      object.nextSettlementDate,
      specifiedType: const FullType.nullable(Date),
    );
    yield r'commissionRateBps';
    yield object.commissionRateBps == null ? null : serializers.serialize(
      object.commissionRateBps,
      specifiedType: const FullType.nullable(int),
    );
    yield r'recentPayments';
    yield serializers.serialize(
      object.recentPayments,
      specifiedType: const FullType(BuiltList, [FullType(MerchantPayment)]),
    );
    yield r'monthByCreditType';
    yield serializers.serialize(
      object.monthByCreditType,
      specifiedType: const FullType(BuiltList, [FullType(CreditTypeAmount)]),
    );
    yield r'monthlyFlows';
    yield serializers.serialize(
      object.monthlyFlows,
      specifiedType: const FullType(BuiltList, [FullType(MerchantMonthlyFlow)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantDashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantDashboardBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'todayCollectedMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.todayCollectedMillimes = valueDes;
          break;
        case r'todayPaymentsCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.todayPaymentsCount = valueDes;
          break;
        case r'receivablesMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.receivablesMillimes = valueDes;
          break;
        case r'nextSettlementDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.nextSettlementDate = valueDes;
          break;
        case r'commissionRateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.commissionRateBps = valueDes;
          break;
        case r'recentPayments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantPayment)]),
          ) as BuiltList<MerchantPayment>;
          result.recentPayments.replace(valueDes);
          break;
        case r'monthByCreditType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreditTypeAmount)]),
          ) as BuiltList<CreditTypeAmount>;
          result.monthByCreditType.replace(valueDes);
          break;
        case r'monthlyFlows':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantMonthlyFlow)]),
          ) as BuiltList<MerchantMonthlyFlow>;
          result.monthlyFlows.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantDashboard deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantDashboardBuilder();
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


