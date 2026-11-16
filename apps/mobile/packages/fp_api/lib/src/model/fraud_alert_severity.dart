//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fraud_alert_severity.g.dart';

class FraudAlertSeverity extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HIGH')
  static const FraudAlertSeverity HIGH = _$HIGH;
  @BuiltValueEnumConst(wireName: r'MEDIUM')
  static const FraudAlertSeverity MEDIUM = _$MEDIUM;
  @BuiltValueEnumConst(wireName: r'LOW')
  static const FraudAlertSeverity LOW = _$LOW;

  static Serializer<FraudAlertSeverity> get serializer => _$fraudAlertSeveritySerializer;

  const FraudAlertSeverity._(String name): super(name);

  static BuiltSet<FraudAlertSeverity> get values => _$values;
  static FraudAlertSeverity valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class FraudAlertSeverityMixin = Object with _$FraudAlertSeverityMixin;

