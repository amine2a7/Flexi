//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'company_monthly_flow.g.dart';

/// CompanyMonthlyFlow
///
/// Properties:
/// * [month] - Mois (AAAA-MM), fuseau métier Africa/Tunis.
/// * [creditedMillimes] - Crédits ajoutés au solde (commandes validées) sur le mois.
/// * [allocatedMillimes] - Crédits attribués aux employés sur le mois.
@BuiltValue()
abstract class CompanyMonthlyFlow implements Built<CompanyMonthlyFlow, CompanyMonthlyFlowBuilder> {
  /// Mois (AAAA-MM), fuseau métier Africa/Tunis.
  @BuiltValueField(wireName: r'month')
  String get month;

  /// Crédits ajoutés au solde (commandes validées) sur le mois.
  @BuiltValueField(wireName: r'creditedMillimes')
  int get creditedMillimes;

  /// Crédits attribués aux employés sur le mois.
  @BuiltValueField(wireName: r'allocatedMillimes')
  int get allocatedMillimes;

  CompanyMonthlyFlow._();

  factory CompanyMonthlyFlow([void updates(CompanyMonthlyFlowBuilder b)]) = _$CompanyMonthlyFlow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CompanyMonthlyFlowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CompanyMonthlyFlow> get serializer => _$CompanyMonthlyFlowSerializer();
}

class _$CompanyMonthlyFlowSerializer implements PrimitiveSerializer<CompanyMonthlyFlow> {
  @override
  final Iterable<Type> types = const [CompanyMonthlyFlow, _$CompanyMonthlyFlow];

  @override
  final String wireName = r'CompanyMonthlyFlow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CompanyMonthlyFlow object, {
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
    yield r'allocatedMillimes';
    yield serializers.serialize(
      object.allocatedMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CompanyMonthlyFlow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CompanyMonthlyFlowBuilder result,
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
        case r'allocatedMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.allocatedMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CompanyMonthlyFlow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CompanyMonthlyFlowBuilder();
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


