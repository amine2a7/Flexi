//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credit_type_settings.g.dart';

/// Paramétrage d'un type de crédit (règle 6 de la décision du 2026-10-13).
///
/// Properties:
/// * [creditType] 
/// * [enabled] - Un type désactivé ne peut plus être commandé, attribué ni payé.
/// * [commissionRateBps] - Taux de commission prélevé sur les paiements de ce type.
/// * [validityMonths] - Durée de validité des crédits de ce type.
/// * [dailyLimitMillimes] - Plafond de dépense journalier d'un bénéficiaire pour ce type.
@BuiltValue()
abstract class CreditTypeSettings implements Built<CreditTypeSettings, CreditTypeSettingsBuilder> {
  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Un type désactivé ne peut plus être commandé, attribué ni payé.
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Taux de commission prélevé sur les paiements de ce type.
  @BuiltValueField(wireName: r'commissionRateBps')
  int get commissionRateBps;

  /// Durée de validité des crédits de ce type.
  @BuiltValueField(wireName: r'validityMonths')
  int get validityMonths;

  /// Plafond de dépense journalier d'un bénéficiaire pour ce type.
  @BuiltValueField(wireName: r'dailyLimitMillimes')
  int get dailyLimitMillimes;

  CreditTypeSettings._();

  factory CreditTypeSettings([void updates(CreditTypeSettingsBuilder b)]) = _$CreditTypeSettings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreditTypeSettingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreditTypeSettings> get serializer => _$CreditTypeSettingsSerializer();
}

class _$CreditTypeSettingsSerializer implements PrimitiveSerializer<CreditTypeSettings> {
  @override
  final Iterable<Type> types = const [CreditTypeSettings, _$CreditTypeSettings];

  @override
  final String wireName = r'CreditTypeSettings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreditTypeSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'creditType';
    yield serializers.serialize(
      object.creditType,
      specifiedType: const FullType(CreditType),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'commissionRateBps';
    yield serializers.serialize(
      object.commissionRateBps,
      specifiedType: const FullType(int),
    );
    yield r'validityMonths';
    yield serializers.serialize(
      object.validityMonths,
      specifiedType: const FullType(int),
    );
    yield r'dailyLimitMillimes';
    yield serializers.serialize(
      object.dailyLimitMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreditTypeSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreditTypeSettingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'creditType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreditType),
          ) as CreditType;
          result.creditType = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'commissionRateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commissionRateBps = valueDes;
          break;
        case r'validityMonths':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.validityMonths = valueDes;
          break;
        case r'dailyLimitMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dailyLimitMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreditTypeSettings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreditTypeSettingsBuilder();
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


