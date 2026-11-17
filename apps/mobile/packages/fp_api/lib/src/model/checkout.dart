//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/checkout_refusal.dart';
import 'package:fp_api/src/model/checkout_status.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout.g.dart';

/// Demande de paiement d'une caisse, vue par le commerce (jamais le solde du client).
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [registerId] - Identifiant opaque de ressource.
/// * [shortCode] - Code à 4 chiffres affiché en caisse, à taper par le client.
/// * [amountMillimes] - Montant en millimes strictement positif (montant d'une opération demandée).
/// * [creditType] 
/// * [status] 
/// * [createdAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [expiresAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [paidAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [customerFirstName] - Prénom du client, quand la demande est payée.
/// * [paymentReference] 
/// * [lastRefusal] 
@BuiltValue()
abstract class Checkout implements Built<Checkout, CheckoutBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'registerId')
  String get registerId;

  /// Code à 4 chiffres affiché en caisse, à taper par le client.
  @BuiltValueField(wireName: r'shortCode')
  String get shortCode;

  /// Montant en millimes strictement positif (montant d'une opération demandée).
  @BuiltValueField(wireName: r'amountMillimes')
  int get amountMillimes;

  @BuiltValueField(wireName: r'creditType')
  CreditType get creditType;
  // enum creditTypeEnum {  RESTAURATION,  HABILLEMENT,  CARBURANT,  CADEAUX,  };

  @BuiltValueField(wireName: r'status')
  CheckoutStatus get status;
  // enum statusEnum {  PENDING,  PAID,  EXPIRED,  CANCELLED,  };

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'paidAt')
  DateTime? get paidAt;

  /// Prénom du client, quand la demande est payée.
  @BuiltValueField(wireName: r'customerFirstName')
  String? get customerFirstName;

  @BuiltValueField(wireName: r'paymentReference')
  String? get paymentReference;

  @BuiltValueField(wireName: r'lastRefusal')
  CheckoutRefusal? get lastRefusal;

  Checkout._();

  factory Checkout([void updates(CheckoutBuilder b)]) = _$Checkout;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Checkout> get serializer => _$CheckoutSerializer();
}

class _$CheckoutSerializer implements PrimitiveSerializer<Checkout> {
  @override
  final Iterable<Type> types = const [Checkout, _$Checkout];

  @override
  final String wireName = r'Checkout';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Checkout object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'registerId';
    yield serializers.serialize(
      object.registerId,
      specifiedType: const FullType(String),
    );
    yield r'shortCode';
    yield serializers.serialize(
      object.shortCode,
      specifiedType: const FullType(String),
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CheckoutStatus),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.paidAt != null) {
      yield r'paidAt';
      yield serializers.serialize(
        object.paidAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.customerFirstName != null) {
      yield r'customerFirstName';
      yield serializers.serialize(
        object.customerFirstName,
        specifiedType: const FullType(String),
      );
    }
    if (object.paymentReference != null) {
      yield r'paymentReference';
      yield serializers.serialize(
        object.paymentReference,
        specifiedType: const FullType(String),
      );
    }
    if (object.lastRefusal != null) {
      yield r'lastRefusal';
      yield serializers.serialize(
        object.lastRefusal,
        specifiedType: const FullType(CheckoutRefusal),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Checkout object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckoutBuilder result,
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
        case r'registerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.registerId = valueDes;
          break;
        case r'shortCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.shortCode = valueDes;
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CheckoutStatus),
          ) as CheckoutStatus;
          result.status = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'paidAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.paidAt = valueDes;
          break;
        case r'customerFirstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.customerFirstName = valueDes;
          break;
        case r'paymentReference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.paymentReference = valueDes;
          break;
        case r'lastRefusal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CheckoutRefusal),
          ) as CheckoutRefusal?;
          if (valueDes == null) continue;
          result.lastRefusal.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Checkout deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutBuilder();
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


