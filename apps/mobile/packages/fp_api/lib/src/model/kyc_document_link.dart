//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'kyc_document_link.g.dart';

/// Lien signé vers une pièce KYC, valable 5 minutes, pour l'administrateur qui l'a demandé (SEC-1).
///
/// Properties:
/// * [url] 
/// * [expires] - Échéance (secondes Unix), à repasser dans `expires`.
/// * [signature] 
/// * [expiresAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
@BuiltValue()
abstract class KycDocumentLink implements Built<KycDocumentLink, KycDocumentLinkBuilder> {
  @BuiltValueField(wireName: r'url')
  String get url;

  /// Échéance (secondes Unix), à repasser dans `expires`.
  @BuiltValueField(wireName: r'expires')
  int get expires;

  @BuiltValueField(wireName: r'signature')
  String get signature;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  KycDocumentLink._();

  factory KycDocumentLink([void updates(KycDocumentLinkBuilder b)]) = _$KycDocumentLink;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(KycDocumentLinkBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<KycDocumentLink> get serializer => _$KycDocumentLinkSerializer();
}

class _$KycDocumentLinkSerializer implements PrimitiveSerializer<KycDocumentLink> {
  @override
  final Iterable<Type> types = const [KycDocumentLink, _$KycDocumentLink];

  @override
  final String wireName = r'KycDocumentLink';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    KycDocumentLink object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'expires';
    yield serializers.serialize(
      object.expires,
      specifiedType: const FullType(int),
    );
    yield r'signature';
    yield serializers.serialize(
      object.signature,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    KycDocumentLink object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required KycDocumentLinkBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'expires':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expires = valueDes;
          break;
        case r'signature':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.signature = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  KycDocumentLink deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = KycDocumentLinkBuilder();
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


