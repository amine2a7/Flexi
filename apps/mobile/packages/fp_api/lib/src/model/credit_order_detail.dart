//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_order_line.dart';
import 'package:fp_api/src/model/credit_order_event.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/first_validation.dart';
import 'package:fp_api/src/model/order_status.dart';
import 'package:fp_api/src/model/transfer_declaration.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credit_order_detail.g.dart';

/// Commande avec sa déclaration de virement, son dernier motif et son historique.
///
/// Properties:
/// * [quoteExpiresAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [quoteExpired] 
/// * [id] - Identifiant opaque de ressource.
/// * [reference] 
/// * [status] 
/// * [lines] - Montant commandé par type ; `amountMillimes` en est la somme.
/// * [companyId] - Identifiant opaque de ressource.
/// * [companyName] 
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [feeRateBps] - Taux de la tranche de la grille, figé dans la commande.
/// * [feesMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [vatRateBps] - TVA sur la commission, figée (décision du 2026-11-03).
/// * [vatMillimes] - TVA de la commission arrondie, au millime le plus proche.
/// * [stampDutyMillimes] - Timbre fiscal, figé.
/// * [withholdingRateBps] - Retenue à la source (taux de la forme juridique, au-delà du seuil ; 0 sinon).
/// * [withholdingMillimes] - Retenue à la source sur la commission, ajoutée comme la TVA.
/// * [transferFeeMillimes] - Frais de virement.
/// * [totalMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [createdAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [paymentReference] - Référence à indiquer sur le virement.
/// * [declaredAmountMillimes] - Montant du dernier virement déclaré (absent sans déclaration en cours).
/// * [declaration] - Dernière déclaration de virement (absente avant la première déclaration).
/// * [refusalReason] - Motif du refus de la commande (statut REFUSED).
/// * [proofRejectionReason] - Motif du dernier rejet de justificatif, affiché à l'entreprise pour redéclarer.
/// * [requiresSecondValidation] - Double validation (règle 12) : vrai quand les crédits dépassent 10 000,000 TND (`amountMillimes` > 10000000). La validation du paiement exige alors deux administrateurs différents. 
/// * [firstValidation] - Première validation enregistrée, en attente du second administrateur.
/// * [history] 
@BuiltValue()
abstract class CreditOrderDetail implements Built<CreditOrderDetail, CreditOrderDetailBuilder> {
  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'quoteExpiresAt')
  DateTime get quoteExpiresAt;

  @BuiltValueField(wireName: r'quoteExpired')
  bool get quoteExpired;

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'status')
  OrderStatus get status;
  // enum statusEnum {  AWAITING_CONFIRMATION,  AWAITING_PAYMENT,  AWAITING_VALIDATION,  VALIDATED,  REFUSED,  CANCELLED,  };

  /// Montant commandé par type ; `amountMillimes` en est la somme.
  @BuiltValueField(wireName: r'lines')
  BuiltList<CreditOrderLine> get lines;

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'companyId')
  String get companyId;

  @BuiltValueField(wireName: r'companyName')
  String get companyName;

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  /// Taux de la tranche de la grille, figé dans la commande.
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

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Référence à indiquer sur le virement.
  @BuiltValueField(wireName: r'paymentReference')
  String get paymentReference;

  /// Montant du dernier virement déclaré (absent sans déclaration en cours).
  @BuiltValueField(wireName: r'declaredAmountMillimes')
  int? get declaredAmountMillimes;

  /// Dernière déclaration de virement (absente avant la première déclaration).
  @BuiltValueField(wireName: r'declaration')
  TransferDeclaration? get declaration;

  /// Motif du refus de la commande (statut REFUSED).
  @BuiltValueField(wireName: r'refusalReason')
  String? get refusalReason;

  /// Motif du dernier rejet de justificatif, affiché à l'entreprise pour redéclarer.
  @BuiltValueField(wireName: r'proofRejectionReason')
  String? get proofRejectionReason;

  /// Double validation (règle 12) : vrai quand les crédits dépassent 10 000,000 TND (`amountMillimes` > 10000000). La validation du paiement exige alors deux administrateurs différents. 
  @BuiltValueField(wireName: r'requiresSecondValidation')
  bool get requiresSecondValidation;

  /// Première validation enregistrée, en attente du second administrateur.
  @BuiltValueField(wireName: r'firstValidation')
  FirstValidation? get firstValidation;

  @BuiltValueField(wireName: r'history')
  BuiltList<CreditOrderEvent> get history;

  CreditOrderDetail._();

  factory CreditOrderDetail([void updates(CreditOrderDetailBuilder b)]) = _$CreditOrderDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreditOrderDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreditOrderDetail> get serializer => _$CreditOrderDetailSerializer();
}

