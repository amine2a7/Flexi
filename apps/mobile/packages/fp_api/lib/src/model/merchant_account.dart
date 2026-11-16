//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/temporary_credentials.dart';
import 'package:fp_api/src/model/legal_form.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/account_status.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:fp_api/src/model/merchant_category.dart';
import 'package:fp_api/src/model/commission_grid.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_account.g.dart';

/// MerchantAccount
///
/// Properties:
/// * [credentials] 
/// * [legalForm] 
/// * [id] - Identifiant opaque de ressource.
/// * [name] 
/// * [category] 
/// * [acceptedCreditTypes] - Types de crédit acceptés (un restaurant : Restauration ; une station : Carburant…).
/// * [city] 
/// * [status] 
/// * [commissionGrid] - Grille de commission du commerçant (taux sur le montant de chaque virement). Jamais `null` après la migration 0025 (décision du 2026-11-04) : sans grille, l'opération est refusée (`422 COMMISSION_GRID_MISSING`) et une alerte est levée. Le taux est figé dans la demande de virement. 
/// * [createdAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class MerchantAccount implements Built<MerchantAccount, MerchantAccountBuilder> {
  @BuiltValueField(wireName: r'credentials')
  TemporaryCredentials? get credentials;

  @BuiltValueField(wireName: r'legalForm')
  LegalForm get legalForm;
  // enum legalFormEnum {  PP_CIN,  PP_MF,  PM_MF,  };

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  MerchantCategory get category;
  // enum categoryEnum {  RESTAURANT,  CAFE,  GROCERY,  BAKERY,  FAST_FOOD,  CLOTHING,  FUEL_STATION,  GIFT_SHOP,  };

  /// Types de crédit acceptés (un restaurant : Restauration ; une station : Carburant…).
  @BuiltValueField(wireName: r'acceptedCreditTypes')
  BuiltSet<CreditType> get acceptedCreditTypes;

  @BuiltValueField(wireName: r'city')
  String get city;

  @BuiltValueField(wireName: r'status')
  AccountStatus get status;
  // enum statusEnum {  PENDING_KYC,  APPROVED,  REJECTED,  SUSPENDED,  };

  /// Grille de commission du commerçant (taux sur le montant de chaque virement). Jamais `null` après la migration 0025 (décision du 2026-11-04) : sans grille, l'opération est refusée (`422 COMMISSION_GRID_MISSING`) et une alerte est levée. Le taux est figé dans la demande de virement. 
  @BuiltValueField(wireName: r'commissionGrid')
  CommissionGrid? get commissionGrid;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  MerchantAccount._();

  factory MerchantAccount([void updates(MerchantAccountBuilder b)]) = _$MerchantAccount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantAccountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantAccount> get serializer => _$MerchantAccountSerializer();
}

class _$MerchantAccountSerializer implements PrimitiveSerializer<MerchantAccount> {
  @override
  final Iterable<Type> types = const [MerchantAccount, _$MerchantAccount];

  @override
  final String wireName = r'MerchantAccount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantAccount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.credentials != null) {
      yield r'credentials';
      yield serializers.serialize(
        object.credentials,
        specifiedType: const FullType(TemporaryCredentials),
      );
    }
    yield r'legalForm';
    yield serializers.serialize(
      object.legalForm,
      specifiedType: const FullType(LegalForm),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(MerchantCategory),
    );
    yield r'acceptedCreditTypes';
    yield serializers.serialize(
      object.acceptedCreditTypes,
      specifiedType: const FullType(BuiltSet, [FullType(CreditType)]),
    );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AccountStatus),
    );
    yield r'commissionGrid';
    yield object.commissionGrid == null ? null : serializers.serialize(
      object.commissionGrid,
      specifiedType: const FullType.nullable(CommissionGrid),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantAccount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantAccountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'credentials':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(TemporaryCredentials),
          ) as TemporaryCredentials?;
          if (valueDes == null) continue;
          result.credentials.replace(valueDes);
          break;
        case r'legalForm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LegalForm),
          ) as LegalForm;
          result.legalForm = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MerchantCategory),
          ) as MerchantCategory;
          result.category = valueDes;
          break;
        case r'acceptedCreditTypes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(CreditType)]),
          ) as BuiltSet<CreditType>;
          result.acceptedCreditTypes.replace(valueDes);
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AccountStatus),
          ) as AccountStatus;
          result.status = valueDes;
          break;
        case r'commissionGrid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CommissionGrid),
          ) as CommissionGrid?;
          if (valueDes == null) continue;
          result.commissionGrid.replace(valueDes);
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantAccount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantAccountBuilder();
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


