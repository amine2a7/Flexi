// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_issue_code.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ImportIssueCode _$REQUIRED = const ImportIssueCode._('REQUIRED');
const ImportIssueCode _$INVALID_FORMAT = const ImportIssueCode._(
  'INVALID_FORMAT',
);
const ImportIssueCode _$DUPLICATE_IN_FILE = const ImportIssueCode._(
  'DUPLICATE_IN_FILE',
);
const ImportIssueCode _$ALREADY_EXISTS = const ImportIssueCode._(
  'ALREADY_EXISTS',
);

ImportIssueCode _$valueOf(String name) {
  switch (name) {
    case 'REQUIRED':
      return _$REQUIRED;
    case 'INVALID_FORMAT':
      return _$INVALID_FORMAT;
    case 'DUPLICATE_IN_FILE':
      return _$DUPLICATE_IN_FILE;
    case 'ALREADY_EXISTS':
      return _$ALREADY_EXISTS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ImportIssueCode> _$values = BuiltSet<ImportIssueCode>(
  const <ImportIssueCode>[
    _$REQUIRED,
    _$INVALID_FORMAT,
    _$DUPLICATE_IN_FILE,
    _$ALREADY_EXISTS,
  ],
);

class _$ImportIssueCodeMeta {
  const _$ImportIssueCodeMeta();
  ImportIssueCode get REQUIRED => _$REQUIRED;
  ImportIssueCode get INVALID_FORMAT => _$INVALID_FORMAT;
  ImportIssueCode get DUPLICATE_IN_FILE => _$DUPLICATE_IN_FILE;
  ImportIssueCode get ALREADY_EXISTS => _$ALREADY_EXISTS;
  ImportIssueCode valueOf(String name) => _$valueOf(name);
  BuiltSet<ImportIssueCode> get values => _$values;
}

mixin _$ImportIssueCodeMixin {
  // ignore: non_constant_identifier_names
  _$ImportIssueCodeMeta get ImportIssueCode => const _$ImportIssueCodeMeta();
}

Serializer<ImportIssueCode> _$importIssueCodeSerializer =
    _$ImportIssueCodeSerializer();

class _$ImportIssueCodeSerializer
    implements PrimitiveSerializer<ImportIssueCode> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REQUIRED': 'REQUIRED',
    'INVALID_FORMAT': 'INVALID_FORMAT',
    'DUPLICATE_IN_FILE': 'DUPLICATE_IN_FILE',
    'ALREADY_EXISTS': 'ALREADY_EXISTS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REQUIRED': 'REQUIRED',
    'INVALID_FORMAT': 'INVALID_FORMAT',
    'DUPLICATE_IN_FILE': 'DUPLICATE_IN_FILE',
    'ALREADY_EXISTS': 'ALREADY_EXISTS',
  };

  @override
  final Iterable<Type> types = const <Type>[ImportIssueCode];
  @override
  final String wireName = 'ImportIssueCode';

  @override
  Object serialize(
    Serializers serializers,
    ImportIssueCode object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ImportIssueCode deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ImportIssueCode.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
