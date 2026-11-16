// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_error.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FieldErrorIn_Enum _$fieldErrorInEnum_body = const FieldErrorIn_Enum._(
  'body',
);
const FieldErrorIn_Enum _$fieldErrorInEnum_query = const FieldErrorIn_Enum._(
  'query',
);
const FieldErrorIn_Enum _$fieldErrorInEnum_path = const FieldErrorIn_Enum._(
  'path',
);
const FieldErrorIn_Enum _$fieldErrorInEnum_header = const FieldErrorIn_Enum._(
  'header',
);

FieldErrorIn_Enum _$fieldErrorInEnumValueOf(String name) {
  switch (name) {
    case 'body':
      return _$fieldErrorInEnum_body;
    case 'query':
      return _$fieldErrorInEnum_query;
    case 'path':
      return _$fieldErrorInEnum_path;
    case 'header':
      return _$fieldErrorInEnum_header;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FieldErrorIn_Enum> _$fieldErrorInEnumValues =
    BuiltSet<FieldErrorIn_Enum>(const <FieldErrorIn_Enum>[
      _$fieldErrorInEnum_body,
      _$fieldErrorInEnum_query,
      _$fieldErrorInEnum_path,
      _$fieldErrorInEnum_header,
    ]);

Serializer<FieldErrorIn_Enum> _$fieldErrorInEnumSerializer =
    _$FieldErrorIn_EnumSerializer();

class _$FieldErrorIn_EnumSerializer
    implements PrimitiveSerializer<FieldErrorIn_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'body': 'body',
    'query': 'query',
    'path': 'path',
    'header': 'header',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'body': 'body',
    'query': 'query',
    'path': 'path',
    'header': 'header',
  };

  @override
  final Iterable<Type> types = const <Type>[FieldErrorIn_Enum];
  @override
  final String wireName = 'FieldErrorIn_Enum';

  @override
  Object serialize(
    Serializers serializers,
    FieldErrorIn_Enum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  FieldErrorIn_Enum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => FieldErrorIn_Enum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$FieldError extends FieldError {
  @override
  final FieldErrorIn_Enum in_;
  @override
  final String pointer;
  @override
  final FieldErrorCode code;
  @override
  final String messageKey;
  @override
  final BuiltMap<String, FieldErrorParamsValue>? params;

  factory _$FieldError([void Function(FieldErrorBuilder)? updates]) =>
      (FieldErrorBuilder()..update(updates))._build();

  _$FieldError._({
    required this.in_,
    required this.pointer,
    required this.code,
    required this.messageKey,
    this.params,
  }) : super._();
  @override
  FieldError rebuild(void Function(FieldErrorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FieldErrorBuilder toBuilder() => FieldErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FieldError &&
        in_ == other.in_ &&
        pointer == other.pointer &&
        code == other.code &&
        messageKey == other.messageKey &&
        params == other.params;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, in_.hashCode);
    _$hash = $jc(_$hash, pointer.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, messageKey.hashCode);
    _$hash = $jc(_$hash, params.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FieldError')
          ..add('in_', in_)
          ..add('pointer', pointer)
          ..add('code', code)
          ..add('messageKey', messageKey)
          ..add('params', params))
        .toString();
  }
}

class FieldErrorBuilder implements Builder<FieldError, FieldErrorBuilder> {
  _$FieldError? _$v;

  FieldErrorIn_Enum? _in_;
  FieldErrorIn_Enum? get in_ => _$this._in_;
  set in_(FieldErrorIn_Enum? in_) => _$this._in_ = in_;

  String? _pointer;
  String? get pointer => _$this._pointer;
  set pointer(String? pointer) => _$this._pointer = pointer;

  FieldErrorCode? _code;
  FieldErrorCode? get code => _$this._code;
  set code(FieldErrorCode? code) => _$this._code = code;

  String? _messageKey;
  String? get messageKey => _$this._messageKey;
  set messageKey(String? messageKey) => _$this._messageKey = messageKey;

  MapBuilder<String, FieldErrorParamsValue>? _params;
  MapBuilder<String, FieldErrorParamsValue> get params =>
      _$this._params ??= MapBuilder<String, FieldErrorParamsValue>();
  set params(MapBuilder<String, FieldErrorParamsValue>? params) =>
      _$this._params = params;

  FieldErrorBuilder() {
    FieldError._defaults(this);
  }

  FieldErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _in_ = $v.in_;
      _pointer = $v.pointer;
      _code = $v.code;
      _messageKey = $v.messageKey;
      _params = $v.params?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FieldError other) {
    _$v = other as _$FieldError;
  }

  @override
  void update(void Function(FieldErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FieldError build() => _build();

  _$FieldError _build() {
    _$FieldError _$result;
    try {
      _$result =
          _$v ??
          _$FieldError._(
            in_: BuiltValueNullFieldError.checkNotNull(
              in_,
              r'FieldError',
              'in_',
            ),
            pointer: BuiltValueNullFieldError.checkNotNull(
              pointer,
              r'FieldError',
              'pointer',
            ),
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'FieldError',
              'code',
            ),
            messageKey: BuiltValueNullFieldError.checkNotNull(
              messageKey,
              r'FieldError',
              'messageKey',
            ),
            params: _params?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'params';
        _params?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'FieldError',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
