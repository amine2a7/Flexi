// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insufficient_funds_problem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InsufficientFundsProblem extends InsufficientFundsProblem {
  @override
  final InsufficientFundsProblemAllOfDetails? details;
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

  factory _$InsufficientFundsProblem([
    void Function(InsufficientFundsProblemBuilder)? updates,
  ]) => (InsufficientFundsProblemBuilder()..update(updates))._build();

  _$InsufficientFundsProblem._({
    this.details,
    required this.type,
    required this.title,
    required this.status,
    required this.code,
    required this.messageKey,
    required this.requestId,
  }) : super._();
  @override
  InsufficientFundsProblem rebuild(
    void Function(InsufficientFundsProblemBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  InsufficientFundsProblemBuilder toBuilder() =>
      InsufficientFundsProblemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InsufficientFundsProblem &&
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
    return (newBuiltValueToStringHelper(r'InsufficientFundsProblem')
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

class InsufficientFundsProblemBuilder
    implements
        Builder<InsufficientFundsProblem, InsufficientFundsProblemBuilder>,
        ProblemBaseBuilder {
  _$InsufficientFundsProblem? _$v;

  InsufficientFundsProblemAllOfDetailsBuilder? _details;
  InsufficientFundsProblemAllOfDetailsBuilder get details =>
      _$this._details ??= InsufficientFundsProblemAllOfDetailsBuilder();
  set details(covariant InsufficientFundsProblemAllOfDetailsBuilder? details) =>
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

  InsufficientFundsProblemBuilder() {
    InsufficientFundsProblem._defaults(this);
  }

  InsufficientFundsProblemBuilder get _$this {
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
  void replace(covariant InsufficientFundsProblem other) {
    _$v = other as _$InsufficientFundsProblem;
  }

  @override
  void update(void Function(InsufficientFundsProblemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InsufficientFundsProblem build() => _build();

  _$InsufficientFundsProblem _build() {
    _$InsufficientFundsProblem _$result;
    try {
      _$result =
          _$v ??
          _$InsufficientFundsProblem._(
            details: _details?.build(),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'InsufficientFundsProblem',
              'type',
            ),
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'InsufficientFundsProblem',
              'title',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'InsufficientFundsProblem',
              'status',
            ),
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'InsufficientFundsProblem',
              'code',
            ),
            messageKey: BuiltValueNullFieldError.checkNotNull(
              messageKey,
              r'InsufficientFundsProblem',
              'messageKey',
            ),
            requestId: BuiltValueNullFieldError.checkNotNull(
              requestId,
              r'InsufficientFundsProblem',
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
          r'InsufficientFundsProblem',
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
