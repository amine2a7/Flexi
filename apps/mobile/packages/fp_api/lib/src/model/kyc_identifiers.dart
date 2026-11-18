//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'kyc_identifiers.g.dart';

/// N° de CIN, matricule fiscal et RIB du client ; masqués (4 derniers caractères) sauf pour Opérations (SEC-1).
///
/// Properties:
/// * [nationalId] 
/// * [taxId] 
/// * [iban] 
@BuiltValue()
abstract class KycIdentifiers implements Built<KycIdentifiers, KycIdentifiersBuilder> {
  @BuiltValueField(wireName: r'nationalId')
  String? get nationalId;

  @BuiltValueField(wireName: r'taxId')
  String? get taxId;

  @BuiltValueField(wireName: r'iban')
  String? get iban;

  KycIdentifiers._();

  factory KycIdentifiers([void updates(KycIdentifiersBuilder b)]) = _$KycIdentifiers;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(KycIdentifiersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<KycIdentifiers> get serializer => _$KycIdentifiersSerializer();
}

class _$KycIdentifiersSerializer implements PrimitiveSerializer<KycIdentifiers> {
  @override
  final Iterable<Type> types = const [KycIdentifiers, _$KycIdentifiers];

  @override
  final String wireName = r'KycIdentifiers';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    KycIdentifiers object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nationalId';
    yield object.nationalId == null ? null : serializers.serialize(
      object.nationalId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'taxId';
    yield object.taxId == null ? null : serializers.serialize(
      object.taxId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'iban';
    yield object.iban == null ? null : serializers.serialize(
      object.iban,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    KycIdentifiers object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required KycIdentifiersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'nationalId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nationalId = valueDes;
          break;
        case r'taxId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.taxId = valueDes;
          break;
        case r'iban':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.iban = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  KycIdentifiers deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = KycIdentifiersBuilder();
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


