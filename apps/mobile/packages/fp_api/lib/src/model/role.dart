//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'role.g.dart';

/// Rôle de l'utilisateur (spec 01 §2). Le web sert ADMIN, COMPANY, MERCHANT et, depuis la décision du 2026-10-13, EMPLOYEE (espace Bénéficiaire, banc d'essai de l'app mobile, mêmes routes `/v1/employee/_*`). FAMILY_MEMBER reste réservé à l'application mobile. 
class Role extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const Role ADMIN = _$ADMIN;
  @BuiltValueEnumConst(wireName: r'COMPANY')
  static const Role COMPANY = _$COMPANY;
  @BuiltValueEnumConst(wireName: r'MERCHANT')
  static const Role MERCHANT = _$MERCHANT;
  @BuiltValueEnumConst(wireName: r'EMPLOYEE')
  static const Role EMPLOYEE = _$EMPLOYEE;
  @BuiltValueEnumConst(wireName: r'FAMILY_MEMBER')
  static const Role FAMILY_MEMBER = _$FAMILY_MEMBER;

  static Serializer<Role> get serializer => _$roleSerializer;

  const Role._(String name): super(name);

  static BuiltSet<Role> get values => _$values;
  static Role valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class RoleMixin = Object with _$RoleMixin;

