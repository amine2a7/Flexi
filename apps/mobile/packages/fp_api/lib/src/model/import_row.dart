//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fp_api/src/model/import_issue.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'import_row.g.dart';

/// ImportRow
///
/// Properties:
/// * [line] 
/// * [employeeNumber] 
/// * [firstName] 
/// * [lastName] 
/// * [email] 
/// * [phone] 
/// * [issues] 
@BuiltValue()
abstract class ImportRow implements Built<ImportRow, ImportRowBuilder> {
  @BuiltValueField(wireName: r'line')
  int get line;

  @BuiltValueField(wireName: r'employeeNumber')
  String get employeeNumber;

  @BuiltValueField(wireName: r'firstName')
  String get firstName;

  @BuiltValueField(wireName: r'lastName')
  String get lastName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'issues')
  BuiltList<ImportIssue> get issues;

  ImportRow._();

  factory ImportRow([void updates(ImportRowBuilder b)]) = _$ImportRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImportRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImportRow> get serializer => _$ImportRowSerializer();
}

class _$ImportRowSerializer implements PrimitiveSerializer<ImportRow> {
  @override
  final Iterable<Type> types = const [ImportRow, _$ImportRow];

  @override
  final String wireName = r'ImportRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImportRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'line';
    yield serializers.serialize(
      object.line,
      specifiedType: const FullType(int),
    );
    yield r'employeeNumber';
    yield serializers.serialize(
      object.employeeNumber,
      specifiedType: const FullType(String),
    );
    yield r'firstName';
    yield serializers.serialize(
      object.firstName,
      specifiedType: const FullType(String),
    );
    yield r'lastName';
    yield serializers.serialize(
      object.lastName,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'issues';
    yield serializers.serialize(
      object.issues,
      specifiedType: const FullType(BuiltList, [FullType(ImportIssue)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ImportRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ImportRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'line':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.line = valueDes;
          break;
        case r'employeeNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.employeeNumber = valueDes;
          break;
        case r'firstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstName = valueDes;
          break;
        case r'lastName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lastName = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'issues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ImportIssue)]),
          ) as BuiltList<ImportIssue>;
          result.issues.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImportRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImportRowBuilder();
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


