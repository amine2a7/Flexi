//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/date.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'family_member_balance.g.dart';

/// FamilyMemberBalance
///
/// Properties:
/// * [creditType] 
/// * [amountMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [dailyLimitMillimes] - Plafond par jour fixé par le bénéficiaire (null = celui du type).
/// * [endsOn] - Date de fin (null = aucune) ; après elle, le membre ne paie plus avec ce type.
@BuiltValue()
abstract class FamilyMemberBalance implements Built<FamilyMemberBalance, FamilyMemberBalanceBuilder> {
  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  /// Plafond par jour fixé par le bénéficiaire (null = celui du type).
  @BuiltValueField(wireName: r'dailyLimitMillimes')
  int? get dailyLimitMillimes;

  /// Date de fin (null = aucune) ; après elle, le membre ne paie plus avec ce type.
  @BuiltValueField(wireName: r'endsOn')
  Date? get endsOn;

  FamilyMemberBalance._();

  factory FamilyMemberBalance([void updates(FamilyMemberBalanceBuilder b)]) = _$FamilyMemberBalance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FamilyMemberBalanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FamilyMemberBalance> get serializer => _$FamilyMemberBalanceSerializer();
}

class _$FamilyMemberBalanceSerializer implements PrimitiveSerializer<FamilyMemberBalance> {
  @override
  final Iterable<Type> types = const [FamilyMemberBalance, _$FamilyMemberBalance];

  @override
  final String wireName = r'FamilyMemberBalance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FamilyMemberBalance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'creditType';
    yield serializers.serialize(
      object.creditType,
      specifiedType: const FullType(CreditType),
    );
    yield r'amountMillimes';
    yield serializers.serialize(
      object.amountMillimes,
      specifiedType: const FullType(int),
    );
    yield r'dailyLimitMillimes';
    yield object.dailyLimitMillimes == null ? null : serializers.serialize(
      object.dailyLimitMillimes,
      specifiedType: const FullType.nullable(int),
    );
    yield r'endsOn';
    yield object.endsOn == null ? null : serializers.serialize(
      object.endsOn,
      specifiedType: const FullType.nullable(Date),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FamilyMemberBalance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FamilyMemberBalanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'creditType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreditType),
          ) as CreditType;
          result.creditType = valueDes;
          break;
        case r'amountMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountMillimes = valueDes;
          break;
        case r'dailyLimitMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.dailyLimitMillimes = valueDes;
          break;
        case r'endsOn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.endsOn = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FamilyMemberBalance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FamilyMemberBalanceBuilder();
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


