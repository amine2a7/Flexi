//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/employee_operation_type.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:fp_api/src/model/employee_operation_status.dart';
import 'package:fp_api/src/model/direction.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_operation.g.dart';

/// EmployeeOperation
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [reference] 
/// * [type] 
/// * [direction] 
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [creditType] 
/// * [counterpartyName] - Commerçant (paiement) ou entreprise (crédits reçus, expiration).
/// * [status] 
/// * [occurredAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class EmployeeOperation implements Built<EmployeeOperation, EmployeeOperationBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'type')
  EmployeeOperationType get type;
  // enum typeEnum {  PAYMENT,  ALLOCATION,  EXPIRY,  FAMILY_TRANSFER,  };

  @BuiltValueField(wireName: r'direction')
  Direction get direction;
  // enum directionEnum {  DEBIT,  CREDIT,  };

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Commerçant (paiement) ou entreprise (crédits reçus, expiration).
  @BuiltValueField(wireName: r'counterpartyName')
  String get counterpartyName;

  @BuiltValueField(wireName: r'status')
  EmployeeOperationStatus get status;
  // enum statusEnum {  COMPLETED,  PENDING,  REFUSED,  };

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'occurredAt')
  DateTime get occurredAt;

  EmployeeOperation._();

  factory EmployeeOperation([void updates(EmployeeOperationBuilder b)]) = _$EmployeeOperation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeOperationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeOperation> get serializer => _$EmployeeOperationSerializer();
}

class _$EmployeeOperationSerializer implements PrimitiveSerializer<EmployeeOperation> {
  @override
  final Iterable<Type> types = const [EmployeeOperation, _$EmployeeOperation];

  @override
  final String wireName = r'EmployeeOperation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeOperation object, {
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
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(EmployeeOperationType),
    );
    yield r'direction';
    yield serializers.serialize(
      object.direction,
      specifiedType: const FullType(Direction),
    );
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
    yield r'counterpartyName';
    yield serializers.serialize(
      object.counterpartyName,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(EmployeeOperationStatus),
    );
    yield r'occurredAt';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeOperation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeOperationBuilder result,
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EmployeeOperationType),
          ) as EmployeeOperationType;
          result.type = valueDes;
          break;
        case r'direction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Direction),
          ) as Direction;
          result.direction = valueDes;
          break;
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
        case r'counterpartyName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.counterpartyName = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EmployeeOperationStatus),
          ) as EmployeeOperationStatus;
          result.status = valueDes;
          break;
        case r'occurredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeOperation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeOperationBuilder();
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


