//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:fp_api/src/model/merchant_category.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_lookup.g.dart';

/// MerchantLookup
///
/// Properties:
/// * [merchantCode] 
/// * [merchantName] 
/// * [city] 
/// * [acceptedCreditTypes] - Types acceptés : le bénéficiaire paie avec le solde de l'un d'eux.
/// * [category] 
@BuiltValue()
abstract class MerchantLookup implements Built<MerchantLookup, MerchantLookupBuilder> {
  @BuiltValueField(wireName: r'merchantCode')
  String get merchantCode;

  @BuiltValueField(wireName: r'merchantName')
  String get merchantName;

  @BuiltValueField(wireName: r'city')
  String get city;

  /// Types acceptés : le bénéficiaire paie avec le solde de l'un d'eux.
  @BuiltValueField(wireName: r'acceptedCreditTypes')
  BuiltSet<CreditType> get acceptedCreditTypes;

  @BuiltValueField(wireName: r'category')
  MerchantCategory get category;
  // enum categoryEnum {  RESTAURANT,  CAFE,  GROCERY,  BAKERY,  FAST_FOOD,  CLOTHING,  FUEL_STATION,  GIFT_SHOP,  };

  MerchantLookup._();

  factory MerchantLookup([void updates(MerchantLookupBuilder b)]) = _$MerchantLookup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantLookupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantLookup> get serializer => _$MerchantLookupSerializer();
}

class _$MerchantLookupSerializer implements PrimitiveSerializer<MerchantLookup> {
  @override
  final Iterable<Type> types = const [MerchantLookup, _$MerchantLookup];

  @override
  final String wireName = r'MerchantLookup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantLookup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'merchantCode';
    yield serializers.serialize(
      object.merchantCode,
      specifiedType: const FullType(String),
    );
    yield r'merchantName';
    yield serializers.serialize(
      object.merchantName,
      specifiedType: const FullType(String),
    );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'acceptedCreditTypes';
    yield serializers.serialize(
      object.acceptedCreditTypes,
      specifiedType: const FullType(BuiltSet, [FullType(CreditType)]),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(MerchantCategory),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantLookup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantLookupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'merchantCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.merchantCode = valueDes;
          break;
        case r'merchantName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.merchantName = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'acceptedCreditTypes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(CreditType)]),
          ) as BuiltSet<CreditType>;
          result.acceptedCreditTypes.replace(valueDes);
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MerchantCategory),
          ) as MerchantCategory;
          result.category = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantLookup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantLookupBuilder();
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


