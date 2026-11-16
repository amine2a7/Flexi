//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type_amount.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/admin_monthly_flow.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard.g.dart';

/// AdminDashboard
///
/// Properties:
/// * [merchantsCount] 
/// * [companiesCount] 
/// * [todayVolumeMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [pendingApprovalsCount] 
/// * [pendingKycCount] 
/// * [nextSettlementNetMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [monthByCreditType] - Paiements du mois sur la plateforme, par type de crédit (répartition).
/// * [monthlyFlows] - Six derniers mois, du plus ancien au mois en cours (graphique du tableau de bord).
@BuiltValue()
abstract class AdminDashboard implements Built<AdminDashboard, AdminDashboardBuilder> {
  @BuiltValueField(wireName: r'merchantsCount')
  int get merchantsCount;

  @BuiltValueField(wireName: r'companiesCount')
  int get companiesCount;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'todayVolumeMillimes')
  int get todayVolumeMillimes;

  @BuiltValueField(wireName: r'pendingApprovalsCount')
  int get pendingApprovalsCount;

  @BuiltValueField(wireName: r'pendingKycCount')
  int get pendingKycCount;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'nextSettlementNetMillimes')
  int get nextSettlementNetMillimes;

  /// Paiements du mois sur la plateforme, par type de crédit (répartition).
  @BuiltValueField(wireName: r'monthByCreditType')
  BuiltList<CreditTypeAmount> get monthByCreditType;

  /// Six derniers mois, du plus ancien au mois en cours (graphique du tableau de bord).
  @BuiltValueField(wireName: r'monthlyFlows')
  BuiltList<AdminMonthlyFlow> get monthlyFlows;

  AdminDashboard._();

  factory AdminDashboard([void updates(AdminDashboardBuilder b)]) = _$AdminDashboard;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboard> get serializer => _$AdminDashboardSerializer();
}

class _$AdminDashboardSerializer implements PrimitiveSerializer<AdminDashboard> {
  @override
  final Iterable<Type> types = const [AdminDashboard, _$AdminDashboard];

  @override
  final String wireName = r'AdminDashboard';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'merchantsCount';
    yield serializers.serialize(
      object.merchantsCount,
      specifiedType: const FullType(int),
    );
    yield r'companiesCount';
    yield serializers.serialize(
      object.companiesCount,
      specifiedType: const FullType(int),
    );
    yield r'todayVolumeMillimes';
    yield serializers.serialize(
      object.todayVolumeMillimes,
      specifiedType: const FullType(int),
    );
    yield r'pendingApprovalsCount';
    yield serializers.serialize(
      object.pendingApprovalsCount,
      specifiedType: const FullType(int),
    );
    yield r'pendingKycCount';
    yield serializers.serialize(
      object.pendingKycCount,
      specifiedType: const FullType(int),
    );
    yield r'nextSettlementNetMillimes';
    yield serializers.serialize(
      object.nextSettlementNetMillimes,
      specifiedType: const FullType(int),
    );
    yield r'monthByCreditType';
    yield serializers.serialize(
      object.monthByCreditType,
      specifiedType: const FullType(BuiltList, [FullType(CreditTypeAmount)]),
    );
    yield r'monthlyFlows';
    yield serializers.serialize(
      object.monthlyFlows,
      specifiedType: const FullType(BuiltList, [FullType(AdminMonthlyFlow)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'merchantsCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.merchantsCount = valueDes;
          break;
        case r'companiesCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.companiesCount = valueDes;
          break;
        case r'todayVolumeMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.todayVolumeMillimes = valueDes;
          break;
        case r'pendingApprovalsCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingApprovalsCount = valueDes;
          break;
        case r'pendingKycCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingKycCount = valueDes;
          break;
        case r'nextSettlementNetMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nextSettlementNetMillimes = valueDes;
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
            specifiedType: const FullType(BuiltList, [FullType(AdminMonthlyFlow)]),
          ) as BuiltList<AdminMonthlyFlow>;
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
  AdminDashboard deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardBuilder();
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


