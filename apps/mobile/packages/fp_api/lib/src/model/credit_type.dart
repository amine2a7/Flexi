//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credit_type.g.dart';

/// Type de crédit (décision du 2026-10-13) : Restauration, Habillement, Carburant, Cadeaux. Chaque compte (entreprise, bénéficiaire) a un **solde séparé par type** ; un total n'est donné qu'à titre d'information. **Aucun transfert ni paiement entre types** : un paiement débite le solde du type accepté par le commerçant, sinon `422 INSUFFICIENT_FUNDS`. 
class CreditType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RESTAURATION')
  static const CreditType RESTAURATION = _$RESTAURATION;
  @BuiltValueEnumConst(wireName: r'HABILLEMENT')
  static const CreditType HABILLEMENT = _$HABILLEMENT;
  @BuiltValueEnumConst(wireName: r'CARBURANT')
  static const CreditType CARBURANT = _$CARBURANT;
  @BuiltValueEnumConst(wireName: r'CADEAUX')
  static const CreditType CADEAUX = _$CADEAUX;

  static Serializer<CreditType> get serializer => _$creditTypeSerializer;

  const CreditType._(String name): super(name);

  static BuiltSet<CreditType> get values => _$values;
  static CreditType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class CreditTypeMixin = Object with _$CreditTypeMixin;

