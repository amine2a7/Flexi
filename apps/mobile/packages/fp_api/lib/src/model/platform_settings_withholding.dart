//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_settings_withholding.g.dart';

/// Retenue à la source (processus v2) — au-delà du seuil, taux de la forme juridique sur la commission.
///
/// Properties:
/// * [thresholdMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [ppCinBps] - Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
/// * [ppMfBps] - Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
/// * [pmMfBps] - Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
@BuiltValue()
abstract class PlatformSettingsWithholding implements Built<PlatformSettingsWithholding, PlatformSettingsWithholdingBuilder> {
  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'thresholdMillimes')
  int get thresholdMillimes;

  /// Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
  @BuiltValueField(wireName: r'ppCinBps')
  int get ppCinBps;

  /// Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
  @BuiltValueField(wireName: r'ppMfBps')
  int get ppMfBps;

  /// Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
  @BuiltValueField(wireName: r'pmMfBps')
  int get pmMfBps;

  PlatformSettingsWithholding._();

  factory PlatformSettingsWithholding([void updates(PlatformSettingsWithholdingBuilder b)]) = _$PlatformSettingsWithholding;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformSettingsWithholdingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformSettingsWithholding> get serializer => _$PlatformSettingsWithholdingSerializer();
}

class _$PlatformSettingsWithholdingSerializer implements PrimitiveSerializer<PlatformSettingsWithholding> {
  @override
  final Iterable<Type> types = const [PlatformSettingsWithholding, _$PlatformSettingsWithholding];

  @override
  final String wireName = r'PlatformSettingsWithholding';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformSettingsWithholding object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'thresholdMillimes';
    yield serializers.serialize(
      object.thresholdMillimes,
      specifiedType: const FullType(int),
    );
    yield r'ppCinBps';
    yield serializers.serialize(
      object.ppCinBps,
      specifiedType: const FullType(int),
    );
    yield r'ppMfBps';
    yield serializers.serialize(
      object.ppMfBps,
      specifiedType: const FullType(int),
    );
    yield r'pmMfBps';
    yield serializers.serialize(
      object.pmMfBps,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PlatformSettingsWithholding object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlatformSettingsWithholdingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'thresholdMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.thresholdMillimes = valueDes;
          break;
        case r'ppCinBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ppCinBps = valueDes;
          break;
        case r'ppMfBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ppMfBps = valueDes;
          break;
        case r'pmMfBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pmMfBps = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlatformSettingsWithholding deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformSettingsWithholdingBuilder();
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


