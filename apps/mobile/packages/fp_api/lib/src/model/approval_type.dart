//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'approval_type.g.dart';

/// Opération sensible soumise à double validation (règle 12).
class ApprovalType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COMMISSION_RATE_CHANGE')
  static const ApprovalType COMMISSION_RATE_CHANGE = _$COMMISSION_RATE_CHANGE;
  @BuiltValueEnumConst(wireName: r'SETTINGS_CHANGE')
  static const ApprovalType SETTINGS_CHANGE = _$SETTINGS_CHANGE;
  @BuiltValueEnumConst(wireName: r'DISPUTE_REFUND')
  static const ApprovalType DISPUTE_REFUND = _$DISPUTE_REFUND;
  @BuiltValueEnumConst(wireName: r'COMMISSION_GRID_CHANGE')
  static const ApprovalType COMMISSION_GRID_CHANGE = _$COMMISSION_GRID_CHANGE;
  @BuiltValueEnumConst(wireName: r'IBAN_CHANGE')
  static const ApprovalType IBAN_CHANGE = _$IBAN_CHANGE;
  @BuiltValueEnumConst(wireName: r'BATCH_RELEASE')
  static const ApprovalType BATCH_RELEASE = _$BATCH_RELEASE;
  @BuiltValueEnumConst(wireName: r'LEGAL_FORM_CHANGE')
  static const ApprovalType LEGAL_FORM_CHANGE = _$LEGAL_FORM_CHANGE;

  static Serializer<ApprovalType> get serializer => _$approvalTypeSerializer;

  const ApprovalType._(String name): super(name);

  static BuiltSet<ApprovalType> get values => _$values;
  static ApprovalType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ApprovalTypeMixin = Object with _$ApprovalTypeMixin;

