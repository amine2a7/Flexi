//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_payment.g.dart';

/// Paiement enregistré par Finance (virement fait depuis la banque de FlexiPay, hors plateforme).
///
/// Properties:
/// * [bankReference] 
/// * [paidOn] - Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
/// * [amountMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [note] - Motif saisi quand le montant n'est pas le net.
@BuiltValue()
abstract class PayoutPayment implements Built<PayoutPayment, PayoutPaymentBuilder> {
  @BuiltValueField(wireName: r'bankReference')
  String get bankReference;

  /// Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
  @BuiltValueField(wireName: r'paidOn')
  Date get paidOn;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  /// Motif saisi quand le montant n'est pas le net.
  @BuiltValueField(wireName: r'note')
  String? get note;

  PayoutPayment._();

  factory PayoutPayment([void updates(PayoutPaymentBuilder b)]) = _$PayoutPayment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutPaymentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutPayment> get serializer => _$PayoutPaymentSerializer();
}

class _$PayoutPaymentSerializer implements PrimitiveSerializer<PayoutPayment> {
  @override
  final Iterable<Type> types = const [PayoutPayment, _$PayoutPayment];

  @override
  final String wireName = r'PayoutPayment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutPayment object, {
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
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PayoutPayment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutPaymentBuilder result,
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
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PayoutPayment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutPaymentBuilder();
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


