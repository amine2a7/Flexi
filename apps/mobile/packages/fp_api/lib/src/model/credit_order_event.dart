//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/credit_order_event_action.dart';
import 'package:fp_api/src/model/role.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credit_order_event.g.dart';

/// Étape de l'historique d'une commande (qui, quoi, quand).
///
/// Properties:
/// * [action] 
/// * [occurredAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [actorName] 
/// * [actorRole] 
/// * [reason] 
@BuiltValue()
abstract class CreditOrderEvent implements Built<CreditOrderEvent, CreditOrderEventBuilder> {
  @BuiltValueField(wireName: r'action')
  CreditOrderEventAction get action;
  // enum actionEnum {  CREATED,  CONFIRMED,  REFUSED,  CANCELLED,  TRANSFER_DECLARED,  PROOF_REJECTED,  FIRST_VALIDATION,  VALIDATED,  };

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'occurredAt')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'actorName')
  String get actorName;

  @BuiltValueField(wireName: r'actorRole')
  Role get actorRole;
  // enum actorRoleEnum {  ADMIN,  COMPANY,  MERCHANT,  EMPLOYEE,  FAMILY_MEMBER,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  CreditOrderEvent._();

  factory CreditOrderEvent([void updates(CreditOrderEventBuilder b)]) = _$CreditOrderEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreditOrderEventBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreditOrderEvent> get serializer => _$CreditOrderEventSerializer();
}

class _$CreditOrderEventSerializer implements PrimitiveSerializer<CreditOrderEvent> {
  @override
  final Iterable<Type> types = const [CreditOrderEvent, _$CreditOrderEvent];

  @override
  final String wireName = r'CreditOrderEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreditOrderEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(CreditOrderEventAction),
    );
    yield r'occurredAt';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'actorName';
    yield serializers.serialize(
      object.actorName,
      specifiedType: const FullType(String),
    );
    yield r'actorRole';
    yield serializers.serialize(
      object.actorRole,
      specifiedType: const FullType(Role),
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
    CreditOrderEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreditOrderEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreditOrderEventAction),
          ) as CreditOrderEventAction;
          result.action = valueDes;
          break;
        case r'occurredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        case r'actorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actorName = valueDes;
          break;
        case r'actorRole':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Role),
          ) as Role;
          result.actorRole = valueDes;
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
  CreditOrderEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreditOrderEventBuilder();
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


