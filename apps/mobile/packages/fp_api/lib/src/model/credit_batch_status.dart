//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credit_batch_status.g.dart';

/// Lot de crédits — Actif, Expiré (glossaire, DP n° 14). Calculé par le serveur en `Africa/Tunis` (E10) ; le client ne compare jamais une date d'expiration à l'heure locale. 
class CreditBatchStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const CreditBatchStatus ACTIVE = _$ACTIVE;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const CreditBatchStatus EXPIRED = _$EXPIRED;

  static Serializer<CreditBatchStatus> get serializer => _$creditBatchStatusSerializer;

  const CreditBatchStatus._(String name): super(name);

  static BuiltSet<CreditBatchStatus> get values => _$values;
  static CreditBatchStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class CreditBatchStatusMixin = Object with _$CreditBatchStatusMixin;

