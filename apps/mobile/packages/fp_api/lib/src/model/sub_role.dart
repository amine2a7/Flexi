//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sub_role.g.dart';

/// Sous-rôle (spec 01 §2, cahier ENT-10, spec 07 §2). ADMIN : `SUPER_ADMIN`, `FINANCE`, `SUPPORT`, `COMPLIANCE`. COMPANY (2026-11-14) : `OWNER` (Propriétaire), `MANAGER` (RH), `FINANCE` (Finance). MERCHANT : `OWNER` (Propriétaire), `CASHIER` (Caissier). `ACCOUNTANT` et `READ_ONLY` sont d'anciens sous-rôles, plus attribués (lecture seule). Aucun pour EMPLOYEE et FAMILY_MEMBER. Liste extensible. Le client ne déduit **aucun droit** du sous-rôle : il utilise `permissions`. 
class SubRole extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SUPER_ADMIN')
  static const SubRole SUPER_ADMIN = _$SUPER_ADMIN;
  @BuiltValueEnumConst(wireName: r'FINANCE')
  static const SubRole FINANCE = _$FINANCE;
  @BuiltValueEnumConst(wireName: r'SUPPORT')
  static const SubRole SUPPORT = _$SUPPORT;
  @BuiltValueEnumConst(wireName: r'COMPLIANCE')
  static const SubRole COMPLIANCE = _$COMPLIANCE;
  @BuiltValueEnumConst(wireName: r'OWNER')
  static const SubRole OWNER = _$OWNER;
  @BuiltValueEnumConst(wireName: r'MANAGER')
  static const SubRole MANAGER = _$MANAGER;
  @BuiltValueEnumConst(wireName: r'ACCOUNTANT')
  static const SubRole ACCOUNTANT = _$ACCOUNTANT;
  @BuiltValueEnumConst(wireName: r'READ_ONLY')
  static const SubRole READ_ONLY = _$READ_ONLY;
  @BuiltValueEnumConst(wireName: r'CASHIER')
  static const SubRole CASHIER = _$CASHIER;

  static Serializer<SubRole> get serializer => _$subRoleSerializer;

  const SubRole._(String name): super(name);

  static BuiltSet<SubRole> get values => _$values;
  static SubRole valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SubRoleMixin = Object with _$SubRoleMixin;

