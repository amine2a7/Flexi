//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_monthly_flow.g.dart';

/// AdminMonthlyFlow
///
/// Properties:
/// * [month] - Mois (AAAA-MM), fuseau métier Africa/Tunis.
/// * [creditedMillimes] - Crédits ajoutés aux soldes des entreprises (commandes validées) sur le mois.
/// * [paymentsMillimes] - Paiements confirmés chez les commerçants sur le mois.
@BuiltValue()
abstract class AdminMonthlyFlow implements Built<AdminMonthlyFlow, AdminMonthlyFlowBuilder> {
  /// Mois (AAAA-MM), fuseau métier Africa/Tunis.
  @BuiltValueField(wireName: r'month')
  String get month;

  /// Crédits ajoutés aux soldes des entreprises (commandes validées) sur le mois.
  @BuiltValueField(wireName: r'creditedMillimes')
  int get creditedMillimes;

  /// Paiements confirmés chez les commerçants sur le mois.
  @BuiltValueField(wireName: r'paymentsMillimes')
  int get paymentsMillimes;

  AdminMonthlyFlow._();

  factory AdminMonthlyFlow([void updates(AdminMonthlyFlowBuilder b)]) = _$AdminMonthlyFlow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMonthlyFlowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMonthlyFlow> get serializer => _$AdminMonthlyFlowSerializer();
}

class _$AdminMonthlyFlowSerializer implements PrimitiveSerializer<AdminMonthlyFlow> {
  @override
  final Iterable<Type> types = const [AdminMonthlyFlow, _$AdminMonthlyFlow];

  @override
  final String wireName = r'AdminMonthlyFlow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMonthlyFlow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'month';
    yield serializers.serialize(
      object.month,
      specifiedType: const FullType(String),
    );
    yield r'creditedMillimes';
    yield serializers.serialize(
      object.creditedMillimes,
      specifiedType: const FullType(int),
    );
    yield r'paymentsMillimes';
    yield serializers.serialize(
      object.paymentsMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMonthlyFlow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminMonthlyFlowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'month':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.month = valueDes;
          break;
        case r'creditedMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.creditedMillimes = valueDes;
          break;
        case r'paymentsMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentsMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMonthlyFlow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMonthlyFlowBuilder();
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


