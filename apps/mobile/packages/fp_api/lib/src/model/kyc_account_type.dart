//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'kyc_account_type.g.dart';

class KycAccountType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MERCHANT')
  static const KycAccountType MERCHANT = _$MERCHANT;
  @BuiltValueEnumConst(wireName: r'COMPANY')
  static const KycAccountType COMPANY = _$COMPANY;

  static Serializer<KycAccountType> get serializer => _$kycAccountTypeSerializer;

  const KycAccountType._(String name): super(name);

  static BuiltSet<KycAccountType> get values => _$values;
  static KycAccountType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class KycAccountTypeMixin = Object with _$KycAccountTypeMixin;

