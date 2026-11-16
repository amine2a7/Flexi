//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credit_order_event_action.g.dart';

class CreditOrderEventAction extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CREATED')
  static const CreditOrderEventAction CREATED = _$CREATED;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const CreditOrderEventAction CONFIRMED = _$CONFIRMED;
  @BuiltValueEnumConst(wireName: r'REFUSED')
  static const CreditOrderEventAction REFUSED = _$REFUSED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CreditOrderEventAction CANCELLED = _$CANCELLED;
  @BuiltValueEnumConst(wireName: r'TRANSFER_DECLARED')
  static const CreditOrderEventAction TRANSFER_DECLARED = _$TRANSFER_DECLARED;
  @BuiltValueEnumConst(wireName: r'PROOF_REJECTED')
  static const CreditOrderEventAction PROOF_REJECTED = _$PROOF_REJECTED;
  @BuiltValueEnumConst(wireName: r'FIRST_VALIDATION')
  static const CreditOrderEventAction FIRST_VALIDATION = _$FIRST_VALIDATION;
  @BuiltValueEnumConst(wireName: r'VALIDATED')
  static const CreditOrderEventAction VALIDATED = _$VALIDATED;

  static Serializer<CreditOrderEventAction> get serializer => _$creditOrderEventActionSerializer;

  const CreditOrderEventAction._(String name): super(name);

  static BuiltSet<CreditOrderEventAction> get values => _$values;
  static CreditOrderEventAction valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class CreditOrderEventActionMixin = Object with _$CreditOrderEventActionMixin;

