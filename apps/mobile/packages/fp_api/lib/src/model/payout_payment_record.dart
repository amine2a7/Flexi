//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_payment_record.g.dart';

/// Montant différent du net à virer → `reason` obligatoire (400 REQUIRED sur /reason, `params.expectedMillimes`).
///
/// Properties:
/// * [bankReference] 
/// * [paidOn] - Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [reason] 
@BuiltValue()
abstract class PayoutPaymentRecord implements Built<PayoutPaymentRecord, PayoutPaymentRecordBuilder> {
  @BuiltValueField(wireName: r'bankReference')
  String get bankReference;

  /// Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
  @BuiltValueField(wireName: r'paidOn')
  Date get paidOn;

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  PayoutPaymentRecord._();

  factory PayoutPaymentRecord([void updates(PayoutPaymentRecordBuilder b)]) = _$PayoutPaymentRecord;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutPaymentRecordBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutPaymentRecord> get serializer => _$PayoutPaymentRecordSerializer();
}

class _$PayoutPaymentRecordSerializer implements PrimitiveSerializer<PayoutPaymentRecord> {
  @override
  final Iterable<Type> types = const [PayoutPaymentRecord, _$PayoutPaymentRecord];

  @override
  final String wireName = r'PayoutPaymentRecord';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutPaymentRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'bankReference';
    yield serializers.serialize(
      object.bankReference,
      specifiedType: const FullType(String),
    );
    yield r'paidOn';
    yield serializers.serialize(
      object.paidOn,
      specifiedType: const FullType(Date),
    );
    yield r'amountMillimes';
    yield serializers.serialize(
      object.amountMillimes,
      specifiedType: const FullType(int),
    );
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
    PayoutPaymentRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutPaymentRecordBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bankReference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bankReference = valueDes;
          break;
        case r'paidOn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.paidOn = valueDes;
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
  PayoutPaymentRecord deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutPaymentRecordBuilder();
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


