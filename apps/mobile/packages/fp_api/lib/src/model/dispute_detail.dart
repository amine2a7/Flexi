//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/dispute.dart';
import 'package:fp_api/src/model/dispute_note.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:fp_api/src/model/dispute_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_detail.g.dart';

/// DisputeDetail
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
/// * [notes] 
@BuiltValue()
abstract class DisputeDetail implements Dispute, Built<DisputeDetail, DisputeDetailBuilder> {
  @BuiltValueField(wireName: r'notes')
  BuiltList<DisputeNote> get notes;

  DisputeDetail._();

  factory DisputeDetail([void updates(DisputeDetailBuilder b)]) = _$DisputeDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeDetail> get serializer => _$DisputeDetailSerializer();
}

class _$DisputeDetailSerializer implements PrimitiveSerializer<DisputeDetail> {
  @override
  final Iterable<Type> types = const [DisputeDetail, _$DisputeDetail];

  @override
  final String wireName = r'DisputeDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'openedByName';
    yield serializers.serialize(
      object.openedByName,
      specifiedType: const FullType(String),
    );
    yield r'notes';
    yield serializers.serialize(
      object.notes,
      specifiedType: const FullType(BuiltList, [FullType(DisputeNote)]),
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
    yield r'openedAt';
    yield serializers.serialize(
      object.openedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'dueAt';
    yield serializers.serialize(
      object.dueAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'decidedAt';
    yield object.decidedAt == null ? null : serializers.serialize(
      object.decidedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'decisionReason';
    yield object.decisionReason == null ? null : serializers.serialize(
      object.decisionReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DisputeStatus),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'openedByName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.openedByName = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeNote)]),
          ) as BuiltList<DisputeNote>;
          result.notes.replace(valueDes);
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
        case r'openedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.openedAt = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'dueAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dueAt = valueDes;
          break;
        case r'decidedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.decidedAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'decisionReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.decisionReason = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeStatus),
          ) as DisputeStatus;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeDetailBuilder();
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


