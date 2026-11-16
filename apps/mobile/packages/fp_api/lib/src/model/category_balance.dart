//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/date.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'category_balance.g.dart';

/// CategoryBalance
///
/// Properties:
/// * [creditType] 
/// * [balanceMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [expiringMillimes] - Part du solde qui expire à `nextExpiryDate`.
/// * [dailyLimitMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [todaySpentMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [enabled] 
/// * [nextExpiryDate] - Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
@BuiltValue()
abstract class CategoryBalance implements Built<CategoryBalance, CategoryBalanceBuilder> {
  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'balanceMillimes')
  int get balanceMillimes;

  /// Part du solde qui expire à `nextExpiryDate`.
  @BuiltValueField(wireName: r'expiringMillimes')
  int get expiringMillimes;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'dailyLimitMillimes')
  int get dailyLimitMillimes;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'todaySpentMillimes')
  int get todaySpentMillimes;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// Date calendaire sans heure, dans le fuseau des règles métier `Africa/Tunis`.
  @BuiltValueField(wireName: r'nextExpiryDate')
  Date? get nextExpiryDate;

  CategoryBalance._();

  factory CategoryBalance([void updates(CategoryBalanceBuilder b)]) = _$CategoryBalance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CategoryBalanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CategoryBalance> get serializer => _$CategoryBalanceSerializer();
}

class _$CategoryBalanceSerializer implements PrimitiveSerializer<CategoryBalance> {
  @override
  final Iterable<Type> types = const [CategoryBalance, _$CategoryBalance];

  @override
  final String wireName = r'CategoryBalance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CategoryBalance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'creditType';
    yield serializers.serialize(
      object.creditType,
      specifiedType: const FullType(CreditType),
    );
    yield r'balanceMillimes';
    yield serializers.serialize(
      object.balanceMillimes,
      specifiedType: const FullType(int),
    );
    yield r'expiringMillimes';
    yield serializers.serialize(
      object.expiringMillimes,
      specifiedType: const FullType(int),
    );
    yield r'dailyLimitMillimes';
    yield serializers.serialize(
      object.dailyLimitMillimes,
      specifiedType: const FullType(int),
    );
    yield r'todaySpentMillimes';
    yield serializers.serialize(
      object.todaySpentMillimes,
      specifiedType: const FullType(int),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'nextExpiryDate';
    yield object.nextExpiryDate == null ? null : serializers.serialize(
      object.nextExpiryDate,
      specifiedType: const FullType.nullable(Date),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CategoryBalance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CategoryBalanceBuilder result,
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
        case r'balanceMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.balanceMillimes = valueDes;
          break;
        case r'expiringMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expiringMillimes = valueDes;
          break;
        case r'dailyLimitMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dailyLimitMillimes = valueDes;
          break;
        case r'todaySpentMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.todaySpentMillimes = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'nextExpiryDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.nextExpiryDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CategoryBalance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CategoryBalanceBuilder();
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


