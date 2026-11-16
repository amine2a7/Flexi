//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'expired_credits_destination.g.dart';

/// Destination du reste des lots de crédits expirés (décision du 2026-10-14, provisoire en attendant l'avis d'un comptable) : `PLATFORM_REVENUE` = compte `REVENUE_EXPIRED` de FlexiPay ; `COMPANY_RETURN` = retour au solde de l'entreprise, sur le même type de crédit. Modifiée comme tout paramétrage (double validation). 
class ExpiredCreditsDestination extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PLATFORM_REVENUE')
  static const ExpiredCreditsDestination PLATFORM_REVENUE = _$PLATFORM_REVENUE;
  @BuiltValueEnumConst(wireName: r'COMPANY_RETURN')
  static const ExpiredCreditsDestination COMPANY_RETURN = _$COMPANY_RETURN;

  static Serializer<ExpiredCreditsDestination> get serializer => _$expiredCreditsDestinationSerializer;

  const ExpiredCreditsDestination._(String name): super(name);

  static BuiltSet<ExpiredCreditsDestination> get values => _$values;
  static ExpiredCreditsDestination valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ExpiredCreditsDestinationMixin = Object with _$ExpiredCreditsDestinationMixin;

