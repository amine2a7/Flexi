//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/invoice_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'overview_invoice.g.dart';

/// OverviewInvoice
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [number] 
/// * [status] 
/// * [totalMillimes] - Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
/// * [issuedAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class OverviewInvoice implements Built<OverviewInvoice, OverviewInvoiceBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'status')
  InvoiceStatus get status;
  // enum statusEnum {  PAID,  UNPAID,  CANCELLED,  };

  /// Montant en **millimes** (1 TND = 1 000). Entier, jamais décimal ni chaîne. Devise : TND. Exemple : 45,000 TND = 45000. Les champs de ce type sont suffixés `Millimes`. 
  @BuiltValueField(wireName: r'totalMillimes')
  int get totalMillimes;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'issuedAt')
  DateTime get issuedAt;

  OverviewInvoice._();

  factory OverviewInvoice([void updates(OverviewInvoiceBuilder b)]) = _$OverviewInvoice;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OverviewInvoiceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OverviewInvoice> get serializer => _$OverviewInvoiceSerializer();
}

class _$OverviewInvoiceSerializer implements PrimitiveSerializer<OverviewInvoice> {
  @override
  final Iterable<Type> types = const [OverviewInvoice, _$OverviewInvoice];

  @override
  final String wireName = r'OverviewInvoice';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OverviewInvoice object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(InvoiceStatus),
    );
    yield r'totalMillimes';
    yield serializers.serialize(
      object.totalMillimes,
      specifiedType: const FullType(int),
    );
    yield r'issuedAt';
    yield serializers.serialize(
      object.issuedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OverviewInvoice object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OverviewInvoiceBuilder result,
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
        case r'number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.number = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoiceStatus),
          ) as InvoiceStatus;
          result.status = valueDes;
          break;
        case r'totalMillimes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalMillimes = valueDes;
          break;
        case r'issuedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.issuedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OverviewInvoice deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OverviewInvoiceBuilder();
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


