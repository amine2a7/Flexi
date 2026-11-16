// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_category.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantCategory _$RESTAURANT = const MerchantCategory._('RESTAURANT');
const MerchantCategory _$CAFE = const MerchantCategory._('CAFE');
const MerchantCategory _$GROCERY = const MerchantCategory._('GROCERY');
const MerchantCategory _$BAKERY = const MerchantCategory._('BAKERY');
const MerchantCategory _$FAST_FOOD = const MerchantCategory._('FAST_FOOD');
const MerchantCategory _$CLOTHING = const MerchantCategory._('CLOTHING');
const MerchantCategory _$FUEL_STATION = const MerchantCategory._(
  'FUEL_STATION',
);
const MerchantCategory _$GIFT_SHOP = const MerchantCategory._('GIFT_SHOP');

MerchantCategory _$valueOf(String name) {
  switch (name) {
    case 'RESTAURANT':
      return _$RESTAURANT;
    case 'CAFE':
      return _$CAFE;
    case 'GROCERY':
      return _$GROCERY;
    case 'BAKERY':
      return _$BAKERY;
    case 'FAST_FOOD':
      return _$FAST_FOOD;
    case 'CLOTHING':
      return _$CLOTHING;
    case 'FUEL_STATION':
      return _$FUEL_STATION;
    case 'GIFT_SHOP':
      return _$GIFT_SHOP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantCategory> _$values = BuiltSet<MerchantCategory>(
  const <MerchantCategory>[
    _$RESTAURANT,
    _$CAFE,
    _$GROCERY,
    _$BAKERY,
    _$FAST_FOOD,
    _$CLOTHING,
    _$FUEL_STATION,
    _$GIFT_SHOP,
  ],
);

class _$MerchantCategoryMeta {
  const _$MerchantCategoryMeta();
  MerchantCategory get RESTAURANT => _$RESTAURANT;
  MerchantCategory get CAFE => _$CAFE;
  MerchantCategory get GROCERY => _$GROCERY;
  MerchantCategory get BAKERY => _$BAKERY;
  MerchantCategory get FAST_FOOD => _$FAST_FOOD;
  MerchantCategory get CLOTHING => _$CLOTHING;
  MerchantCategory get FUEL_STATION => _$FUEL_STATION;
  MerchantCategory get GIFT_SHOP => _$GIFT_SHOP;
  MerchantCategory valueOf(String name) => _$valueOf(name);
  BuiltSet<MerchantCategory> get values => _$values;
}

mixin _$MerchantCategoryMixin {
  // ignore: non_constant_identifier_names
  _$MerchantCategoryMeta get MerchantCategory => const _$MerchantCategoryMeta();
}

Serializer<MerchantCategory> _$merchantCategorySerializer =
    _$MerchantCategorySerializer();

class _$MerchantCategorySerializer
    implements PrimitiveSerializer<MerchantCategory> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RESTAURANT': 'RESTAURANT',
    'CAFE': 'CAFE',
    'GROCERY': 'GROCERY',
    'BAKERY': 'BAKERY',
    'FAST_FOOD': 'FAST_FOOD',
    'CLOTHING': 'CLOTHING',
    'FUEL_STATION': 'FUEL_STATION',
    'GIFT_SHOP': 'GIFT_SHOP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RESTAURANT': 'RESTAURANT',
    'CAFE': 'CAFE',
    'GROCERY': 'GROCERY',
    'BAKERY': 'BAKERY',
    'FAST_FOOD': 'FAST_FOOD',
    'CLOTHING': 'CLOTHING',
    'FUEL_STATION': 'FUEL_STATION',
    'GIFT_SHOP': 'GIFT_SHOP',
  };

  @override
  final Iterable<Type> types = const <Type>[MerchantCategory];
  @override
  final String wireName = 'MerchantCategory';

  @override
  Object serialize(
    Serializers serializers,
    MerchantCategory object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantCategory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantCategory.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
