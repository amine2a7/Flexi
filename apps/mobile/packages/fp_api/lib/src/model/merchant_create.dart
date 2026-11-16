//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/commission_tier.dart';
import 'package:fp_api/src/model/legal_form.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:fp_api/src/model/merchant_category.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_create.g.dart';

/// MerchantCreate
///
/// Properties:
/// * [legalForm] 
/// * [acceptedCreditTypes] - Types de crédit acceptés par le commerçant.
/// * [name] 
/// * [category] 
/// * [city] 
/// * [phone] - Numéro tunisien au format E.164.
/// * [email] 
/// * [commissionGrid] - Grille de commission saisie à la création (étape 2, fenêtre « Commission »).
@BuiltValue()
abstract class MerchantCreate implements Built<MerchantCreate, MerchantCreateBuilder> {
  @BuiltValueField(wireName: r'legalForm')
  LegalForm get legalForm;
  // enum legalFormEnum {  PP_CIN,  PP_MF,  PM_MF,  };

  /// Types de crédit acceptés par le commerçant.
  @BuiltValueField(wireName: r'acceptedCreditTypes')
  BuiltSet<CreditType> get acceptedCreditTypes;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  MerchantCategory get category;
  // enum categoryEnum {  RESTAURANT,  CAFE,  GROCERY,  BAKERY,  FAST_FOOD,  CLOTHING,  FUEL_STATION,  GIFT_SHOP,  };

  @BuiltValueField(wireName: r'city')
  String get city;

  /// Numéro tunisien au format E.164.
  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'email')
  String get email;

  /// Grille de commission saisie à la création (étape 2, fenêtre « Commission »).
  @BuiltValueField(wireName: r'commissionGrid')
  BuiltList<CommissionTier> get commissionGrid;

  MerchantCreate._();

  factory MerchantCreate([void updates(MerchantCreateBuilder b)]) = _$MerchantCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantCreate> get serializer => _$MerchantCreateSerializer();
}

class _$MerchantCreateSerializer implements PrimitiveSerializer<MerchantCreate> {
  @override
  final Iterable<Type> types = const [MerchantCreate, _$MerchantCreate];

  @override
  final String wireName = r'MerchantCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'legalForm';
    yield serializers.serialize(
      object.legalForm,
      specifiedType: const FullType(LegalForm),
    );
    yield r'acceptedCreditTypes';
    yield serializers.serialize(
      object.acceptedCreditTypes,
      specifiedType: const FullType(BuiltSet, [FullType(CreditType)]),
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
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'commissionGrid';
    yield serializers.serialize(
      object.commissionGrid,
      specifiedType: const FullType(BuiltList, [FullType(CommissionTier)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'legalForm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LegalForm),
          ) as LegalForm;
          result.legalForm = valueDes;
          break;
        case r'acceptedCreditTypes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(CreditType)]),
          ) as BuiltSet<CreditType>;
          result.acceptedCreditTypes.replace(valueDes);
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
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'commissionGrid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CommissionTier)]),
          ) as BuiltList<CommissionTier>;
          result.commissionGrid.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantCreateBuilder();
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


