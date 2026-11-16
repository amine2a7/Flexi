// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_issue.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ImportIssueFieldEnum _$importIssueFieldEnum_employeeNumber =
    const ImportIssueFieldEnum._('employeeNumber');
const ImportIssueFieldEnum _$importIssueFieldEnum_firstName =
    const ImportIssueFieldEnum._('firstName');
const ImportIssueFieldEnum _$importIssueFieldEnum_lastName =
    const ImportIssueFieldEnum._('lastName');
const ImportIssueFieldEnum _$importIssueFieldEnum_email =
    const ImportIssueFieldEnum._('email');
const ImportIssueFieldEnum _$importIssueFieldEnum_phone =
    const ImportIssueFieldEnum._('phone');

ImportIssueFieldEnum _$importIssueFieldEnumValueOf(String name) {
  switch (name) {
    case 'employeeNumber':
      return _$importIssueFieldEnum_employeeNumber;
    case 'firstName':
      return _$importIssueFieldEnum_firstName;
    case 'lastName':
      return _$importIssueFieldEnum_lastName;
    case 'email':
      return _$importIssueFieldEnum_email;
    case 'phone':
      return _$importIssueFieldEnum_phone;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ImportIssueFieldEnum> _$importIssueFieldEnumValues =
    BuiltSet<ImportIssueFieldEnum>(const <ImportIssueFieldEnum>[
      _$importIssueFieldEnum_employeeNumber,
      _$importIssueFieldEnum_firstName,
      _$importIssueFieldEnum_lastName,
      _$importIssueFieldEnum_email,
      _$importIssueFieldEnum_phone,
    ]);

Serializer<ImportIssueFieldEnum> _$importIssueFieldEnumSerializer =
    _$ImportIssueFieldEnumSerializer();

class _$ImportIssueFieldEnumSerializer
    implements PrimitiveSerializer<ImportIssueFieldEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'employeeNumber': 'employeeNumber',
    'firstName': 'firstName',
    'lastName': 'lastName',
    'email': 'email',
    'phone': 'phone',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'employeeNumber': 'employeeNumber',
    'firstName': 'firstName',
    'lastName': 'lastName',
    'email': 'email',
    'phone': 'phone',
  };

  @override
  final Iterable<Type> types = const <Type>[ImportIssueFieldEnum];
  @override
  final String wireName = 'ImportIssueFieldEnum';

  @override
  Object serialize(
    Serializers serializers,
    ImportIssueFieldEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ImportIssueFieldEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ImportIssueFieldEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ImportIssue extends ImportIssue {
  @override
  final ImportIssueFieldEnum field;
  @override
  final ImportIssueCode code;

  factory _$ImportIssue([void Function(ImportIssueBuilder)? updates]) =>
      (ImportIssueBuilder()..update(updates))._build();

  _$ImportIssue._({required this.field, required this.code}) : super._();
  @override
  ImportIssue rebuild(void Function(ImportIssueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImportIssueBuilder toBuilder() => ImportIssueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImportIssue && field == other.field && code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, field.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImportIssue')
          ..add('field', field)
          ..add('code', code))
        .toString();
  }
}

class ImportIssueBuilder implements Builder<ImportIssue, ImportIssueBuilder> {
  _$ImportIssue? _$v;

  ImportIssueFieldEnum? _field;
  ImportIssueFieldEnum? get field => _$this._field;
  set field(ImportIssueFieldEnum? field) => _$this._field = field;

  ImportIssueCode? _code;
  ImportIssueCode? get code => _$this._code;
  set code(ImportIssueCode? code) => _$this._code = code;

  ImportIssueBuilder() {
    ImportIssue._defaults(this);
  }

  ImportIssueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _field = $v.field;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImportIssue other) {
    _$v = other as _$ImportIssue;
  }

  @override
  void update(void Function(ImportIssueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImportIssue build() => _build();

  _$ImportIssue _build() {
    final _$result =
        _$v ??
        _$ImportIssue._(
          field: BuiltValueNullFieldError.checkNotNull(
            field,
            r'ImportIssue',
            'field',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'ImportIssue',
            'code',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
