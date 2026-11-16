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

part 'employee_operation_detail.g.dart';

/// Opération avec les éléments du reçu.
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [reference] 
/// * [type] 
/// * [direction] 
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [creditType] 
/// * [counterpartyName] 
/// * [counterpartyCity] 
/// * [status] 
/// * [occurredAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [balanceAfterMillimes] - Solde de la catégorie après l'opération (visible du seul titulaire).
@BuiltValue()
abstract class EmployeeOperationDetail implements Built<EmployeeOperationDetail, EmployeeOperationDetailBuilder> {
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

  @BuiltValueField(wireName: r'counterpartyName')
  String get counterpartyName;

  @BuiltValueField(wireName: r'counterpartyCity')
  String? get counterpartyCity;

  @BuiltValueField(wireName: r'status')
  EmployeeOperationStatus get status;
  // enum statusEnum {  COMPLETED,  PENDING,  REFUSED,  };

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'occurredAt')
  DateTime get occurredAt;

  /// Solde de la catégorie après l'opération (visible du seul titulaire).
  @BuiltValueField(wireName: r'balanceAfterMillimes')
  int get balanceAfterMillimes;

  EmployeeOperationDetail._();

  factory EmployeeOperationDetail([void updates(EmployeeOperationDetailBuilder b)]) = _$EmployeeOperationDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeOperationDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeOperationDetail> get serializer => _$EmployeeOperationDetailSerializer();
}

class _$EmployeeOperationDetailSerializer implements PrimitiveSerializer<EmployeeOperationDetail> {
  @override
  final Iterable<Type> types = const [EmployeeOperationDetail, _$EmployeeOperationDetail];

  @override
  final String wireName = r'EmployeeOperationDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeOperationDetail object, {
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
    yield r'counterpartyCity';
    yield object.counterpartyCity == null ? null : serializers.serialize(
      object.counterpartyCity,
      specifiedType: const FullType.nullable(String),
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
    yield r'balanceAfterMillimes';
    yield serializers.serialize(
      object.balanceAfterMillimes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeOperationDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeOperationDetailBuilder result,
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
        case r'counterpartyCity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.counterpartyCity = valueDes;
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
        case r'balanceAfterMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.balanceAfterMillimes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeOperationDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeOperationDetailBuilder();
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


