//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'family_relationship.g.dart';

/// Lien avec le bénéficiaire — conjoint, enfant, parent.
class FamilyRelationship extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SPOUSE')
  static const FamilyRelationship SPOUSE = _$SPOUSE;
  @BuiltValueEnumConst(wireName: r'CHILD')
  static const FamilyRelationship CHILD = _$CHILD;
  @BuiltValueEnumConst(wireName: r'PARENT')
  static const FamilyRelationship PARENT = _$PARENT;

  static Serializer<FamilyRelationship> get serializer => _$familyRelationshipSerializer;

  const FamilyRelationship._(String name): super(name);

  static BuiltSet<FamilyRelationship> get values => _$values;
  static FamilyRelationship valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class FamilyRelationshipMixin = Object with _$FamilyRelationshipMixin;

