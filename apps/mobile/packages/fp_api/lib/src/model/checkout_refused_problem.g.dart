// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_refused_problem.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckoutRefusedProblem extends CheckoutRefusedProblem {
  @override
  final CheckoutRefusedProblemAllOfDetails? details;
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

  factory _$CheckoutRefusedProblem([
    void Function(CheckoutRefusedProblemBuilder)? updates,
  ]) => (CheckoutRefusedProblemBuilder()..update(updates))._build();

  _$CheckoutRefusedProblem._({
    this.details,
    required this.type,
    required this.title,
    required this.status,
    required this.code,
    required this.messageKey,
    required this.requestId,
  }) : super._();
  @override
  CheckoutRefusedProblem rebuild(
    void Function(CheckoutRefusedProblemBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CheckoutRefusedProblemBuilder toBuilder() =>
      CheckoutRefusedProblemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutRefusedProblem &&
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
    return (newBuiltValueToStringHelper(r'CheckoutRefusedProblem')
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

class CheckoutRefusedProblemBuilder
    implements
        Builder<CheckoutRefusedProblem, CheckoutRefusedProblemBuilder>,
        ProblemBaseBuilder {
  _$CheckoutRefusedProblem? _$v;

  CheckoutRefusedProblemAllOfDetailsBuilder? _details;
  CheckoutRefusedProblemAllOfDetailsBuilder get details =>
      _$this._details ??= CheckoutRefusedProblemAllOfDetailsBuilder();
  set details(covariant CheckoutRefusedProblemAllOfDetailsBuilder? details) =>
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

  CheckoutRefusedProblemBuilder() {
    CheckoutRefusedProblem._defaults(this);
  }

  CheckoutRefusedProblemBuilder get _$this {
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
  void replace(covariant CheckoutRefusedProblem other) {
    _$v = other as _$CheckoutRefusedProblem;
  }

  @override
  void update(void Function(CheckoutRefusedProblemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutRefusedProblem build() => _build();

  _$CheckoutRefusedProblem _build() {
    _$CheckoutRefusedProblem _$result;
    try {
      _$result =
          _$v ??
          _$CheckoutRefusedProblem._(
            details: _details?.build(),
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'CheckoutRefusedProblem',
              'type',
            ),
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'CheckoutRefusedProblem',
              'title',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'CheckoutRefusedProblem',
              'status',
            ),
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'CheckoutRefusedProblem',
              'code',
            ),
            messageKey: BuiltValueNullFieldError.checkNotNull(
              messageKey,
              r'CheckoutRefusedProblem',
              'messageKey',
            ),
            requestId: BuiltValueNullFieldError.checkNotNull(
              requestId,
              r'CheckoutRefusedProblem',
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
          r'CheckoutRefusedProblem',
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
