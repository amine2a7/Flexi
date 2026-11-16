// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_problem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ValidationProblem extends ValidationProblem {
  @override
  final ValidationProblemAllOfDetails details;
  @override
  final String type;
  @override
  final String title;
  @override
  final int status;
  @override
  final ProblemCode code;
  @override
  final String messageKey;
  @override
  final String requestId;

  factory _$ValidationProblem([
    void Function(ValidationProblemBuilder)? updates,
  ]) => (ValidationProblemBuilder()..update(updates))._build();

  _$ValidationProblem._({
    required this.details,
    required this.type,
    required this.title,
    required this.status,
    required this.code,
    required this.messageKey,
    required this.requestId,
  }) : super._();
  @override
  ValidationProblem rebuild(void Function(ValidationProblemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ValidationProblemBuilder toBuilder() =>
      ValidationProblemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValidationProblem &&
        details == other.details &&
        type == other.type &&
        title == other.title &&
        status == other.status &&
        code == other.code &&
        messageKey == other.messageKey &&
        requestId == other.requestId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, messageKey.hashCode);
    _$hash = $jc(_$hash, requestId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ValidationProblem')
          ..add('details', details)
          ..add('type', type)
          ..add('title', title)
          ..add('status', status)
          ..add('code', code)
          ..add('messageKey', messageKey)
          ..add('requestId', requestId))
        .toString();
  }
}

class ValidationProblemBuilder
    implements
        Builder<ValidationProblem, ValidationProblemBuilder>,
        ProblemBaseBuilder {
  _$ValidationProblem? _$v;

  ValidationProblemAllOfDetailsBuilder? _details;
  ValidationProblemAllOfDetailsBuilder get details =>
      _$this._details ??= ValidationProblemAllOfDetailsBuilder();
  set details(covariant ValidationProblemAllOfDetailsBuilder? details) =>
      _$this._details = details;

  String? _type;
  String? get type => _$this._type;
  set type(covariant String? type) => _$this._type = type;

  String? _title;
  String? get title => _$this._title;
  set title(covariant String? title) => _$this._title = title;

  int? _status;
  int? get status => _$this._status;
  set status(covariant int? status) => _$this._status = status;

  ProblemCode? _code;
  ProblemCode? get code => _$this._code;
  set code(covariant ProblemCode? code) => _$this._code = code;

  String? _messageKey;
  String? get messageKey => _$this._messageKey;
  set messageKey(covariant String? messageKey) =>
      _$this._messageKey = messageKey;

  String? _requestId;
  String? get requestId => _$this._requestId;
  set requestId(covariant String? requestId) => _$this._requestId = requestId;

  ValidationProblemBuilder() {
    ValidationProblem._defaults(this);
  }

  ValidationProblemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _details = $v.details.toBuilder();
      _type = $v.type;
      _title = $v.title;
      _status = $v.status;
      _code = $v.code;
      _messageKey = $v.messageKey;
      _requestId = $v.requestId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ValidationProblem other) {
    _$v = other as _$ValidationProblem;
  }

  @override
  void update(void Function(ValidationProblemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ValidationProblem build() => _build();

  _$ValidationProblem _build() {
    _$ValidationProblem _$result;
    try {
      _$result =
          _$v ??
          _$ValidationProblem._(
            details: details.build(),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'ValidationProblem',
              'type',
            ),
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'ValidationProblem',
              'title',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'ValidationProblem',
              'status',
            ),
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'ValidationProblem',
              'code',
            ),
            messageKey: BuiltValueNullFieldError.checkNotNull(
              messageKey,
              r'ValidationProblem',
              'messageKey',
            ),
            requestId: BuiltValueNullFieldError.checkNotNull(
              requestId,
              r'ValidationProblem',
              'requestId',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'details';
        details.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ValidationProblem',
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
