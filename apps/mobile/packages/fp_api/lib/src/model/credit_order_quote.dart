//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_order_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credit_order_quote.g.dart';

/// Récapitulatif calculé par le serveur.
///
/// Properties:
/// * [quoteId] - Devis figé jusqu'à expiresAt ; la commande créée avec cet identifiant en reprend les montants.
/// * [expiresAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [lines] 
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [feeRateBps] - Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
/// * [feesMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [vatRateBps] - TVA sur la commission, figée (décision du 2026-11-03).
/// * [vatMillimes] - TVA de la commission arrondie, au millime le plus proche.
/// * [stampDutyMillimes] - Timbre fiscal, figé.
/// * [withholdingRateBps] - Retenue à la source (taux de la forme juridique, au-delà du seuil ; 0 sinon).
/// * [withholdingMillimes] - Retenue à la source sur la commission, ajoutée comme la TVA.
/// * [transferFeeMillimes] - Frais de virement.
/// * [totalMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
@BuiltValue()
abstract class CreditOrderQuote implements Built<CreditOrderQuote, CreditOrderQuoteBuilder> {
  /// Devis figé jusqu'à expiresAt ; la commande créée avec cet identifiant en reprend les montants.
  @BuiltValueField(wireName: r'quoteId')
  String get quoteId;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'lines')
  BuiltList<CreditOrderLine> get lines;

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  /// Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
  @BuiltValueField(wireName: r'feeRateBps')
  int get feeRateBps;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'feesMillimes')
  int get feesMillimes;

  /// TVA sur la commission, figée (décision du 2026-11-03).
  @BuiltValueField(wireName: r'vatRateBps')
  int get vatRateBps;

  /// TVA de la commission arrondie, au millime le plus proche.
  @BuiltValueField(wireName: r'vatMillimes')
  int get vatMillimes;

  /// Timbre fiscal, figé.
  @BuiltValueField(wireName: r'stampDutyMillimes')
  int get stampDutyMillimes;

  /// Retenue à la source (taux de la forme juridique, au-delà du seuil ; 0 sinon).
  @BuiltValueField(wireName: r'withholdingRateBps')
  int get withholdingRateBps;

  /// Retenue à la source sur la commission, ajoutée comme la TVA.
  @BuiltValueField(wireName: r'withholdingMillimes')
  int get withholdingMillimes;

  /// Frais de virement.
  @BuiltValueField(wireName: r'transferFeeMillimes')
  int get transferFeeMillimes;

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'totalMillimes')
  int get totalMillimes;

  CreditOrderQuote._();

  factory CreditOrderQuote([void updates(CreditOrderQuoteBuilder b)]) = _$CreditOrderQuote;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreditOrderQuoteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreditOrderQuote> get serializer => _$CreditOrderQuoteSerializer();
}

class _$CreditOrderQuoteSerializer implements PrimitiveSerializer<CreditOrderQuote> {
  @override
  final Iterable<Type> types = const [CreditOrderQuote, _$CreditOrderQuote];

  @override
  final String wireName = r'CreditOrderQuote';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreditOrderQuote object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'quoteId';
    yield serializers.serialize(
      object.quoteId,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(CreditOrderLine)]),
    );
    yield r'amountMillimes';
    yield serializers.serialize(
      object.amountMillimes,
      specifiedType: const FullType(int),
    );
    yield r'feeRateBps';
    yield serializers.serialize(
      object.feeRateBps,
      specifiedType: const FullType(int),
    );
    yield r'feesMillimes';
    yield serializers.serialize(
      object.feesMillimes,
      specifiedType: const FullType(int),
    );
    yield r'vatRateBps';
    yield serializers.serialize(
      object.vatRateBps,
      specifiedType: const FullType(int),
    );
    yield r'vatMillimes';
    yield serializers.serialize(
      object.vatMillimes,
      specifiedType: const FullType(int),
    );
    yield r'stampDutyMillimes';
    yield serializers.serialize(
      object.stampDutyMillimes,
      specifiedType: const FullType(int),
    );
    yield r'withholdingRateBps';
    yield serializers.serialize(
      object.withholdingRateBps,
      specifiedType: const FullType(int),
    );
    yield r'withholdingMillimes';
    yield serializers.serialize(
      object.withholdingMillimes,
      specifiedType: const FullType(int),
    );
    yield r'transferFeeMillimes';
    yield serializers.serialize(
      object.transferFeeMillimes,
      specifiedType: const FullType(int),
    );
    yield r'totalMillimes';
    yield serializers.serialize(
      object.totalMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreditOrderQuote object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreditOrderQuoteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'quoteId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quoteId = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreditOrderLine)]),
          ) as BuiltList<CreditOrderLine>;
          result.lines.replace(valueDes);
          break;
        case r'amountMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountMillimes = valueDes;
          break;
        case r'feeRateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.feeRateBps = valueDes;
          break;
        case r'feesMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.feesMillimes = valueDes;
          break;
        case r'vatRateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vatRateBps = valueDes;
          break;
        case r'vatMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vatMillimes = valueDes;
          break;
        case r'stampDutyMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stampDutyMillimes = valueDes;
          break;
        case r'withholdingRateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.withholdingRateBps = valueDes;
          break;
        case r'withholdingMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.withholdingMillimes = valueDes;
          break;
        case r'transferFeeMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.transferFeeMillimes = valueDes;
          break;
        case r'totalMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreditOrderQuote deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreditOrderQuoteBuilder();
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


