//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_payment_create.g.dart';

/// EmployeePaymentCreate
///
/// Properties:
/// * [merchantCode] 
/// * [creditType] - Type payé, accepté par le commerçant ; seul le solde de ce type est débité.
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [pin] 
@BuiltValue()
abstract class EmployeePaymentCreate implements Built<EmployeePaymentCreate, EmployeePaymentCreateBuilder> {
  @BuiltValueField(wireName: r'merchantCode')
  String get merchantCode;

  /// Type payé, accepté par le commerçant ; seul le solde de ce type est débité.
  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  @BuiltValueField(wireName: r'pin')
  String get pin;

  EmployeePaymentCreate._();

  factory EmployeePaymentCreate([void updates(EmployeePaymentCreateBuilder b)]) = _$EmployeePaymentCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeePaymentCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeePaymentCreate> get serializer => _$EmployeePaymentCreateSerializer();
}

class _$EmployeePaymentCreateSerializer implements PrimitiveSerializer<EmployeePaymentCreate> {
  @override
  final Iterable<Type> types = const [EmployeePaymentCreate, _$EmployeePaymentCreate];

  @override
  final String wireName = r'EmployeePaymentCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeePaymentCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'merchantCode';
    yield serializers.serialize(
      object.merchantCode,
      specifiedType: const FullType(String),
    );
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
    yield r'pin';
    yield serializers.serialize(
      object.pin,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeePaymentCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeePaymentCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'merchantCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.merchantCode = valueDes;
          break;
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
        case r'pin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeePaymentCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeePaymentCreateBuilder();
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


