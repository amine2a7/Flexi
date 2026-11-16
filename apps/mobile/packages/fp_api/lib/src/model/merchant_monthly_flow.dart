//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_monthly_flow.g.dart';

/// MerchantMonthlyFlow
///
/// Properties:
/// * [month] - Mois (AAAA-MM), fuseau métier Africa/Tunis.
/// * [collectedMillimes] - Paiements encaissés (confirmés) sur le mois.
/// * [settledMillimes] - Montant net réglé au commerçant sur le mois.
@BuiltValue()
abstract class MerchantMonthlyFlow implements Built<MerchantMonthlyFlow, MerchantMonthlyFlowBuilder> {
  /// Mois (AAAA-MM), fuseau métier Africa/Tunis.
  @BuiltValueField(wireName: r'month')
  String get month;

  /// Paiements encaissés (confirmés) sur le mois.
  @BuiltValueField(wireName: r'collectedMillimes')
  int get collectedMillimes;

  /// Montant net réglé au commerçant sur le mois.
  @BuiltValueField(wireName: r'settledMillimes')
  int get settledMillimes;

  MerchantMonthlyFlow._();

  factory MerchantMonthlyFlow([void updates(MerchantMonthlyFlowBuilder b)]) = _$MerchantMonthlyFlow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMonthlyFlowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMonthlyFlow> get serializer => _$MerchantMonthlyFlowSerializer();
}

class _$MerchantMonthlyFlowSerializer implements PrimitiveSerializer<MerchantMonthlyFlow> {
  @override
  final Iterable<Type> types = const [MerchantMonthlyFlow, _$MerchantMonthlyFlow];

  @override
  final String wireName = r'MerchantMonthlyFlow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMonthlyFlow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'month';
    yield serializers.serialize(
      object.month,
      specifiedType: const FullType(String),
    );
    yield r'collectedMillimes';
    yield serializers.serialize(
      object.collectedMillimes,
      specifiedType: const FullType(int),
    );
    yield r'settledMillimes';
    yield serializers.serialize(
      object.settledMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMonthlyFlow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantMonthlyFlowBuilder result,
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
        case r'collectedMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.collectedMillimes = valueDes;
          break;
        case r'settledMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.settledMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMonthlyFlow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMonthlyFlowBuilder();
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


