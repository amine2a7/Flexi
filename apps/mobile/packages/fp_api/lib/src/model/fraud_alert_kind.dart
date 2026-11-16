//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fraud_alert_kind.g.dart';

class FraudAlertKind extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REPEATED_REFUSALS')
  static const FraudAlertKind REPEATED_REFUSALS = _$REPEATED_REFUSALS;
  @BuiltValueEnumConst(wireName: r'MERCHANT_BURST')
  static const FraudAlertKind MERCHANT_BURST = _$MERCHANT_BURST;
  @BuiltValueEnumConst(wireName: r'NEAR_DAILY_LIMIT')
  static const FraudAlertKind NEAR_DAILY_LIMIT = _$NEAR_DAILY_LIMIT;
  @BuiltValueEnumConst(wireName: r'RIB_CHANGE_PAYOUT')
  static const FraudAlertKind RIB_CHANGE_PAYOUT = _$RIB_CHANGE_PAYOUT;
  @BuiltValueEnumConst(wireName: r'NEW_DEVICE_PAYMENT')
  static const FraudAlertKind NEW_DEVICE_PAYMENT = _$NEW_DEVICE_PAYMENT;
  @BuiltValueEnumConst(wireName: r'COMMISSION_GRID_MISSING')
  static const FraudAlertKind COMMISSION_GRID_MISSING = _$COMMISSION_GRID_MISSING;
  @BuiltValueEnumConst(wireName: r'LEDGER_MISMATCH')
  static const FraudAlertKind LEDGER_MISMATCH = _$LEDGER_MISMATCH;

  static Serializer<FraudAlertKind> get serializer => _$fraudAlertKindSerializer;

  const FraudAlertKind._(String name): super(name);

  static BuiltSet<FraudAlertKind> get values => _$values;
  static FraudAlertKind valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class FraudAlertKindMixin = Object with _$FraudAlertKindMixin;

