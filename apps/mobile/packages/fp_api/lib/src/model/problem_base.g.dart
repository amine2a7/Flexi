// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_base.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

abstract mixin class ProblemBaseBuilder {
  void replace(ProblemBase other);
  void update(void Function(ProblemBaseBuilder) updates);
  String? get type;
  set type(String? type);

  String? get title;
  set title(String? title);

  int? get status;
  set status(int? status);

  ProblemCode? get code;
  set code(ProblemCode? code);

  String? get messageKey;
  set messageKey(String? messageKey);

  String? get requestId;
  set requestId(String? requestId);
}

class _$$ProblemBase extends $ProblemBase {
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

  factory _$$ProblemBase([void Function($ProblemBaseBuilder)? updates]) =>
      ($ProblemBaseBuilder()..update(updates))._build();

  _$$ProblemBase._({
    required this.type,
    required this.title,
    required this.status,
    required this.code,
    required this.messageKey,
    required this.requestId,
  }) : super._();
  @override
  $ProblemBase rebuild(void Function($ProblemBaseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  $ProblemBaseBuilder toBuilder() => $ProblemBaseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is $ProblemBase &&
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
    return (newBuiltValueToStringHelper(r'$ProblemBase')
          ..add('type', type)
          ..add('title', title)
          ..add('status', status)
          ..add('code', code)
          ..add('messageKey', messageKey)
          ..add('requestId', requestId))
        .toString();
  }
}

class $ProblemBaseBuilder
    implements Builder<$ProblemBase, $ProblemBaseBuilder>, ProblemBaseBuilder {
  _$$ProblemBase? _$v;

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

  $ProblemBaseBuilder() {
    $ProblemBase._defaults(this);
  }

  $ProblemBaseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
  void replace(covariant $ProblemBase other) {
    _$v = other as _$$ProblemBase;
  }

  @override
  void update(void Function($ProblemBaseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  $ProblemBase build() => _build();

  _$$ProblemBase _build() {
    final _$result =
        _$v ??
        _$$ProblemBase._(
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'$ProblemBase',
            'type',
          ),
          title: BuiltValueNullFieldError.checkNotNull(
            title,
            r'$ProblemBase',
            'title',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'$ProblemBase',
            'status',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'$ProblemBase',
            'code',
          ),
          messageKey: BuiltValueNullFieldError.checkNotNull(
            messageKey,
            r'$ProblemBase',
            'messageKey',
          ),
          requestId: BuiltValueNullFieldError.checkNotNull(
            requestId,
            r'$ProblemBase',
            'requestId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
