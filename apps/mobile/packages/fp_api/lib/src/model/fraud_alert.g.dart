// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fraud_alert.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FraudAlert extends FraudAlert {
  @override
  final String id;
  @override
  final FraudAlertKind kind;
  @override
  final FraudAlertSeverity severity;
  @override
  final String subject;
  @override
  final DateTime occurredAt;
  @override
  final FraudAlertStatus status;
  @override
  final String? handledByName;
  @override
  final String? closeReason;

  factory _$FraudAlert([void Function(FraudAlertBuilder)? updates]) =>
      (FraudAlertBuilder()..update(updates))._build();

  _$FraudAlert._({
    required this.id,
    required this.kind,
    required this.severity,
    required this.subject,
    required this.occurredAt,
    required this.status,
    this.handledByName,
    this.closeReason,
  }) : super._();
  @override
  FraudAlert rebuild(void Function(FraudAlertBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FraudAlertBuilder toBuilder() => FraudAlertBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FraudAlert &&
        id == other.id &&
        kind == other.kind &&
        severity == other.severity &&
        subject == other.subject &&
        occurredAt == other.occurredAt &&
        status == other.status &&
        handledByName == other.handledByName &&
        closeReason == other.closeReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, severity.hashCode);
    _$hash = $jc(_$hash, subject.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, handledByName.hashCode);
    _$hash = $jc(_$hash, closeReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FraudAlert')
          ..add('id', id)
          ..add('kind', kind)
          ..add('severity', severity)
          ..add('subject', subject)
          ..add('occurredAt', occurredAt)
          ..add('status', status)
          ..add('handledByName', handledByName)
          ..add('closeReason', closeReason))
        .toString();
  }
}

class FraudAlertBuilder implements Builder<FraudAlert, FraudAlertBuilder> {
  _$FraudAlert? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  FraudAlertKind? _kind;
  FraudAlertKind? get kind => _$this._kind;
  set kind(FraudAlertKind? kind) => _$this._kind = kind;

  FraudAlertSeverity? _severity;
  FraudAlertSeverity? get severity => _$this._severity;
  set severity(FraudAlertSeverity? severity) => _$this._severity = severity;

  String? _subject;
  String? get subject => _$this._subject;
  set subject(String? subject) => _$this._subject = subject;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  FraudAlertStatus? _status;
  FraudAlertStatus? get status => _$this._status;
  set status(FraudAlertStatus? status) => _$this._status = status;

  String? _handledByName;
  String? get handledByName => _$this._handledByName;
  set handledByName(String? handledByName) =>
      _$this._handledByName = handledByName;

  String? _closeReason;
  String? get closeReason => _$this._closeReason;
  set closeReason(String? closeReason) => _$this._closeReason = closeReason;

  FraudAlertBuilder() {
    FraudAlert._defaults(this);
  }

  FraudAlertBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _severity = $v.severity;
      _subject = $v.subject;
      _occurredAt = $v.occurredAt;
      _status = $v.status;
      _handledByName = $v.handledByName;
      _closeReason = $v.closeReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FraudAlert other) {
    _$v = other as _$FraudAlert;
  }

  @override
  void update(void Function(FraudAlertBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FraudAlert build() => _build();

  _$FraudAlert _build() {
    final _$result =
        _$v ??
        _$FraudAlert._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'FraudAlert', 'id'),
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'FraudAlert',
            'kind',
          ),
          severity: BuiltValueNullFieldError.checkNotNull(
            severity,
            r'FraudAlert',
            'severity',
          ),
          subject: BuiltValueNullFieldError.checkNotNull(
            subject,
            r'FraudAlert',
            'subject',
          ),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
            occurredAt,
            r'FraudAlert',
            'occurredAt',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'FraudAlert',
            'status',
          ),
          handledByName: handledByName,
          closeReason: closeReason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
