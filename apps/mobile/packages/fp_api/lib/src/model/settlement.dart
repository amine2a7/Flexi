//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/date.dart';
import 'package:fp_api/src/model/settlement_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'settlement.g.dart';

/// Settlement
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [reference] 
/// * [settlementDate] - Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
/// * [paymentsCount] 
/// * [grossMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [commissionMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [netMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [status] 
@BuiltValue()
abstract class Settlement implements Built<Settlement, SettlementBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  /// Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
  @BuiltValueField(wireName: r'settlementDate')
  Date get settlementDate;

  @BuiltValueField(wireName: r'paymentsCount')
  int get paymentsCount;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'grossMillimes')
  int get grossMillimes;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'commissionMillimes')
  int get commissionMillimes;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'netMillimes')
  int get netMillimes;

  @BuiltValueField(wireName: r'status')
  SettlementStatus get status;
  // enum statusEnum {  SCHEDULED,  PAID,  };

  Settlement._();

  factory Settlement([void updates(SettlementBuilder b)]) = _$Settlement;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettlementBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Settlement> get serializer => _$SettlementSerializer();
}

class _$SettlementSerializer implements PrimitiveSerializer<Settlement> {
  @override
  final Iterable<Type> types = const [Settlement, _$Settlement];

  @override
  final String wireName = r'Settlement';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Settlement object, {
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
    yield r'paymentsCount';
    yield serializers.serialize(
      object.paymentsCount,
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
    yield r'netMillimes';
    yield serializers.serialize(
      object.netMillimes,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SettlementStatus),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Settlement object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SettlementBuilder result,
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
        case r'paymentsCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentsCount = valueDes;
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
            specifiedType: const FullType(SettlementStatus),
          ) as SettlementStatus;
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
  Settlement deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettlementBuilder();
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


