//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_category.g.dart';

/// Activité du commerce (distincte des types de crédit acceptés, voir acceptedCreditTypes).
class MerchantCategory extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RESTAURANT')
  static const MerchantCategory RESTAURANT = _$RESTAURANT;
  @BuiltValueEnumConst(wireName: r'CAFE')
  static const MerchantCategory CAFE = _$CAFE;
  @BuiltValueEnumConst(wireName: r'GROCERY')
  static const MerchantCategory GROCERY = _$GROCERY;
  @BuiltValueEnumConst(wireName: r'BAKERY')
  static const MerchantCategory BAKERY = _$BAKERY;
  @BuiltValueEnumConst(wireName: r'FAST_FOOD')
  static const MerchantCategory FAST_FOOD = _$FAST_FOOD;
  @BuiltValueEnumConst(wireName: r'CLOTHING')
  static const MerchantCategory CLOTHING = _$CLOTHING;
  @BuiltValueEnumConst(wireName: r'FUEL_STATION')
  static const MerchantCategory FUEL_STATION = _$FUEL_STATION;
  @BuiltValueEnumConst(wireName: r'GIFT_SHOP')
  static const MerchantCategory GIFT_SHOP = _$GIFT_SHOP;

  static Serializer<MerchantCategory> get serializer => _$merchantCategorySerializer;

  const MerchantCategory._(String name): super(name);

  static BuiltSet<MerchantCategory> get values => _$values;
  static MerchantCategory valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class MerchantCategoryMixin = Object with _$MerchantCategoryMixin;

