//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'settlement_batch_status.g.dart';

/// Lot de règlement (tâche 9) : prévu ; libéré par Finance en double validation ; ordre envoyé à la banque ; payé (retour de la banque rapproché). 
class SettlementBatchStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const SettlementBatchStatus SCHEDULED = _$SCHEDULED;
  @BuiltValueEnumConst(wireName: r'RELEASED')
  static const SettlementBatchStatus RELEASED = _$RELEASED;
  @BuiltValueEnumConst(wireName: r'SENT')
  static const SettlementBatchStatus SENT = _$SENT;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const SettlementBatchStatus PAID = _$PAID;

  static Serializer<SettlementBatchStatus> get serializer => _$settlementBatchStatusSerializer;

  const SettlementBatchStatus._(String name): super(name);

  static BuiltSet<SettlementBatchStatus> get values => _$values;
  static SettlementBatchStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SettlementBatchStatusMixin = Object with _$SettlementBatchStatusMixin;

