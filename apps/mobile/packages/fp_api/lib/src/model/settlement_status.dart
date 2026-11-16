//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'settlement_status.g.dart';

/// Règlement J+2 — Prévu, Payé (provisoire).
class SettlementStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const SettlementStatus SCHEDULED = _$SCHEDULED;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const SettlementStatus PAID = _$PAID;

  static Serializer<SettlementStatus> get serializer => _$settlementStatusSerializer;

  const SettlementStatus._(String name): super(name);

  static BuiltSet<SettlementStatus> get values => _$values;
  static SettlementStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SettlementStatusMixin = Object with _$SettlementStatusMixin;

