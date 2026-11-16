//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'limit_type.g.dart';

/// Plafond atteint (RG-4, spec 02 §5). Liste extensible.
class LimitType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TRANSACTION')
  static const LimitType TRANSACTION = _$TRANSACTION;
  @BuiltValueEnumConst(wireName: r'DAILY')
  static const LimitType DAILY = _$DAILY;
  @BuiltValueEnumConst(wireName: r'MONTHLY')
  static const LimitType MONTHLY = _$MONTHLY;
  @BuiltValueEnumConst(wireName: r'FAMILY_MEMBER')
  static const LimitType FAMILY_MEMBER = _$FAMILY_MEMBER;

  static Serializer<LimitType> get serializer => _$limitTypeSerializer;

  const LimitType._(String name): super(name);

  static BuiltSet<LimitType> get values => _$values;
  static LimitType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class LimitTypeMixin = Object with _$LimitTypeMixin;

