//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/platform_settings_withholding.dart';
import 'package:fp_api/src/model/credit_type_settings.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/funding_bank_account.dart';
import 'package:fp_api/src/model/kyc_document_type.dart';
import 'package:fp_api/src/model/expired_credits_destination.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_settings.g.dart';

/// Toutes les valeurs métier de la plateforme (demande du 2026-11-05) : aucune n'est écrite en dur dans le code. Toute modification est une demande soumise à double validation. 
///
/// Properties:
/// * [withholding] 
/// * [transferFeeMillimes] - Frais de virement de chaque commande et de chaque virement commerçant.
/// * [fundingAccount] 
/// * [secondValidationThresholdMillimes] - Au-delà de ce montant, une commande exige deux administrateurs (figé dans chaque commande).
/// * [quoteValidityDays] - Validité du devis d'une commande, en jours (figée à la création).
/// * [invitationValidityDays] - Validité du mot de passe temporaire d'une invitation, en jours.
/// * [otpValidityMinutes] - Validité du code de connexion (OTP), en minutes.
/// * [pinLockMinutes] - Paliers de blocage du PIN, en minutes ; au-delà du dernier, reconnexion complète.
/// * [paymentCancelHours] - Délai d'annulation d'un paiement confirmé par le commerçant, en heures (0 = jamais).
/// * [settlementDelayDays] - Cycle de règlement (J + n jours ouvrés, J+0 accepté).
/// * [kycRequiredDocuments] - Pièces KYC demandées aux clients (processus v2), au moins une.
/// * [expiredCreditsDestination] 
/// * [payoutMinimumMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [creditValidityMonths] 
/// * [maxFamilyMembers] 
/// * [orderFeeRateBps] - Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
/// * [vatRateBps] - TVA sur la commission (19 % = 1 900 bps), décision du 2026-11-03.
/// * [stampDutyMillimes] - Timbre fiscal par commande et par virement (1 DT = 1 000), décision du 2026-11-03.
/// * [creditTypes] - Paramétrage par type (un élément par type, les 4 types).
@BuiltValue()
abstract class PlatformSettings implements Built<PlatformSettings, PlatformSettingsBuilder> {
  @BuiltValueField(wireName: r'withholding')
  PlatformSettingsWithholding? get withholding;

  /// Frais de virement de chaque commande et de chaque virement commerçant.
  @BuiltValueField(wireName: r'transferFeeMillimes')
  int? get transferFeeMillimes;

  @BuiltValueField(wireName: r'fundingAccount')
  FundingBankAccount get fundingAccount;

  /// Au-delà de ce montant, une commande exige deux administrateurs (figé dans chaque commande).
  @BuiltValueField(wireName: r'secondValidationThresholdMillimes')
  int get secondValidationThresholdMillimes;

  /// Validité du devis d'une commande, en jours (figée à la création).
  @BuiltValueField(wireName: r'quoteValidityDays')
  int get quoteValidityDays;

  /// Validité du mot de passe temporaire d'une invitation, en jours.
  @BuiltValueField(wireName: r'invitationValidityDays')
  int get invitationValidityDays;

  /// Validité du code de connexion (OTP), en minutes.
  @BuiltValueField(wireName: r'otpValidityMinutes')
  int get otpValidityMinutes;

  /// Paliers de blocage du PIN, en minutes ; au-delà du dernier, reconnexion complète.
  @BuiltValueField(wireName: r'pinLockMinutes')
  BuiltList<int> get pinLockMinutes;

  /// Délai d'annulation d'un paiement confirmé par le commerçant, en heures (0 = jamais).
  @BuiltValueField(wireName: r'paymentCancelHours')
  int get paymentCancelHours;

  /// Cycle de règlement (J + n jours ouvrés, J+0 accepté).
  @BuiltValueField(wireName: r'settlementDelayDays')
  int get settlementDelayDays;

  /// Pièces KYC demandées aux clients (processus v2), au moins une.
  @BuiltValueField(wireName: r'kycRequiredDocuments')
  BuiltSet<KycDocumentType>? get kycRequiredDocuments;

  @BuiltValueField(wireName: r'expiredCreditsDestination')
  ExpiredCreditsDestination get expiredCreditsDestination;
  // enum expiredCreditsDestinationEnum {  PLATFORM_REVENUE,  COMPANY_RETURN,  };

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'payoutMinimumMillimes')
  int get payoutMinimumMillimes;

  @BuiltValueField(wireName: r'creditValidityMonths')
  int get creditValidityMonths;

  @BuiltValueField(wireName: r'maxFamilyMembers')
  int get maxFamilyMembers;

  /// Taux en **points de base** (200 = 2 %, 150 = 1,5 %). Champs suffixés `Bps`.
  @BuiltValueField(wireName: r'orderFeeRateBps')
  int get orderFeeRateBps;

  /// TVA sur la commission (19 % = 1 900 bps), décision du 2026-11-03.
  @BuiltValueField(wireName: r'vatRateBps')
  int get vatRateBps;

  /// Timbre fiscal par commande et par virement (1 DT = 1 000), décision du 2026-11-03.
  @BuiltValueField(wireName: r'stampDutyMillimes')
  int get stampDutyMillimes;

  /// Paramétrage par type (un élément par type, les 4 types).
  @BuiltValueField(wireName: r'creditTypes')
  BuiltList<CreditTypeSettings> get creditTypes;

  PlatformSettings._();

  factory PlatformSettings([void updates(PlatformSettingsBuilder b)]) = _$PlatformSettings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformSettingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformSettings> get serializer => _$PlatformSettingsSerializer();
}

