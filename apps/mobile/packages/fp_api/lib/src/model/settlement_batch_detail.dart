//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/date.dart';
import 'package:fp_api/src/model/settlement_batch_status.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/admin_payout_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'settlement_batch_detail.g.dart';

/// SettlementBatchDetail
///
/// Properties:
/// * [paidOn] - Date du virement bancaire du lot, enregistrée par Finance.
/// * [id] - Identifiant opaque de ressource.
/// * [reference] 
/// * [settlementDate] - Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
/// * [merchantsCount] 
/// * [grossMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [commissionMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [vatMillimes] - TVA retenue sur les virements du lot.
/// * [stampDutyMillimes] - Timbres retenus sur les virements du lot.
/// * [netMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [status] 
/// * [releasedAt] - Libéré par Finance en double validation (`null` avant).
/// * [sentAt] - Ordre transmis à la banque (simulée).
/// * [bankReference] - Référence de l'ordre à la banque, après son retour.
/// * [payouts] - Virements validés qui composent le lot (sommes égales aux totaux du lot).
@BuiltValue()
abstract class SettlementBatchDetail implements Built<SettlementBatchDetail, SettlementBatchDetailBuilder> {
  /// Date du virement bancaire du lot, enregistrée par Finance.
  @BuiltValueField(wireName: r'paidOn')
  Date? get paidOn;

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  /// Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
  @BuiltValueField(wireName: r'settlementDate')
  Date get settlementDate;

  @BuiltValueField(wireName: r'merchantsCount')
  int get merchantsCount;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'grossMillimes')
  int get grossMillimes;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'commissionMillimes')
  int get commissionMillimes;

  /// TVA retenue sur les virements du lot.
  @BuiltValueField(wireName: r'vatMillimes')
  int get vatMillimes;

  /// Timbres retenus sur les virements du lot.
  @BuiltValueField(wireName: r'stampDutyMillimes')
  int get stampDutyMillimes;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'netMillimes')
  int get netMillimes;

  @BuiltValueField(wireName: r'status')
  SettlementBatchStatus get status;
  // enum statusEnum {  SCHEDULED,  RELEASED,  SENT,  PAID,  };

  /// Libéré par Finance en double validation (`null` avant).
  @BuiltValueField(wireName: r'releasedAt')
  DateTime? get releasedAt;

  /// Ordre transmis à la banque (simulée).
  @BuiltValueField(wireName: r'sentAt')
  DateTime? get sentAt;

  /// Référence de l'ordre à la banque, après son retour.
  @BuiltValueField(wireName: r'bankReference')
  String? get bankReference;

  /// Virements validés qui composent le lot (sommes égales aux totaux du lot).
  @BuiltValueField(wireName: r'payouts')
  BuiltList<AdminPayoutRequest> get payouts;

  SettlementBatchDetail._();

  factory SettlementBatchDetail([void updates(SettlementBatchDetailBuilder b)]) = _$SettlementBatchDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettlementBatchDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettlementBatchDetail> get serializer => _$SettlementBatchDetailSerializer();
}

class _$SettlementBatchDetailSerializer implements PrimitiveSerializer<SettlementBatchDetail> {
  @override
  final Iterable<Type> types = const [SettlementBatchDetail, _$SettlementBatchDetail];

  @override
  final String wireName = r'SettlementBatchDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettlementBatchDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.paidOn != null) {
      yield r'paidOn';
      yield serializers.serialize(
        object.paidOn,
        specifiedType: const FullType(Date),
      );
    }
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
    yield r'settlementDate';
    yield serializers.serialize(
      object.settlementDate,
      specifiedType: const FullType(Date),
    );
    yield r'merchantsCount';
    yield serializers.serialize(
      object.merchantsCount,
      specifiedType: const FullType(int),
    );
    yield r'grossMillimes';
    yield serializers.serialize(
      object.grossMillimes,
      specifiedType: const FullType(int),
    );
    yield r'commissionMillimes';
    yield serializers.serialize(
      object.commissionMillimes,
      specifiedType: const FullType(int),
    );
    yield r'vatMillimes';
    yield serializers.serialize(
      object.vatMillimes,
      specifiedType: const FullType(int),
    );
    yield r'stampDutyMillimes';
    yield serializers.serialize(
      object.stampDutyMillimes,
      specifiedType: const FullType(int),
    );
    yield r'netMillimes';
    yield serializers.serialize(
      object.netMillimes,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SettlementBatchStatus),
    );
    yield r'releasedAt';
    yield object.releasedAt == null ? null : serializers.serialize(
      object.releasedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'sentAt';
    yield object.sentAt == null ? null : serializers.serialize(
      object.sentAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'bankReference';
    yield object.bankReference == null ? null : serializers.serialize(
      object.bankReference,
      specifiedType: const FullType.nullable(String),
    );
    yield r'payouts';
    yield serializers.serialize(
      object.payouts,
      specifiedType: const FullType(BuiltList, [FullType(AdminPayoutRequest)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SettlementBatchDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SettlementBatchDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'paidOn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.paidOn = valueDes;
          break;
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
        case r'settlementDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.settlementDate = valueDes;
          break;
        case r'merchantsCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.merchantsCount = valueDes;
          break;
        case r'grossMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.grossMillimes = valueDes;
          break;
        case r'commissionMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commissionMillimes = valueDes;
          break;
        case r'vatMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vatMillimes = valueDes;
          break;
        case r'stampDutyMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stampDutyMillimes = valueDes;
          break;
        case r'netMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.netMillimes = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SettlementBatchStatus),
          ) as SettlementBatchStatus;
          result.status = valueDes;
          break;
        case r'releasedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.releasedAt = valueDes;
          break;
        case r'sentAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.sentAt = valueDes;
          break;
        case r'bankReference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bankReference = valueDes;
          break;
        case r'payouts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPayoutRequest)]),
          ) as BuiltList<AdminPayoutRequest>;
          result.payouts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SettlementBatchDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettlementBatchDetailBuilder();
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


