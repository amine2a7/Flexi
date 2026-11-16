//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/category_balance.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_wallet.g.dart';

/// Soldes du bénéficiaire, un par type de crédit ; le total n'est qu'informatif.
///
/// Properties:
/// * [companyName] 
/// * [totalBalanceMillimes] - Somme des soldes par type, à titre d'information uniquement.
/// * [balances] 
@BuiltValue()
abstract class EmployeeWallet implements Built<EmployeeWallet, EmployeeWalletBuilder> {
  @BuiltValueField(wireName: r'companyName')
  String get companyName;

  /// Somme des soldes par type, à titre d'information uniquement.
  @BuiltValueField(wireName: r'totalBalanceMillimes')
  int get totalBalanceMillimes;

  @BuiltValueField(wireName: r'balances')
  BuiltList<CategoryBalance> get balances;

  EmployeeWallet._();

  factory EmployeeWallet([void updates(EmployeeWalletBuilder b)]) = _$EmployeeWallet;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeWalletBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeWallet> get serializer => _$EmployeeWalletSerializer();
}

class _$EmployeeWalletSerializer implements PrimitiveSerializer<EmployeeWallet> {
  @override
  final Iterable<Type> types = const [EmployeeWallet, _$EmployeeWallet];

  @override
  final String wireName = r'EmployeeWallet';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeWallet object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'companyName';
    yield serializers.serialize(
      object.companyName,
      specifiedType: const FullType(String),
    );
    yield r'totalBalanceMillimes';
    yield serializers.serialize(
      object.totalBalanceMillimes,
      specifiedType: const FullType(int),
    );
    yield r'balances';
    yield serializers.serialize(
      object.balances,
      specifiedType: const FullType(BuiltList, [FullType(CategoryBalance)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeWallet object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeWalletBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'companyName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.companyName = valueDes;
          break;
        case r'totalBalanceMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalBalanceMillimes = valueDes;
          break;
        case r'balances':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CategoryBalance)]),
          ) as BuiltList<CategoryBalance>;
          result.balances.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeWallet deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeWalletBuilder();
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


