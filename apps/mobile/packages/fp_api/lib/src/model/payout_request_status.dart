//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_request_status.g.dart';

/// Demande de virement — Demandée, Contrôlée, Envoyée, Exécutée, Rejetée.
class PayoutRequestStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUESTED')
  static const PayoutRequestStatus REQUESTED = _$REQUESTED;
  @BuiltValueEnumConst(wireName: r'CHECKED')
  static const PayoutRequestStatus CHECKED = _$CHECKED;
  @BuiltValueEnumConst(wireName: r'SENT')
  static const PayoutRequestStatus SENT = _$SENT;
  @BuiltValueEnumConst(wireName: r'EXECUTED')
  static const PayoutRequestStatus EXECUTED = _$EXECUTED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const PayoutRequestStatus REJECTED = _$REJECTED;
  @BuiltValueEnumConst(wireName: r'ON_HOLD')
  static const PayoutRequestStatus ON_HOLD = _$ON_HOLD;

  static Serializer<PayoutRequestStatus> get serializer => _$payoutRequestStatusSerializer;

  const PayoutRequestStatus._(String name): super(name);

  static BuiltSet<PayoutRequestStatus> get values => _$values;
  static PayoutRequestStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PayoutRequestStatusMixin = Object with _$PayoutRequestStatusMixin;

