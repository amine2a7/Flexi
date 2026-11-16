//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type.dart';
import 'package:fp_api/src/model/dispute_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute.g.dart';

/// Dispute
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [reference] 
/// * [paymentReference] 
/// * [creditType] 
/// * [merchantName] 
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [reason] 
/// * [status] 
/// * [openedAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [openedByName] 
/// * [dueAt] - Échéance cible de la décision (15 jours).
/// * [decisionReason] 
/// * [decidedAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue(instantiable: false)
abstract class Dispute  {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'paymentReference')
  String get paymentReference;

  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  @BuiltValueField(wireName: r'merchantName')
  String get merchantName;

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'status')
  DisputeStatus get status;
  // enum statusEnum {  OPEN,  ACCEPTANCE_PENDING,  ACCEPTED,  REJECTED,  };

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'openedAt')
  DateTime get openedAt;

  @BuiltValueField(wireName: r'openedByName')
  String get openedByName;

  /// Échéance cible de la décision (15 jours).
  @BuiltValueField(wireName: r'dueAt')
  DateTime get dueAt;

  @BuiltValueField(wireName: r'decisionReason')
  String? get decisionReason;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'decidedAt')
  DateTime? get decidedAt;

  @BuiltValueSerializer(custom: true)
  static Serializer<Dispute> get serializer => _$DisputeSerializer();
}

class _$DisputeSerializer implements PrimitiveSerializer<Dispute> {
  @override
  final Iterable<Type> types = const [Dispute];

  @override
  final String wireName = r'Dispute';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Dispute object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'paymentReference';
    yield serializers.serialize(
      object.paymentReference,
      specifiedType: const FullType(String),
    );
    yield r'creditType';
    yield serializers.serialize(
      object.creditType,
      specifiedType: const FullType(CreditType),
    );
    yield r'merchantName';
    yield serializers.serialize(
      object.merchantName,
      specifiedType: const FullType(String),
    );
    yield r'amountMillimes';
    yield serializers.serialize(
      object.amountMillimes,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DisputeStatus),
    );
    yield r'openedAt';
    yield serializers.serialize(
      object.openedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'openedByName';
    yield serializers.serialize(
      object.openedByName,
      specifiedType: const FullType(String),
    );
    yield r'dueAt';
    yield serializers.serialize(
      object.dueAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'decisionReason';
    yield object.decisionReason == null ? null : serializers.serialize(
      object.decisionReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'decidedAt';
    yield object.decidedAt == null ? null : serializers.serialize(
      object.decidedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Dispute object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  Dispute deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($Dispute)) as $Dispute;
  }
}


/// a concrete implementation of [Dispute], since [Dispute] is not instantiable
@BuiltValue(instantiable: true)
abstract class $Dispute implements Dispute, Built<$Dispute, $DisputeBuilder> {
  $Dispute._();

  factory $Dispute([void Function($DisputeBuilder)? updates]) = _$$Dispute;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($DisputeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$Dispute> get serializer => _$$DisputeSerializer();
}

class _$$DisputeSerializer implements PrimitiveSerializer<$Dispute> {
  @override
  final Iterable<Type> types = const [$Dispute, _$$Dispute];

  @override
  final String wireName = r'$Dispute';

  @override
  Object serialize(
    Serializers serializers,
    $Dispute object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(Dispute))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeBuilder result,
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
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'paymentReference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentReference = valueDes;
          break;
        case r'creditType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreditType),
          ) as CreditType;
          result.creditType = valueDes;
          break;
        case r'merchantName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.merchantName = valueDes;
          break;
        case r'amountMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountMillimes = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeStatus),
          ) as DisputeStatus;
          result.status = valueDes;
          break;
        case r'openedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.openedAt = valueDes;
          break;
        case r'openedByName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.openedByName = valueDes;
          break;
        case r'dueAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dueAt = valueDes;
          break;
        case r'decisionReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.decisionReason = valueDes;
          break;
        case r'decidedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.decidedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  $Dispute deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $DisputeBuilder();
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

