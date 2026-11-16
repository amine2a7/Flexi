// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'limit_exceeded_problem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LimitExceededProblem extends LimitExceededProblem {
  @override
  final LimitExceededProblemAllOfDetails? details;
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

  factory _$LimitExceededProblem([
    void Function(LimitExceededProblemBuilder)? updates,
  ]) => (LimitExceededProblemBuilder()..update(updates))._build();

  _$LimitExceededProblem._({
    this.details,
    required this.type,
    required this.title,
    required this.status,
    required this.code,
    required this.messageKey,
    required this.requestId,
  }) : super._();
  @override
  LimitExceededProblem rebuild(
    void Function(LimitExceededProblemBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  LimitExceededProblemBuilder toBuilder() =>
      LimitExceededProblemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LimitExceededProblem &&
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
    return (newBuiltValueToStringHelper(r'LimitExceededProblem')
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

class LimitExceededProblemBuilder
    implements
        Builder<LimitExceededProblem, LimitExceededProblemBuilder>,
        ProblemBaseBuilder {
  _$LimitExceededProblem? _$v;

  LimitExceededProblemAllOfDetailsBuilder? _details;
  LimitExceededProblemAllOfDetailsBuilder get details =>
      _$this._details ??= LimitExceededProblemAllOfDetailsBuilder();
  set details(covariant LimitExceededProblemAllOfDetailsBuilder? details) =>
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

  LimitExceededProblemBuilder() {
    LimitExceededProblem._defaults(this);
  }

  LimitExceededProblemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _details = $v.details?.toBuilder();
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
  void replace(covariant LimitExceededProblem other) {
    _$v = other as _$LimitExceededProblem;
  }

  @override
  void update(void Function(LimitExceededProblemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LimitExceededProblem build() => _build();

  _$LimitExceededProblem _build() {
    _$LimitExceededProblem _$result;
    try {
      _$result =
          _$v ??
          _$LimitExceededProblem._(
            details: _details?.build(),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'LimitExceededProblem',
              'type',
            ),
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'LimitExceededProblem',
              'title',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'LimitExceededProblem',
              'status',
            ),
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'LimitExceededProblem',
              'code',
            ),
            messageKey: BuiltValueNullFieldError.checkNotNull(
              messageKey,
              r'LimitExceededProblem',
              'messageKey',
            ),
            requestId: BuiltValueNullFieldError.checkNotNull(
              requestId,
              r'LimitExceededProblem',
              'requestId',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'details';
        _details?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'LimitExceededProblem',
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
