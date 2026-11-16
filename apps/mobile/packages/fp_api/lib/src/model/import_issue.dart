//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fp_api/src/model/import_issue_code.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'import_issue.g.dart';

/// ImportIssue
///
/// Properties:
/// * [field] 
/// * [code] 
@BuiltValue()
abstract class ImportIssue implements Built<ImportIssue, ImportIssueBuilder> {
  @BuiltValueField(wireName: r'field')
  ImportIssueFieldEnum get field;
  // enum fieldEnum {  employeeNumber,  firstName,  lastName,  email,  phone,  };

  @BuiltValueField(wireName: r'code')
  ImportIssueCode get code;
  // enum codeEnum {  REQUIRED,  INVALID_FORMAT,  DUPLICATE_IN_FILE,  ALREADY_EXISTS,  };

  ImportIssue._();

  factory ImportIssue([void updates(ImportIssueBuilder b)]) = _$ImportIssue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImportIssueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImportIssue> get serializer => _$ImportIssueSerializer();
}

class _$ImportIssueSerializer implements PrimitiveSerializer<ImportIssue> {
  @override
  final Iterable<Type> types = const [ImportIssue, _$ImportIssue];

  @override
  final String wireName = r'ImportIssue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImportIssue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'field';
    yield serializers.serialize(
      object.field,
      specifiedType: const FullType(ImportIssueFieldEnum),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(ImportIssueCode),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ImportIssue object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ImportIssueBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'field':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportIssueFieldEnum),
          ) as ImportIssueFieldEnum;
          result.field = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ImportIssueCode),
          ) as ImportIssueCode;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImportIssue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImportIssueBuilder();
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


class ImportIssueFieldEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'employeeNumber')
  static const ImportIssueFieldEnum employeeNumber = _$importIssueFieldEnum_employeeNumber;
  @BuiltValueEnumConst(wireName: r'firstName')
  static const ImportIssueFieldEnum firstName = _$importIssueFieldEnum_firstName;
  @BuiltValueEnumConst(wireName: r'lastName')
  static const ImportIssueFieldEnum lastName = _$importIssueFieldEnum_lastName;
  @BuiltValueEnumConst(wireName: r'email')
  static const ImportIssueFieldEnum email = _$importIssueFieldEnum_email;
  @BuiltValueEnumConst(wireName: r'phone')
  static const ImportIssueFieldEnum phone = _$importIssueFieldEnum_phone;

  static Serializer<ImportIssueFieldEnum> get serializer => _$importIssueFieldEnumSerializer;

  const ImportIssueFieldEnum._(String name): super(name);

  static BuiltSet<ImportIssueFieldEnum> get values => _$importIssueFieldEnumValues;
  static ImportIssueFieldEnum valueOf(String name) => _$importIssueFieldEnumValueOf(name);
}

