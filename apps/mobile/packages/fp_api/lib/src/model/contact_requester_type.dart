//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_requester_type.g.dart';

/// Entreprise intéressée, commerçant intéressé, autre demande.
class ContactRequesterType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COMPANY')
  static const ContactRequesterType COMPANY = _$COMPANY;
  @BuiltValueEnumConst(wireName: r'MERCHANT')
  static const ContactRequesterType MERCHANT = _$MERCHANT;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const ContactRequesterType OTHER = _$OTHER;

  static Serializer<ContactRequesterType> get serializer => _$contactRequesterTypeSerializer;

  const ContactRequesterType._(String name): super(name);

  static BuiltSet<ContactRequesterType> get values => _$values;
  static ContactRequesterType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ContactRequesterTypeMixin = Object with _$ContactRequesterTypeMixin;

