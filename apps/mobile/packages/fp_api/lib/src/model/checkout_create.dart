//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_create.g.dart';

/// CheckoutCreate
///
/// Properties:
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [creditType] 
@BuiltValue()
abstract class CheckoutCreate implements Built<CheckoutCreate, CheckoutCreateBuilder> {
  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  CheckoutCreate._();

  factory CheckoutCreate([void updates(CheckoutCreateBuilder b)]) = _$CheckoutCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutCreate> get serializer => _$CheckoutCreateSerializer();
}

class _$CheckoutCreateSerializer implements PrimitiveSerializer<CheckoutCreate> {
  @override
  final Iterable<Type> types = const [CheckoutCreate, _$CheckoutCreate];

  @override
  final String wireName = r'CheckoutCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amountMillimes';
    yield serializers.serialize(
      object.amountMillimes,
      specifiedType: const FullType(int),
    );
    yield r'creditType';
    yield serializers.serialize(
      object.creditType,
      specifiedType: const FullType(CreditType),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckoutCreateBuilder result,
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
        case r'creditType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreditType),
          ) as CreditType;
          result.creditType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutCreateBuilder();
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


