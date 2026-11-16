//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/account_change.dart';
import 'package:fp_api/src/model/legal_form.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/account_status.dart';
import 'package:fp_api/src/model/approval.dart';
import 'package:fp_api/src/model/merchant_category.dart';
import 'package:fp_api/src/model/commission_grid.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_record.g.dart';

/// Fiche d'une entreprise ou d'un commerçant (décision du 2026-11-03).
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [kind] 
/// * [name] 
/// * [city] 
/// * [status] 
/// * [legalForm] 
/// * [email] 
/// * [phone] - Téléphone, seulement pour les administrateurs qui peuvent le modifier (sinon `null`).
/// * [category] 
/// * [address] 
/// * [maskedIban] - RIB masqué du commerçant (4 derniers chiffres), `null` sans RIB.
/// * [commissionGrid] - Grille en vigueur (`null` sans `commissions.read`).
/// * [gridVersions] - Versions de la grille, de la plus récente à la plus ancienne (`commissions.read`).
/// * [history] - Changements de la fiche (noms des champs seulement, jamais leurs valeurs).
/// * [requests] - Demandes en attente de seconde validation (grille, RIB).
/// * [createdAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class AccountRecord implements Built<AccountRecord, AccountRecordBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  AccountRecordKindEnum get kind;
  // enum kindEnum {  COMPANY,  MERCHANT,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'city')
  String get city;

  @BuiltValueField(wireName: r'status')
  AccountStatus get status;
  // enum statusEnum {  PENDING_KYC,  APPROVED,  REJECTED,  SUSPENDED,  };

  @BuiltValueField(wireName: r'legalForm')
  LegalForm get legalForm;
  // enum legalFormEnum {  PP_CIN,  PP_MF,  PM_MF,  };

  @BuiltValueField(wireName: r'email')
  String get email;

  /// Téléphone, seulement pour les administrateurs qui peuvent le modifier (sinon `null`).
  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'category')
  MerchantCategory? get category;
  // enum categoryEnum {  RESTAURANT,  CAFE,  GROCERY,  BAKERY,  FAST_FOOD,  CLOTHING,  FUEL_STATION,  GIFT_SHOP,  };

  @BuiltValueField(wireName: r'address')
  String? get address;

  /// RIB masqué du commerçant (4 derniers chiffres), `null` sans RIB.
  @BuiltValueField(wireName: r'maskedIban')
  String? get maskedIban;

  /// Grille en vigueur (`null` sans `commissions.read`).
  @BuiltValueField(wireName: r'commissionGrid')
  CommissionGrid? get commissionGrid;

  /// Versions de la grille, de la plus récente à la plus ancienne (`commissions.read`).
  @BuiltValueField(wireName: r'gridVersions')
  BuiltList<CommissionGrid> get gridVersions;

  /// Changements de la fiche (noms des champs seulement, jamais leurs valeurs).
  @BuiltValueField(wireName: r'history')
  BuiltList<AccountChange> get history;

  /// Demandes en attente de seconde validation (grille, RIB).
  @BuiltValueField(wireName: r'requests')
  BuiltList<Approval> get requests;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  AccountRecord._();

  factory AccountRecord([void updates(AccountRecordBuilder b)]) = _$AccountRecord;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountRecordBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountRecord> get serializer => _$AccountRecordSerializer();
}

class _$AccountRecordSerializer implements PrimitiveSerializer<AccountRecord> {
  @override
  final Iterable<Type> types = const [AccountRecord, _$AccountRecord];

  @override
  final String wireName = r'AccountRecord';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AccountRecordKindEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
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
    yield r'legalForm';
    yield serializers.serialize(
      object.legalForm,
      specifiedType: const FullType(LegalForm),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield object.phone == null ? null : serializers.serialize(
      object.phone,
      specifiedType: const FullType.nullable(String),
    );
    if (object.category != null) {
      yield r'category';
      yield serializers.serialize(
        object.category,
        specifiedType: const FullType(MerchantCategory),
      );
    }
    if (object.address != null) {
      yield r'address';
      yield serializers.serialize(
        object.address,
        specifiedType: const FullType(String),
      );
    }
    if (object.maskedIban != null) {
      yield r'maskedIban';
      yield serializers.serialize(
        object.maskedIban,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'commissionGrid';
    yield object.commissionGrid == null ? null : serializers.serialize(
      object.commissionGrid,
      specifiedType: const FullType.nullable(CommissionGrid),
    );
    yield r'gridVersions';
    yield serializers.serialize(
      object.gridVersions,
      specifiedType: const FullType(BuiltList, [FullType(CommissionGrid)]),
    );
    yield r'history';
    yield serializers.serialize(
      object.history,
      specifiedType: const FullType(BuiltList, [FullType(AccountChange)]),
    );
    yield r'requests';
    yield serializers.serialize(
      object.requests,
      specifiedType: const FullType(BuiltList, [FullType(Approval)]),
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
    AccountRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountRecordBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AccountRecordKindEnum),
          ) as AccountRecordKindEnum;
          result.kind = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
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
        case r'legalForm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LegalForm),
          ) as LegalForm;
          result.legalForm = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MerchantCategory),
          ) as MerchantCategory?;
          if (valueDes == null) continue;
          result.category = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.address = valueDes;
          break;
        case r'maskedIban':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.maskedIban = valueDes;
          break;
        case r'commissionGrid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CommissionGrid),
          ) as CommissionGrid?;
          if (valueDes == null) continue;
          result.commissionGrid.replace(valueDes);
          break;
        case r'gridVersions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CommissionGrid)]),
          ) as BuiltList<CommissionGrid>;
          result.gridVersions.replace(valueDes);
          break;
        case r'history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AccountChange)]),
          ) as BuiltList<AccountChange>;
          result.history.replace(valueDes);
          break;
        case r'requests':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Approval)]),
          ) as BuiltList<Approval>;
          result.requests.replace(valueDes);
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
  AccountRecord deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountRecordBuilder();
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


class AccountRecordKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COMPANY')
  static const AccountRecordKindEnum COMPANY = _$accountRecordKindEnum_COMPANY;
  @BuiltValueEnumConst(wireName: r'MERCHANT')
  static const AccountRecordKindEnum MERCHANT = _$accountRecordKindEnum_MERCHANT;

  static Serializer<AccountRecordKindEnum> get serializer => _$accountRecordKindEnumSerializer;

  const AccountRecordKindEnum._(String name): super(name);

  static BuiltSet<AccountRecordKindEnum> get values => _$accountRecordKindEnumValues;
  static AccountRecordKindEnum valueOf(String name) => _$accountRecordKindEnumValueOf(name);
}

