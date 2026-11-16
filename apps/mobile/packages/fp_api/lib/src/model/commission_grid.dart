//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/commission_tier.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_grid.g.dart';

/// Grille en vigueur (dernière version) : entreprise = taux sur le montant de chaque commande, commerçant = taux sur le montant de chaque virement (décision du 2026-11-03). 
///
/// Properties:
/// * [tiers] 
/// * [effectiveFrom] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class CommissionGrid implements Built<CommissionGrid, CommissionGridBuilder> {
  @BuiltValueField(wireName: r'tiers')
  BuiltList<CommissionTier> get tiers;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime get effectiveFrom;

  CommissionGrid._();

  factory CommissionGrid([void updates(CommissionGridBuilder b)]) = _$CommissionGrid;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionGridBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionGrid> get serializer => _$CommissionGridSerializer();
}

class _$CommissionGridSerializer implements PrimitiveSerializer<CommissionGrid> {
  @override
  final Iterable<Type> types = const [CommissionGrid, _$CommissionGrid];

  @override
  final String wireName = r'CommissionGrid';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionGrid object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tiers';
    yield serializers.serialize(
      object.tiers,
      specifiedType: const FullType(BuiltList, [FullType(CommissionTier)]),
    );
    yield r'effectiveFrom';
    yield serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionGrid object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionGridBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CommissionTier)]),
          ) as BuiltList<CommissionTier>;
          result.tiers.replace(valueDes);
          break;
        case r'effectiveFrom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.effectiveFrom = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionGrid deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionGridBuilder();
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


