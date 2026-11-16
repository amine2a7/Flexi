//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_tier.g.dart';

/// Ligne d'une grille de commission : tranche [min, max] en millimes (min et max inclus, décision du 2026-11-04 ; sans min = 0, sans max = illimité), ou ligne par défaut sans min ni max (obligatoire et unique, appliquée quand aucune tranche ne correspond). Les tranches ne se chevauchent pas. 
///
/// Properties:
/// * [rateBps] - Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
/// * [minMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [maxMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
@BuiltValue()
abstract class CommissionTier implements Built<CommissionTier, CommissionTierBuilder> {
  /// Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
  @BuiltValueField(wireName: r'rateBps')
  int get rateBps;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'minMillimes')
  int? get minMillimes;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'maxMillimes')
  int? get maxMillimes;

  CommissionTier._();

  factory CommissionTier([void updates(CommissionTierBuilder b)]) = _$CommissionTier;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionTierBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionTier> get serializer => _$CommissionTierSerializer();
}

class _$CommissionTierSerializer implements PrimitiveSerializer<CommissionTier> {
  @override
  final Iterable<Type> types = const [CommissionTier, _$CommissionTier];

  @override
  final String wireName = r'CommissionTier';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionTier object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rateBps';
    yield serializers.serialize(
      object.rateBps,
      specifiedType: const FullType(int),
    );
    yield r'minMillimes';
    yield object.minMillimes == null ? null : serializers.serialize(
      object.minMillimes,
      specifiedType: const FullType.nullable(int),
    );
    yield r'maxMillimes';
    yield object.maxMillimes == null ? null : serializers.serialize(
      object.maxMillimes,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionTier object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionTierBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rateBps = valueDes;
          break;
        case r'minMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.minMillimes = valueDes;
          break;
        case r'maxMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionTier deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionTierBuilder();
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


