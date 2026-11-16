//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/kyc_document_status.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/kyc_document_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'kyc_document.g.dart';

/// KycDocument
///
/// Properties:
/// * [id] - Identifiant opaque de ressource.
/// * [type] 
/// * [fileName] 
/// * [contentType] 
/// * [sizeBytes] 
/// * [uploadedAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [status] 
/// * [correctionReason] 
@BuiltValue()
abstract class KycDocument implements Built<KycDocument, KycDocumentBuilder> {
  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  KycDocumentType get type;
  // enum typeEnum {  REGISTRY_EXTRACT,  TAX_CERTIFICATE,  MANAGER_ID,  MANAGER_ID_FRONT,  MANAGER_ID_BACK,  BANK_DETAILS,  COMPANY_STATUTES,  PROOF_OF_ADDRESS,  };

  @BuiltValueField(wireName: r'fileName')
  String get fileName;

  @BuiltValueField(wireName: r'contentType')
  KycDocumentContentTypeEnum get contentType;
  // enum contentTypeEnum {  image/jpeg,  image/png,  application/pdf,  };

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'uploadedAt')
  DateTime get uploadedAt;

  @BuiltValueField(wireName: r'status')
  KycDocumentStatus? get status;
  // enum statusEnum {  SUBMITTED,  VALIDATED,  TO_CORRECT,  };

  @BuiltValueField(wireName: r'correctionReason')
  String? get correctionReason;

  KycDocument._();

  factory KycDocument([void updates(KycDocumentBuilder b)]) = _$KycDocument;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(KycDocumentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<KycDocument> get serializer => _$KycDocumentSerializer();
}

class _$KycDocumentSerializer implements PrimitiveSerializer<KycDocument> {
  @override
  final Iterable<Type> types = const [KycDocument, _$KycDocument];

  @override
  final String wireName = r'KycDocument';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    KycDocument object, {
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
      specifiedType: const FullType(KycDocumentType),
    );
    yield r'fileName';
    yield serializers.serialize(
      object.fileName,
      specifiedType: const FullType(String),
    );
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(KycDocumentContentTypeEnum),
    );
    yield r'sizeBytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(int),
    );
    yield r'uploadedAt';
    yield serializers.serialize(
      object.uploadedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(KycDocumentStatus),
      );
    }
    if (object.correctionReason != null) {
      yield r'correctionReason';
      yield serializers.serialize(
        object.correctionReason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    KycDocument object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required KycDocumentBuilder result,
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
            specifiedType: const FullType(KycDocumentType),
          ) as KycDocumentType;
          result.type = valueDes;
          break;
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
            specifiedType: const FullType(KycDocumentContentTypeEnum),
          ) as KycDocumentContentTypeEnum;
          result.contentType = valueDes;
          break;
        case r'sizeBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sizeBytes = valueDes;
          break;
        case r'uploadedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.uploadedAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(KycDocumentStatus),
          ) as KycDocumentStatus?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        case r'correctionReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.correctionReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  KycDocument deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = KycDocumentBuilder();
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


class KycDocumentContentTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const KycDocumentContentTypeEnum imageSlashJpeg = _$kycDocumentContentTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const KycDocumentContentTypeEnum imageSlashPng = _$kycDocumentContentTypeEnum_imageSlashPng;
  @BuiltValueEnumConst(wireName: r'application/pdf')
  static const KycDocumentContentTypeEnum applicationSlashPdf = _$kycDocumentContentTypeEnum_applicationSlashPdf;

  static Serializer<KycDocumentContentTypeEnum> get serializer => _$kycDocumentContentTypeEnumSerializer;

  const KycDocumentContentTypeEnum._(String name): super(name);

  static BuiltSet<KycDocumentContentTypeEnum> get values => _$kycDocumentContentTypeEnumValues;
  static KycDocumentContentTypeEnum valueOf(String name) => _$kycDocumentContentTypeEnumValueOf(name);
}

