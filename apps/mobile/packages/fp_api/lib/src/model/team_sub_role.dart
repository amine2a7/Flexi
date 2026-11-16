//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'team_sub_role.g.dart';

/// Sous-rôle d'un compte d'entreprise (`OWNER` Propriétaire, `MANAGER` RH, `FINANCE` Finance) ou de commerçant (`OWNER` Propriétaire, `CASHIER` Caissier), demande du 2026-11-14. 
class TeamSubRole extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OWNER')
  static const TeamSubRole OWNER = _$OWNER;
  @BuiltValueEnumConst(wireName: r'MANAGER')
  static const TeamSubRole MANAGER = _$MANAGER;
  @BuiltValueEnumConst(wireName: r'FINANCE')
  static const TeamSubRole FINANCE = _$FINANCE;
  @BuiltValueEnumConst(wireName: r'CASHIER')
  static const TeamSubRole CASHIER = _$CASHIER;

  static Serializer<TeamSubRole> get serializer => _$teamSubRoleSerializer;

  const TeamSubRole._(String name): super(name);

  static BuiltSet<TeamSubRole> get values => _$values;
  static TeamSubRole valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class TeamSubRoleMixin = Object with _$TeamSubRoleMixin;

