//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/date.dart';
import 'package:fp_api/src/model/settlement_batch_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'settlement_batch.g.dart';

/// SettlementBatch
///
/// Properties:
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
@BuiltValue()
abstract class SettlementBatch implements Built<SettlementBatch, SettlementBatchBuilder> {
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

  SettlementBatch._();

  factory SettlementBatch([void updates(SettlementBatchBuilder b)]) = _$SettlementBatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettlementBatchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettlementBatch> get serializer => _$SettlementBatchSerializer();
}

class _$SettlementBatchSerializer implements PrimitiveSerializer<SettlementBatch> {
  @override
  final Iterable<Type> types = const [SettlementBatch, _$SettlementBatch];

  @override
  final String wireName = r'SettlementBatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettlementBatch object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    SettlementBatch object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SettlementBatchBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SettlementBatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettlementBatchBuilder();
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


