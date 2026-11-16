//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/kyc_document_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'kyc_piece.g.dart';

/// Une pièce du dossier et son statut (processus v2) ; MISSING = à déposer.
///
/// Properties:
/// * [type] 
/// * [status] 
/// * [documentId] - Identifiant opaque de ressource.
/// * [fileName] 
/// * [contentType] 
/// * [sizeBytes] 
/// * [uploadedAt] - Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
/// * [correctionReason] 
@BuiltValue()
abstract class KycPiece implements Built<KycPiece, KycPieceBuilder> {
  @BuiltValueField(wireName: r'type')
  KycDocumentType get type;
  // enum typeEnum {  REGISTRY_EXTRACT,  TAX_CERTIFICATE,  MANAGER_ID,  MANAGER_ID_FRONT,  MANAGER_ID_BACK,  BANK_DETAILS,  COMPANY_STATUTES,  PROOF_OF_ADDRESS,  };

  @BuiltValueField(wireName: r'status')
  KycPieceStatusEnum get status;
  // enum statusEnum {  MISSING,  SUBMITTED,  VALIDATED,  TO_CORRECT,  };

  /// Identifiant opaque de ressource.
  @BuiltValueField(wireName: r'documentId')
  String? get documentId;

  @BuiltValueField(wireName: r'fileName')
  String? get fileName;

  @BuiltValueField(wireName: r'contentType')
  KycPieceContentTypeEnum? get contentType;
  // enum contentTypeEnum {  image/jpeg,  image/png,  application/pdf,  };

  @BuiltValueField(wireName: r'sizeBytes')
  int? get sizeBytes;

  /// Horodatage RFC 3339 en UTC, suffixe `Z`, précision milliseconde.
  @BuiltValueField(wireName: r'uploadedAt')
  DateTime? get uploadedAt;

  @BuiltValueField(wireName: r'correctionReason')
  String? get correctionReason;

  KycPiece._();

  factory KycPiece([void updates(KycPieceBuilder b)]) = _$KycPiece;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(KycPieceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<KycPiece> get serializer => _$KycPieceSerializer();
}

class _$KycPieceSerializer implements PrimitiveSerializer<KycPiece> {
  @override
  final Iterable<Type> types = const [KycPiece, _$KycPiece];

  @override
  final String wireName = r'KycPiece';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    KycPiece object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(KycDocumentType),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(KycPieceStatusEnum),
    );
    if (object.documentId != null) {
      yield r'documentId';
      yield serializers.serialize(
        object.documentId,
        specifiedType: const FullType(String),
      );
    }
    if (object.fileName != null) {
      yield r'fileName';
      yield serializers.serialize(
        object.fileName,
        specifiedType: const FullType(String),
      );
    }
    if (object.contentType != null) {
      yield r'contentType';
      yield serializers.serialize(
        object.contentType,
        specifiedType: const FullType(KycPieceContentTypeEnum),
      );
    }
    if (object.sizeBytes != null) {
      yield r'sizeBytes';
      yield serializers.serialize(
        object.sizeBytes,
        specifiedType: const FullType(int),
      );
    }
    if (object.uploadedAt != null) {
      yield r'uploadedAt';
      yield serializers.serialize(
        object.uploadedAt,
        specifiedType: const FullType(DateTime),
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
    KycPiece object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required KycPieceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(KycDocumentType),
          ) as KycDocumentType;
          result.type = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(KycPieceStatusEnum),
          ) as KycPieceStatusEnum;
          result.status = valueDes;
          break;
        case r'documentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.documentId = valueDes;
          break;
        case r'fileName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fileName = valueDes;
          break;
        case r'contentType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(KycPieceContentTypeEnum),
          ) as KycPieceContentTypeEnum?;
          if (valueDes == null) continue;
          result.contentType = valueDes;
          break;
        case r'sizeBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.sizeBytes = valueDes;
          break;
        case r'uploadedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.uploadedAt = valueDes;
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
  KycPiece deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = KycPieceBuilder();
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


class KycPieceStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MISSING')
  static const KycPieceStatusEnum MISSING = _$kycPieceStatusEnum_MISSING;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const KycPieceStatusEnum SUBMITTED = _$kycPieceStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'VALIDATED')
  static const KycPieceStatusEnum VALIDATED = _$kycPieceStatusEnum_VALIDATED;
  @BuiltValueEnumConst(wireName: r'TO_CORRECT')
  static const KycPieceStatusEnum TO_CORRECT = _$kycPieceStatusEnum_TO_CORRECT;

  static Serializer<KycPieceStatusEnum> get serializer => _$kycPieceStatusEnumSerializer;

  const KycPieceStatusEnum._(String name): super(name);

  static BuiltSet<KycPieceStatusEnum> get values => _$kycPieceStatusEnumValues;
  static KycPieceStatusEnum valueOf(String name) => _$kycPieceStatusEnumValueOf(name);
}

class KycPieceContentTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const KycPieceContentTypeEnum imageSlashJpeg = _$kycPieceContentTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const KycPieceContentTypeEnum imageSlashPng = _$kycPieceContentTypeEnum_imageSlashPng;
  @BuiltValueEnumConst(wireName: r'application/pdf')
  static const KycPieceContentTypeEnum applicationSlashPdf = _$kycPieceContentTypeEnum_applicationSlashPdf;

  static Serializer<KycPieceContentTypeEnum> get serializer => _$kycPieceContentTypeEnumSerializer;

  const KycPieceContentTypeEnum._(String name): super(name);

  static BuiltSet<KycPieceContentTypeEnum> get values => _$kycPieceContentTypeEnumValues;
  static KycPieceContentTypeEnum valueOf(String name) => _$kycPieceContentTypeEnumValueOf(name);
}

