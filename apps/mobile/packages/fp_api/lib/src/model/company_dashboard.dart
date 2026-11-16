//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type_amount.dart';
import 'package:fp_api/src/model/credit_order.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/company_monthly_flow.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'company_dashboard.g.dart';

/// CompanyDashboard
///
/// Properties:
/// * [balances] - Solde de l'entreprise par type de crédit (un compte par type).
/// * [walletBalanceMillimes] - Total des soldes par type, à titre d'information uniquement.
/// * [employeesCount] 
/// * [activeEmployeesCount] 
/// * [monthAllocatedMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [pendingOrdersCount] 
/// * [recentOrders] 
/// * [monthlyFlows] - Six derniers mois, du plus ancien au mois en cours (graphique du tableau de bord).
@BuiltValue()
abstract class CompanyDashboard implements Built<CompanyDashboard, CompanyDashboardBuilder> {
  /// Solde de l'entreprise par type de crédit (un compte par type).
  @BuiltValueField(wireName: r'balances')
  BuiltList<CreditTypeAmount> get balances;

  /// Total des soldes par type, à titre d'information uniquement.
  @BuiltValueField(wireName: r'walletBalanceMillimes')
  int get walletBalanceMillimes;

  @BuiltValueField(wireName: r'employeesCount')
  int get employeesCount;

  @BuiltValueField(wireName: r'activeEmployeesCount')
  int get activeEmployeesCount;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'monthAllocatedMillimes')
  int get monthAllocatedMillimes;

  @BuiltValueField(wireName: r'pendingOrdersCount')
  int get pendingOrdersCount;

  @BuiltValueField(wireName: r'recentOrders')
  BuiltList<CreditOrder> get recentOrders;

  /// Six derniers mois, du plus ancien au mois en cours (graphique du tableau de bord).
  @BuiltValueField(wireName: r'monthlyFlows')
  BuiltList<CompanyMonthlyFlow> get monthlyFlows;

  CompanyDashboard._();

  factory CompanyDashboard([void updates(CompanyDashboardBuilder b)]) = _$CompanyDashboard;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompanyDashboardBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompanyDashboard> get serializer => _$CompanyDashboardSerializer();
}

class _$CompanyDashboardSerializer implements PrimitiveSerializer<CompanyDashboard> {
  @override
  final Iterable<Type> types = const [CompanyDashboard, _$CompanyDashboard];

  @override
  final String wireName = r'CompanyDashboard';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompanyDashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'balances';
    yield serializers.serialize(
      object.balances,
      specifiedType: const FullType(BuiltList, [FullType(CreditTypeAmount)]),
    );
    yield r'walletBalanceMillimes';
    yield serializers.serialize(
      object.walletBalanceMillimes,
      specifiedType: const FullType(int),
    );
    yield r'employeesCount';
    yield serializers.serialize(
      object.employeesCount,
      specifiedType: const FullType(int),
    );
    yield r'activeEmployeesCount';
    yield serializers.serialize(
      object.activeEmployeesCount,
      specifiedType: const FullType(int),
    );
    yield r'monthAllocatedMillimes';
    yield serializers.serialize(
      object.monthAllocatedMillimes,
      specifiedType: const FullType(int),
    );
    yield r'pendingOrdersCount';
    yield serializers.serialize(
      object.pendingOrdersCount,
      specifiedType: const FullType(int),
    );
    yield r'recentOrders';
    yield serializers.serialize(
      object.recentOrders,
      specifiedType: const FullType(BuiltList, [FullType(CreditOrder)]),
    );
    yield r'monthlyFlows';
    yield serializers.serialize(
      object.monthlyFlows,
      specifiedType: const FullType(BuiltList, [FullType(CompanyMonthlyFlow)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CompanyDashboard object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CompanyDashboardBuilder result,
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
        case r'walletBalanceMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.walletBalanceMillimes = valueDes;
          break;
        case r'employeesCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.employeesCount = valueDes;
          break;
        case r'activeEmployeesCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.activeEmployeesCount = valueDes;
          break;
        case r'monthAllocatedMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.monthAllocatedMillimes = valueDes;
          break;
        case r'pendingOrdersCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingOrdersCount = valueDes;
          break;
        case r'recentOrders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreditOrder)]),
          ) as BuiltList<CreditOrder>;
          result.recentOrders.replace(valueDes);
          break;
        case r'monthlyFlows':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CompanyMonthlyFlow)]),
          ) as BuiltList<CompanyMonthlyFlow>;
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
  CompanyDashboard deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompanyDashboardBuilder();
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


