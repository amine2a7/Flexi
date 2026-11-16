//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/payout_request_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_event.g.dart';

/// Passage de la demande à un statut ; le motif accompagne un rejet.
///
/// Properties:
/// * [status] 
/// * [occurredAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [reasonKey] - Clé i18n d'un motif de rejet automatique.
/// * [reason] - Motif saisi par l'administrateur qui a refusé la demande.
@BuiltValue()
abstract class PayoutEvent implements Built<PayoutEvent, PayoutEventBuilder> {
  @BuiltValueField(wireName: r'status')
  PayoutRequestStatus get status;
  // enum statusEnum {  REQUESTED,  CHECKED,  SENT,  EXECUTED,  REJECTED,  ON_HOLD,  };

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'occurredAt')
  DateTime get occurredAt;

  /// Clé i18n d'un motif de rejet automatique.
  @BuiltValueField(wireName: r'reasonKey')
  String? get reasonKey;

  /// Motif saisi par l'administrateur qui a refusé la demande.
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  PayoutEvent._();

  factory PayoutEvent([void updates(PayoutEventBuilder b)]) = _$PayoutEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutEventBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutEvent> get serializer => _$PayoutEventSerializer();
}

class _$PayoutEventSerializer implements PrimitiveSerializer<PayoutEvent> {
  @override
  final Iterable<Type> types = const [PayoutEvent, _$PayoutEvent];

  @override
  final String wireName = r'PayoutEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PayoutRequestStatus),
    );
    yield r'occurredAt';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.reasonKey != null) {
      yield r'reasonKey';
      yield serializers.serialize(
        object.reasonKey,
        specifiedType: const FullType(String),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PayoutEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PayoutRequestStatus),
          ) as PayoutRequestStatus;
          result.status = valueDes;
          break;
        case r'occurredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        case r'reasonKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reasonKey = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PayoutEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutEventBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


