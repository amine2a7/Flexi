// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_limited_problem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RateLimitedProblem extends RateLimitedProblem {
  @override
  final RetryAfterDetails details;
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

  factory _$RateLimitedProblem([
    void Function(RateLimitedProblemBuilder)? updates,
  ]) => (RateLimitedProblemBuilder()..update(updates))._build();

  _$RateLimitedProblem._({
    required this.details,
    required this.type,
    required this.title,
    required this.status,
    required this.code,
    required this.messageKey,
    required this.requestId,
  }) : super._();
  @override
  RateLimitedProblem rebuild(
    void Function(RateLimitedProblemBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  RateLimitedProblemBuilder toBuilder() =>
      RateLimitedProblemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RateLimitedProblem &&
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
    return (newBuiltValueToStringHelper(r'RateLimitedProblem')
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

class RateLimitedProblemBuilder
    implements
        Builder<RateLimitedProblem, RateLimitedProblemBuilder>,
        ProblemBaseBuilder {
  _$RateLimitedProblem? _$v;

  RetryAfterDetailsBuilder? _details;
  RetryAfterDetailsBuilder get details =>
      _$this._details ??= RetryAfterDetailsBuilder();
  set details(covariant RetryAfterDetailsBuilder? details) =>
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

  RateLimitedProblemBuilder() {
    RateLimitedProblem._defaults(this);
  }

  RateLimitedProblemBuilder get _$this {
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
  void replace(covariant RateLimitedProblem other) {
    _$v = other as _$RateLimitedProblem;
  }

  @override
  void update(void Function(RateLimitedProblemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RateLimitedProblem build() => _build();

  _$RateLimitedProblem _build() {
    _$RateLimitedProblem _$result;
    try {
      _$result =
          _$v ??
          _$RateLimitedProblem._(
            details: details.build(),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'RateLimitedProblem',
              'type',
            ),
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'RateLimitedProblem',
              'title',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'RateLimitedProblem',
              'status',
            ),
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'RateLimitedProblem',
              'code',
            ),
            messageKey: BuiltValueNullFieldError.checkNotNull(
              messageKey,
              r'RateLimitedProblem',
              'messageKey',
            ),
            requestId: BuiltValueNullFieldError.checkNotNull(
              requestId,
              r'RateLimitedProblem',
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
          r'RateLimitedProblem',
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
