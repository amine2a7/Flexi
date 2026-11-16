//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'funding_bank_account.g.dart';

/// Compte bancaire de FlexiPay sur lequel l'entreprise vire le total de la commande.
///
/// Properties:
/// * [bankName] 
/// * [holder] 
/// * [rib] 
/// * [iban] 
@BuiltValue()
abstract class FundingBankAccount implements Built<FundingBankAccount, FundingBankAccountBuilder> {
  @BuiltValueField(wireName: r'bankName')
  String get bankName;

  @BuiltValueField(wireName: r'holder')
  String get holder;

  @BuiltValueField(wireName: r'rib')
  String get rib;

  @BuiltValueField(wireName: r'iban')
  String get iban;

  FundingBankAccount._();

  factory FundingBankAccount([void updates(FundingBankAccountBuilder b)]) = _$FundingBankAccount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FundingBankAccountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FundingBankAccount> get serializer => _$FundingBankAccountSerializer();
}

class _$FundingBankAccountSerializer implements PrimitiveSerializer<FundingBankAccount> {
  @override
  final Iterable<Type> types = const [FundingBankAccount, _$FundingBankAccount];

  @override
  final String wireName = r'FundingBankAccount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FundingBankAccount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'bankName';
    yield serializers.serialize(
      object.bankName,
      specifiedType: const FullType(String),
    );
    yield r'holder';
    yield serializers.serialize(
      object.holder,
      specifiedType: const FullType(String),
    );
    yield r'rib';
    yield serializers.serialize(
      object.rib,
      specifiedType: const FullType(String),
    );
    yield r'iban';
    yield serializers.serialize(
      object.iban,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FundingBankAccount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FundingBankAccountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bankName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bankName = valueDes;
          break;
        case r'holder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.holder = valueDes;
          break;
        case r'rib':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.rib = valueDes;
          break;
        case r'iban':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.iban = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FundingBankAccount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FundingBankAccountBuilder();
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


