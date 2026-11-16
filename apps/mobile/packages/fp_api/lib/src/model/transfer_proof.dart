//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transfer_proof.g.dart';

/// Métadonnées de la capture ; le fichier se lit par la route `…/proof`.
///
/// Properties:
/// * [fileName] 
/// * [contentType] 
/// * [sizeBytes] 
@BuiltValue()
abstract class TransferProof implements Built<TransferProof, TransferProofBuilder> {
  @BuiltValueField(wireName: r'fileName')
  String get fileName;

  @BuiltValueField(wireName: r'contentType')
  TransferProofContentTypeEnum get contentType;
  // enum contentTypeEnum {  image/jpeg,  image/png,  application/pdf,  };

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  TransferProof._();

  factory TransferProof([void updates(TransferProofBuilder b)]) = _$TransferProof;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TransferProofBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TransferProof> get serializer => _$TransferProofSerializer();
}

class _$TransferProofSerializer implements PrimitiveSerializer<TransferProof> {
  @override
  final Iterable<Type> types = const [TransferProof, _$TransferProof];

  @override
  final String wireName = r'TransferProof';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TransferProof object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fileName';
    yield serializers.serialize(
      object.fileName,
      specifiedType: const FullType(String),
    );
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(TransferProofContentTypeEnum),
    );
    yield r'sizeBytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TransferProof object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TransferProofBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fileName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fileName = valueDes;
          break;
        case r'contentType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TransferProofContentTypeEnum),
          ) as TransferProofContentTypeEnum;
          result.contentType = valueDes;
          break;
        case r'sizeBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sizeBytes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TransferProof deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TransferProofBuilder();
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


class TransferProofContentTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const TransferProofContentTypeEnum imageSlashJpeg = _$transferProofContentTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const TransferProofContentTypeEnum imageSlashPng = _$transferProofContentTypeEnum_imageSlashPng;
  @BuiltValueEnumConst(wireName: r'application/pdf')
  static const TransferProofContentTypeEnum applicationSlashPdf = _$transferProofContentTypeEnum_applicationSlashPdf;

  static Serializer<TransferProofContentTypeEnum> get serializer => _$transferProofContentTypeEnumSerializer;

  const TransferProofContentTypeEnum._(String name): super(name);

  static BuiltSet<TransferProofContentTypeEnum> get values => _$transferProofContentTypeEnumValues;
  static TransferProofContentTypeEnum valueOf(String name) => _$transferProofContentTypeEnumValueOf(name);
}

