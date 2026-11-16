//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_status.g.dart';

/// Litige — ouvert (montant mis en réserve), acceptation en attente de la seconde validation Finance, accepté (remboursé), rejeté (règlement normal).
class DisputeStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const DisputeStatus OPEN = _$OPEN;
  @BuiltValueEnumConst(wireName: r'ACCEPTANCE_PENDING')
  static const DisputeStatus ACCEPTANCE_PENDING = _$ACCEPTANCE_PENDING;
  @BuiltValueEnumConst(wireName: r'ACCEPTED')
  static const DisputeStatus ACCEPTED = _$ACCEPTED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const DisputeStatus REJECTED = _$REJECTED;

  static Serializer<DisputeStatus> get serializer => _$disputeStatusSerializer;

  const DisputeStatus._(String name): super(name);

  static BuiltSet<DisputeStatus> get values => _$values;
  static DisputeStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class DisputeStatusMixin = Object with _$DisputeStatusMixin;

