//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_document_type.g.dart';

/// Facture de commission, relevé, attestation (COM-08).
class MerchantDocumentType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COMMISSION_INVOICE')
  static const MerchantDocumentType COMMISSION_INVOICE = _$COMMISSION_INVOICE;
  @BuiltValueEnumConst(wireName: r'STATEMENT')
  static const MerchantDocumentType STATEMENT = _$STATEMENT;
  @BuiltValueEnumConst(wireName: r'CERTIFICATE')
  static const MerchantDocumentType CERTIFICATE = _$CERTIFICATE;

  static Serializer<MerchantDocumentType> get serializer => _$merchantDocumentTypeSerializer;

  const MerchantDocumentType._(String name): super(name);

  static BuiltSet<MerchantDocumentType> get values => _$values;
  static MerchantDocumentType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class MerchantDocumentTypeMixin = Object with _$MerchantDocumentTypeMixin;

