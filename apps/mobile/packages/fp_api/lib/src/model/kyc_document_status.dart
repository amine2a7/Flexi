//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'kyc_document_status.g.dart';

class KycDocumentStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const KycDocumentStatus SUBMITTED = _$SUBMITTED;
  @BuiltValueEnumConst(wireName: r'VALIDATED')
  static const KycDocumentStatus VALIDATED = _$VALIDATED;
  @BuiltValueEnumConst(wireName: r'TO_CORRECT')
  static const KycDocumentStatus TO_CORRECT = _$TO_CORRECT;

  static Serializer<KycDocumentStatus> get serializer => _$kycDocumentStatusSerializer;

  const KycDocumentStatus._(String name): super(name);

  static BuiltSet<KycDocumentStatus> get values => _$values;
  static KycDocumentStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class KycDocumentStatusMixin = Object with _$KycDocumentStatusMixin;

