//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'kyc_document_type.g.dart';

/// Extrait du registre de commerce, attestation fiscale, pièce d'identité du gérant (MANAGER_ID, ancienne pièce unique, puis recto et verso séparés depuis le 13/11), RIB, statuts, justificatif d'adresse (processus v2 — le Super-admin choisit les pièces demandées).
class KycDocumentType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REGISTRY_EXTRACT')
  static const KycDocumentType REGISTRY_EXTRACT = _$REGISTRY_EXTRACT;
  @BuiltValueEnumConst(wireName: r'TAX_CERTIFICATE')
  static const KycDocumentType TAX_CERTIFICATE = _$TAX_CERTIFICATE;
  @BuiltValueEnumConst(wireName: r'MANAGER_ID')
  static const KycDocumentType MANAGER_ID = _$MANAGER_ID;
  @BuiltValueEnumConst(wireName: r'MANAGER_ID_FRONT')
  static const KycDocumentType MANAGER_ID_FRONT = _$MANAGER_ID_FRONT;
  @BuiltValueEnumConst(wireName: r'MANAGER_ID_BACK')
  static const KycDocumentType MANAGER_ID_BACK = _$MANAGER_ID_BACK;
  @BuiltValueEnumConst(wireName: r'BANK_DETAILS')
  static const KycDocumentType BANK_DETAILS = _$BANK_DETAILS;
  @BuiltValueEnumConst(wireName: r'COMPANY_STATUTES')
  static const KycDocumentType COMPANY_STATUTES = _$COMPANY_STATUTES;
  @BuiltValueEnumConst(wireName: r'PROOF_OF_ADDRESS')
  static const KycDocumentType PROOF_OF_ADDRESS = _$PROOF_OF_ADDRESS;

  static Serializer<KycDocumentType> get serializer => _$kycDocumentTypeSerializer;

  const KycDocumentType._(String name): super(name);

  static BuiltSet<KycDocumentType> get values => _$values;
  static KycDocumentType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class KycDocumentTypeMixin = Object with _$KycDocumentTypeMixin;

