//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/point_of_sale.dart';
import 'package:fp_api/src/model/staff_member.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:fp_api/src/model/merchant_category.dart';
import 'package:fp_api/src/model/commission_grid.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_profile.g.dart';

/// MerchantProfile
///
/// Properties:
/// * [name] 
/// * [category] 
/// * [city] 
/// * [address] 
/// * [phone] - Numéro tunisien au format E.164.
/// * [maskedIban] 
/// * [paymentCode] - Code commerçant à 6 chiffres, affiché en QR (`flexipay:merchant:<code>`) dans le commerce : le bénéficiaire le scanne ou le saisit pour payer. 
/// * [acceptedCreditTypes] - Types de crédit que le commerce accepte (définis par FlexiPay).
/// * [commissionGrid] - Grille de commission du commerçant (taux sur le montant de chaque virement). Jamais `null` après la migration 0025 (décision du 2026-11-04) : sans grille, l'opération est refusée (`422 COMMISSION_GRID_MISSING`) et une alerte est levée. Le taux est figé dans la demande de virement. 
/// * [pointsOfSale] 
/// * [staff] 
@BuiltValue()
abstract class MerchantProfile implements Built<MerchantProfile, MerchantProfileBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  MerchantCategory get category;
  // enum categoryEnum {  RESTAURANT,  CAFE,  GROCERY,  BAKERY,  FAST_FOOD,  CLOTHING,  FUEL_STATION,  GIFT_SHOP,  };

  @BuiltValueField(wireName: r'city')
  String get city;

  @BuiltValueField(wireName: r'address')
  String get address;

  /// Numéro tunisien au format E.164.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'maskedIban')
  String get maskedIban;

  /// Code commerçant à 6 chiffres, affiché en QR (`flexipay:merchant:<code>`) dans le commerce : le bénéficiaire le scanne ou le saisit pour payer. 
  @BuiltValueField(wireName: r'paymentCode')
  String get paymentCode;

  /// Types de crédit que le commerce accepte (définis par FlexiPay).
  @BuiltValueField(wireName: r'acceptedCreditTypes')
  BuiltSet<CreditType> get acceptedCreditTypes;

  /// Grille de commission du commerçant (taux sur le montant de chaque virement). Jamais `null` après la migration 0025 (décision du 2026-11-04) : sans grille, l'opération est refusée (`422 COMMISSION_GRID_MISSING`) et une alerte est levée. Le taux est figé dans la demande de virement. 
  @BuiltValueField(wireName: r'commissionGrid')
  CommissionGrid? get commissionGrid;

  @BuiltValueField(wireName: r'pointsOfSale')
  BuiltList<PointOfSale> get pointsOfSale;

  @BuiltValueField(wireName: r'staff')
  BuiltList<StaffMember> get staff;

  MerchantProfile._();

  factory MerchantProfile([void updates(MerchantProfileBuilder b)]) = _$MerchantProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantProfile> get serializer => _$MerchantProfileSerializer();
}

class _$MerchantProfileSerializer implements PrimitiveSerializer<MerchantProfile> {
  @override
  final Iterable<Type> types = const [MerchantProfile, _$MerchantProfile];

  @override
  final String wireName = r'MerchantProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'maskedIban';
    yield serializers.serialize(
      object.maskedIban,
      specifiedType: const FullType(String),
    );
    yield r'paymentCode';
    yield serializers.serialize(
      object.paymentCode,
      specifiedType: const FullType(String),
    );
    yield r'acceptedCreditTypes';
    yield serializers.serialize(
      object.acceptedCreditTypes,
      specifiedType: const FullType(BuiltSet, [FullType(CreditType)]),
    );
    yield r'commissionGrid';
    yield object.commissionGrid == null ? null : serializers.serialize(
      object.commissionGrid,
      specifiedType: const FullType.nullable(CommissionGrid),
    );
    yield r'pointsOfSale';
    yield serializers.serialize(
      object.pointsOfSale,
      specifiedType: const FullType(BuiltList, [FullType(PointOfSale)]),
    );
    yield r'staff';
    yield serializers.serialize(
      object.staff,
      specifiedType: const FullType(BuiltList, [FullType(StaffMember)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantProfileBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.address = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'maskedIban':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.maskedIban = valueDes;
          break;
        case r'paymentCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentCode = valueDes;
          break;
        case r'acceptedCreditTypes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(CreditType)]),
          ) as BuiltSet<CreditType>;
          result.acceptedCreditTypes.replace(valueDes);
          break;
        case r'commissionGrid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CommissionGrid),
          ) as CommissionGrid?;
          if (valueDes == null) continue;
          result.commissionGrid.replace(valueDes);
          break;
        case r'pointsOfSale':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PointOfSale)]),
          ) as BuiltList<PointOfSale>;
          result.pointsOfSale.replace(valueDes);
          break;
        case r'staff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(StaffMember)]),
          ) as BuiltList<StaffMember>;
          result.staff.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantProfileBuilder();
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


