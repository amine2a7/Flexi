//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/fraud_alert_status.dart';
import 'package:fp_api/src/model/fraud_alert_kind.dart';
import 'package:fp_api/src/model/fraud_alert_severity.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fraud_alert.g.dart';

/// FraudAlert
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [kind] 
/// * [severity] 
/// * [subject] - Compte ou commerçant concerné (nom affiché, jamais de donnée sensible).
/// * [occurredAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [status] 
/// * [handledByName] - Personne qui traite ou a fermé l'alerte.
/// * [closeReason] 
@BuiltValue()
abstract class FraudAlert implements Built<FraudAlert, FraudAlertBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  FraudAlertKind get kind;
  // enum kindEnum {  REPEATED_REFUSALS,  MERCHANT_BURST,  NEAR_DAILY_LIMIT,  RIB_CHANGE_PAYOUT,  NEW_DEVICE_PAYMENT,  COMMISSION_GRID_MISSING,  LEDGER_MISMATCH,  };

  @BuiltValueField(wireName: r'severity')
  FraudAlertSeverity get severity;
  // enum severityEnum {  HIGH,  MEDIUM,  LOW,  };

  /// Compte ou commerçant concerné (nom affiché, jamais de donnée sensible).
  @BuiltValueField(wireName: r'subject')
  String get subject;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'occurredAt')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'status')
  FraudAlertStatus get status;
  // enum statusEnum {  OPEN,  IN_PROGRESS,  CLOSED,  };

  /// Personne qui traite ou a fermé l'alerte.
  @BuiltValueField(wireName: r'handledByName')
  String? get handledByName;

  @BuiltValueField(wireName: r'closeReason')
  String? get closeReason;

  FraudAlert._();

  factory FraudAlert([void updates(FraudAlertBuilder b)]) = _$FraudAlert;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FraudAlertBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FraudAlert> get serializer => _$FraudAlertSerializer();
}

class _$FraudAlertSerializer implements PrimitiveSerializer<FraudAlert> {
  @override
  final Iterable<Type> types = const [FraudAlert, _$FraudAlert];

  @override
  final String wireName = r'FraudAlert';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FraudAlert object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(FraudAlertKind),
    );
    yield r'severity';
    yield serializers.serialize(
      object.severity,
      specifiedType: const FullType(FraudAlertSeverity),
    );
    yield r'subject';
    yield serializers.serialize(
      object.subject,
      specifiedType: const FullType(String),
    );
    yield r'occurredAt';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(FraudAlertStatus),
    );
    yield r'handledByName';
    yield object.handledByName == null ? null : serializers.serialize(
      object.handledByName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'closeReason';
    yield object.closeReason == null ? null : serializers.serialize(
      object.closeReason,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FraudAlert object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FraudAlertBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FraudAlertKind),
          ) as FraudAlertKind;
          result.kind = valueDes;
          break;
        case r'severity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FraudAlertSeverity),
          ) as FraudAlertSeverity;
          result.severity = valueDes;
          break;
        case r'subject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subject = valueDes;
          break;
        case r'occurredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FraudAlertStatus),
          ) as FraudAlertStatus;
          result.status = valueDes;
          break;
        case r'handledByName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.handledByName = valueDes;
          break;
        case r'closeReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.closeReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FraudAlert deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FraudAlertBuilder();
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


