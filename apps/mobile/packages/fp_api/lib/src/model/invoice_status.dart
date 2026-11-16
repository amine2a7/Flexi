//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_status.g.dart';

/// Facture — Payée, À payer, Annulée (avoir).
class InvoiceStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PAID')
  static const InvoiceStatus PAID = _$PAID;
  @BuiltValueEnumConst(wireName: r'UNPAID')
  static const InvoiceStatus UNPAID = _$UNPAID;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const InvoiceStatus CANCELLED = _$CANCELLED;

  static Serializer<InvoiceStatus> get serializer => _$invoiceStatusSerializer;

  const InvoiceStatus._(String name): super(name);

  static BuiltSet<InvoiceStatus> get values => _$values;
  static InvoiceStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class InvoiceStatusMixin = Object with _$InvoiceStatusMixin;

