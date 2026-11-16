//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fraud_alert_status.g.dart';

/// Alerte antifraude — Ouverte, En cours, Close (clôture motivée et journalisée, DP n° 14).
class FraudAlertStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const FraudAlertStatus OPEN = _$OPEN;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const FraudAlertStatus IN_PROGRESS = _$IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const FraudAlertStatus CLOSED = _$CLOSED;

  static Serializer<FraudAlertStatus> get serializer => _$fraudAlertStatusSerializer;

  const FraudAlertStatus._(String name): super(name);

  static BuiltSet<FraudAlertStatus> get values => _$values;
  static FraudAlertStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class FraudAlertStatusMixin = Object with _$FraudAlertStatusMixin;

