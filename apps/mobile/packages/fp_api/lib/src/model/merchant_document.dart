//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/merchant_document_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_document.g.dart';

/// MerchantDocument
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [type] 
/// * [period] - Mois couvert (AAAA-MM).
/// * [issuedAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class MerchantDocument implements Built<MerchantDocument, MerchantDocumentBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  MerchantDocumentType get type;
  // enum typeEnum {  COMMISSION_INVOICE,  STATEMENT,  CERTIFICATE,  };

  /// Mois couvert (AAAA-MM).
  @BuiltValueField(wireName: r'period')
  String get period;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'issuedAt')
  DateTime get issuedAt;

  MerchantDocument._();

  factory MerchantDocument([void updates(MerchantDocumentBuilder b)]) = _$MerchantDocument;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantDocumentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantDocument> get serializer => _$MerchantDocumentSerializer();
}

class _$MerchantDocumentSerializer implements PrimitiveSerializer<MerchantDocument> {
  @override
  final Iterable<Type> types = const [MerchantDocument, _$MerchantDocument];

  @override
  final String wireName = r'MerchantDocument';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantDocument object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(MerchantDocumentType),
    );
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(String),
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
    MerchantDocument object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantDocumentBuilder result,
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MerchantDocumentType),
          ) as MerchantDocumentType;
          result.type = valueDes;
          break;
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.period = valueDes;
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
  MerchantDocument deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantDocumentBuilder();
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