class _$CreditOrderDetailSerializer implements PrimitiveSerializer<CreditOrderDetail> {
  @override
  final Iterable<Type> types = const [CreditOrderDetail, _$CreditOrderDetail];

  @override
  final String wireName = r'CreditOrderDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreditOrderDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'quoteExpiresAt';
    yield serializers.serialize(
      object.quoteExpiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'quoteExpired';
    yield serializers.serialize(
      object.quoteExpired,
      specifiedType: const FullType(bool),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(OrderStatus),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(CreditOrderLine)]),
    );
    yield r'companyId';
    yield serializers.serialize(
      object.companyId,
      specifiedType: const FullType(String),
    );
    yield r'companyName';
    yield serializers.serialize(
      object.companyName,
      specifiedType: const FullType(String),
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
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'paymentReference';
    yield serializers.serialize(
      object.paymentReference,
      specifiedType: const FullType(String),
    );
    if (object.declaredAmountMillimes != null) {
      yield r'declaredAmountMillimes';
      yield serializers.serialize(
        object.declaredAmountMillimes,
        specifiedType: const FullType(int),
      );
    }
    if (object.declaration != null) {
      yield r'declaration';
      yield serializers.serialize(
        object.declaration,
        specifiedType: const FullType(TransferDeclaration),
      );
    }
    if (object.refusalReason != null) {
      yield r'refusalReason';
      yield serializers.serialize(
        object.refusalReason,
        specifiedType: const FullType(String),
      );
    }
    if (object.proofRejectionReason != null) {
      yield r'proofRejectionReason';
      yield serializers.serialize(
        object.proofRejectionReason,
        specifiedType: const FullType(String),
      );
    }
    yield r'requiresSecondValidation';
    yield serializers.serialize(
      object.requiresSecondValidation,
      specifiedType: const FullType(bool),
    );
    if (object.firstValidation != null) {
      yield r'firstValidation';
      yield serializers.serialize(
        object.firstValidation,
        specifiedType: const FullType(FirstValidation),
      );
    }
    yield r'history';
    yield serializers.serialize(
      object.history,
      specifiedType: const FullType(BuiltList, [FullType(CreditOrderEvent)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreditOrderDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreditOrderDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'quoteExpiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.quoteExpiresAt = valueDes;
          break;
        case r'quoteExpired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.quoteExpired = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderStatus),
          ) as OrderStatus;
          result.status = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreditOrderLine)]),
          ) as BuiltList<CreditOrderLine>;
          result.lines.replace(valueDes);
          break;
        case r'companyId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyId = valueDes;
          break;
        case r'companyName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyName = valueDes;
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
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'paymentReference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentReference = valueDes;
          break;
        case r'declaredAmountMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.declaredAmountMillimes = valueDes;
          break;
        case r'declaration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TransferDeclaration),
          ) as TransferDeclaration?;
          if (valueDes == null) continue;
          result.declaration.replace(valueDes);
          break;
        case r'refusalReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.refusalReason = valueDes;
          break;
        case r'proofRejectionReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.proofRejectionReason = valueDes;
          break;
        case r'requiresSecondValidation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.requiresSecondValidation = valueDes;
          break;
        case r'firstValidation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FirstValidation),
          ) as FirstValidation?;
          if (valueDes == null) continue;
          result.firstValidation.replace(valueDes);
          break;
        case r'history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreditOrderEvent)]),
          ) as BuiltList<CreditOrderEvent>;
          result.history.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreditOrderDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreditOrderDetailBuilder();
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


