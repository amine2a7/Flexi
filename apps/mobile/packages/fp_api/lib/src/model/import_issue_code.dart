//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'import_issue_code.g.dart';

/// Problème d'une ligne d'import.
class ImportIssueCode extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUIRED')
  static const ImportIssueCode REQUIRED = _$REQUIRED;
  @BuiltValueEnumConst(wireName: r'INVALID_FORMAT')
  static const ImportIssueCode INVALID_FORMAT = _$INVALID_FORMAT;
  @BuiltValueEnumConst(wireName: r'DUPLICATE_IN_FILE')
  static const ImportIssueCode DUPLICATE_IN_FILE = _$DUPLICATE_IN_FILE;
  @BuiltValueEnumConst(wireName: r'ALREADY_EXISTS')
  static const ImportIssueCode ALREADY_EXISTS = _$ALREADY_EXISTS;

  static Serializer<ImportIssueCode> get serializer => _$importIssueCodeSerializer;

  const ImportIssueCode._(String name): super(name);

  static BuiltSet<ImportIssueCode> get values => _$values;
  static ImportIssueCode valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ImportIssueCodeMixin = Object with _$ImportIssueCodeMixin;

