//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'legal_form.g.dart';

/// Forme juridique (PP CIN, PP MF, PM MF) ; fixe le taux de retenue à la source.
class LegalForm extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PP_CIN')
  static const LegalForm PP_CIN = _$PP_CIN;
  @BuiltValueEnumConst(wireName: r'PP_MF')
  static const LegalForm PP_MF = _$PP_MF;
  @BuiltValueEnumConst(wireName: r'PM_MF')
  static const LegalForm PM_MF = _$PM_MF;

  static Serializer<LegalForm> get serializer => _$legalFormSerializer;

  const LegalForm._(String name): super(name);

  static BuiltSet<LegalForm> get values => _$values;
  static LegalForm valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class LegalFormMixin = Object with _$LegalFormMixin;

