//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_terms.g.dart';

/// Valeurs publiques du paramétrage (textes des pages).
///
/// Properties:
/// * [settlementDelayDays] 
/// * [invitationValidityDays] 
/// * [quoteValidityDays] 
/// * [paymentCancelHours] 
/// * [payoutMinimumMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [secondValidationThresholdMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
@BuiltValue()
abstract class PlatformTerms implements Built<PlatformTerms, PlatformTermsBuilder> {
  @BuiltValueField(wireName: r'settlementDelayDays')
  int get settlementDelayDays;

  @BuiltValueField(wireName: r'invitationValidityDays')
  int get invitationValidityDays;

  @BuiltValueField(wireName: r'quoteValidityDays')
  int get quoteValidityDays;

  @BuiltValueField(wireName: r'paymentCancelHours')
  int get paymentCancelHours;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'payoutMinimumMillimes')
  int get payoutMinimumMillimes;

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'secondValidationThresholdMillimes')
  int get secondValidationThresholdMillimes;

  PlatformTerms._();

  factory PlatformTerms([void updates(PlatformTermsBuilder b)]) = _$PlatformTerms;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformTermsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformTerms> get serializer => _$PlatformTermsSerializer();
}

class _$PlatformTermsSerializer implements PrimitiveSerializer<PlatformTerms> {
  @override
  final Iterable<Type> types = const [PlatformTerms, _$PlatformTerms];

  @override
  final String wireName = r'PlatformTerms';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformTerms object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'settlementDelayDays';
    yield serializers.serialize(
      object.settlementDelayDays,
      specifiedType: const FullType(int),
    );
    yield r'invitationValidityDays';
    yield serializers.serialize(
      object.invitationValidityDays,
      specifiedType: const FullType(int),
    );
    yield r'quoteValidityDays';
    yield serializers.serialize(
      object.quoteValidityDays,
      specifiedType: const FullType(int),
    );
    yield r'paymentCancelHours';
    yield serializers.serialize(
      object.paymentCancelHours,
      specifiedType: const FullType(int),
    );
    yield r'payoutMinimumMillimes';
    yield serializers.serialize(
      object.payoutMinimumMillimes,
      specifiedType: const FullType(int),
    );
    yield r'secondValidationThresholdMillimes';
    yield serializers.serialize(
      object.secondValidationThresholdMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PlatformTerms object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlatformTermsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'settlementDelayDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.settlementDelayDays = valueDes;
          break;
        case r'invitationValidityDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.invitationValidityDays = valueDes;
          break;
        case r'quoteValidityDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.quoteValidityDays = valueDes;
          break;
        case r'paymentCancelHours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentCancelHours = valueDes;
          break;
        case r'payoutMinimumMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.payoutMinimumMillimes = valueDes;
          break;
        case r'secondValidationThresholdMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.secondValidationThresholdMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlatformTerms deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformTermsBuilder();
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


