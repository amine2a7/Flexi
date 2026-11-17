//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/employee_notification_kind.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_notification.g.dart';

/// Notification ; le texte est construit par l'app à partir de clés i18n.
///
/// Properties:
/// * [id] 
/// * [kind] 
/// * [occurredAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [unread] 
/// * [amountMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [creditType] 
/// * [counterpartyName] - Commerce, entreprise ou prénom du membre famille.
@BuiltValue()
abstract class EmployeeNotification implements Built<EmployeeNotification, EmployeeNotificationBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  EmployeeNotificationKind get kind;
  // enum kindEnum {  CREDIT_RECEIVED,  PAYMENT_APPROVED,  FAMILY_PAYMENT,  CREDIT_EXPIRING,  };

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'occurredAt')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'unread')
  bool get unread;

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'amountMillimes')
  int? get amountMillimes;

  @BuiltValueField(wireName: r'creditType')
  CreditType? get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  /// Commerce, entreprise ou prénom du membre famille.
  @BuiltValueField(wireName: r'counterpartyName')
  String? get counterpartyName;

  EmployeeNotification._();

  factory EmployeeNotification([void updates(EmployeeNotificationBuilder b)]) = _$EmployeeNotification;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeNotificationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeNotification> get serializer => _$EmployeeNotificationSerializer();
}

class _$EmployeeNotificationSerializer implements PrimitiveSerializer<EmployeeNotification> {
  @override
  final Iterable<Type> types = const [EmployeeNotification, _$EmployeeNotification];

  @override
  final String wireName = r'EmployeeNotification';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeNotification object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(EmployeeNotificationKind),
    );
    yield r'occurredAt';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'unread';
    yield serializers.serialize(
      object.unread,
      specifiedType: const FullType(bool),
    );
    if (object.amountMillimes != null) {
      yield r'amountMillimes';
      yield serializers.serialize(
        object.amountMillimes,
        specifiedType: const FullType(int),
      );
    }
    if (object.creditType != null) {
      yield r'creditType';
      yield serializers.serialize(
        object.creditType,
        specifiedType: const FullType(CreditType),
      );
    }
    if (object.counterpartyName != null) {
      yield r'counterpartyName';
      yield serializers.serialize(
        object.counterpartyName,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeNotification object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeNotificationBuilder result,
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EmployeeNotificationKind),
          ) as EmployeeNotificationKind;
          result.kind = valueDes;
          break;
        case r'occurredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        case r'unread':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.unread = valueDes;
          break;
        case r'amountMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.amountMillimes = valueDes;
          break;
        case r'creditType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CreditType),
          ) as CreditType?;
          if (valueDes == null) continue;
          result.creditType = valueDes;
          break;
        case r'counterpartyName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.counterpartyName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeNotification deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeNotificationBuilder();
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