class _$PlatformSettingsSerializer implements PrimitiveSerializer<PlatformSettings> {
  @override
  final Iterable<Type> types = const [PlatformSettings, _$PlatformSettings];

  @override
  final String wireName = r'PlatformSettings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.withholding != null) {
      yield r'withholding';
      yield serializers.serialize(
        object.withholding,
        specifiedType: const FullType(PlatformSettingsWithholding),
      );
    }
    if (object.transferFeeMillimes != null) {
      yield r'transferFeeMillimes';
      yield serializers.serialize(
        object.transferFeeMillimes,
        specifiedType: const FullType(int),
      );
    }
    yield r'fundingAccount';
    yield serializers.serialize(
      object.fundingAccount,
      specifiedType: const FullType(FundingBankAccount),
    );
    yield r'secondValidationThresholdMillimes';
    yield serializers.serialize(
      object.secondValidationThresholdMillimes,
      specifiedType: const FullType(int),
    );
    yield r'quoteValidityDays';
    yield serializers.serialize(
      object.quoteValidityDays,
      specifiedType: const FullType(int),
    );
    yield r'invitationValidityDays';
    yield serializers.serialize(
      object.invitationValidityDays,
      specifiedType: const FullType(int),
    );
    yield r'otpValidityMinutes';
    yield serializers.serialize(
      object.otpValidityMinutes,
      specifiedType: const FullType(int),
    );
    yield r'pinLockMinutes';
    yield serializers.serialize(
      object.pinLockMinutes,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'paymentCancelHours';
    yield serializers.serialize(
      object.paymentCancelHours,
      specifiedType: const FullType(int),
    );
    yield r'settlementDelayDays';
    yield serializers.serialize(
      object.settlementDelayDays,
      specifiedType: const FullType(int),
    );
    if (object.kycRequiredDocuments != null) {
      yield r'kycRequiredDocuments';
      yield serializers.serialize(
        object.kycRequiredDocuments,
        specifiedType: const FullType(BuiltSet, [FullType(KycDocumentType)]),
      );
    }
    yield r'expiredCreditsDestination';
    yield serializers.serialize(
      object.expiredCreditsDestination,
      specifiedType: const FullType(ExpiredCreditsDestination),
    );
    yield r'payoutMinimumMillimes';
    yield serializers.serialize(
      object.payoutMinimumMillimes,
      specifiedType: const FullType(int),
    );
    yield r'creditValidityMonths';
    yield serializers.serialize(
      object.creditValidityMonths,
      specifiedType: const FullType(int),
    );
    yield r'maxFamilyMembers';
    yield serializers.serialize(
      object.maxFamilyMembers,
      specifiedType: const FullType(int),
    );
    yield r'orderFeeRateBps';
    yield serializers.serialize(
      object.orderFeeRateBps,
      specifiedType: const FullType(int),
    );
    yield r'vatRateBps';
    yield serializers.serialize(
      object.vatRateBps,
      specifiedType: const FullType(int),
    );
    yield r'stampDutyMillimes';
    yield serializers.serialize(
      object.stampDutyMillimes,
      specifiedType: const FullType(int),
    );
    yield r'creditTypes';
    yield serializers.serialize(
      object.creditTypes,
      specifiedType: const FullType(BuiltList, [FullType(CreditTypeSettings)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PlatformSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlatformSettingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'withholding':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PlatformSettingsWithholding),
          ) as PlatformSettingsWithholding?;
          if (valueDes == null) continue;
          result.withholding.replace(valueDes);
          break;
        case r'transferFeeMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.transferFeeMillimes = valueDes;
          break;
        case r'fundingAccount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FundingBankAccount),
          ) as FundingBankAccount;
          result.fundingAccount.replace(valueDes);
          break;
        case r'secondValidationThresholdMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.secondValidationThresholdMillimes = valueDes;
          break;
        case r'quoteValidityDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.quoteValidityDays = valueDes;
          break;
        case r'invitationValidityDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.invitationValidityDays = valueDes;
          break;
        case r'otpValidityMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.otpValidityMinutes = valueDes;
          break;
        case r'pinLockMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.pinLockMinutes.replace(valueDes);
          break;
        case r'paymentCancelHours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentCancelHours = valueDes;
          break;
        case r'settlementDelayDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.settlementDelayDays = valueDes;
          break;
        case r'kycRequiredDocuments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltSet, [FullType(KycDocumentType)]),
          ) as BuiltSet<KycDocumentType>?;
          if (valueDes == null) continue;
          result.kycRequiredDocuments.replace(valueDes);
          break;
        case r'expiredCreditsDestination':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ExpiredCreditsDestination),
          ) as ExpiredCreditsDestination;
          result.expiredCreditsDestination = valueDes;
          break;
        case r'payoutMinimumMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.payoutMinimumMillimes = valueDes;
          break;
        case r'creditValidityMonths':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.creditValidityMonths = valueDes;
          break;
        case r'maxFamilyMembers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxFamilyMembers = valueDes;
          break;
        case r'orderFeeRateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orderFeeRateBps = valueDes;
          break;
        case r'vatRateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vatRateBps = valueDes;
          break;
        case r'stampDutyMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stampDutyMillimes = valueDes;
          break;
        case r'creditTypes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreditTypeSettings)]),
          ) as BuiltList<CreditTypeSettings>;
          result.creditTypes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlatformSettings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformSettingsBuilder();
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


