//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type_amount.dart';
import 'package:fp_api/src/model/department.dart';
import 'package:fp_api/src/model/overview_invoice.dart';
import 'package:fp_api/src/model/overview_kyc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/overview_order.dart';
import 'package:fp_api/src/model/allocation_template.dart';
import 'package:fp_api/src/model/overview_user.dart';
import 'package:fp_api/src/model/overview_employee.dart';
import 'package:fp_api/src/model/overview_allocation.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'company_overview.g.dart';

/// Fiche client complète (processus v2), lecture seule ; chaque ligne ouvre sa page dactions.
///
/// Properties:
/// * [kyc] 
/// * [users] 
/// * [departments] 
/// * [employeeCount] 
/// * [employees] 
/// * [balances] 
/// * [orders] 
/// * [allocations] 
/// * [templates] 
/// * [invoices] 
@BuiltValue()
abstract class CompanyOverview implements Built<CompanyOverview, CompanyOverviewBuilder> {
  @BuiltValueField(wireName: r'kyc')
  OverviewKyc? get kyc;

  @BuiltValueField(wireName: r'users')
  BuiltList<OverviewUser> get users;

  @BuiltValueField(wireName: r'departments')
  BuiltList<Department> get departments;

  @BuiltValueField(wireName: r'employeeCount')
  int get employeeCount;

  @BuiltValueField(wireName: r'employees')
  BuiltList<OverviewEmployee> get employees;

  @BuiltValueField(wireName: r'balances')
  BuiltList<CreditTypeAmount> get balances;

  @BuiltValueField(wireName: r'orders')
  BuiltList<OverviewOrder> get orders;

  @BuiltValueField(wireName: r'allocations')
  BuiltList<OverviewAllocation> get allocations;

  @BuiltValueField(wireName: r'templates')
  BuiltList<AllocationTemplate> get templates;

  @BuiltValueField(wireName: r'invoices')
  BuiltList<OverviewInvoice> get invoices;

  CompanyOverview._();

  factory CompanyOverview([void updates(CompanyOverviewBuilder b)]) = _$CompanyOverview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompanyOverviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompanyOverview> get serializer => _$CompanyOverviewSerializer();
}

class _$CompanyOverviewSerializer implements PrimitiveSerializer<CompanyOverview> {
  @override
  final Iterable<Type> types = const [CompanyOverview, _$CompanyOverview];

  @override
  final String wireName = r'CompanyOverview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompanyOverview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kyc';
    yield object.kyc == null ? null : serializers.serialize(
      object.kyc,
      specifiedType: const FullType.nullable(OverviewKyc),
    );
    yield r'users';
    yield serializers.serialize(
      object.users,
      specifiedType: const FullType(BuiltList, [FullType(OverviewUser)]),
    );
    yield r'departments';
    yield serializers.serialize(
      object.departments,
      specifiedType: const FullType(BuiltList, [FullType(Department)]),
    );
    yield r'employeeCount';
    yield serializers.serialize(
      object.employeeCount,
      specifiedType: const FullType(int),
    );
    yield r'employees';
    yield serializers.serialize(
      object.employees,
      specifiedType: const FullType(BuiltList, [FullType(OverviewEmployee)]),
    );
    yield r'balances';
    yield serializers.serialize(
      object.balances,
      specifiedType: const FullType(BuiltList, [FullType(CreditTypeAmount)]),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(BuiltList, [FullType(OverviewOrder)]),
    );
    yield r'allocations';
    yield serializers.serialize(
      object.allocations,
      specifiedType: const FullType(BuiltList, [FullType(OverviewAllocation)]),
    );
    yield r'templates';
    yield serializers.serialize(
      object.templates,
      specifiedType: const FullType(BuiltList, [FullType(AllocationTemplate)]),
    );
    yield r'invoices';
    yield serializers.serialize(
      object.invoices,
      specifiedType: const FullType(BuiltList, [FullType(OverviewInvoice)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CompanyOverview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CompanyOverviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kyc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OverviewKyc),
          ) as OverviewKyc?;
          if (valueDes == null) continue;
          result.kyc.replace(valueDes);
          break;
        case r'users':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OverviewUser)]),
          ) as BuiltList<OverviewUser>;
          result.users.replace(valueDes);
          break;
        case r'departments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Department)]),
          ) as BuiltList<Department>;
          result.departments.replace(valueDes);
          break;
        case r'employeeCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.employeeCount = valueDes;
          break;
        case r'employees':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OverviewEmployee)]),
          ) as BuiltList<OverviewEmployee>;
          result.employees.replace(valueDes);
          break;
        case r'balances':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreditTypeAmount)]),
          ) as BuiltList<CreditTypeAmount>;
          result.balances.replace(valueDes);
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OverviewOrder)]),
          ) as BuiltList<OverviewOrder>;
          result.orders.replace(valueDes);
          break;
        case r'allocations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OverviewAllocation)]),
          ) as BuiltList<OverviewAllocation>;
          result.allocations.replace(valueDes);
          break;
        case r'templates':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AllocationTemplate)]),
          ) as BuiltList<AllocationTemplate>;
          result.templates.replace(valueDes);
          break;
        case r'invoices':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OverviewInvoice)]),
          ) as BuiltList<OverviewInvoice>;
          result.invoices.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CompanyOverview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompanyOverviewBuilder();
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


